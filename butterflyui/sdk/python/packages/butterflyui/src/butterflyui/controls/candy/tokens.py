from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any
from collections.abc import Mapping


@dataclass
class CandyTokens:
    """
    Serializable token map used by ``CandyScope``.
    """

    data: dict[str, Any] = field(default_factory=dict)
    """
    Raw token mapping forwarded to the runtime after JSON-safe normalization.
    """
    """
    Raw mapping payload stored by this helper type and forwarded to the runtime after JSON-safe normalization.
    """

    @staticmethod
    def from_dict(values: Mapping[str, Any]) -> "CandyTokens":
        return CandyTokens(dict(values))

    def to_json(self) -> dict[str, Any]:
        return dict(self.data)


@dataclass
class CandyTheme:
    """
    Structured token bundle for ``CandyScope``.
    """

    brightness: str = "light"
    """
    Brightness mode associated with the scoped Candy theme, usually ``"light"`` or ``"dark"``.
    """
    colors: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named color tokens to concrete color values.
    """
    typography: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of typography tokens to reusable text-style values.
    """
    radii: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named radius tokens to reusable corner-radius values.
    """
    spacing: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of spacing tokens consumed by layout and surface controls.
    """
    elevation: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named elevation or shadow tokens.
    """
    motion: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named motion tokens to duration, easing, or transition values.
    """
    button: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of button-related tokens or style defaults.
    """
    card: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of card and surface presentation tokens.
    """
    effects: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of reusable effect tokens or effect definitions.
    """
    ui: dict[str, Any] = field(default_factory=dict)
    """
    Shared general-purpose UI token bucket.
    """
    webview: dict[str, Any] = field(default_factory=dict)
    """
    Webview-specific token bucket forwarded to the runtime.
    """

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
