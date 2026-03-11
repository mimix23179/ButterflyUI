from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass
from typing import Any

__all__ = [
    "BorderTokens",
    "BoxShadow",
    "ColorTokens",
    "DepthTokens",
    "DecorationImage",
    "LinearGradient",
    "GradientWash",
    "LineField",
    "LottieLayer",
    "MotionTokens",
    "NoiseField",
    "OrbitField",
    "ParticleField",
    "RadialGradient",
    "RadiusTokens",
    "RiveLayer",
    "SceneMask",
    "SceneRegion",
    "SceneLayer",
    "ShaderLayer",
    "ShadowTokens",
    "SpacingTokens",
    "Style",
    "StyleTokens",
    "StyleValue",
    "SweepGradient",
    "TypographyRole",
    "TypographyTokens",
]


@dataclass(slots=True)
class BoxShadow:
    """Shadow specification for local control styling."""

    color: Any = None
    """
    Shadow color applied to the rendered surface.
    """

    blur: float = 16.0
    """
    Blur radius used to soften the shadow.
    """

    spread: float = 0.0
    """
    Spread distance applied before the blur is rendered.
    """

    offset: Any | None = None
    """
    Optional explicit offset object or two-value list.
    """

    offset_x: float = 0.0
    """
    Horizontal shadow offset used when ``offset`` is not provided.
    """

    offset_y: float = 8.0
    """
    Vertical shadow offset used when ``offset`` is not provided.
    """

    def to_json(self) -> dict[str, Any]:
        offset = self.offset
        if offset is None:
            offset = [float(self.offset_x), float(self.offset_y)]
        else:
            offset = _to_json_value(offset)
        return {
            "color": _to_json_value(self.color),
            "blur": float(self.blur),
            "spread": float(self.spread),
            "offset": offset,
        }


@dataclass(slots=True)
class DecorationImage:
    """Image decoration payload for surfaces and local style objects."""

    src: str
    """
    Source path or URL for the decoration image.
    """

    fit: str | None = None
    """
    Image fit forwarded to the runtime decoration image renderer.
    """

    alignment: Any | None = None
    """
    Alignment used when the image does not fully cover the target area.
    """

    repeat: str | None = None
    """
    Repeat behavior for the image within the styled region.
    """

    opacity: float | None = None
    """
    Optional opacity multiplier applied to the image layer.
    """

    def to_json(self) -> dict[str, Any]:
        payload = {"src": self.src}
        if self.fit is not None:
            payload["fit"] = self.fit
        if self.alignment is not None:
            payload["alignment"] = _to_json_value(self.alignment)
        if self.repeat is not None:
            payload["repeat"] = self.repeat
        if self.opacity is not None:
            payload["opacity"] = float(self.opacity)
        return payload


@dataclass(slots=True)
class LinearGradient:
    """Linear gradient value object for local style declarations."""

    colors: list[Any]
    """
    Ordered color stops for the gradient.
    """

    begin: str | None = None
    """
    Gradient start alignment token such as ``top_left``.
    """

    end: str | None = None
    """
    Gradient end alignment token such as ``bottom_right``.
    """

    stops: list[float] | None = None
    """
    Optional normalized stop positions matching ``colors``.
    """

    def to_json(self) -> dict[str, Any]:
        payload = {
            "type": "linear",
            "colors": [_to_json_value(color) for color in self.colors],
        }
        if self.begin is not None:
            payload["begin"] = self.begin
        if self.end is not None:
            payload["end"] = self.end
        if self.stops is not None:
            payload["stops"] = [float(stop) for stop in self.stops]
        return payload


@dataclass(slots=True)
class RadialGradient:
    """Radial gradient value object for local style declarations."""

    colors: list[Any]
    """
    Ordered color stops for the gradient.
    """

    radius: float | None = None
    """
    Radius factor for the radial falloff.
    """

    center: Any | None = None
    """
    Gradient center point or alignment token.
    """

    stops: list[float] | None = None
    """
    Optional normalized stop positions matching ``colors``.
    """

    def to_json(self) -> dict[str, Any]:
        payload = {
            "type": "radial",
            "colors": [_to_json_value(color) for color in self.colors],
        }
        if self.radius is not None:
            payload["radius"] = float(self.radius)
        if self.center is not None:
            payload["center"] = _to_json_value(self.center)
        if self.stops is not None:
            payload["stops"] = [float(stop) for stop in self.stops]
        return payload


@dataclass(slots=True)
class SweepGradient:
    """Sweep gradient value object for angular color transitions."""

    colors: list[Any]
    """
    Ordered color stops for the gradient.
    """

    start_angle: float | None = None
    """
    Starting angle in radians for the sweep.
    """

    end_angle: float | None = None
    """
    Ending angle in radians for the sweep.
    """

    center: Any | None = None
    """
    Gradient center point or alignment token.
    """

    stops: list[float] | None = None
    """
    Optional normalized stop positions matching ``colors``.
    """

    def to_json(self) -> dict[str, Any]:
        payload = {
            "type": "sweep",
            "colors": [_to_json_value(color) for color in self.colors],
        }
        if self.start_angle is not None:
            payload["start_angle"] = float(self.start_angle)
        if self.end_angle is not None:
            payload["end_angle"] = float(self.end_angle)
        if self.center is not None:
            payload["center"] = _to_json_value(self.center)
        if self.stops is not None:
            payload["stops"] = [float(stop) for stop in self.stops]
        return payload


@dataclass(slots=True)
class SceneRegion:
    """Typed scene-region constraint used to clip a layer inside a surface."""

    x: float = 0.0
    """
    Normalized left position of the region inside the host surface.
    """

    y: float = 0.0
    """
    Normalized top position of the region inside the host surface.
    """

    width: float = 1.0
    """
    Normalized region width relative to the host surface.
    """

    height: float = 1.0
    """
    Normalized region height relative to the host surface.
    """

    def to_json(self) -> dict[str, Any]:
        return {
            "x": float(self.x),
            "y": float(self.y),
            "width": float(self.width),
            "height": float(self.height),
        }


@dataclass(slots=True)
class SceneMask:
    """Typed scene mask used to constrain authored scene layers."""

    type: str
    """
    Mask kind such as ``oval``, ``rounded``, ``radial``, or ``rect``.
    """

    radius: float | None = None
    """
    Corner radius used by rounded masks.
    """

    feather: float | None = None
    """
    Optional feather amount used to soften the mask edge.
    """

    center: Any | None = None
    """
    Optional center point used by radial masks.
    """

    def to_json(self) -> dict[str, Any]:
        payload = {"type": self.type}
        if self.radius is not None:
            payload["radius"] = float(self.radius)
        if self.feather is not None:
            payload["feather"] = float(self.feather)
        if self.center is not None:
            payload["center"] = _to_json_value(self.center)
        return payload


