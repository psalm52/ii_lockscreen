---
name: Bug report
about: Something doesn't lock, unlock, or render correctly
title: ""
labels: bug
---

**Compositor + version**
e.g. MangoWC 0.14.2, niri 25.x, Hyprland ...

**What happened**
A clear description of the actual behavior.

**Expected behavior**
What you expected instead.

**Full startup log**
Run `qs -p /path/to/quickshell-lock` and paste the *entire* output, not just
the error line — Quickshell's error chains are usually several files deep
from the actual cause (e.g. a missing type three files away shows up as the
top-level error).

```
paste here
```

**Protocol support (if known)**
Does your compositor support `ext-session-lock-v1` and `wlr-layer-shell-v1`?
(Most wlroots-based compositors do; worth checking if you're on something
less common.)

**Config/build**
- [ ] Running via `qs -p` directly
- [ ] Running via the Nix `mkIiLock` package
- Any knobs changed from defaults (uiScale, clockStyle, etc.)?
