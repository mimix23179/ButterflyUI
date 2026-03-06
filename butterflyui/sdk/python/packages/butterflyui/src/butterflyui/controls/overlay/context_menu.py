from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ContextMenu"]

class ContextMenu(Component):
    """
    Popup context menu bound to a child trigger surface.

    ``ContextMenu`` opens a floating action list on secondary click, long
    press, or tap (depending on ``trigger``/``open_on_tap``). Items may define
    icons, separators, enabled state, and custom payload fields. The runtime
    emits ``open``, ``dismiss``, ``select``, and ``change`` events.

    The menu shell supports styling/shape hints through ``props`` (for example
    ``bgcolor``, ``radius``, ``elevation``), and the trigger surface also
    accepts shared layout hints through ``props``.

    ```python
    import butterflyui as bui

    bui.ContextMenu(
        bui.Text("Right-click me"),
        items=[
            {"id": "copy", "label": "Copy"},
            {"id": "paste", "label": "Paste"},
        ],
    )
    ```

    Args:
        items:
            List of menu item spec mappings shown in the context menu.
        trigger:
            Gesture that opens the menu. Values: ``"secondary_tap"``,
            ``"long_press"``.
        open_on_tap:
            When ``True`` a primary tap also opens the context menu.
        props:
            Raw prop overrides merged after typed arguments, including trigger
            placement/layout hints and menu shell style hints.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
        **kwargs:
            Additional runtime props passed through to Flutter.
    """

    control_type = "context_menu"

    def __init__(
        self,
        child: Any | None = None,
        *,
        items: list[Any] | None = None,
        trigger: str | None = None,
        open_on_tap: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            trigger=trigger,
            open_on_tap=open_on_tap,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_items",
            {"items": [dict(item) for item in items]},
        )

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def open_at(self, session: Any, x: float, y: float) -> dict[str, Any]:
        return self.invoke(session, "open_at", {"x": x, "y": y})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
