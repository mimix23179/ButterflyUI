from __future__ import annotations

import asyncio
import logging
import uuid
from typing import Any, Optional

from websockets import ServerConnection, serve
from websockets.exceptions import ConnectionClosed

from ..protocol.codec import decode_message, encode_message, build_message

_log = logging.getLogger(__name__)


class WebSocketRuntimeServer:
    """Transport-only WebSocket server that handles runtime.hello/ack."""

    def __init__(
        self,
        *,
        host: str = "127.0.0.1",
        port: int = 8765,
        path: str = "/ws",
        token: str | None = None,
        require_token: bool = False,
        protocol: int = 1,
        target_fps: int = 60,
        on_event: callable | None = None,
        on_result: callable | None = None,
        on_applied: callable | None = None,
    ) -> None:
        self.host = host
        self.port = port
        self.path = path
        self.token = token
        self.require_token = require_token
        self.protocol = protocol
        self.target_fps = int(target_fps)
        self._on_event = on_event
        self._on_result = on_result
        self._on_applied = on_applied

        self._server: Any | None = None
        self._ws: ServerConnection | None = None
        self._session_id: str | None = None
        self._hello_event = asyncio.Event()
        self._disconnect_event = asyncio.Event()
        self._hello_payload: dict[str, Any] | None = None

    @property
    def session_id(self) -> str | None:
        return self._session_id

    @property
    def url(self) -> str:
        return f"ws://{self.host}:{self.port}{self.path}"

    async def start(self) -> None:
        if self._server is not None:
            return

        async def _handler(ws: ServerConnection) -> None:
            path = getattr(ws, "path", None)
            if self.path and path and path != self.path:
                await ws.close(code=1008, reason="Invalid path")
                return
            self._ws = ws
            self._session_id = uuid.uuid4().hex
            _log.info("Runtime connected: %s", ws.remote_address)
            try:
                async for raw in ws:
                    await self._handle_message(raw)
            except ConnectionClosed as exc:
                _log.info("Runtime disconnected: %s", exc)
            except Exception as exc:
                _log.exception("Runtime transport error: %s", exc)
            finally:
                self._disconnect_event.set()
                self._ws = None

        self._server = await serve(_handler, self.host, self.port)

        if self._server.sockets:
            sock = self._server.sockets[0]
            self.port = sock.getsockname()[1]

    async def stop(self) -> None:
        if self._server is None:
            return
        self._server.close()
        await self._server.wait_closed()
        self._server = None

    async def wait_for_hello(self, *, timeout: float | None = None) -> dict[str, Any] | None:
        try:
            await asyncio.wait_for(self._hello_event.wait(), timeout=timeout)
        except asyncio.TimeoutError:
            return None
        return self._hello_payload

    async def wait_for_disconnect(self) -> None:
        await self._disconnect_event.wait()

    async def send(
        self,
        msg_type: str,
        payload: dict[str, Any] | None = None,
        *,
        msg_id: str | None = None,
        reply_to: str | None = None,
    ) -> None:
        if self._ws is None:
            return
        message = build_message(msg_type, payload or {}, msg_id=msg_id, reply_to=reply_to)
        await self._ws.send(encode_message(message))

    async def _handle_message(self, raw: str | bytes) -> None:
        message = decode_message(raw)
        if message.type == "runtime.hello":
            payload = message.payload or {}
            token = payload.get("token")
            if self.require_token and (token is None or str(token) != str(self.token)):
                await self._close_with_error("Invalid token")
                return

            self._hello_payload = payload
            self._hello_event.set()

            client_protocol_raw = payload.get("protocol")
            try:
                client_protocol = int(client_protocol_raw)
            except Exception:
                client_protocol = None

            ack_payload = {
                "protocol": int(self.protocol),
                "client_protocol": client_protocol,
                "session_id": self._session_id,
                "server": "python",
                "target_fps": self.target_fps,
            }
            reply_to = message.id
            ack = build_message("runtime.hello_ack", ack_payload, reply_to=reply_to)
            if self._ws is not None:
                await self._ws.send(encode_message(ack))
            return

        if message.type == "ui.event":
            if self._on_event is not None:
                self._on_event(message.payload or {})
            return

        if message.type == "invoke.result":
            if self._on_result is not None:
                self._on_result(message.payload or {}, message.reply_to)
            return

        if message.type == "ui.applied":
            if self._on_applied is not None:
                self._on_applied(message.payload or {})
            return

    async def _close_with_error(self, reason: str) -> None:
        if self._ws is None:
            return
        await self._ws.close(code=1008, reason=reason)
