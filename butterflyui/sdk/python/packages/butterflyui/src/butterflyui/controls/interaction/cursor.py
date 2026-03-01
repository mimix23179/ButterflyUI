from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Cursor"]

class Cursor(Component):
    """
    Wraps a child widget and overrides the mouse cursor shown on hover.

    The Flutter runtime wraps the child in a ``MouseRegion`` configured
    with the requested ``cursor`` style.  When ``opaque`` is ``True``
    the region absorbs pointer events so they do not propagate to
    widgets underneath.  Cursor changes can also be applied
    imperatively via :meth:`set_cursor`.

    ```python
    import butterflyui as bui

    bui.Cursor(bui.Text("Hover me"), cursor="click")
    ```

    Args:
        cursor:
            Flutter ``SystemMouseCursor`` name to display while the
            pointer is over the child — e.g. ``"click"``,
            ``"text"``, ``"forbidden"``, ``"grab"``, ``"move"``.
        enabled:
            If ``False``, the cursor override is inactive and the
            default cursor is used.
        opaque:
            If ``True``, the ``MouseRegion`` absorbs pointer events,
            preventing them from reaching widgets behind it.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "cursor"

    def __init__(
        self,
        child: Any | None = None,
        *,
        cursor: str | None = None,
        enabled: bool | None = None,
        opaque: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            cursor=cursor,
            enabled=enabled,
            opaque=opaque,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_cursor(self, session: Any, cursor: str) -> dict[str, Any]:
        return self.invoke(session, "set_cursor", {"cursor": cursor})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
