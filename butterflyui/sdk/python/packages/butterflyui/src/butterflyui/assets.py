from __future__ import annotations

import base64
import mimetypes
import secrets
import threading
import time
import urllib.parse
from dataclasses import dataclass
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any, Iterable, Mapping, Optional

__all__ = [
    "AssetServer",
    "data_uri_from_base64",
    "file_payload_to_src",
    "files_payload_to_srcs",
]


@dataclass(slots=True)
class _AssetEntry:
    path: Path | None
    data: bytes | None
    mime: str
    filename: str
    expires_at: float | None

    def expired(self) -> bool:
        return self.expires_at is not None and time.time() >= self.expires_at


class _AssetHTTPServer(ThreadingHTTPServer):
    def __init__(self, server_address: tuple[str, int], handler: type[BaseHTTPRequestHandler], asset_server: "AssetServer") -> None:
        self.asset_server = asset_server
        super().__init__(server_address, handler)


class _AssetHandler(BaseHTTPRequestHandler):
    def do_HEAD(self) -> None:  # noqa: N802
        self._handle_request(head_only=True)

    def do_GET(self) -> None:  # noqa: N802
        self._handle_request(head_only=False)

    def _handle_request(self, *, head_only: bool) -> None:
        server = self.server
        if not isinstance(server, _AssetHTTPServer):
            self.send_error(HTTPStatus.INTERNAL_SERVER_ERROR)
            return
        asset_server = server.asset_server
        entry = asset_server._resolve_request(self.path)
        if entry is None:
            self.send_error(HTTPStatus.NOT_FOUND)
            return

        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", entry.mime)
        self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Disposition", f'inline; filename="{entry.filename}"')
        if entry.data is not None:
            self.send_header("Content-Length", str(len(entry.data)))
        elif entry.path is not None:
            try:
                self.send_header("Content-Length", str(entry.path.stat().st_size))
            except Exception:
                pass
        self.end_headers()

        if head_only:
            return
        if entry.data is not None:
            self.wfile.write(entry.data)
        elif entry.path is not None:
            try:
                with entry.path.open("rb") as handle:
                    while True:
                        chunk = handle.read(1024 * 128)
                        if not chunk:
                            break
                        self.wfile.write(chunk)
            except Exception:
                self.send_error(HTTPStatus.INTERNAL_SERVER_ERROR)

    def log_message(self, format: str, *args: Any) -> None:
        # Keep the asset server quiet by default.
        return


