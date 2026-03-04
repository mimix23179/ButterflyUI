from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Style"]


class Style(Component):
    """
    Subtree style context control for packs, tokens, and component recipes.

    ``Style`` lets you define a style boundary around child controls without
    changing page-global theme configuration. It can:
    - switch ``style_pack`` for a subtree,
    - provide token overrides for descendants,
    - inject reusable component recipes (style fragments),
    - set default modifiers/motion for descendants.

    This control complements page-level ``set_style_pack`` and
    ``register_style_pack``: use page-level APIs for app-wide identity,
    and ``Style`` for localized design systems.

    The style boundary feeds the runtime's universal decorator pipeline:
    style slots -> modifiers -> motion -> effects -> events/semantics.
    That means descendants can rely on shared slot names such as
    ``root``, ``background``, ``border``, ``content``, ``label``, ``icon``,
    ``leading``, ``trailing``, and ``overlay``.

    Example:
        ```python
        import butterflyui as bui

        section = bui.Style(
            style_pack="glass",
            tokens={"colors": {"primary": "#38bdf8"}},
            recipes={
                "button": {"variant": {"intent": "primary", "size": "lg"}},
                "surface": {"slots": {"surface": {"radius": 20}}},
            },
            default_modifiers=["hover_lift", {"type": "glow", "blur": 16}],
            child=bui.Column(
                children=[
                    bui.Text("Local style boundary"),
                    bui.Button("Start"),
                ]
            ),
        )
        ```

    Args:
        child:
            Primary child control.
        children:
            Additional child controls.
        style_pack:
            Subtree style pack name (alias: ``pack``).
        pack:
            Alias for ``style_pack``.
        tokens:
            Token overrides applied to the subtree.
        token_overrides:
            Alias for ``tokens``.
        style_tokens:
            Additional token alias merged with ``tokens``.
        recipes:
            Mapping of ``control_type -> style map`` applied to descendants.
        default_style:
            Style map merged into each descendant style map.
        default_modifiers:
            Modifiers prepended to descendant ``modifiers`` lists.
        default_motion:
            Motion spec applied when a descendant has no explicit ``motion``.
        state:
            Optional style state override for descendants (for example ``hover``).
        variant:
            Optional style variant override for descendants.
        classes:
            Optional style-class tokens applied to descendants.
        effects:
            Default effects spec merged when descendants do not provide one.
        events:
            Runtime events to emit for this style host.
        props:
            Raw prop overrides merged after typed args.
        style:
            Style map for the style host itself.
        strict:
            Enables strict validation when supported.
    """

    control_type = "style"

    def __init__(
        self,
        child: Any | None = None,
        *children_args: Any,
        style_pack: str | None = None,
        pack: str | None = None,
        tokens: Mapping[str, Any] | None = None,
        token_overrides: Mapping[str, Any] | None = None,
        style_tokens: Mapping[str, Any] | None = None,
        recipes: Mapping[str, Any] | None = None,
        default_style: Mapping[str, Any] | None = None,
        default_modifiers: list[Any] | None = None,
        default_motion: Any | None = None,
        state: str | None = None,
        variant: Any | None = None,
        classes: str | list[str] | None = None,
        effects: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_pack = style_pack if style_pack is not None else pack
        merged_tokens = dict(tokens or {})
        if token_overrides:
            merged_tokens.update(dict(token_overrides))
        if style_tokens:
            merged_tokens.update(dict(style_tokens))

        super().__init__(
            *children_args,
            child=child,
            props=merge_props(
                props,
                style_pack=resolved_pack,
                pack=resolved_pack,
                tokens=merged_tokens or None,
                token_overrides=merged_tokens or None,
                style_tokens=merged_tokens or None,
                recipes=dict(recipes) if recipes is not None else None,
                default_style=dict(default_style) if default_style is not None else None,
                default_modifiers=default_modifiers,
                default_motion=default_motion,
                state=state,
                variant=variant,
                classes=classes,
                effects=effects,
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
