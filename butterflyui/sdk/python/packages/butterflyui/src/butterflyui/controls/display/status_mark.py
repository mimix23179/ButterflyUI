from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["StatusMark"]

class StatusMark(Component):
    """Coloured status dot with label and optional value.

    Renders a small coloured circle whose colour is derived from the
    ``status`` keyword (``"ok"``/``"success"`` → green,
    ``"warn"``/``"warning"`` → orange, ``"error"``/``"danger"`` → red,
    ``"info"`` → light blue, default grey) or overridden by ``color``.
    An optional ``icon``, ``label`` text, and bold ``value`` text are
    placed to the right of the dot.

    Tapping the mark emits ``"select"`` with label, value, and status.
    Use ``set_status`` to update the status keyword and ``get_state``
    to retrieve the current display state.

    Example::

        import butterflyui as bui

        mark = bui.StatusMark(
            label="API",
            status="ok",
            value="200 ms",
        )

    Args:
        label: 
            Text displayed to the right of the status dot.
        status: 
            Semantic status keyword — ``"ok"``, ``"success"``, ``"warn"``, ``"warning"``, ``"error"``, ``"danger"``, ``"info"``, or any other string (defaults to grey).
        value: 
            Bold secondary text after the label.
        icon: 
            Optional Material icon rendered between the dot and the label.
        dense: 
            If ``True`` uses smaller dot and tighter padding.
        align: 
            Horizontal alignment hint.
        color: 
            Explicit dot colour overriding the ``status`` default.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "status_mark"

    def __init__(
        self,
        *,
        label: str | None = None,
        status: str | None = None,
        value: str | None = None,
        icon: str | None = None,
        dense: bool | None = None,
        align: str | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            status=status,
            value=value,
            icon=icon,
            dense=dense,
            align=align,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_status(self, session: Any, status: str) -> dict[str, Any]:
        return self.invoke(session, "set_status", {"status": status})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
