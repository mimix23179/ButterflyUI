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

    glow: float | None = None
    """
    Blur radius of the outer glow ``BoxShadow``.  Defaults
    to ``10``.
    """

    spread: float | None = None
    """
    Spread radius of the glow shadow.  Defaults to ``0``.
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