@dataclass(slots=True)
class ColorTokens:
    """Color token collection forwarded to the Styling engine."""

    background: Any | None = None
    """
    App/page background color token.
    """

    surface: Any | None = None
    """
    Default surface color token for cards and containers.
    """

    surface_alt: Any | None = None
    """
    Alternate surface color token for nested panels and soft contrasts.
    """

    text: Any | None = None
    """
    Primary foreground text token.
    """

    muted_text: Any | None = None
    """
    Secondary muted text token for captions and helper copy.
    """

    border: Any | None = None
    """
    Default border color token.
    """

    primary: Any | None = None
    """
    Primary accent token for CTA surfaces and focus states.
    """

    secondary: Any | None = None
    """
    Secondary accent token for alternate emphasis surfaces.
    """

    success: Any | None = None
    """
    Success state color token.
    """

    warning: Any | None = None
    """
    Warning state color token.
    """

    info: Any | None = None
    """
    Informational state color token.
    """

    error: Any | None = None
    """
    Error state color token.
    """

    def to_json(self) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        for key in (
            "background",
            "surface",
            "surface_alt",
            "text",
            "muted_text",
            "border",
            "primary",
            "secondary",
            "success",
            "warning",
            "info",
            "error",
        ):
            value = getattr(self, key)
            if value is not None:
                payload[key] = _to_json_value(value)
        return payload


@dataclass(slots=True)
class RadiusTokens:
    """Corner-radius token collection."""

    sm: float | None = None
    """
    Small radius token.
    """

    md: float | None = None
    """
    Medium radius token.
    """

    lg: float | None = None
    """
    Large radius token.
    """

    xl: float | None = None
    """
    Extra-large radius token.
    """

    def to_json(self) -> dict[str, Any]:
        return {
            key: float(value)
            for key in ("sm", "md", "lg", "xl")
            if (value := getattr(self, key)) is not None
        }


@dataclass(slots=True)
class SpacingTokens:
    """Spacing token collection."""

    xs: float | None = None
    """
    Extra-small spacing token.
    """

    sm: float | None = None
    """
    Small spacing token.
    """

    md: float | None = None
    """
    Medium spacing token.
    """

    lg: float | None = None
    """
    Large spacing token.
    """

    xl: float | None = None
    """
    Extra-large spacing token.
    """

    def to_json(self) -> dict[str, Any]:
        return {
            key: float(value)
            for key in ("xs", "sm", "md", "lg", "xl")
            if (value := getattr(self, key)) is not None
        }


@dataclass(slots=True)
class BorderTokens:
    """Border-width token collection."""

    sm: float | None = None
    """
    Small border-width token.
    """

    md: float | None = None
    """
    Medium border-width token.
    """

    lg: float | None = None
    """
    Large border-width token.
    """

    def to_json(self) -> dict[str, Any]:
        return {
            key: float(value)
            for key in ("sm", "md", "lg")
            if (value := getattr(self, key)) is not None
        }


@dataclass(slots=True)
class ShadowTokens:
    """Shadow-intensity token collection."""

    sm: float | None = None
    """
    Small shadow token.
    """

    md: float | None = None
    """
    Medium shadow token.
    """

    lg: float | None = None
    """
    Large shadow token.
    """

    def to_json(self) -> dict[str, Any]:
        return {
            key: float(value)
            for key in ("sm", "md", "lg")
            if (value := getattr(self, key)) is not None
        }


@dataclass(slots=True)
class MotionTokens:
    """Motion timing token collection."""

    fast_ms: int | None = None
    """
    Fast transition duration in milliseconds.
    """

    normal_ms: int | None = None
    """
    Default transition duration in milliseconds.
    """

    slow_ms: int | None = None
    """
    Slow transition duration in milliseconds.
    """

    def to_json(self) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if self.fast_ms is not None:
            payload["fast_ms"] = int(self.fast_ms)
        if self.normal_ms is not None:
            payload["normal_ms"] = int(self.normal_ms)
        if self.slow_ms is not None:
            payload["slow_ms"] = int(self.slow_ms)
        return payload


@dataclass(slots=True)
class DepthTokens:
    """Depth/z-plane token collection."""

    base: float | None = None
    """
    Base z-depth token for regular surfaces.
    """

    overlay: float | None = None
    """
    Overlay z-depth token for popovers and floating panels.
    """

    modal: float | None = None
    """
    Modal z-depth token for dialogs and scrims.
    """

    def to_json(self) -> dict[str, Any]:
        return {
            key: float(value)
            for key in ("base", "overlay", "modal")
            if (value := getattr(self, key)) is not None
        }


@dataclass(slots=True)
class TypographyRole:
    """Single named typography role forwarded into Styling tokens."""

    font_size: float | None = None
    """
    Role font size in logical pixels.
    """

    font_weight: Any | None = None
    """
    Role font weight token or numeric weight.
    """

    line_height: float | None = None
    """
    Line-height multiplier for the role.
    """

    letter_spacing: float | None = None
    """
    Letter-spacing/tracking value for the role.
    """

    font_family: str | None = None
    """
    Font family override for the role.
    """

    color: Any | None = None
    """
    Optional default color for the role.
    """

    max_width: float | None = None
    """
    Optional max text width associated with the role.
    """

    wrap: str | None = None
    """
    Preferred wrap policy such as ``balance`` or ``pretty``.
    """

    def to_json(self) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if self.font_size is not None:
            payload["font_size"] = float(self.font_size)
        if self.font_weight is not None:
            payload["font_weight"] = _to_json_value(self.font_weight)
        if self.line_height is not None:
            payload["line_height"] = float(self.line_height)
        if self.letter_spacing is not None:
            payload["letter_spacing"] = float(self.letter_spacing)
        if self.font_family is not None:
            payload["font_family"] = self.font_family
        if self.color is not None:
            payload["color"] = _to_json_value(self.color)
        if self.max_width is not None:
            payload["max_width"] = float(self.max_width)
        if self.wrap is not None:
            payload["wrap"] = self.wrap
        return payload


