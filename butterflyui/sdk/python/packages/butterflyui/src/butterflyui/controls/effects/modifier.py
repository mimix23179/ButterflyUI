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

    Args:
        child:
            Primary child control.
        children:
            Additional child controls.
        modifiers:
            Base modifier descriptors merged into descendants.
        motion:
            Default motion spec for descendants.
        on_hover:
            Modifier descriptors activated on hover state.
        on_hover_modifiers:
            Explicit alias of ``on_hover``.
        on_pressed:
            Modifier descriptors activated on pressed state.
        on_pressed_modifiers:
            Explicit alias of ``on_pressed``.
        on_focus:
            Modifier descriptors activated on focus state.
        on_focus_modifiers:
            Explicit alias of ``on_focus``.
        cursor:
            Cursor override for descendants.
        padding:
            Descendant padding override.
        margin:
            Descendant margin override.
        align:
            Descendant alignment override.
        max_width:
            Descendant max width constraint.
        max_height:
            Descendant max height constraint.
        min_width:
            Descendant min width constraint.
        min_height:
            Descendant min height constraint.
        border:
            Border descriptor merged into descendant style.
        background:
            Background color/gradient descriptor merged into descendant style.
        shadow:
            Shadow descriptor merged into descendant style.
        glow:
            Glow descriptor shorthand.
        glass:
            Glass descriptor shorthand.
        focus_ring:
            Focus ring descriptor shorthand.
        hit_test:
            Hit test behavior hint.
        events:
            Runtime event subscriptions for this modifier host.
        props:
            Raw prop overrides merged after typed args.
        style:
            Style map for the modifier host itself.
        strict:
            Enables strict validation when supported.
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
        super().__init__(
            *children_args,
            child=child,
            props=merge_props(
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
            ),
            style=style,
            strict=strict,
        )

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
