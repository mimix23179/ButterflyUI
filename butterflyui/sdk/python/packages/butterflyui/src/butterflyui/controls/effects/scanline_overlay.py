from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ScanlineOverlay"]

class ScanlineOverlay(Component):
    """CRT-style horizontal scanline overlay rendered on top of the
    child content.

    The Flutter runtime paints evenly-spaced horizontal lines using a
    custom ``ButterflyUIScanlineOverlay`` widget.  Line spacing,
    thickness, opacity, and colour are all configurable at creation
    time and can be updated at runtime via the ``set_style()`` invoke
    method.

    Example::

        import butterflyui as bui

        crt = bui.ScanlineOverlay(
            bui.Image(src="retro.png"),
            spacing=6,
            thickness=1,
            opacity=0.18,
            color="#00ff00",
        )

    Args:
        spacing: 
            Vertical distance between scanlines in logical pixels
            (``1`` – ``256``).  Defaults to ``6``.
        thickness: 
            Stroke thickness of each scanline (``0.5`` –
            ``32``).  Defaults to ``1``.
        opacity: 
            Scanline opacity (``0.0`` – ``1.0``).  Defaults to
            ``0.18``.
        color: 
            Scanline colour.  Defaults to the current theme's
            text colour.
        enabled: 
            When ``False`` the overlay is hidden and the child
            is rendered unmodified.
    """
    control_type = "scanline_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *,
        spacing: float | None = None,
        thickness: float | None = None,
        opacity: float | None = None,
        color: Any | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing,
            thickness=thickness,
            opacity=opacity,
            color=color,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
