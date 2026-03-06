from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["NeonEdge"]

@butterfly_control('neon_edge')
class NeonEdge(EffectControl):
    """
    Neon-glow border effect rendered as a ``BoxDecoration`` with a
    coloured ``Border.all`` stroke and a matching ``BoxShadow``.

    The Flutter runtime wraps the child in either a plain ``Container``
    or an ``AnimatedContainer`` (when ``animated`` is ``True``), whose
    ``BoxDecoration`` combines a coloured border, a glow shadow, and a
    corner radius.

    Example:

    ```python
    import butterflyui as bui

    neon = bui.NeonEdge(
        bui.Text("Glow"),
        color="#22d3ee",
        width=2,
        glow=12,
        radius=12,
        animated=True,
    )
    ```
    """

    color: Any | None = None
    """
    Border and glow colour.  Defaults to ``#22D3EE``.
    """

    glow: float | None = None
    """
    Blur radius of the outer glow ``BoxShadow``.  Defaults
    to ``10``.
    """

    spread: float | None = None
    """
    Spread radius of the glow shadow.  Defaults to ``0``.
    """

    radius: float | None = None
    """
    Corner radius of the ``BoxDecoration``.  Defaults to
    ``12``.
    """

    animated: bool | None = None
    """
    When ``True`` the container uses
    ``AnimatedContainer`` for smooth property transitions.
    """

    duration_ms: int | None = None
    """
    Animation duration in milliseconds when
    *animated* is ``True``.  Defaults to ``300``.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `neon_edge` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `neon_edge` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `neon_edge` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `neon_edge` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `neon_edge` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `neon_edge` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `neon_edge` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `neon_edge` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `neon_edge` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `neon_edge` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `neon_edge` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `neon_edge` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `neon_edge` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `neon_edge` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `neon_edge` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `neon_edge` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `neon_edge` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `neon_edge` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `neon_edge` runtime control.
    """
