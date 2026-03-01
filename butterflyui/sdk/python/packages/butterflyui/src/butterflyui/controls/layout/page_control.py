from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PageControl"]

class PageControl(Component):
    """
    Root page container that optionally respects device safe-area insets.

    Maps to the outermost Flutter page widget. When ``safe_area`` is ``True``
    the page content is inset to avoid the device's status bar, navigation
    bar, and notch.

    ```python
    import butterflyui as bui

    bui.PageControl(
        bui.Text("Hello"),
        safe_area=True,
    )
    ```

    Args:
        safe_area:
            When ``True`` wraps content in a ``SafeArea`` to avoid OS
            intrusions. Defaults to ``True``.
    """

    control_type = "page"

    def __init__(
        self,
        *children: Any,
        safe_area: bool = True,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, safe_area=safe_area, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)
