from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ContextMenu"]

class ContextMenu(Component):
    """
    Context menu that appears near a trigger widget on right-click or long-press.

    The runtime wraps its child with an interactive region that opens a
    floating menu populated by ``items``. ``trigger`` selects the activation
    gesture; ``open_on_tap`` additionally opens the menu on a regular tap.

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
