from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Tooltip"]

class Tooltip(Component):
    """
    Hover tooltip that displays a short message near its child widget.

    The runtime wraps Flutter's ``Tooltip`` widget. ``message`` is the
    text shown in the tooltip bubble. ``prefer_below`` positions the
    tooltip below the child when ``True`` (default) or above when ``False``.
    ``wait_ms`` sets the hover delay before the tooltip appears.

    ```python
    import butterflyui as bui

    bui.Tooltip(
        bui.IconButton(icon="info"),
        message="Show information",
        prefer_below=True,
        wait_ms=500,
    )
    ```

    Args:
        message:
            Text displayed inside the tooltip bubble.
        prefer_below:
            When ``True`` the tooltip prefers to appear below the child.
        wait_ms:
            Hover delay in milliseconds before the tooltip is shown.
    """

    control_type = "tooltip"

    def __init__(
        self,
        child: Any | None = None,
        *,
        message: str | None = None,
        prefer_below: bool | None = None,
        wait_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            message=message,
            prefer_below=prefer_below,
            wait_ms=wait_ms,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