class AssetServer:
    def __init__(self, *, host: str = "127.0.0.1", port: int = 0, base_path: str = "/assets") -> None:
        self.host = host
        self.port = int(port)
        normalized = (base_path or "/assets").strip() or "/assets"
        if not normalized.startswith("/"):
            normalized = f"/{normalized}"
        if normalized != "/" and normalized.endswith("/"):
            normalized = normalized[:-1]
        self.base_path = normalized
        self._server: _AssetHTTPServer | None = None
        self._thread: threading.Thread | None = None
        self._lock = threading.Lock()
        self._entries: dict[str, _AssetEntry] = {}

    def start(self) -> None:
        if self._server is not None:
            return
        self._server = _AssetHTTPServer((self.host, self.port), _AssetHandler, self)
        self.port = int(self._server.server_address[1])
        self._thread = threading.Thread(target=self._server.serve_forever, name="ButterflyUIAssetServer", daemon=True)
        self._thread.start()

    def stop(self) -> None:
        if self._server is None:
            return
        self._server.shutdown()
        self._server.server_close()
        self._server = None
        if self._thread is not None:
            self._thread.join(timeout=2.0)
        self._thread = None

    def clear(self) -> None:
        with self._lock:
            self._entries.clear()

    @property
    def base_url(self) -> str:
        if self._server is None:
            self.start()
        return f"http://{self.host}:{self.port}{self.base_path}"

    def register_file(
        self,
        path: str | Path,
        *,
        filename: Optional[str] = None,
        mime: Optional[str] = None,
        ttl: Optional[float] = None,
    ) -> str:
        file_path = Path(path).expanduser().resolve()
        if not file_path.exists():
            raise FileNotFoundError(str(file_path))
        name = filename or file_path.name
        mime = mime or _guess_mime(name)
        token = secrets.token_urlsafe(16)
        expires_at = None if ttl is None else time.time() + float(ttl)
        with self._lock:
            self._entries[token] = _AssetEntry(path=file_path, data=None, mime=mime, filename=name, expires_at=expires_at)
        return self.url_for(token, name)

    def register_bytes(
        self,
        data: bytes,
        *,
        filename: Optional[str] = None,
        mime: Optional[str] = None,
        ttl: Optional[float] = None,
    ) -> str:
        name = filename or "blob"
        mime = mime or _guess_mime(name)
        token = secrets.token_urlsafe(16)
        expires_at = None if ttl is None else time.time() + float(ttl)
        with self._lock:
            self._entries[token] = _AssetEntry(path=None, data=bytes(data), mime=mime, filename=name, expires_at=expires_at)
        return self.url_for(token, name)

    def url_for(self, token: str, filename: Optional[str] = None) -> str:
        name = filename or token
        safe_name = urllib.parse.quote(name)
        return f"{self.base_url}/{token}/{safe_name}"

    def _resolve_request(self, raw_path: str) -> _AssetEntry | None:
        parsed = urllib.parse.urlparse(raw_path)
        path = parsed.path or ""
        if not path.startswith(self.base_path + "/"):
            return None
        remainder = path[len(self.base_path) + 1 :]
        token = remainder.split("/", 1)[0]
        if not token:
            return None
        with self._lock:
            entry = self._entries.get(token)
            if entry is None:
                return None
            if entry.expired():
                self._entries.pop(token, None)
                return None
            return entry

    def __enter__(self) -> "AssetServer":
        self.start()
        return self

    def __exit__(self, exc_type: Any, exc: Any, tb: Any) -> None:
        self.stop()


def _guess_mime(name: Optional[str]) -> str:
    if name:
        mime, _ = mimetypes.guess_type(name)
        if mime:
            return mime
    return "application/octet-stream"


def _decode_base64(value: str) -> bytes:
    padded = value + "=" * (-len(value) % 4)
    return base64.b64decode(padded)


def data_uri_from_base64(value: str, *, mime: Optional[str] = None) -> str:
    mime = mime or "application/octet-stream"
    return f"data:{mime};base64,{value}"


def file_payload_to_src(
    file_payload: Mapping[str, Any] | None,
    *,
    prefer_data: bool = False,
    asset_server: AssetServer | None = None,
) -> Optional[str]:
    if not isinstance(file_payload, Mapping):
        return None
    path = file_payload.get("path")
    name = file_payload.get("name")
    ext = file_payload.get("extension")
    b64 = file_payload.get("bytes")
    filename = str(name) if name else (f"file.{ext}" if ext else None)
    mime = _guess_mime(filename)

    if prefer_data and isinstance(b64, str) and b64:
        return data_uri_from_base64(b64, mime=mime)

    if asset_server is not None:
        if path:
            return asset_server.register_file(path, filename=filename, mime=mime)
        if isinstance(b64, str) and b64:
            try:
                data = _decode_base64(b64)
            except Exception:
                data = None
            if data is not None:
                return asset_server.register_bytes(data, filename=filename, mime=mime)

    if path:
        return str(path)
    if isinstance(b64, str) and b64:
        return data_uri_from_base64(b64, mime=mime)
    return None


def files_payload_to_srcs(
    files: Iterable[Mapping[str, Any]] | None,
    *,
    prefer_data: bool = False,
    asset_server: AssetServer | None = None,
) -> list[str]:
    out: list[str] = []
    if not files:
        return out
    for item in files:
        src = file_payload_to_src(item, prefer_data=prefer_data, asset_server=asset_server)
        if src:
            out.append(src)
    return out
