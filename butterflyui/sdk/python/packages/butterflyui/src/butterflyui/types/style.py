from __future__ import annotations

from dataclasses import asdict, dataclass
from typing import Any, Literal

__all__ = [
    "BoxShadow",
    "LinearGradient",
    "RadialGradient",
    "SweepGradient",
    "DecorationImage",
    "Style",
    "StyleValue",
]


def _to_json_value(v: Any) -> Any:
    if hasattr(v, "to_json"):
        return v.to_json()
    if isinstance(v, (list, tuple)):
        return [_to_json_value(x) for x in v]
    if isinstance(v, dict):
        return {k: _to_json_value(val) for k, val in v.items()}
    return v


@dataclass
class BoxShadow:
    color: str | None = None
    offset: tuple[float, float] | None = None
    blur: float = 0.0
    spread: float = 0.0
    blur_style: Literal["normal", "solid", "outer", "inner"] = "normal"

    def to_json(self) -> dict[str, Any]:
        return {k: _to_json_value(v) for k, v in asdict(self).items() if v is not None}


@dataclass
class LinearGradient:
    colors: list[str]
    stops: list[float] | None = None
    begin: Any | None = None
    end: Any | None = None
    tile_mode: str = "clamp"
    type: str = "linear"

    def to_json(self) -> dict[str, Any]:
        return {k: _to_json_value(v) for k, v in asdict(self).items() if v is not None}


@dataclass
class RadialGradient:
    colors: list[str]
    stops: list[float] | None = None
    center: Any | None = None
    radius: float = 0.5
    focal: Any | None = None
    focal_radius: float = 0.0
    tile_mode: str = "clamp"
    type: str = "radial"

    def to_json(self) -> dict[str, Any]:
        return {k: _to_json_value(v) for k, v in asdict(self).items() if v is not None}


@dataclass
class SweepGradient:
    colors: list[str]
    stops: list[float] | None = None
    center: Any | None = None
    start_angle: float = 0.0
    end_angle: float = 6.28318530718
    tile_mode: str = "clamp"
    type: str = "sweep"

    def to_json(self) -> dict[str, Any]:
        return {k: _to_json_value(v) for k, v in asdict(self).items() if v is not None}


@dataclass
class DecorationImage:
    src: str
    fit: Literal["contain", "cover", "fill", "fit_width", "fit_height", "scale_down", "none"] | None = None
    alignment: Any | None = None
    opacity: float = 1.0
    repeat: Literal["no_repeat", "repeat", "repeat_x", "repeat_y"] = "no_repeat"

    def to_json(self) -> dict[str, Any]:
        return {k: _to_json_value(v) for k, v in asdict(self).items() if v is not None}


@dataclass
class Style:
    bgcolor: str | None = None
    border_color: str | None = None
    border_width: float | None = None
    radius: float | None = None
    padding: Any | None = None
    margin: Any | None = None
    alignment: Any | None = None
    shadow: BoxShadow | list[BoxShadow] | None = None
    gradient: LinearGradient | RadialGradient | SweepGradient | None = None
    image: DecorationImage | None = None
    blur: float | None = None
    shape: Literal["rectangle", "circle"] | None = None
    color: str | None = None
    size: float | None = None
    weight: str | None = None
    font_family: str | None = None
    italic: bool | None = None
    width: float | None = None
    height: float | None = None
    min_width: float | None = None
    min_height: float | None = None
    max_width: float | None = None
    max_height: float | None = None
    expand: bool | None = None
    flex: int | None = None
    opacity: float | None = None
    elevation: float | None = None
    style_pack: str | None = None

    def to_json(self) -> dict[str, Any]:
        out: dict[str, Any] = {}
        for key, value in asdict(self).items():
            if value is not None:
                out[key] = _to_json_value(value)
        return out


StyleValue = Style
