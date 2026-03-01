from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ContextMenu"]

class ContextMenu(Component):
    """Contextual pop-up menu triggered by pointer events.

    Renders a floating menu anchored near a trigger widget, presenting a list
    of actions within the Flutter widget tree.

    Example:
        ```python
        menu = ContextMenu(items=[{"label": "Cut"}, {"label": "Paste"}])
        ```

    Args:
        items: List of menu item descriptors to display.
        trigger: Child widget that activates the menu.
        open_on_tap: Whether to open the menu on a tap instead of long-press.
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
