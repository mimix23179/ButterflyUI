from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["RippleBurst"]

@butterfly_control('ripple_burst')
class RippleBurst(EffectControl):
    """
    Expanding concentric ripple rings triggered by tap or
    programmatic ``burst()`` call.

    The Flutter runtime paints *count* concentric circles on a
    ``CustomPaint`` foreground canvas.  An ``AnimationController``
    drives the expansion; each ring is staggered, fading out and
    thinning as it grows toward ``max_radius``.  A ``GestureDetector``
    fires a burst on tap; the ``burst()`` invoke method triggers the
    same animation from Python.

    Example:

    ```python
    import butterflyui as bui

    ripple = bui.RippleBurst(
        bui.Container(width=200, height=200),
        color="#22d3ee",
        count=4,
        duration_ms=600,
        max_radius=120,
    )
    ```
    """

    color: Any | None = None
    """
    Ripple ring colour.  Defaults to the primary colour
    from the current theme.
    """

    count: int | None = None
    """
    Number of concentric rings per burst (``1`` – ``8``).
    Defaults to ``3``.
    """

    duration_ms: int | None = None
    """
    Burst animation duration in milliseconds.
    Defaults to ``500``.
    """

    max_radius: float | None = None
    """
    Maximum expansion radius in logical pixels.
    Defaults to ``90``.
    """

    center: Any | None = None
    """
    Reserved — custom ripple origin point.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `ripple_burst` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `ripple_burst` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `ripple_burst` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `ripple_burst` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `ripple_burst` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `ripple_burst` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `ripple_burst` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `ripple_burst` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `ripple_burst` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `ripple_burst` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `ripple_burst` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `ripple_burst` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `ripple_burst` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `ripple_burst` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `ripple_burst` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `ripple_burst` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `ripple_burst` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `ripple_burst` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `ripple_burst` runtime control.
    """

    def burst(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "burst", {"payload": dict(payload or {})})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
