from __future__ import annotations

from dataclasses import dataclass, field
from collections.abc import Mapping, Iterable
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Candy", "CandyScope", "CandyTheme", "CandyTokens"]


@dataclass
class CandyTokens:
    data: dict[str, Any] = field(default_factory=dict)

    @staticmethod
    def from_dict(values: Mapping[str, Any]) -> "CandyTokens":
        return CandyTokens(dict(values))

    def to_json(self) -> dict[str, Any]:
        return dict(self.data)


@dataclass
class CandyTheme:
    brightness: str = "light"
    colors: dict[str, Any] = field(default_factory=dict)
    typography: dict[str, Any] = field(default_factory=dict)
    radii: dict[str, Any] = field(default_factory=dict)
    spacing: dict[str, Any] = field(default_factory=dict)
    elevation: dict[str, Any] = field(default_factory=dict)
    motion: dict[str, Any] = field(default_factory=dict)
    button: dict[str, Any] = field(default_factory=dict)
    card: dict[str, Any] = field(default_factory=dict)
    effects: dict[str, Any] = field(default_factory=dict)
    ui: dict[str, Any] = field(default_factory=dict)
    webview: dict[str, Any] = field(default_factory=dict)

    def to_json(self) -> dict[str, Any]:
        return {
            "brightness": self.brightness,
            "theme": {"brightness": self.brightness},
            "colors": self.colors,
            "typography": self.typography,
            "radii": self.radii,
            "spacing": self.spacing,
            "elevation": self.elevation,
            "motion": self.motion,
            "button": self.button,
            "card": self.card,
            "effects": self.effects,
            "ui": self.ui,
            "webview": self.webview,
        }


class CandyScope(Component):
    control_type = "candy_scope"

    def __init__(
        self,
        *children: Any,
        tokens: CandyTokens | Mapping[str, Any] | None = None,
        theme: CandyTheme | Mapping[str, Any] | None = None,
        brightness: str | None = None,
        radius: Mapping[str, Any] | None = None,
        colors: Mapping[str, Any] | None = None,
        typography: Mapping[str, Any] | None = None,
        spacing: Mapping[str, Any] | None = None,
        elevation: Mapping[str, Any] | None = None,
        motion: Mapping[str, Any] | None = None,
        button: Mapping[str, Any] | None = None,
        card: Mapping[str, Any] | None = None,
        effects: Mapping[str, Any] | None = None,
        ui: Mapping[str, Any] | None = None,
        webview: Mapping[str, Any] | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_tokens: Mapping[str, Any] | None = None
        if isinstance(tokens, CandyTokens):
            resolved_tokens = tokens.to_json()
        elif tokens is not None:
            resolved_tokens = dict(tokens)

        resolved_theme: Mapping[str, Any] | None = None
        if isinstance(theme, CandyTheme):
            resolved_theme = theme.to_json()
        elif theme is not None:
            resolved_theme = dict(theme)

        merged = merge_props(
            props,
            tokens=resolved_tokens,
            theme=resolved_theme,
            brightness=brightness,
            radius=radius,
            colors=colors,
            typography=typography,
            spacing=spacing,
            elevation=elevation,
            motion=motion,
            button=button,
            card=card,
            effects=effects,
            ui=ui,
            webview=webview,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


class Candy(Component):
    control_type = "candy"

    def __init__(
        self,
        *children: Any,
        module: str | None = None,
        layout: str | None = None,
        state: str | None = None,
        states: Iterable[str] | None = None,
        events: list[str] | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            module=module if module is not None else layout,
            layout=layout,
            state=state,
            states=list(states) if states is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)
