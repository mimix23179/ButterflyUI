from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Pane"]

class Pane(Component):
    """
    Named pane for use inside a slot-based layout such as ``DockLayout``.

    Declares a slot-addressed pane. The ``slot`` string tells the parent
    layout where to place this pane (e.g. ``"top"``, ``"left"``,
    ``"fill"``). ``title`` labels the pane in containers that show titles.
    ``size``, ``width``, and ``height`` hint at the preferred dimensions.

    ```python
    import butterflyui as bui

    bui.Pane(
        bui.Text("Sidebar"),
        slot="left",
        size=240,
    )
    ```

    Args:
        slot:
            Slot identifier that controls placement within the parent layout.
        title:
            Optional display title for the pane.
        size:
            Preferred size in logical pixels along the pane's constrained axis.
        width:
            Explicit width hint in logical pixels.
        height:
            Explicit height hint in logical pixels.
    """

    control_type = "pane"

    def __init__(
        self,
        child: Any | None = None,
        *,
        slot: str | None = None,
        title: str | None = None,
        size: float | None = None,
        width: float | None = None,
        height: float | None = None,
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
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
