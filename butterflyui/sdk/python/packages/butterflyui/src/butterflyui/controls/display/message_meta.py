from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MessageMeta"]

class MessageMeta(Component):
    """Compact metadata line for chat messages.

    Renders a single ``Text`` widget that joins ``timestamp``,
    ``status``, and optional ``"edited"`` / ``"pinned"`` tags with
    bullet separators (``" \u2022 "``).  The line can be aligned
    left, centre, or right and supports a ``dense`` mode with a
    smaller font.

    Example::

        import butterflyui as bui

        meta = bui.MessageMeta(
            timestamp="2:34 PM",
            status="delivered",
            edited=True,
            align="right",
        )

    Args:
        timestamp: 
            Timestamp string (e.g. ``"2:34 PM"``).
        status: 
            Delivery status string (e.g. ``"sent"``, ``"delivered"``, ``"read"``).
        edited: 
            If ``True`` the word ``"edited"`` is appended.
        pinned: 
            If ``True`` the word ``"pinned"`` is appended.
        align: 
            Horizontal alignment — ``"start"`` (default), ``"center"``, ``"right"`` / ``"end"``.
        dense: 
            If ``True`` uses a smaller font size.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "message_meta"

    def __init__(
        self,
        *,
        timestamp: str | None = None,
        status: str | None = None,
        edited: bool | None = None,
        pinned: bool | None = None,
        align: str | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            timestamp=timestamp,
            status=status,
            edited=edited,
            pinned=pinned,
            align=align,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
