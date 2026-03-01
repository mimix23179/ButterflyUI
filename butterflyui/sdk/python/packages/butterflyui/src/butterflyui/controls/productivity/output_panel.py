from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["OutputPanel"]

class OutputPanel(Component):
    """
    Multi-channel output log panel similar to a terminal or IDE output view.

    The runtime renders a scrollable, read-only text log with support for
    multiple named channels. ``channels`` provides an initial mapping of
    channel name to content. ``active_channel`` sets the currently visible
    channel. Use ``append`` to add lines, ``clear_channel`` to empty a
    channel, and ``set_channel`` to switch the active channel.

    ```python
    import butterflyui as bui

    panel = bui.OutputPanel(
        channels={"stdout": "", "stderr": ""},
        active_channel="stdout",
    )
    ```

    Args:
        channels:
            Mapping of channel name to initial text content.
        active_channel:
            Name of the channel displayed on first render.
    """

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
