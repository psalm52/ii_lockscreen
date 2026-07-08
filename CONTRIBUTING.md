# Contributing

This started as a personal fork to get end-4's lock screen running standalone
on MangoWC, not a general-purpose project — so expectations here are
deliberately light.

## Before opening a PR

- **Bug fixes, portability fixes (other compositors), packaging improvements** —
  welcome, open a PR directly.
- **New features / visual changes** — open an issue first to discuss. This
  repo intentionally stays close to end-4's original design; if you want
  something substantially different, a fork of this fork is probably the
  right move rather than a PR here.
- **Touching `modules/common/widgets/shapes/`** — that's a vendored copy of
  end-4/rounded-polygon-qmljs (Apache-2.0), not code to modify here. Fixes
  belong upstream in that repo instead.

## Reporting compositor compatibility issues

If it doesn't lock/unlock correctly on your compositor, please include:
- Compositor name + version
- Output of `qs -p /path/to/quickshell-lock` (the full startup log, not just
  the error line — Quickshell's error chains are usually several files deep
  from the actual problem)
- Whether `ext-session-lock-v1` and `wlr-layer-shell-v1` are supported by
  your compositor (most wlroots-based ones are; some aren't)

## Attribution

If you port in code from elsewhere (another shell config, another fork,
etc.), credit it in the README's Credit section the same way the existing
entries are done, and make sure the license is GPL-3.0-compatible before
opening the PR — see `licenses/README.md` for how third-party-licensed
subtrees are tracked here.
