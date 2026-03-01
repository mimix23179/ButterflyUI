from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FittedBox"]

class FittedBox(Component):
    """
    Scales and positions its child to fit within the allocated bounds.

    The runtime wraps Flutter's ``FittedBox``. ``fit`` accepts Flutter
    ``BoxFit`` values: ``"contain"`` (default), ``"cover"``, ``"fill"``,
    ``"fitWidth"``, ``"fitHeight"``, ``"none"``, ``"scaleDown"``.
    ``alignment`` positions the child when empty space remains after fitting.
    ``clip_behavior`` clips overflow.

    ```python
    import butterflyui as bui

    bui.FittedBox(
        bui.Image(src="logo.png"),
        fit="contain",
        alignment="center",
    )
    ```

    Args:
        fit:
            Scaling mode. Values: ``"contain"``, ``"cover"``, ``"fill"``,
            ``"fitWidth"``, ``"fitHeight"``, ``"none"``, ``"scaleDown"``.
        alignment:
            Positions the child within unfilled space after fitting.
        clip_behavior:
            Anti-aliasing clip mode applied when the child overflows.
    """

    control_type = "fitted_box"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        fit: str | None = None,
        alignment: Any | None = None,
        clip_behavior: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            fit=fit,
            alignment=alignment,
            clip_behavior=clip_behavior,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
