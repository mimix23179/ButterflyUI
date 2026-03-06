from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["StyleScope", "Style"]


class StyleScope(Component):
    """Subtree style context control for packs, tokens, and component recipes."""

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


Style = StyleScope
