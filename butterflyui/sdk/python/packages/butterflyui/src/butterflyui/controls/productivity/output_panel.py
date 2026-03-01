from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["OutputPanel"]

class OutputPanel(Component):
    control_type = "output_panel"

    def __init__(
        self,
        *,
        channels: Mapping[str, Any] | None = None,
        active_channel: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            channels=channels,
            active_channel=active_channel,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def append(self, session: Any, text: str, channel: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {"text": text}
        if channel is not None:
            payload["channel"] = channel
        return self.invoke(session, "append", payload)

    def clear_channel(self, session: Any, channel: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if channel is not None:
            payload["channel"] = channel
        return self.invoke(session, "clear_channel", payload)

    def set_channel(self, session: Any, channel: str) -> dict[str, Any]:
        return self.invoke(session, "set_channel", {"channel": channel})

    def get_channel(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_channel", {})
