pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

// Standalone build note :: trimmed from the original ~20-property GlobalStates down to
// just what the lock module reads/writes. Also dropped `import Quickshell.Hyprland` and
// the `workspaceNumber` GlobalShortcut, which was unrelated to locking (a hold-to-show-
// workspace-numbers feature) and Hyprland-only.

Singleton {
    id: root
    property bool screenLocked: false
    property bool screenLockContainsCharacters: false
    property bool screenUnlockFailed: false
}