@dataclass(slots=True)
class TypographyTokens:
    """Typography role collection used by the Styling theme layer."""

    display_hero: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for the largest hero titles.
    """

    display: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for strong display headings.
    """

    headline: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for major section headings.
    """

    title: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for medium titles and subsection headers.
    """

    body: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for primary body copy.
    """

    body_lg: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for larger supporting body text.
    """

    caption: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for captions and metadata.
    """

    helper: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for input helper and muted supporting text.
    """

    button_label: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for button labels.
    """

    input: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for input field values.
    """

    nav: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for navigation links and tabs.
    """

    overline: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for overlines and eyebrow labels.
    """

    mono: TypographyRole | Mapping[str, Any] | None = None
    """
    Typography role for code and monospaced UI elements.
    """

    def to_json(self) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        for key in (
            "display_hero",
            "display",
            "headline",
            "title",
            "body",
            "body_lg",
            "caption",
            "helper",
            "button_label",
            "input",
            "nav",
            "overline",
            "mono",
        ):
            value = getattr(self, key)
            if value is None:
                continue
            if isinstance(value, TypographyRole):
                payload[key] = value.to_json()
            elif isinstance(value, Mapping):
                payload[key] = _to_json_value(value)
        return payload


@dataclass(slots=True)
class StyleTokens:
    """Typed token bundle used by the Styling engine."""

    colors: ColorTokens | Mapping[str, Any] | None = None
    """
    Color token collection.
    """

    radii: RadiusTokens | Mapping[str, Any] | None = None
    """
    Radius token collection.
    """

    spacing: SpacingTokens | Mapping[str, Any] | None = None
    """
    Spacing token collection.
    """

    borders: BorderTokens | Mapping[str, Any] | None = None
    """
    Border token collection.
    """

    shadows: ShadowTokens | Mapping[str, Any] | None = None
    """
    Shadow token collection.
    """

    motion: MotionTokens | Mapping[str, Any] | None = None
    """
    Motion timing token collection.
    """

    depth: DepthTokens | Mapping[str, Any] | None = None
    """
    Depth/z-plane token collection.
    """

    typography: TypographyTokens | Mapping[str, Any] | None = None
    """
    Typography role collection.
    """

    font_family: str | None = None
    """
    Default proportional font family token.
    """

    mono_family: str | None = None
    """
    Default monospaced font family token.
    """

    focus_ring: Any | None = None
    """
    Focus-ring color token.
    """

    overlay_scrim: Any | None = None
    """
    Overlay scrim color token used by dialogs and sheets.
    """

    glass_blur: float | None = None
    """
    Default backdrop-blur token for glass-like surfaces.
    """

    def to_json(self) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        for key in ("colors", "radii", "spacing", "borders", "shadows", "motion", "depth"):
            value = getattr(self, key)
            if value is None:
                continue
            payload[key] = _to_json_value(value)
        if self.typography is not None:
            payload["typography"] = _to_json_value(self.typography)
        if self.font_family is not None:
            payload["font_family"] = self.font_family
        if self.mono_family is not None:
            payload["mono_family"] = self.mono_family
        if self.focus_ring is not None:
            payload["focus_ring"] = _to_json_value(self.focus_ring)
        if self.overlay_scrim is not None:
            payload["overlay_scrim"] = _to_json_value(self.overlay_scrim)
        if self.glass_blur is not None:
            payload["glass_blur"] = float(self.glass_blur)
        return payload


class SceneLayer:
    """Base authored scene layer that Styling can compose behind or above content."""

    type: str
    """
    Runtime scene-layer kind such as ``particle_field`` or ``shader``.
    """

    position: str | None = None
    """
    Placement region for the layer, for example ``background`` or ``foreground``.
    """

    opacity: float | None = None
    """
    Opacity multiplier applied to the rendered scene layer.
    """

    speed: float | None = None
    """
    Animation speed multiplier used by moving layers.
    """

    density: float | None = None
    """
    Density hint forwarded to painter or shader-backed scene layers.
    """

    intensity: float | None = None
    """
    Overall strength value used by the runtime effect renderer.
    """

    color: Any | None = None
    """
    Primary tint color for the scene layer.
    """

    accent_color: Any | None = None
    """
    Secondary tint color used for richer authored scenes.
    """

    region: Any | None = None
    """
    Optional region map or token that constrains the layer inside the host surface.
    """

    mask: Any | None = None
    """
    Optional layer mask such as ``oval``, ``radial``, or a rounded-mask mapping.
    """

    animate: bool | None = None
    """
    Controls whether the scene layer animates when hosted by the runtime.
    """

    repeat: bool | None = None
    """
    Controls whether asset-backed scene layers loop after reaching the end.
    """

    reverse: bool | None = None
    """
    Controls reverse playback for asset-backed animated layers.
    """

    duration_ms: int | None = None
    """
    Optional authored duration used by asset-backed layers and scene hosts.
    """

    phase: float | None = None
    """
    Optional normalized phase offset used to desynchronize repeated scene layers.
    """

    config: Mapping[str, Any] | None = None
    """
    Extra scene-layer configuration merged into the serialized payload.
    """

    def __init__(
        self,
        type: str,
        *,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        config: Mapping[str, Any] | None = None,
    ) -> None:
        _validate_scene_position(position)
        _validate_unit_interval("opacity", opacity)
        _validate_positive_float("speed", speed)
        _validate_positive_float("density", density)
        _validate_positive_float("intensity", intensity)
        _validate_scene_region(region)
        _validate_positive_int("duration_ms", duration_ms)
        _validate_unit_interval("phase", phase)
        self.type = type
        self.position = position
        self.opacity = opacity
        self.speed = speed
        self.density = density
        self.intensity = intensity
        self.color = color
        self.accent_color = accent_color
        self.region = region
        self.mask = mask
        self.animate = animate
        self.repeat = repeat
        self.reverse = reverse
        self.duration_ms = duration_ms
        self.phase = phase
        self.config = dict(config or {})

    def to_json(self) -> dict[str, Any]:
        payload: dict[str, Any] = {"type": self.type}
        if self.position is not None:
            payload["position"] = self.position
        if self.opacity is not None:
            payload["opacity"] = float(self.opacity)
        if self.speed is not None:
            payload["speed"] = float(self.speed)
        if self.density is not None:
            payload["density"] = float(self.density)
        if self.intensity is not None:
            payload["intensity"] = float(self.intensity)
        if self.color is not None:
            payload["color"] = _to_json_value(self.color)
        if self.accent_color is not None:
            payload["accent_color"] = _to_json_value(self.accent_color)
        if self.region is not None:
            payload["region"] = _to_json_value(self.region)
        if self.mask is not None:
            payload["mask"] = _to_json_value(self.mask)
        if self.animate is not None:
            payload["animate"] = bool(self.animate)
        if self.repeat is not None:
            payload["repeat"] = bool(self.repeat)
        if self.reverse is not None:
            payload["reverse"] = bool(self.reverse)
        if self.duration_ms is not None:
            payload["duration_ms"] = int(self.duration_ms)
        if self.phase is not None:
            payload["phase"] = float(self.phase)
        if self.config:
            payload.update(
                {
                    str(key): _to_json_value(value)
                    for key, value in self.config.items()
                    if value is not None
                }
            )
        return payload


