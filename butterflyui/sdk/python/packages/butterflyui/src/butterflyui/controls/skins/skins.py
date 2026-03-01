from __future__ import annotations

from dataclasses import dataclass, field
from collections.abc import Mapping, Iterable
from typing import Any

from .._shared import Component, merge_props

__all__ = [
    "Skins",
    "SkinsScope",
    "SkinsTokens",
    "SkinsPresets",
    "skins_row",
    "skins_column",
    "skins_container",
    "skins_card",
    "skins_transition",
]


@dataclass
class SkinsTokens:
    data: dict[str, Any] = field(default_factory=dict)

    @staticmethod
    def from_dict(values: Mapping[str, Any]) -> "SkinsTokens":
        return SkinsTokens(dict(values))

    def to_json(self) -> dict[str, Any]:
        return dict(self.data)


class SkinsPresets:
    @staticmethod
    def default() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#FAFAFA",
                "surface": "#F5F5F5",
                "surfaceAlt": "#EEEEEE",
                "text": "#1A1A1A",
                "mutedText": "#666666",
                "border": "#E0E0E0",
                "primary": "#6366F1",
                "secondary": "#8B5CF6",
                "radius": {"sm": 6, "md": 12, "lg": 18},
                "spacing": {"xs": 4, "sm": 8, "md": 12, "lg": 20},
                "effects": {"glassBlur": 18},
            }
        )

    @staticmethod
    def shadow() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A1A2E",
                "surface": "#16213E",
                "surfaceAlt": "#0F3460",
                "text": "#EAEAEA",
                "mutedText": "#A0A0A0",
                "border": "#2D2D44",
                "primary": "#7B68EE",
                "secondary": "#9370DB",
                "radius": {"sm": 8, "md": 16, "lg": 24},
                "spacing": {"xs": 4, "sm": 8, "md": 16, "lg": 24},
                "effects": {"glassBlur": 20},
            }
        )

    @staticmethod
    def fire() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A0A0A",
                "surface": "#2D1515",
                "surfaceAlt": "#4A1C1C",
                "text": "#FFE4D6",
                "mutedText": "#CC9988",
                "border": "#5C2020",
                "primary": "#FF4500",
                "secondary": "#FF6347",
                "radius": {"sm": 4, "md": 8, "lg": 16},
                "spacing": {"xs": 2, "sm": 6, "md": 10, "lg": 18},
                "effects": {"glassBlur": 10},
            }
        )

    @staticmethod
    def earth() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A1A14",
                "surface": "#2D2D1F",
                "surfaceAlt": "#3D3D2A",
                "text": "#E8E4D6",
                "mutedText": "#A8A490",
                "border": "#4A4A35",
                "primary": "#8B7355",
                "secondary": "#A0826D",
                "radius": {"sm": 2, "md": 6, "lg": 12},
                "spacing": {"xs": 4, "sm": 8, "md": 12, "lg": 20},
                "effects": {"glassBlur": 15},
            }
        )

    @staticmethod
    def gaming() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#0D0D1A",
                "surface": "#151525",
                "surfaceAlt": "#1E1E30",
                "text": "#00FF88",
                "mutedText": "#00AA55",
                "border": "#2A2A40",
                "primary": "#00FF88",
                "secondary": "#00DDFF",
                "radius": {"sm": 2, "md": 4, "lg": 8},
                "spacing": {"xs": 2, "sm": 4, "md": 8, "lg": 16},
                "effects": {"glassBlur": 25},
            }
        )


class SkinsScope(Component):
    control_type = "skins_scope"

    def __init__(
        self,
        *children: Any,
        skin: str | None = None,
        tokens: SkinsTokens | Mapping[str, Any] | None = None,
        brightness: str | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_tokens: Mapping[str, Any] | None = None
        if isinstance(tokens, SkinsTokens):
            resolved_tokens = tokens.to_json()
        elif tokens is not None:
            resolved_tokens = dict(tokens)
        merged = merge_props(
            props,
            skin=skin,
            tokens=resolved_tokens,
            brightness=brightness,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


class Skins(Component):
    control_type = "skins"

    def __init__(
        self,
        *children: Any,
        module: str | None = None,
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
            module=module,
            state=state,
            states=list(states) if states is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


def skins_row(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="row", **kwargs)


def skins_column(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="column", **kwargs)


def skins_container(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="container", **kwargs)


def skins_card(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="card", **kwargs)


def skins_transition(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="transition", **kwargs)
