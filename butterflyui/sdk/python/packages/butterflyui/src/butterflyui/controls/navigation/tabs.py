from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Tabs"]

class Tabs(Component):
    """
    Horizontal tab bar for switching between views.

    The runtime renders a Flutter tab bar. ``labels`` supplies the tab
    label strings. ``index`` sets the active tab (0-based). ``scrollable``
    allows the tab bar to scroll horizontally when there are more tabs than
    fit in the available width. Positional children can inject custom tab
    content.

    ```python
    import butterflyui as bui

    bui.Tabs(
        bui.Text("Content A"),
        bui.Text("Content B"),
        labels=["Tab A", "Tab B"],
        index=0,
    )
    ```

    Args:
        labels:
            List of tab label strings.
        index:
            Zero-based index of the currently selected tab.
        scrollable:
            When ``True`` the tab bar scrolls horizontally on overflow.
    """

    control_type = "tabs"

    def __init__(
        self,
        *children: Any,
        labels: list[str] | None = None,
        index: int | None = None,
        scrollable: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            labels=labels,
            index=index,
            scrollable=scrollable,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