def _validate_non_negative_int(name: str, value: int | None) -> None:
    if value is None:
        return
    if int(value) < 0:
        raise ValueError(f"{name} must be >= 0")


def _validate_positive_int(name: str, value: int | None) -> None:
    if value is None:
        return
    if int(value) <= 0:
        raise ValueError(f"{name} must be > 0")


def _validate_non_negative_float(name: str, value: float | None) -> None:
    if value is None:
        return
    if float(value) < 0:
        raise ValueError(f"{name} must be >= 0")


def _validate_positive_float(name: str, value: float | None) -> None:
    if value is None:
        return
    if float(value) <= 0:
        raise ValueError(f"{name} must be > 0")


def _validate_unit_interval(name: str, value: float | None) -> None:
    if value is None:
        return
    if not 0.0 <= float(value) <= 1.0:
        raise ValueError(f"{name} must be between 0.0 and 1.0")


def _validate_scene_position(value: str | None) -> None:
    if value is None:
        return
    if value not in {"background", "foreground", "overlay"}:
        raise ValueError("position must be one of: background, foreground, overlay")


def _validate_scene_region(region: Any | None) -> None:
    if region is None or isinstance(region, str):
        return
    if isinstance(region, SceneRegion):
        _validate_unit_interval("region.x", region.x)
        _validate_unit_interval("region.y", region.y)
        _validate_positive_float("region.width", region.width)
        _validate_positive_float("region.height", region.height)
        return
    if isinstance(region, Mapping):
        mapping = dict(region)
        x = mapping.get("x", mapping.get("left"))
        y = mapping.get("y", mapping.get("top"))
        width = mapping.get("width", mapping.get("w"))
        height = mapping.get("height", mapping.get("h"))
        if x is not None:
            _validate_unit_interval("region.x", float(x))
        if y is not None:
            _validate_unit_interval("region.y", float(y))
        if width is not None:
            _validate_positive_float("region.width", float(width))
        if height is not None:
            _validate_positive_float("region.height", float(height))
        return
    raise TypeError("region must be a SceneRegion, mapping, string token, or None")


class ParticleField(SceneLayer):
    """Authored particle field layer for lightweight motion backgrounds."""

    count: int | None = None
    """
    Approximate particle count to render.
    """

    spread: str | None = None
    """
    Distribution mode such as ``radial`` or ``scatter``.
    """

    center: Any | None = None
    """
    Optional center point for radial or clustered particle layouts.
    """

    drift: float | None = None
    """
    Drift factor that controls how much particles wander over time.
    """

    rotation: float | None = None
    """
    Rotation amount used for orbital or angled motion.
    """

    length: float | None = None
    """
    Visual length of each particle mark.
    """

    thickness: float | None = None
    """
    Stroke thickness for each particle mark.
    """

    palette: list[Any] | None = None
    """
    Optional color palette cycled across the particle field.
    """

    shape: str | None = None
    """
    Particle glyph shape such as ``capsule`` or ``line``.
    """

    def __init__(
        self,
        *,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        count: int | None = None,
        spread: str | None = None,
        center: Any | None = None,
        drift: float | None = None,
        rotation: float | None = None,
        length: float | None = None,
        thickness: float | None = None,
        palette: list[Any] | None = None,
        shape: str | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        **config: Any,
    ) -> None:
        _validate_non_negative_int("count", count)
        _validate_non_negative_float("drift", drift)
        _validate_positive_float("length", length)
        _validate_positive_float("thickness", thickness)
        super().__init__(
            type="particle_field",
            position=position,
            opacity=opacity,
            speed=speed,
            density=density,
            intensity=intensity,
            color=color,
            accent_color=accent_color,
            region=region,
            mask=mask,
            animate=animate,
            repeat=repeat,
            reverse=reverse,
            duration_ms=duration_ms,
            phase=phase,
            config=config or None,
        )
        self.count = count
        self.spread = spread
        self.center = center
        self.drift = drift
        self.rotation = rotation
        self.length = length
        self.thickness = thickness
        self.palette = palette
        self.shape = shape

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        if self.count is not None:
            payload["count"] = int(self.count)
        if self.spread is not None:
            payload["spread"] = self.spread
        if self.center is not None:
            payload["center"] = _to_json_value(self.center)
        if self.drift is not None:
            payload["drift"] = float(self.drift)
        if self.rotation is not None:
            payload["rotation"] = float(self.rotation)
        if self.length is not None:
            payload["length"] = float(self.length)
        if self.thickness is not None:
            payload["thickness"] = float(self.thickness)
        if self.palette is not None:
            payload["palette"] = [_to_json_value(value) for value in self.palette]
        if self.shape is not None:
            payload["shape"] = self.shape
        return payload


class GradientWash(SceneLayer):
    """Soft atmospheric gradient wash layer for large surfaces or page backgrounds."""

    gradient: Any | None = None
    """
    Gradient value object or raw gradient mapping used by the wash.
    """

    def __init__(
        self,
        gradient: Any | None = None,
        *,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        **config: Any,
    ) -> None:
        super().__init__(
            type="gradient_wash",
            position=position,
            opacity=opacity,
            speed=speed,
            density=density,
            intensity=intensity,
            color=color,
            accent_color=accent_color,
            region=region,
            mask=mask,
            animate=animate,
            repeat=repeat,
            reverse=reverse,
            duration_ms=duration_ms,
            phase=phase,
            config=config or None,
        )
        self.gradient = gradient

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        if self.gradient is not None:
            payload["gradient"] = _to_json_value(self.gradient)
        return payload


