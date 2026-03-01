from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["OverflowBox"]

class OverflowBox(Component):
    """
    Imposes its own constraints on its child, allowing deliberate overflow.

    The runtime wraps Flutter's ``OverflowBox``. The four constraint
    properties override those passed by the parent, so the child may render
    larger than its allocated space. ``alignment`` positions the child when
    it does not fill the box. ``fit`` controls whether the override
    constraints are applied loosely or tightly.

    ```python
    import butterflyui as bui

    bui.OverflowBox(
        bui.Image(src="large.png"),
        max_width=800,
        max_height=600,
        alignment="center",
    )
    ```

    Args:
        min_width:
            Minimum width override passed to the child.
        min_height:
            Minimum height override passed to the child.
        max_width:
            Maximum width override passed to the child.
        max_height:
            Maximum height override passed to the child.
        alignment:
            Aligns the child within the box when it does not fill it.
        fit:
            Constraint application mode. Values: ``"loose"``, ``"tight"``.
    """

    control_type = "overflow_box"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        min_width: float | None = None,
        min_height: float | None = None,
        max_width: float | None = None,
        max_height: float | None = None,
        alignment: Any | None = None,
        fit: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            min_width=min_width,
            min_height=min_height,
            max_width=max_width,
            max_height=max_height,
            alignment=alignment,
            fit=fit,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
