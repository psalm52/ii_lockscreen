import qs.modules.common.panels.lock
import qs.modules.ii.lock as Lock
import Quickshell

// Standalone build note :: this replaces end-4's ii/lock/Lock.qml, which subclassed
// LockScreen purely to add Hyprland workspace-shuffling (moving every workspace to a
// hidden one during lock, via raw hyprctl dispatch batches -- a cosmetic/extra-privacy
// layer, not part of the actual lock mechanism). That's Hyprland-only and dropped here;
// the session-lock protocol already blocks all input/view regardless of compositor.
//
// Run with:  qs -p /path/to/quickshell-lock
// Trigger with:  qs -p /path/to/quickshell-lock ipc call lock activate
// (bind that command to Super+L and to your idle daemon's lock timeout)

LockScreen {
    id: root
    lockSurface: Lock.LockSurface {
        context: root.context
    }
}