class LineField(SceneLayer):
    """Authored line-field layer for directional motion patterns."""

    count: int | None = None
    """
    Approximate number of line marks to render.
    """

    direction: str | None = None
    """
    Primary flow direction such as ``diagonal`` or ``vertical``.
    """

    spacing: float | None = None
    """
    Spacing value used when the line field is arranged in bands.
    """

    thickness: float | None = None
    """
    Stroke thickness for each line mark.
    """

    length: float | None = None
    """
    Visual length of each rendered line.
    """

    palette: list[Any] | None = None
    """
    Optional color palette cycled across the line field.
    """

    def __init__(
        self,
        *,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        count: int | None = None,
        direction: str | None = None,
        spacing: float | None = None,
        thickness: float | None = None,
        length: float | None = None,
        palette: list[Any] | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        **config: Any,
    ) -> None:
        _validate_non_negative_int("count", count)
        _validate_positive_float("spacing", spacing)
        _validate_positive_float("thickness", thickness)
        _validate_positive_float("length", length)
        super().__init__(
            type="line_field",
            position=position,
            opacity=opacity,
            speed=speed,
            density=density,
            intensity=intensity,
            color=color,
            accent_color=accent_color,
            region=region,
            mask=mask,
            animate=animate,
            repeat=repeat,
            reverse=reverse,
            duration_ms=duration_ms,
            phase=phase,
            config=config or None,
        )
        self.count = count
        self.direction = direction
        self.spacing = spacing
        self.thickness = thickness
        self.length = length
        self.palette = palette

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        if self.count is not None:
            payload["count"] = int(self.count)
        if self.direction is not None:
            payload["direction"] = self.direction
        if self.spacing is not None:
            payload["spacing"] = float(self.spacing)
        if self.thickness is not None:
            payload["thickness"] = float(self.thickness)
        if self.length is not None:
            payload["length"] = float(self.length)
        if self.palette is not None:
            payload["palette"] = [_to_json_value(value) for value in self.palette]
        return payload


class OrbitField(SceneLayer):
    """Scene layer for orbital bands, swirls, and circular motion fields."""

    count: int | None = None
    """
    Approximate number of orbit markers to render.
    """

    radius: float | None = None
    """
    Base radius for the orbit field.
    """

    band_width: float | None = None
    """
    Width of the orbital band around the base radius.
    """

    swirl: float | None = None
    """
    Swirl amount applied to the orbital motion.
    """

    marker_size: float | None = None
    """
    Visual size for each orbit marker.
    """

    palette: list[Any] | None = None
    """
    Optional color palette cycled across orbit markers.
    """

    def __init__(
        self,
        *,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        count: int | None = None,
        radius: float | None = None,
        band_width: float | None = None,
        swirl: float | None = None,
        marker_size: float | None = None,
        palette: list[Any] | None = None,
        center: Any | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        **config: Any,
    ) -> None:
        _validate_non_negative_int("count", count)
        _validate_positive_float("radius", radius)
        _validate_positive_float("band_width", band_width)
        _validate_positive_float("marker_size", marker_size)
        merged_config = dict(config or {})
        if center is not None:
            merged_config["center"] = center
        super().__init__(
            type="orbit_field",
            position=position,
            opacity=opacity,
            speed=speed,
            density=density,
            intensity=intensity,
            color=color,
            accent_color=accent_color,
            region=region,
            mask=mask,
            animate=animate,
            repeat=repeat,
            reverse=reverse,
            duration_ms=duration_ms,
            phase=phase,
            config=merged_config or None,
        )
        self.count = count
        self.radius = radius
        self.band_width = band_width
        self.swirl = swirl
        self.marker_size = marker_size
        self.palette = palette

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        if self.count is not None:
            payload["count"] = int(self.count)
        if self.radius is not None:
            payload["radius"] = float(self.radius)
        if self.band_width is not None:
            payload["band_width"] = float(self.band_width)
        if self.swirl is not None:
            payload["swirl"] = float(self.swirl)
        if self.marker_size is not None:
            payload["marker_size"] = float(self.marker_size)
        if self.palette is not None:
            payload["palette"] = [_to_json_value(value) for value in self.palette]
        return payload


class NoiseField(SceneLayer):
    """Scene layer for lightweight procedural noise and atmospheric grain."""

    scale: float | None = None
    """
    Noise scale controlling feature size in the generated field.
    """

    contrast: float | None = None
    """
    Contrast multiplier applied to the generated noise signal.
    """

    octaves: int | None = None
    """
    Number of octaves used when layering fractal noise.
    """

    def __init__(
        self,
        *,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        scale: float | None = None,
        contrast: float | None = None,
        octaves: int | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        **config: Any,
    ) -> None:
        _validate_positive_float("scale", scale)
        _validate_positive_float("contrast", contrast)
        _validate_positive_int("octaves", octaves)
        super().__init__(
            type="noise_field",
            position=position,
            opacity=opacity,
            speed=speed,
            density=density,
            intensity=intensity,
            color=color,
            accent_color=accent_color,
            region=region,
            mask=mask,
            animate=animate,
            repeat=repeat,
            reverse=reverse,
            duration_ms=duration_ms,
            phase=phase,
            config=config or None,
        )
        self.scale = scale
        self.contrast = contrast
        self.octaves = octaves

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        if self.scale is not None:
            payload["scale"] = float(self.scale)
        if self.contrast is not None:
            payload["contrast"] = float(self.contrast)
        if self.octaves is not None:
            payload["octaves"] = int(self.octaves)
        return payload


class ShaderLayer(SceneLayer):
    """Shader-backed scene layer for authored fragment effects."""

    shader_asset: str
    """
    Flutter shader asset path loaded by the runtime.
    """

    uniforms: Mapping[str, Any] | None = None
    """
    Uniform values forwarded to the shader layer at render time.
    """

    def __init__(
        self,
        shader_asset: str,
        *,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        uniforms: Mapping[str, Any] | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        **config: Any,
    ) -> None:
        if not shader_asset or not shader_asset.strip():
            raise ValueError("shader_asset must not be empty")
        super().__init__(
            type="shader",
            position=position,
            opacity=opacity,
            speed=speed,
            density=density,
            intensity=intensity,
            color=color,
            accent_color=accent_color,
            region=region,
            mask=mask,
            animate=animate,
            repeat=repeat,
            reverse=reverse,
            duration_ms=duration_ms,
            phase=phase,
            config=config or None,
        )
        self.shader_asset = shader_asset
        self.uniforms = dict(uniforms or {})

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        payload["shader_asset"] = self.shader_asset
        if self.uniforms:
            payload["uniforms"] = _to_json_value(self.uniforms)
        return payload


