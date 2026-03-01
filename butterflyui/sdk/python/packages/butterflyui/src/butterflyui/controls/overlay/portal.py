from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Portal"]

class Portal(Component):
    """
    Renders portal content into a separate overlay layer above the widget tree.

    The runtime keeps the ``child`` widget in the normal layout tree but
    projects the ``portal`` content to a top-level overlay layer. ``open``
    controls whether the portal overlay is visible. ``dismissible`` closes
    it on outside tap. ``passthrough`` allows pointer events to reach
    widgets behind the portal. ``alignment`` and ``offset`` position the
    portal content.

    ```python
    import butterflyui as bui

    bui.Portal(
        child=bui.Button(label="Open"),
        portal=bui.Text("Portal content"),
        open=True,
        alignment="center",
    )
    ```

    Args:
        portal:
            The widget projected into the top-level overlay layer.
        open:
            When ``True`` the portal overlay is visible.
        dismissible:
            When ``True`` tapping outside closes the portal.
        passthrough:
            When ``True`` pointer events pass through to widgets below.
        alignment:
            Alignment of the portal content within the overlay area.
        offset:
            Offset of the portal content from the alignment position.
    """

    control_type = "portal"

    def __init__(
        self,
        child: Any | None = None,
        portal: Any | None = None,
        *,
        open: bool | None = None,
        dismissible: bool | None = None,
        passthrough: bool | None = None,
        alignment: Any | None = None,
        offset: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            child=child,
            portal=portal,
            open=open,
            dismissible=dismissible,
            passthrough=passthrough,
            alignment=alignment,
            offset=offset,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
