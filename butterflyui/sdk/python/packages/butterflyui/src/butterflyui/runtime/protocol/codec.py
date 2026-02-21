from __future__ import annotations

import json
from typing import Any

from .message import RuntimeMessage


def encode_message(message: RuntimeMessage) -> str:
    return json.dumps(message.to_dict(), separators=(",", ":"))


def decode_message(raw: str | bytes) -> RuntimeMessage:
    if isinstance(raw, bytes):
        raw = raw.decode("utf-8")
    data = json.loads(raw)
    if not isinstance(data, dict):
        raise ValueError("runtime message must be a JSON object")
    return RuntimeMessage.from_dict(data)


def build_message(
    msg_type: str,
    payload: dict[str, Any] | None = None,
    *,
    msg_id: str | None = None,
    reply_to: str | None = None,
) -> RuntimeMessage:
    return RuntimeMessage(type=msg_type, payload=payload or {}, id=msg_id, reply_to=reply_to)