class LottieLayer(SceneLayer):
    """Typed Lottie scene layer hosted directly through the Styling engine."""

    lottie_asset: str | None = None
    """
    Local Lottie asset path used by the runtime layer host.
    """

    lottie_url: str | None = None
    """
    Remote Lottie URL used when an asset path is not provided.
    """

    lottie_data: Any | None = None
    """
    Inline Lottie JSON or binary payload.
    """

    fit: str | None = None
    """
    Box-fit token used when the animation is placed inside a surface region.
    """

    alignment: Any | None = None
    """
    Alignment used when the layer does not fully cover its host region.
    """

    def __init__(
        self,
        *,
        lottie_asset: str | None = None,
        lottie_url: str | None = None,
        lottie_data: Any | None = None,
        fit: str | None = None,
        alignment: Any | None = None,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        **config: Any,
    ) -> None:
        if not any((lottie_asset, lottie_url, lottie_data is not None)):
            raise ValueError("LottieLayer requires lottie_asset, lottie_url, or lottie_data")
        super().__init__(
            type="lottie",
            position=position,
            opacity=opacity,
            speed=speed,
            density=density,
            intensity=intensity,
            color=color,
            accent_color=accent_color,
            region=region,
            mask=mask,
            animate=animate,
            repeat=repeat,
            reverse=reverse,
            duration_ms=duration_ms,
            phase=phase,
            config=config or None,
        )
        self.lottie_asset = lottie_asset
        self.lottie_url = lottie_url
        self.lottie_data = lottie_data
        self.fit = fit
        self.alignment = alignment

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        if self.lottie_asset is not None:
            payload["lottie_asset"] = self.lottie_asset
        if self.lottie_url is not None:
            payload["lottie_url"] = self.lottie_url
        if self.lottie_data is not None:
            payload["lottie_data"] = _to_json_value(self.lottie_data)
        if self.fit is not None:
            payload["fit"] = self.fit
        if self.alignment is not None:
            payload["alignment"] = _to_json_value(self.alignment)
        return payload


class RiveLayer(SceneLayer):
    """Typed Rive scene layer hosted directly through the Styling engine."""

    rive_asset: str | None = None
    """
    Local Rive asset path used by the runtime layer host.
    """

    rive_url: str | None = None
    """
    Remote Rive URL used when an asset path is not provided.
    """

    artboard: str | None = None
    """
    Optional artboard selector forwarded to the runtime host.
    """

    state_machine: str | None = None
    """
    Optional state-machine selector forwarded to the runtime host.
    """

    fit: str | None = None
    """
    Box-fit token used when the animation is placed inside a surface region.
    """

    alignment: Any | None = None
    """
    Alignment used when the layer does not fully cover its host region.
    """

    def __init__(
        self,
        *,
        rive_asset: str | None = None,
        rive_url: str | None = None,
        artboard: str | None = None,
        state_machine: str | None = None,
        fit: str | None = None,
        alignment: Any | None = None,
        position: str | None = None,
        opacity: float | None = None,
        speed: float | None = None,
        density: float | None = None,
        intensity: float | None = None,
        color: Any | None = None,
        accent_color: Any | None = None,
        region: Any | None = None,
        mask: Any | None = None,
        animate: bool | None = None,
        repeat: bool | None = None,
        reverse: bool | None = None,
        duration_ms: int | None = None,
        phase: float | None = None,
        **config: Any,
    ) -> None:
        if not any((rive_asset, rive_url)):
            raise ValueError("RiveLayer requires rive_asset or rive_url")
        super().__init__(
            type="rive",
            position=position,
            opacity=opacity,
            speed=speed,
            density=density,
            intensity=intensity,
            color=color,
            accent_color=accent_color,
            region=region,
            mask=mask,
            animate=animate,
            repeat=repeat,
            reverse=reverse,
            duration_ms=duration_ms,
            phase=phase,
            config=config or None,
        )
        self.rive_asset = rive_asset
        self.rive_url = rive_url
        self.artboard = artboard
        self.state_machine = state_machine
        self.fit = fit
        self.alignment = alignment

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        if self.rive_asset is not None:
            payload["rive_asset"] = self.rive_asset
        if self.rive_url is not None:
            payload["rive_url"] = self.rive_url
        if self.artboard is not None:
            payload["rive_artboard"] = self.artboard
        if self.state_machine is not None:
            payload["rive_state_machine"] = self.state_machine
        if self.fit is not None:
            payload["fit"] = self.fit
        if self.alignment is not None:
            payload["alignment"] = _to_json_value(self.alignment)
        return payload


def _to_json_value(value: Any) -> Any:
    if value is None:
        return None
    if hasattr(value, "to_json"):
        try:
            return value.to_json()
        except Exception:
            return value
    if isinstance(value, Mapping):
        return {str(key): _to_json_value(item) for key, item in value.items() if item is not None}
    if isinstance(value, (list, tuple, set)):
        return [_to_json_value(item) for item in value if item is not None]
    return value


def _coerce_state_style(value: Any) -> dict[str, Any] | None:
    if value is None:
        return None
    if isinstance(value, Style):
        payload = value.to_json()
        return payload if payload else None
    if isinstance(value, Mapping):
        payload = {str(key): _to_json_value(item) for key, item in value.items() if item is not None}
        return payload or None
    raise TypeError(f"invalid style state type: {type(value).__name__}")


