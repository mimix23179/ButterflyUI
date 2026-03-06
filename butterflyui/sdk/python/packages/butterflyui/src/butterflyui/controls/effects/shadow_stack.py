from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["ShadowStack"]

@butterfly_control('shadow_stack')
class ShadowStack(EffectControl):
    """
    Multi-layer box-shadow stack applied to a child via a
    ``Container`` with a rounded ``BoxDecoration``.

    The Flutter runtime parses the *shadows* list into multiple
    ``BoxShadow`` entries (each with colour, blur, spread, and offset)
    and renders them as a single ``Container`` decoration.  If no
    shadows are provided a sensible two-layer default is used.

    Example:

    ```python
    import butterflyui as bui

    stack = bui.ShadowStack(
        bui.Text("Elevated"),
        shadows=[
            {"color": "#1F000000", "blur": 8, "offset_y": 2},
            {"color": "#14000000", "blur": 20, "offset_y": 8},
        ],
        radius=12,
    )
    ```
    """

    shadows: list[Mapping[str, Any]] | None = None
    """
    List of shadow definition mappings.  Each may contain ``color``, ``blur``, ``spread``, ``offset_x``,
    and ``offset_y``.  Defaults to a two-layer elevation preset.
    """

    radius: float | None = None
    """
    Corner radius of the ``BoxDecoration``.  Defaults to
    ``12``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `shadow_stack` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `shadow_stack` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `shadow_stack` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `shadow_stack` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `shadow_stack` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `shadow_stack` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `shadow_stack` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `shadow_stack` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `shadow_stack` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `shadow_stack` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `shadow_stack` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `shadow_stack` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `shadow_stack` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `shadow_stack` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `shadow_stack` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `shadow_stack` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `shadow_stack` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `shadow_stack` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `shadow_stack` runtime control.
    """
