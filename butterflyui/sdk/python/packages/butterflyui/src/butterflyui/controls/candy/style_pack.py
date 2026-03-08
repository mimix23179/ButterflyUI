from __future__ import annotations

from dataclasses import dataclass
from typing import Any
from collections.abc import Mapping

from ._helpers import _coerce_mapping
from .tokens import CandyTokens


@dataclass
class CandyStylePack:
    """
    Declarative custom style-pack spec builder for Candy/runtime themes.
    """

    name: str
    """
    Human-readable pack name used for registration and activation.
    """
    tokens: CandyTokens | Mapping[str, Any] | None = None
    """
    Token mapping or ``CandyTokens`` helper bundled into this style pack.
    """
    base: str | None = None
    """
    Optional base pack identifier this pack should extend.
    """
    background: Any | None = None
    """
    Optional app-shell or section background value packaged with this style pack.
    """
    overrides: Mapping[str, Any] | None = None
    """
    General override mapping merged on top of the base identity.
    """
    components: Mapping[str, Any] | None = None
    """
    Component-specific overrides packaged with this style pack.
    """
    motion: Mapping[str, Any] | None = None
    """
    Motion token or animation override mapping.
    """
    effects: Mapping[str, Any] | None = None
    """
    Candy/effects definitions bundled with the style pack.
    """

    def to_spec(self) -> dict[str, Any]:
        token_payload: dict[str, Any] | None = None
        if isinstance(self.tokens, CandyTokens):
            token_payload = self.tokens.to_json()
        elif isinstance(self.tokens, Mapping):
            token_payload = dict(self.tokens)

        normalized = self.name.strip().lower().replace(" ", "_")
        spec: dict[str, Any] = {"name": normalized}
        if token_payload is not None:
            spec["tokens"] = token_payload
        if self.base:
            spec["base"] = str(self.base)
        if self.background is not None:
            spec["background"] = self.background
        if self.overrides:
            spec["overrides"] = dict(self.overrides)
        if self.components:
            spec["components"] = dict(self.components)
        if self.motion:
            spec["motion"] = dict(self.motion)
        if self.effects:
            spec["effects"] = dict(self.effects)
        return spec

    def register(self, page: Any | None = None) -> dict[str, Any]:
        from ...style_packs import register_style_pack

        if page is not None and hasattr(page, "register_style_pack"):
            return page.register_style_pack(
                self.name,
                tokens=self.tokens,
                base=self.base,
                background=self.background,
                overrides=_coerce_mapping(self.overrides),
                components=_coerce_mapping(self.components),
                motion=_coerce_mapping(self.motion),
                effects=_coerce_mapping(self.effects),
            )
        return register_style_pack(
            self.name,
            tokens=self.tokens,
            base=self.base,
            background=self.background,
            overrides=_coerce_mapping(self.overrides),
            components=_coerce_mapping(self.components),
            motion=_coerce_mapping(self.motion),
            effects=_coerce_mapping(self.effects),
        )


def candy_style_pack(
    name: str,
    *,
    tokens: CandyTokens | Mapping[str, Any] | None = None,
    base: str | None = None,
    background: Any | None = None,
    overrides: Mapping[str, Any] | None = None,
    components: Mapping[str, Any] | None = None,
    motion: Mapping[str, Any] | None = None,
    effects: Mapping[str, Any] | None = None,
) -> CandyStylePack:
    return CandyStylePack(
        name=name,
        tokens=tokens,
        base=base,
        background=background,
        overrides=overrides,
        components=components,
        motion=motion,
        effects=effects,
    )
