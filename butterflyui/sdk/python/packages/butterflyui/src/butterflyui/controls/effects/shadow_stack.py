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