class Style:
    """Structured local styling payload for ButterflyUI controls.

    `Style` is intentionally engine-friendly: it serializes to a plain mapping
    that the Dart runtime can merge with stylesheet rules, utility classes, and
    style-pack defaults.
    """

    bg: Any | None = None
    """
    Shortcut background color value. When present it wins over ``bgcolor``.
    """

    bgcolor: Any | None = None
    """
    Explicit background color forwarded to the styled surface.
    """

    background: Any | None = None
    """
    Full background payload used for advanced surface configuration.
    """

    fg: Any | None = None
    """
    Shortcut foreground color value. When present it wins over ``foreground``.
    """

    foreground: Any | None = None
    """
    Foreground tint color applied to icons and simple content.
    """

    text_color: Any | None = None
    """
    Primary text color for content rendered inside the styled control.
    """

    icon_color: Any | None = None
    """
    Default icon color for icon-bearing slots within the styled control.
    """

    color: Any | None = None
    """
    Generic color channel used by some controls and effects.
    """

    border_color: Any | None = None
    """
    Border color for the styled surface.
    """

    border_width: float | None = None
    """
    Border width for the styled surface.
    """

    radius: Any | None = None
    """
    Corner radius token, number, or per-corner specification.
    """

    padding: Any | None = None
    """
    Inner padding applied to the styled control content.
    """

    margin: Any | None = None
    """
    Outer margin applied around the styled control.
    """

    alignment: Any | None = None
    """
    Alignment for child content inside the styled control.
    """

    shadow: Any | None = None
    """
    Shadow stack or shadow value object for the styled surface.
    """

    gradient: Any | None = None
    """
    Gradient value object or mapping applied to the surface fill.
    """

    image: Any | None = None
    """
    Decoration image payload rendered on the surface.
    """

    blur: float | None = None
    """
    Foreground blur amount used by supporting runtime controls.
    """

    backdrop_blur: float | None = None
    """
    Background blur amount for glass-like surfaces.
    """

    shape: str | None = None
    """
    Shape token used by controls that support alternative surface outlines.
    """

    width: float | str | None = None
    """
    Explicit width override for the styled control.
    """

    height: float | str | None = None
    """
    Explicit height override for the styled control.
    """

    min_width: float | str | None = None
    """
    Minimum width constraint applied by the layout runtime.
    """

    min_height: float | str | None = None
    """
    Minimum height constraint applied by the layout runtime.
    """

    max_width: float | str | None = None
    """
    Maximum width constraint applied by the layout runtime.
    """

    max_height: float | str | None = None
    """
    Maximum height constraint applied by the layout runtime.
    """

    expand: bool | None = None
    """
    Whether the control should expand within flexible parent layouts.
    """

    flex: int | None = None
    """
    Flex factor used in row and column layouts.
    """

    opacity: float | None = None
    """
    Opacity multiplier applied to the rendered control.
    """

    elevation: float | None = None
    """
    Elevation hint for controls that expose material-like layering.
    """

    font_size: float | None = None
    """
    Preferred text size for styled text-bearing controls.
    """

    size: float | str | None = None
    """
    Generic size shorthand used by some controls and text surfaces.
    """

    weight: str | None = None
    """
    Preferred font weight token. When present it wins over ``font_weight``.
    """

    font_weight: str | None = None
    """
    Explicit font weight token forwarded to the runtime text renderer.
    """

    font_family: str | None = None
    """
    Font family name used for styled text.
    """

    type_role: str | None = None
    """
    Named typography role such as ``display_hero``, ``body``, ``caption``, or ``button_label``.
    """

    text_role: str | None = None
    """
    Alias for ``type_role`` kept for ergonomic CSS-like authoring.
    """

    italic: bool | None = None
    """
    Whether styled text should render in italic form.
    """

    variant: str | Mapping[str, Any] | None = None
    """
    Variant token or structured variant payload applied to the control.
    """

    motion: Any | None = None
    """
    Motion payload merged into the runtime styling contract.
    """

    effect: Any | None = None
    """
    Single effect declaration for the styled control.
    """

    effects: Any | None = None
    """
    List or mapping of effect declarations for the styled control.
    """

    background_effect: Any | None = None
    """
    Background effect declaration resolved behind the control surface.
    """

    foreground_effect: Any | None = None
    """
    Foreground effect declaration resolved above the control content.
    """

    overlay_effect: Any | None = None
    """
    Overlay effect declaration resolved in the top-most local layer.
    """

    background_layers: Any | None = None
    """
    Authored scene layers rendered behind the surface.
    """

    foreground_layers: Any | None = None
    """
    Authored scene layers rendered above the control content.
    """

    overlay_layers: Any | None = None
    """
    Authored scene layers rendered in the overlay plane.
    """

    classes: str | list[str] | None = None
    """
    CSS-like utility classes or semantic class names for the control.
    """

    class_name: str | list[str] | None = None
    """
    Alias for ``classes`` kept for ergonomic Python authoring.
    """

    tokens: Mapping[str, Any] | None = None
    """
    Local design-token overrides merged into the styling cascade.
    """

    slots: Mapping[str, Any] | None = None
    """
    Slot-specific style payloads such as ``label`` or ``helper``.
    """

    position: str | None = None
    """
    Positioning mode such as ``relative`` or ``absolute``.
    """

    top: float | str | None = None
    """
    Top inset used with positioned layouts.
    """

    right: float | str | None = None
    """
    Right inset used with positioned layouts.
    """

    bottom: float | str | None = None
    """
    Bottom inset used with positioned layouts.
    """

    left: float | str | None = None
    """
    Left inset used with positioned layouts.
    """

    z_index: float | None = None
    """
    Stacking order applied when the runtime supports layered positioning.
    """

    translate: Any | None = None
    """
    Two-value translation payload or transform shorthand.
    """

    translate_x: float | None = None
    """
    Horizontal translation applied after layout.
    """

    translate_y: float | None = None
    """
    Vertical translation applied after layout.
    """

    scale: Any | None = None
    """
    Scale transform value or transform payload.
    """

    overflow: str | None = None
    """
    Overflow behavior such as ``visible``, ``clip``, or ``hidden``.
    """

    hover: "Style | Mapping[str, Any] | None" = None
    """
    State-specific style payload applied while the control is hovered.
    """

    pressed: "Style | Mapping[str, Any] | None" = None
    """
    State-specific style payload applied while the control is pressed.
    """

    focus: "Style | Mapping[str, Any] | None" = None
    """
    State-specific style payload applied while the control is focused.
    """

    disabled: "Style | Mapping[str, Any] | None" = None
    """
    State-specific style payload applied while the control is disabled.
    """

    theme: Any | None = None
    """
    Theme or style-pack alias resolved into ``style_pack`` at serialization time.
    """

    style_pack: Any | None = None
    """
    Explicit style-pack value forwarded to the runtime.
    """

    extra: Mapping[str, Any] | None = None
    """
    Extra styling declarations preserved for forward-compatible runtime features.
    """

    def __init__(
        self,
        *,
        bg: Any | None = None,
        bgcolor: Any | None = None,
        background: Any | None = None,
        fg: Any | None = None,
        foreground: Any | None = None,
        text_color: Any | None = None,
        icon_color: Any | None = None,
        color: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: Any | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        alignment: Any | None = None,
        shadow: Any | None = None,
        gradient: Any | None = None,
        image: Any | None = None,
        blur: float | None = None,
        backdrop_blur: float | None = None,
        shape: str | None = None,
        width: float | str | None = None,
        height: float | str | None = None,
        min_width: float | str | None = None,
        min_height: float | str | None = None,
        max_width: float | str | None = None,
        max_height: float | str | None = None,
        expand: bool | None = None,
        flex: int | None = None,
        opacity: float | None = None,
        elevation: float | None = None,
        font_size: float | None = None,
        size: float | str | None = None,
        weight: str | None = None,
        font_weight: str | None = None,
        font_family: str | None = None,
        type_role: str | None = None,
        text_role: str | None = None,
        italic: bool | None = None,
        variant: str | Mapping[str, Any] | None = None,
        motion: Any | None = None,
        effect: Any | None = None,
        effects: Any | None = None,
        background_effect: Any | None = None,
        foreground_effect: Any | None = None,
        overlay_effect: Any | None = None,
        background_layers: Any | None = None,
        foreground_layers: Any | None = None,
        overlay_layers: Any | None = None,
        classes: str | list[str] | None = None,
        class_name: str | list[str] | None = None,
        tokens: Mapping[str, Any] | None = None,
        slots: Mapping[str, Any] | None = None,
        position: str | None = None,
        top: float | str | None = None,
        right: float | str | None = None,
        bottom: float | str | None = None,
        left: float | str | None = None,
        z_index: float | None = None,
        translate: Any | None = None,
        translate_x: float | None = None,
        translate_y: float | None = None,
        scale: Any | None = None,
        overflow: str | None = None,
        hover: "Style | Mapping[str, Any] | None" = None,
        pressed: "Style | Mapping[str, Any] | None" = None,
        focus: "Style | Mapping[str, Any] | None" = None,
        disabled: "Style | Mapping[str, Any] | None" = None,
        theme: Any | None = None,
        style_pack: Any | None = None,
        **extra: Any,
    ) -> None:
        self.bg = bg
        self.bgcolor = bgcolor
        self.background = background
        self.fg = fg
        self.foreground = foreground
        self.text_color = text_color
        self.icon_color = icon_color
        self.color = color
        self.border_color = border_color
        self.border_width = border_width
        self.radius = radius
        self.padding = padding
        self.margin = margin
        self.alignment = alignment
        self.shadow = shadow
        self.gradient = gradient
        self.image = image
        self.blur = blur
        self.backdrop_blur = backdrop_blur
        self.shape = shape
        self.width = width
        self.height = height
        self.min_width = min_width
        self.min_height = min_height
        self.max_width = max_width
        self.max_height = max_height
        self.expand = expand
        self.flex = flex
        self.opacity = opacity
        self.elevation = elevation
        self.font_size = font_size
        self.size = size
        self.weight = weight
        self.font_weight = font_weight
        self.font_family = font_family
        self.type_role = type_role
        self.text_role = text_role
        self.italic = italic
        self.variant = variant
        self.motion = motion
        self.effect = effect
        self.effects = effects
        self.background_effect = background_effect
        self.foreground_effect = foreground_effect
        self.overlay_effect = overlay_effect
        self.background_layers = background_layers
        self.foreground_layers = foreground_layers
        self.overlay_layers = overlay_layers
        self.classes = classes
        self.class_name = class_name
        self.tokens = dict(tokens or {})
        self.slots = dict(slots or {})
        self.position = position
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
        self.z_index = z_index
        self.translate = translate
        self.translate_x = translate_x
        self.translate_y = translate_y
        self.scale = scale
        self.overflow = overflow
        self.hover = hover
        self.pressed = pressed
        self.focus = focus
        self.disabled = disabled
        self.theme = theme
        self.style_pack = style_pack
        self.extra = dict(extra)

    def to_json(self) -> dict[str, Any]:
        payload: dict[str, Any] = {}

        def put(key: str, value: Any) -> None:
            if value is None:
                return
            payload[key] = _to_json_value(value)

        put("bgcolor", self.bg if self.bg is not None else self.bgcolor)
        put("background", self.background)
        put("foreground", self.fg if self.fg is not None else self.foreground)
        put("text_color", self.text_color)
        put("icon_color", self.icon_color)
        put("color", self.color)
        put("border_color", self.border_color)
        put("border_width", self.border_width)
        put("radius", self.radius)
        put("padding", self.padding)
        put("margin", self.margin)
        put("alignment", self.alignment)
        put("shadow", self.shadow)
        put("gradient", self.gradient)
        put("image", self.image)
        put("blur", self.blur)
        put("backdrop_blur", self.backdrop_blur)
        put("shape", self.shape)
        put("width", self.width)
        put("height", self.height)
        put("min_width", self.min_width)
        put("min_height", self.min_height)
        put("max_width", self.max_width)
        put("max_height", self.max_height)
        put("expand", self.expand)
        put("flex", self.flex)
        put("opacity", self.opacity)
        put("elevation", self.elevation)
        put("font_size", self.font_size if self.font_size is not None else self.size)
        put("weight", self.weight if self.weight is not None else self.font_weight)
        put("font_family", self.font_family)
        put("type_role", self.type_role if self.type_role is not None else self.text_role)
        put("italic", self.italic)
        put("variant", self.variant)
        put("motion", self.motion)
        put("effect", self.effect)
        put("effects", self.effects)
        put("background_effect", self.background_effect)
        put("foreground_effect", self.foreground_effect)
        put("overlay_effect", self.overlay_effect)
        put("background_layers", self.background_layers)
        put("foreground_layers", self.foreground_layers)
        put("overlay_layers", self.overlay_layers)
        put("position", self.position)
        put("top", self.top)
        put("right", self.right)
        put("bottom", self.bottom)
        put("left", self.left)
        put("z_index", self.z_index)
        put("translate", self.translate)
        put("translate_x", self.translate_x)
        put("translate_y", self.translate_y)
        put("scale", self.scale)
        put("overflow", self.overflow)

        classes = self.class_name if self.class_name is not None else self.classes
        put("classes", classes)
        if self.tokens:
            payload["tokens"] = _to_json_value(self.tokens)
        if self.slots:
            payload["slots"] = _to_json_value(self.slots)
        if self.style_pack is not None:
            put("style_pack", self.style_pack)
        elif self.theme is not None:
            put("style_pack", self.theme)

        states: dict[str, Any] = {}
        for state_name, state_style in (
            ("hover", self.hover),
            ("pressed", self.pressed),
            ("focused", self.focus),
            ("disabled", self.disabled),
        ):
            resolved = _coerce_state_style(state_style)
            if resolved:
                states[state_name] = resolved
        if states:
            payload["states"] = states

        for key, value in self.extra.items():
            if value is None:
                continue
            payload[str(key)] = _to_json_value(value)
        return payload


StyleValue = Style
