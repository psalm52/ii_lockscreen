Ii_lockscreen
A standalone Quickshell session-lock client in the illogical-impulse visual
style — the lock screen from end-4/dots-hyprland,
extracted from its full desktop shell and stripped of every Hyprland-specific
dependency so it runs as an independent client on any wlroots compositor
(built and tested against MangoWC).

It uses the ext-session-lock-v1 Wayland protocol directly via
Quickshell, so it locks the same way
regardless of which compositor or desktop shell you run day to day.

Why this exists
end-4's lock screen is genuinely excellent, but it only ships as part of the
full Quickshell configuration and leans on Hyprland's IPC in a couple of
places (workspace-shuffling during lock, a keyboard-layout indicator). This
repo pulls out just the lock module — PAM/fingerprint auth, the visual
surface, password-dot animation — and swaps the Hyprland-only pieces for
compositor-agnostic equivalents, so it can run standalone on compositors that
were never its intended target.
It also adds an analog clock face, ported from my own SDDM theme fork (below),
so the lock screen and login screen can share one visual identity.

Credit
This is a derivative work built almost entirely from other people's code.
Nearly nothing here is original — the value-add is extraction, compositor
portability, and gluing pieces together.

·	end-4/dots-hyprland (GPL-3.0) —
source of the entire lock screen: LockScreen.qml, LockContext.qml,
LockSurface.qml, PasswordChars.qml, and the supporting Appearance/
Config/widget library it depends on. All credit for the design, the PAM/
fingerprint auth flow, and the visual language belongs to end-4 and dots-hyprland's
contributors.

·	end-4/rounded-polygon-qmljs (Apache-2.0) —
the Material 3 rounded-polygon shape math (modules/common/widgets/shapes/),
vendored as a git submodule in upstream dots-hyprland; itself a QML/JS port
of Knugel's TypeScript port
of AndroidX's shape library.

·	psalm52/illogical_sddm (GPL-3.0,
my own fork of the ii SDDM theme) — source of the CookieClock/DigitalClock
components ported into the lock screen here, itself adapted from end-4's
dotfiles by 3d3f.

·	Noctalia — no code copied,
but its legacy-v4 MangoWC compositor service was invaluable as a reference
while working out MangoWC's current mmsg dispatch IPC grammar (mango's own
CLI went through a breaking syntax change that broke a lot of downstream
integrations, this repo's fixes included).

If you maintain any of the above and want something here handled differently
— credited differently, removed, relicensed — please open an issue.

What's different from upstream

·	Dropped ii/lock/Lock.qml entirely — it only added Hyprland workspace-
shuffling during lock (a cosmetic/extra-privacy layer, not part of the
actual lock mechanism, which the session-lock protocol already handles).

·	GlobalStates, LockScreen, LockSurface, Persistent, Session,
Idle — trimmed of Hyprland-only branches (global shortcuts, workspace
IPC, HyprlandXkb layout indicator), replaced with generic Wayland/
systemd/loginctl equivalents where a like-for-like replacement existed.

·	Added a wallpaper + dim layer on the lock surface (upstream relies on the
full shell's wallpaper being visible through a transparent surface, which
doesn't exist when this runs standalone).

·	Added the ported clock, with a shared knob/settings surface so it can be
driven identically from Nix alongside a matching SDDM theme (see below).
Building

Packaged as a Nix flake lib function (mkIiLock), mirroring the SDDM
theme's mkIiSddm builder — same knob names for anything the two share
(clock face, hand styles, time format, etc.), so one settings block can drive
both a login screen and a lock screen consistently.
lockPkg = flake.lib.mkIiLock pkgs {
  src = ./.;
  wallpaper = ./assets/wallpaper.jpg;
  clockStyle = "cookie";
  cookieSecondHand = "dot";
  uiScale = 1.3;
};

Or run directly without packaging, given a working
Quickshell install:
qs -p /path/to/quickshell-lock

Trigger the lock via Quickshell's own IPC (works identically on any
compositor):
qs -p /path/to/quickshell-lock ipc call lock activate

License
GPL-3.0, inherited from dots-hyprland — see LICENSE. The
modules/common/widgets/shapes/ subtree is Apache-2.0 (end-4/rounded-polygon-qmljs)
and retains its own license file at that path, per the terms of that license;
see licenses/README.md for the same third-party-code
convention dots-hyprland itself uses.
This is a personal fork built for my own compositor setup, not affiliated
with or endorsed by end-4, Noctalia, or any of the projects credited above.
