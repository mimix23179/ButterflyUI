# Desktop vs Web Target

This document explains how ButterflyUI app launch targets work.

## Preferred API

Use explicit target strings:

- `target="desktop"`
- `target="web"`

Example:

```python
from butterflyui import run, Page

def main(page: Page) -> None:
    page.title = "My App"
    page.update()

if __name__ == "__main__":
    raise SystemExit(run(main, target="desktop"))
```

## Target Resolution

If `target` is not passed to `run(...)` / `app(...)`, ButterflyUI resolves launch target in this order:

1. `[run].target` in `butterflyui.toml`
2. Default: `desktop`

`mode=` and `desktop=` are not supported.

## Desktop Target (`target="desktop"`)

- Uses desktop boot profile (`flutter-desktop` renderer + websocket transport).
- Launches the desktop runtime process automatically.
- Best for native desktop-style apps and tooling.

## Web Target (`target="web"`)

- Uses web boot profile (`flutter-web` renderer + websocket transport).
- Prints local endpoints (`127.0.0.1:{port}` and `localhost:{port}`).
- Only local hosts are allowed: `127.0.0.1` or `localhost`.
- Host values must be plain hosts (no `ws://` or `http://` schemes).
- Best for browser-first and web-preview usage.
