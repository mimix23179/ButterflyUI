from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BorderSide"]

class BorderSide(Component):
    """
    Renders a single border line on one or more sides of the parent.

    Unlike :class:`Border`, which wraps a child, ``BorderSide`` draws a
    standalone line (a thin ``SizedBox`` with a side decoration). It is
    useful for separator-style borders. It also accepts per-side maps via
    `top`, `right`, `bottom`, and `left` for individual configuration.

    ```python
    import butterflyui as bui

    bui.BorderSide(side="bottom", color="#64748b", width=1)
    ```

    Args:
        side: 
            Which side to draw: ``"top"``, ``"right"``, ``"bottom"`` (default), or ``"left"``.
        color: 
            Line colour. Defaults to ``"#64748b"`` (slate-500).
        width: 
            Line thickness in logical pixels. Defaults to ``1``.
        length: 
            Line length in logical pixels. Defaults to ``double.infinity`` (stretches to fill).
        top: 
            Per-side override for the top border as a dict with ``"color"`` and/or ``"width"``.
        right: 
            Per-side override for the right border.
        bottom: 
            Per-side override for the bottom border.
        left: 
            Per-side override for the left border.
        animated: 
            If ``True``, transitions are animated via ``AnimatedContainer``.
        duration_ms: 
            Animation duration in milliseconds. Defaults to ``180``.
    """
    control_type = "border_side"

    def __init__(
        self,
        *,
        side: str | None = None,
        color: Any | None = None,
        width: float | None = None,
        length: float | None = None,
        top: Mapping[str, Any] | None = None,
        right: Mapping[str, Any] | None = None,
        bottom: Mapping[str, Any] | None = None,
        left: Mapping[str, Any] | None = None,
        animated: bool | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            side=side,
            color=color,
            width=width,
            length=length,
            top=dict(top) if top is not None else None,
            right=dict(right) if right is not None else None,
            bottom=dict(bottom) if bottom is not None else None,
            left=dict(left) if left is not None else None,
            animated=animated,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
