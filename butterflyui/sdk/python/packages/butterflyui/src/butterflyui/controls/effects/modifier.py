from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["Modifier"]

@butterfly_control('modifier')
class Modifier(EffectControl):
    """
    Composable modifier host that injects layout/visual/interaction effects into descendants.

    ``Modifier`` is the glue control for reusable visual behavior. Instead of creating
    many one-off controls, you can wrap a subtree and apply:
    - layout constraints (padding/margin/alignment/constrain),
    - visual effects (background/border/shadow/glow/glass),
    - interaction affordances (cursor/focus ring/hover/press state lists),
    - motion defaults for descendants.

    The runtime merges these modifier definitions into each child control's
    ``modifiers`` list and style props, but only for controls that advertise
    modifier/style/motion capabilities through the shared manifest.

    State-specific modifier keys are available in both short and explicit form:
    - ``on_hover`` and ``on_hover_modifiers``
    - ``on_pressed`` and ``on_pressed_modifiers``
    - ``on_focus`` and ``on_focus_modifiers``

    Example:

    ```python
    import butterflyui as bui

    cta = bui.Modifier(
        modifiers=[
            {"type": "glass", "blur": 20, "radius": 999},
            {"type": "glow", "color": "$primary", "blur": 18, "opacity": 0.75},
            "hover_lift",
            "press_scale",
        ],
        on_hover=[{"type": "glow", "blur": 26, "opacity": 0.95}],
        cursor="click",
        child=bui.Button("Start Natively"),
    )
    ```
    """

    on_hover: list[Any] | None = None
    """
    Modifier descriptors activated on hover state.
    """

    on_pressed: list[Any] | None = None
    """
    Modifier descriptors activated on pressed state.
    """

    on_focus: list[Any] | None = None
    """
    Modifier descriptors activated on focus state.
    """

    align: Any | None = None
    """
    Alignment configuration that positions the child or content within the available layout space.
    """

    glow: Any | None = None
    """
    Glow effect configuration merged into the rendered modifier payload.
    """

    glass: Any | None = None
    """
    Glass-effect configuration applied by the modifier pipeline for this control.
    """

    focus_ring: Any | None = None
    """
    Focus-ring configuration applied when the control receives keyboard or accessibility focus. Typical values control ring color, width, inset, or animation depending on the renderer.
    """

    hit_test: str | None = None
    """
    Hit-test behavior that determines how this control participates in pointer targeting.
    """

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
