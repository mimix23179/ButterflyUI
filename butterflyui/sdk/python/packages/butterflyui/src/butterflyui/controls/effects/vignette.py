from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Vignette"]

class Vignette(Component):
    """Radial vignette overlay that darkens the edges of the child
    content.

    The Flutter runtime renders a darkened radial gradient
    (``ButterflyUIVignette``) on top of the child.  The gradient
    fades from transparent at the centre to the configured *color* at
    the edges, with *intensity* controlling the gradient spread.

    Example::

        import butterflyui as bui

        vig = bui.Vignette(
            bui.Image(src="landscape.png"),
            intensity=0.5,
            color="#000000",
        )

    Args:
        intensity: 
            Vignette strength (``0.0`` transparent – ``1.0``
            opaque edges).  Defaults to ``0.45``.
        opacity: 
            Alias for *intensity* (the runtime accepts either).
        color: 
            Edge colour of the vignette gradient.  Defaults to
            the theme's default scaffold/background colour.
        enabled: 
            When ``False`` the overlay is hidden and the child
            renders unmodified.
    """
    control_type = "vignette"

    def __init__(
        self,
        child: Any | None = None,
        *,
        intensity: float | None = None,
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
            intensity=intensity,
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
