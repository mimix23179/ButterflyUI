from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["InfoBar"]

class InfoBar(Component):
    """
    Displays contextual information, hints, or status text.

    Typically rendered as a compact horizontal bar showing one or more
    informational items or a single text message. Useful for status
    lines, tooltips, or contextual hints in editor UIs.

    ```python
    import butterflyui as bui

    bui.InfoBar(
        text="Ready",
        items=[
            {"label": "Width", "value": "1920"},
            {"label": "Height", "value": "1080"},
        ],
        dense=True,
    )
    ```

    Args:
        items: 
            List of info-item dicts. Each item may have ``"label"`` and ``"value"`` keys.
        text: 
            Plain text message displayed in the bar.
        dense: 
            If ``True``, the bar is rendered in a compact layout.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "info_bar"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        text: str | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            text=text,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
