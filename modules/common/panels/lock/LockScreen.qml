pragma ComponentBehavior: Bound
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Standalone build note :: removed `import Quickshell.Hyprland` and both GlobalShortcut
// blocks from the original. Those were a Hyprland-specific trigger path (mirrors what
// `hyprctl dispatch global quickshell:lock` fires). The IpcHandler below is the generic,
// compositor-agnostic trigger -- bind Super+L and your idle daemon to:
//   qs -c quickshell-lock ipc call lock activate

Scope {
    id: root

    required property Component lockSurface
    property alias context: lockContext
    property Component sessionLockSurface: WlSessionLockSurface {
        id: sessionLockSurface
        // Standalone build note :: upstream used color: "transparent", relying on the
        // full ii shell's wallpaper layer behind it (and Hyprland workspace tricks).
        // Standalone has nothing behind the surface, so paint our own: solid base +
        // wallpaper + subtle dim so the clock/toolbars stay readable.
        color: "#000000"
        Image {
            anchors.fill: parent
            source: Quickshell.shellPath("assets/wallpaper.jpg")
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            // 8000x3328 source; cap decode near the surface size to save RAM
            sourceSize.width: sessionLockSurface.width * 1.2
        }
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.28
        }
        Loader {
            active: GlobalStates.screenLocked
            anchors.fill: parent
            opacity: active ? 1 : 0
            Behavior on opacity {
                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
            }
            sourceComponent: root.lockSurface
        }
    }

    Process {
        id: unlockKeyringProc
        onExited: (exitCode, exitStatus) => {
            KeyringStorage.fetchKeyringData();
        }
    }
    function unlockKeyring() {
        unlockKeyringProc.exec({
            environment: ({
                "UNLOCK_PASSWORD": lockContext.currentText
            }),
            command: ["bash", "-c", Quickshell.shellPath("scripts/keyring/unlock.sh")]
        })
    }

    // This stores all the information shared between the lock surfaces on each screen.
    // https://github.com/quickshell-mirror/quickshell-examples/tree/master/lockscreen
    LockContext {
        id: lockContext

        Connections {
            target: GlobalStates
            function onScreenLockedChanged() {
                if (GlobalStates.screenLocked) {
                    lockContext.reset();
                    lockContext.tryFingerUnlock();
                }
            }
        }

        onUnlocked: (targetAction) => {
            // Perform the target action if it's not just unlocking
            if (targetAction == LockContext.ActionEnum.Poweroff) {
                Session.poweroff();
                return;
            } else if (targetAction == LockContext.ActionEnum.Reboot) {
                Session.reboot();
                return;
            }

            // Unlock the keyring if configured to do so
            if (Config.options.lock.security.unlockKeyring) root.unlockKeyring(); // Async

            // Unlock the screen before exiting, or the compositor will display a
            // fallback lock you can't interact with.
            GlobalStates.screenLocked = false;

            // Reset
            lockContext.reset();

            // Post-unlock actions
            if (lockContext.alsoInhibitIdle) {
                lockContext.alsoInhibitIdle = false;
                Idle.toggleInhibit(true);
            }
        }
    }

    WlSessionLock {
        id: lock
        locked: GlobalStates.screenLocked
        surface: root.sessionLockSurface
    }

    function lock() {
        GlobalStates.screenLocked = true;
    }

    IpcHandler {
        target: "lock"

        function activate(): void {
            root.lock();
        }
        function focus(): void {
            lockContext.shouldReFocus();
        }
    }

    function initIfReady() {
        if (!Config.ready || !Persistent.ready) return;
        if (Config.options.lock.launchOnStartup && Persistent.isNewHyprlandInstance) {
            root.lock();
        } else {
            KeyringStorage.fetchKeyringData();
        }
    }
    Connections {
        target: Config
        function onReadyChanged() {
            root.initIfReady();
        }
    }
    Connections {
        target: Persistent
        function onReadyChanged() {
            root.initIfReady();
        }
    }
}
