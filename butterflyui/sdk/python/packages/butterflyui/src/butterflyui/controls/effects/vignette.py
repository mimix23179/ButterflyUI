from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["Vignette"]

@butterfly_control('vignette')
class Vignette(EffectControl):
    """
    Radial vignette overlay that darkens the edges of the child
    content.

    The Flutter runtime renders a darkened radial gradient
    (``ButterflyUIVignette``) on top of the child.  The gradient
    fades from transparent at the centre to the configured *color* at
    the edges, with *intensity* controlling the gradient spread.

    Example:

    ```python
    import butterflyui as bui

    vig = bui.Vignette(
        bui.Image(src="landscape.png"),
        intensity=0.5,
        color="#000000",
    )
    ```
    """

    intensity: float | None = None
    """
    Vignette strength (``0.0`` transparent – ``1.0``
    opaque edges).  Defaults to ``0.45``.
    """

    softness: Any | None = None
    """
    Softness value forwarded to the `vignette` runtime control.
    """

    blend_mode: Any | None = None
    """
    Blend mode value forwarded to the `vignette` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

