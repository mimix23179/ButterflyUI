"""ButterflyUI Web — web runtime installer + local web server.

This package hosts a Flutter web build of ButterflyUI and opens it in a browser.
The web runtime connects back to the Python WebSocket transport via query params.
"""

from __future__ import annotations

from dataclasses import dataclass
import hashlib
import os
import site
import threading
import time
import urllib.parse
import urllib.request
import zipfile
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
from typing import Optional
import webbrowser

# ----------------------------- CONFIGURATION -----------------------------

RUNTIME_ZIP_URL: str = "https://github.com/mimix23179/ButterflyUI/releases/download/0.1.0/butterflyui-web.zip"
RUNTIME_ZIP_SHA256: str = ""
_RUNTIME_DIR_NAME = "web_app"


class ButterflyUIWebInstallError(RuntimeError):
    pass


class ButterflyUIWebRunError(RuntimeError):
    pass


def _get_package_dir() -> Path:
    return Path(__file__).resolve().parent


def _find_installed_package_dir() -> Optional[Path]:
    candidates: list[Path] = []
    try:
        candidates.extend(Path(p) for p in site.getsitepackages() if p)
    except Exception:
        pass
    try:
        user_site = site.getusersitepackages()
        if user_site:
            candidates.append(Path(user_site))
    except Exception:
        pass

    for root in candidates:
        pkg_dir = root / "butterflyui_web"
        if pkg_dir.is_dir() and (pkg_dir / "__init__.py").exists():
            return pkg_dir
    return None


def get_runtime_dir(*, use_env_runtime_dir: bool = True) -> Path:
    if use_env_runtime_dir:
        env = os.environ.get("BUTTERFLYUI_WEB_RUNTIME_DIR", "").strip()
        if env:
            return Path(env)

    package_dir = _get_package_dir()
    installed_dir = _find_installed_package_dir()
    if installed_dir is not None and installed_dir.resolve() != package_dir.resolve():
        return installed_dir / _RUNTIME_DIR_NAME

    return package_dir / _RUNTIME_DIR_NAME


def _require_https(url: str) -> None:
    parsed = urllib.parse.urlparse(url)
    if parsed.scheme.lower() != "https":
        raise ButterflyUIWebInstallError("Runtime URL must use https://")


def _sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def _download_to_path(url: str, dest: Path) -> Path:
    _require_https(url)
    req = urllib.request.Request(url, headers={"User-Agent": "butterflyui-web/0"})
    with urllib.request.urlopen(req, timeout=60) as resp:
        final = getattr(resp, "geturl", lambda: url)()
        _require_https(str(final))
        data = resp.read()

    if len(data) < 4 or data[:4] != b"PK\x03\x04":
        raise ButterflyUIWebInstallError("Downloaded runtime does not look like a zip file")

    dest.write_bytes(data)
    return dest


def get_installed_info(runtime_dir: Optional[Path] = None, *, use_env_runtime_dir: bool = True) -> Optional[dict]:
    runtime_dir = runtime_dir or get_runtime_dir(use_env_runtime_dir=use_env_runtime_dir)
    if not runtime_dir.exists():
        return None
    index = runtime_dir / "index.html"
    if index.exists():
        return {"path": str(index), "installed_at": index.stat().st_mtime}
    return None


def install(
    *,
    url: Optional[str] = None,
    sha256: Optional[str] = None,
    force: bool = False,
    runtime_dir: Optional[Path] = None,
    use_env_runtime_dir: bool = True,
) -> dict:
    env_url = os.environ.get("BUTTERFLYUI_WEB_RUNTIME_URL", "").strip()
    env_sha256 = os.environ.get("BUTTERFLYUI_WEB_RUNTIME_SHA256", "").strip()
    url = (url or env_url or RUNTIME_ZIP_URL or "").strip()
    sha256 = (sha256 or env_sha256 or RUNTIME_ZIP_SHA256 or "").strip()

    if not url:
        raise ButterflyUIWebInstallError(
            "RUNTIME_ZIP_URL is not set. Edit butterflyui_web.__init__.py and set RUNTIME_ZIP_URL to your web runtime zip HTTPS URL."
        )

    _require_https(url)
    runtime_dir = runtime_dir or get_runtime_dir(use_env_runtime_dir=use_env_runtime_dir)
    existing = get_installed_info(runtime_dir, use_env_runtime_dir=use_env_runtime_dir)
    if not force and existing is not None:
        return existing

    runtime_dir.mkdir(parents=True, exist_ok=True)
    zip_path = _download_to_path(url, runtime_dir / "butterflyui-web.zip")
    if sha256:
        actual = _sha256_file(zip_path)
        if actual.lower() != sha256.lower():
            raise ButterflyUIWebInstallError("Runtime zip checksum does not match expected SHA256")

    with zipfile.ZipFile(zip_path, "r") as zf:
        zf.extractall(runtime_dir)

    return {"path": str(runtime_dir), "installed_at": time.time()}


@dataclass
class WebRuntimeHandle:
    url: str
    server: ThreadingHTTPServer
    thread: threading.Thread

    def stop(self) -> None:
        self.server.shutdown()


def _build_ws_url(host: str, port: int, path: str) -> str:
    host = host.strip()
    if host.startswith("ws://") or host.startswith("wss://"):
        return host
    normalized_path = path if path.startswith("/") else f"/{path}"
    return f"ws://{host}:{port}{normalized_path}"


def run(
    *,
    ws_url: Optional[str] = None,
    host: str = "127.0.0.1",
    port: int = 8765,
    path: str = "/ws",
    session_token: Optional[str] = None,
    runtime_dir: Optional[Path] = None,
    wait: bool = False,
    open_browser: bool = True,
    use_env_runtime_dir: bool = True,
    http_host: str = "127.0.0.1",
    http_port: Optional[int] = None,
    auto_install: bool = True,
) -> Optional[WebRuntimeHandle]:
    if auto_install:
        install(runtime_dir=runtime_dir, use_env_runtime_dir=use_env_runtime_dir)
    runtime_dir = runtime_dir or get_runtime_dir(use_env_runtime_dir=use_env_runtime_dir)
    if not runtime_dir.exists():
        raise ButterflyUIWebRunError("Web runtime not installed; call install() first")

    if ws_url is None:
        ws_url = _build_ws_url(host, port, path)

    handler = lambda *args, **kwargs: SimpleHTTPRequestHandler(
        *args,
        directory=str(runtime_dir),
        **kwargs,
    )
    server = ThreadingHTTPServer((http_host, http_port or 0), handler)
    actual_port = server.server_port
    params = {"ws": ws_url}
    if session_token:
        params["token"] = session_token
    query = urllib.parse.urlencode(params, quote_via=urllib.parse.quote)
    url = f"http://{http_host}:{actual_port}/?{query}"

    if wait:
        if open_browser:
            webbrowser.open(url)
        server.serve_forever()
        return None

    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    if open_browser:
        webbrowser.open(url)
    return WebRuntimeHandle(url=url, server=server, thread=thread)


__all__ = [
    "install",
    "run",
    "get_runtime_dir",
    "get_installed_info",
    "WebRuntimeHandle",
    "ButterflyUIWebInstallError",
    "ButterflyUIWebRunError",
]
