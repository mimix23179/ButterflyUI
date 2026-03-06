from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["StyleScope", "Style"]


class StyleScope(Component):
    """
    Subtree style context control for packs, tokens, and component recipes.
    """


    style_pack: str | None = None
    """
    Named style pack activated for the subtree.
    """

    pack: str | None = None
    """
    Backward-compatible alias for ``style_pack``. When both fields are provided, ``style_pack`` takes precedence and this alias is kept only for compatibility.
    """

    tokens: Mapping[str, Any] | None = None
    """
    Token overrides applied inside the scope.
    """

    token_overrides: Mapping[str, Any] | None = None
    """
    Additional token overrides merged into ``tokens``.
    """

    style_tokens: Mapping[str, Any] | None = None
    """
    Named style-token overrides scoped to the wrapped subtree.
    """

    recipes: Mapping[str, Any] | None = None
    """
    Component recipe payloads available inside the scope.
    """

    default_style: Mapping[str, Any] | None = None
    """
    Default style values merged into descendant controls.
    """

    default_modifiers: list[Any] | None = None
    """
    Default modifiers applied within the scope.
    """

    default_motion: Any | None = None
    """
    Default motion payload applied within the scope.
    """

    state: str | None = None
    """
    Current state token or state identifier forwarded into styling and runtime behavior.
    """

    variant: Any | None = None
    """
    Variant token or preset name used to select a specific visual style.
    """

    classes: str | list[str] | None = None
    """
    Scoped class tokens used by descendant styling.
    """

    effects: Any | None = None
    """
    Scoped effects payload applied by the runtime.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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

        merged = merge_props(
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


Style = StyleScope
