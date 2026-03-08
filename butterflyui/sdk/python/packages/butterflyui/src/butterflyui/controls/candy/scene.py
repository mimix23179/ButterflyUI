from __future__ import annotations

from dataclasses import dataclass, field
from collections.abc import Iterable, Mapping
from typing import Any

from ._helpers import _snapshot_control_value


def _coerce_layer_position(value: Any | None) -> str | None:
    if value is None:
        return None
    normalized = str(value).strip().lower().replace("-", "_").replace(" ", "_")
    if normalized in {"bg", "background"}:
        return "background"
    if normalized in {"fg", "foreground", "overlay", "front"}:
        return "overlay"
    return normalized or None


@dataclass
class CandyLayer:
    """
    One native Candy scene layer.

    ``CandyLayer`` describes a painter, Lottie, or Rive layer that can be
    placed behind or above normal UI controls.
    """

    type: str
    """
    Layer kind such as ``"matrix_rain"``, ``"starfield"``, ``"nebula"``, ``"rain"``, ``"lottie"``, or ``"rive"``.
    """
    position: str = "background"
    """
    Placement of the layer inside the Candy scene, usually ``"background"`` or ``"overlay"``.
    """
    opacity: float | None = None
    """
    Layer opacity value forwarded to the runtime painter or asset renderer.
    """
    speed: float | None = None
    """
    Animation speed multiplier for moving Candy layers.
    """
    density: float | None = None
    """
    Density multiplier for particle-like or painter-based layers.
    """
    intensity: float | None = None
    """
    General intensity multiplier used by painter-based Candy layers.
    """
    color: Any | None = None
    """
    Primary color forwarded to the layer renderer.
    """
    accent_color: Any | None = None
    """
    Accent color forwarded to the layer renderer.
    """
    fit: str | None = None
    """
    Asset fit mode used by Lottie or Rive-backed layers.
    """
    alignment: str | None = None
    """
    Alignment of the rendered asset or decorative layer.
    """
    config: dict[str, Any] = field(default_factory=dict)
    """
    Additional raw config values forwarded to the runtime layer renderer.
    """

    @staticmethod
    def from_value(
        value: str | Mapping[str, Any] | "CandyLayer",
        *,
        position: str | None = None,
    ) -> "CandyLayer":
        if isinstance(value, CandyLayer):
            if position is None:
                return value
            cloned = value.to_json()
            cloned["position"] = _coerce_layer_position(position) or value.position
            return CandyLayer.from_value(cloned)
        if isinstance(value, str):
            return CandyLayer(type=value, position=_coerce_layer_position(position) or "background")

        payload = dict(value)
        kind = (
            payload.pop("type", None)
            or payload.pop("kind", None)
            or payload.pop("preset", None)
            or payload.pop("effect", None)
            or payload.pop("scene", None)
            or "custom"
        )
        resolved_position = (
            _coerce_layer_position(position)
            or _coerce_layer_position(payload.pop("position", None))
            or _coerce_layer_position(payload.pop("layer", None))
            or "background"
        )
        return CandyLayer(
            type=str(kind),
            position=resolved_position,
            opacity=payload.pop("opacity", None),
            speed=payload.pop("speed", None),
            density=payload.pop("density", None),
            intensity=payload.pop("intensity", None),
            color=payload.pop("color", None),
            accent_color=payload.pop("accent_color", payload.pop("accentColor", None)),
            fit=payload.pop("fit", None),
            alignment=payload.pop("alignment", None),
            config=payload,
        )

    def to_json(self) -> dict[str, Any]:
        payload = dict(self.config)
        payload["type"] = self.type
        payload["position"] = _coerce_layer_position(self.position) or "background"
        if self.opacity is not None:
            payload["opacity"] = self.opacity
        if self.speed is not None:
            payload["speed"] = self.speed
        if self.density is not None:
            payload["density"] = self.density
        if self.intensity is not None:
            payload["intensity"] = self.intensity
        if self.color is not None:
            payload["color"] = _snapshot_control_value(self.color)
        if self.accent_color is not None:
            payload["accent_color"] = _snapshot_control_value(self.accent_color)
        if self.fit is not None:
            payload["fit"] = self.fit
        if self.alignment is not None:
            payload["alignment"] = self.alignment
        return payload


def _coerce_layers(
    values: Iterable[str | Mapping[str, Any] | CandyLayer] | None,
    *,
    position: str | None = None,
) -> list[dict[str, Any]] | None:
    if values is None:
        return None
    layers = [
        CandyLayer.from_value(value, position=position).to_json()
        for value in values
        if value is not None
    ]
    return layers or None


@dataclass
class CandyScene:
    """
    Structured Candy scene payload.

    A scene can describe one mixed layer list or explicit background/overlay
    layer groups.
    """

    layers: list[CandyLayer] = field(default_factory=list)
    """
    Mixed scene layers without an explicit side assignment.
    """
    background_layers: list[CandyLayer] = field(default_factory=list)
    """
    Scene layers rendered behind the enhanced control subtree.
    """
    overlay_layers: list[CandyLayer] = field(default_factory=list)
    """
    Scene layers rendered above the enhanced control subtree.
    """

    def add_layers(
        self,
        *values: str | Mapping[str, Any] | CandyLayer,
        position: str | None = None,
    ) -> "CandyScene":
        for value in values:
            if value is None:
                continue
            layer = CandyLayer.from_value(value, position=position)
            normalized_position = _coerce_layer_position(layer.position) or "background"
            if position == "background" or normalized_position == "background":
                self.background_layers.append(layer)
            elif position == "overlay" or normalized_position == "overlay":
                self.overlay_layers.append(layer)
            else:
                self.layers.append(layer)
        return self

    def to_json(self) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if self.layers:
            payload["scene_layers"] = [layer.to_json() for layer in self.layers]
        if self.background_layers:
            payload["background_layers"] = [layer.to_json() for layer in self.background_layers]
        if self.overlay_layers:
            payload["overlay_layers"] = [layer.to_json() for layer in self.overlay_layers]
        return payload


def coerce_candy_scene(
    value: CandyScene | Mapping[str, Any] | None,
) -> dict[str, Any] | None:
    if value is None:
        return None
    if isinstance(value, CandyScene):
        return value.to_json()
    return dict(value)


def coerce_candy_layer_list(
    values: Iterable[str | Mapping[str, Any] | CandyLayer] | None,
    *,
    position: str | None = None,
) -> list[dict[str, Any]] | None:
    return _coerce_layers(values, position=position)
