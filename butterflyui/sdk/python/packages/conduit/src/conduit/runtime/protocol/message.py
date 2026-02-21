from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True, slots=True)
class RuntimeMessage:
    type: str
    payload: dict[str, Any]
    id: str | None = None
    reply_to: str | None = None

    def to_dict(self) -> dict[str, Any]:
        data: dict[str, Any] = {"type": self.type, "payload": self.payload}
        if self.id is not None:
            data["id"] = self.id
        if self.reply_to is not None:
            data["reply_to"] = self.reply_to
        return data

    @staticmethod
    def from_dict(data: dict[str, Any]) -> "RuntimeMessage":
        msg_type = data.get("type")
        if not isinstance(msg_type, str) or not msg_type:
            raise ValueError("runtime message must include a non-empty 'type'")
        payload = data.get("payload")
        if payload is None:
            payload = {}
        if not isinstance(payload, dict):
            raise ValueError("runtime message 'payload' must be an object")
        msg_id = data.get("id")
        reply_to = data.get("reply_to")
        return RuntimeMessage(type=msg_type, payload=payload, id=msg_id, reply_to=reply_to)