from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PaneSpec"]

class PaneSpec(Component):
    """
    Size specification and collapse state for a named layout pane.

    Extends the basic pane descriptor with resize constraints and
    collapsibility. ``min_size`` and ``max_size`` bound resize drag
    operations. ``collapsible`` enables the user to collapse the pane;
    ``collapsed`` drives the collapsed state programmatically.

    ```python
    import butterflyui as bui

    bui.PaneSpec(
        slot="left",
        size=240,
        min_size=120,
        max_size=400,
        collapsible=True,
    )
    ```

    Args:
        slot:
            Slot identifier that controls placement within the parent layout.
        title:
            Optional display title for the pane.
        size:
            Preferred size in logical pixels.
        width:
            Explicit width hint in logical pixels.
        height:
            Explicit height hint in logical pixels.
        min_size:
            Minimum size in logical pixels when resizing.
        max_size:
            Maximum size in logical pixels when resizing.
        collapsible:
            When ``True`` the pane can be collapsed to zero size.
        collapsed:
            When ``True`` the pane is currently in the collapsed state.
    """

    control_type = "pane_spec"

    def __init__(
        self,
        child: Any | None = None,
        *,
        slot: str | None = None,
        title: str | None = None,
        size: float | None = None,
        width: float | None = None,
        height: float | None = None,
        min_size: float | None = None,
        max_size: float | None = None,
        collapsible: bool | None = None,
        collapsed: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            slot=slot,
            title=title,
            size=size,
            width=width,
            height=height,
            min_size=min_size,
            max_size=max_size,
            collapsible=collapsible,
            collapsed=collapsed,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
