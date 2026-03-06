from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Modifier"]


class Modifier(Component):
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


    modifiers: list[Any] | None = None
    """
    Base modifier descriptors merged into descendants.
    """

    motion: Any | None = None
    """
    Default motion spec for descendants.
    """

    on_hover: list[Any] | None = None
    """
    Modifier descriptors activated on hover state.
    """

    on_hover_modifiers: list[Any] | None = None
    """
    Modifiers activated while the pointer is hovering the control.
    """

    on_pressed: list[Any] | None = None
    """
    Modifier descriptors activated on pressed state.
    """

    on_pressed_modifiers: list[Any] | None = None
    """
    Explicit alias of ``on_pressed``.
    """

    on_focus: list[Any] | None = None
    """
    Modifier descriptors activated on focus state.
    """

    on_focus_modifiers: list[Any] | None = None
    """
    Modifiers activated while the control or wrapped child currently has focus.
    """

    cursor: str | None = None
    """
    Cursor override for descendants.
    """

    align: Any | None = None
    """
    Alignment configuration that positions the child or content within the available layout space.
    """

    border: Any | None = None
    """
    Border descriptor merged into descendant style.
    """

    background: Any | None = None
    """
    Background color/gradient descriptor merged into descendant style.
    """

    shadow: Any | None = None
    """
    Shadow descriptor merged into descendant style.
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

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "modifier"

    def __init__(
        self,
        child: Any | None = None,
        *children_args: Any,
        modifiers: list[Any] | None = None,
        motion: Any | None = None,
        on_hover: list[Any] | None = None,
        on_hover_modifiers: list[Any] | None = None,
        on_pressed: list[Any] | None = None,
        on_pressed_modifiers: list[Any] | None = None,
        on_focus: list[Any] | None = None,
        on_focus_modifiers: list[Any] | None = None,
        cursor: str | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        align: Any | None = None,
        max_width: Any | None = None,
        max_height: Any | None = None,
        min_width: Any | None = None,
        min_height: Any | None = None,
        border: Any | None = None,
        background: Any | None = None,
        shadow: Any | None = None,
        glow: Any | None = None,
        glass: Any | None = None,
        focus_ring: Any | None = None,
        hit_test: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
                        props,
                        modifiers=modifiers,
                        motion=motion,
                        on_hover=on_hover if on_hover is not None else on_hover_modifiers,
                        on_hover_modifiers=on_hover_modifiers
                        if on_hover_modifiers is not None
                        else on_hover,
                        on_pressed=on_pressed if on_pressed is not None else on_pressed_modifiers,
                        on_pressed_modifiers=on_pressed_modifiers
                        if on_pressed_modifiers is not None
                        else on_pressed,
                        on_focus=on_focus if on_focus is not None else on_focus_modifiers,
                        on_focus_modifiers=on_focus_modifiers
                        if on_focus_modifiers is not None
                        else on_focus,
                        cursor=cursor,
                        padding=padding,
                        margin=margin,
                        align=align,
                        max_width=max_width,
                        max_height=max_height,
                        min_width=min_width,
                        min_height=min_height,
                        border=border,
                        background=background,
                        shadow=shadow,
                        glow=glow,
                        glass=glass,
                        focus_ring=focus_ring,
                        hit_test=hit_test,
                        events=events,
                        **kwargs,
                    )
        super().__init__(
            *children_args,
            child=child,
            props=merged,
            style=style,
            strict=strict,
        )

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
