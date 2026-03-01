from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ChromaticShift"]

class ChromaticShift(Component):
    """Chromatic aberration effect that renders offset red and blue
    colour-filtered copies of the child behind the original.

    The Flutter runtime stacks three layers: a red-tinted copy shifted
    by ``-shift`` pixels, a blue-tinted copy shifted by ``+shift``
    pixels, and the unmodified child on top.  The shift direction is
    governed by ``axis`` (``"x"`` or ``"y"``).

    Example::

        import butterflyui as bui

        fx = bui.ChromaticShift(
            bui.Image(src="photo.png"),
            shift=2.5,
            opacity=0.35,
        )

    Args:
        shift: 
            Pixel distance each colour channel is 
            offset from the original.  Defaults to ``1.2``.
        opacity: 
            Opacity of the red and blue ghost layers 
            (``0.0`` – ``1.0``).  Defaults to ``0.35``.
        axis: 
            Displacement axis — ``"x"`` (horizontal, default) 
            or ``"y"`` (vertical).
        red: 
            Colour used for the *red* channel ghost layer. 
            Defaults to ``Colors.red``.
        blue: 
            Colour used for the *blue* channel ghost layer. 
            Defaults to ``Colors.blue``.
    """
    control_type = "chromatic_shift"

    def __init__(
        self,
        child: Any | None = None,
        *,
        shift: float | None = None,
        opacity: float | None = None,
        axis: str | None = None,
        red: Any | None = None,
        blue: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            shift=shift,
            opacity=opacity,
            axis=axis,
            red=red,
            blue=blue,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_shift(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_shift", {"value": float(value)})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
