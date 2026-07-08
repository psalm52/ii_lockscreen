pragma Singleton
import Quickshell
import qs.services
import qs.modules.common

Singleton {
    id: root

    // Standalone build note :: original closeAllWindows() used HyprlandData.windowList
    // (Hyprland IPC) to gracefully kill app windows before shutdown/reboot. Dropped for
    // this build -- systemd/loginctl already tears down user processes on poweroff/reboot,
    // so this was a nicety, not a requirement.

    function changePassword() {
        Quickshell.execDetached(["bash", "-c", `${Config.options.apps.changePassword}`]);
    }

    function lock() {
        Quickshell.execDetached(["loginctl", "lock-session"]);
    }

    function suspend() {
        Quickshell.execDetached(["bash", "-c", "systemctl suspend || loginctl suspend"]);
    }

    function logout() {
        // Standalone build note :: originally killed Hyprland by name. Use loginctl's
        // generic session terminate instead so this works under any compositor.
        Quickshell.execDetached(["bash", "-c", "loginctl terminate-session $XDG_SESSION_ID"]);
    }

    function launchTaskManager() {
        Quickshell.execDetached(["bash", "-c", `${Config.options.apps.taskManager}`]);
    }

    function hibernate() {
        Quickshell.execDetached(["bash", "-c", `systemctl hibernate || loginctl hibernate`]);
    }

    function poweroff() {
        Quickshell.execDetached(["bash", "-c", `systemctl poweroff || loginctl poweroff`]);
    }

    function reboot() {
        Quickshell.execDetached(["bash", "-c", `reboot || loginctl reboot`]);
    }

    function rebootToFirmware() {
        Quickshell.execDetached(["bash", "-c", `systemctl reboot --firmware-setup || loginctl reboot --firmware-setup`]);
    }
}
