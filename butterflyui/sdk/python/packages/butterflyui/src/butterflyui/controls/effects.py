from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "AnimatedBackground",
    "ChromaticShift",
    "ConfettiBurst",
    "GlassBlur",
    "GlowEffect",
    "GradientSweep",
    "GrainOverlay",
    "NeonEdge",
    "NoiseDisplacement",
    "NoiseField",
    "ParticleField",
    "ScanlineOverlay",
    "Vignette",
]


class AnimatedBackground(Component):
    control_type = "animated_background"

    def __init__(
        self,
        child: Any | None = None,
        *,
        colors: list[Any] | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class ParticleField(Component):
    control_type = "particle_field"

    def __init__(
        self,
        *,
        count: int | None = None,
        colors: list[Any] | None = None,
        size: float | None = None,
        min_size: float | None = None,
        max_size: float | None = None,
        speed: float | None = None,
        min_speed: float | None = None,
        max_speed: float | None = None,
        direction: float | None = None,
        spread: float | None = None,
        opacity: float | None = None,
        seed: int | None = None,
        loop: bool | None = None,
        play: bool | None = None,
        shape: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            count=count,
            colors=colors,
            size=size,
            min_size=min_size,
            max_size=max_size,
            speed=speed,
            min_speed=min_speed,
            max_speed=max_speed,
            direction=direction,
            spread=spread,
            opacity=opacity,
            seed=seed,
            loop=loop,
            play=play,
            shape=shape,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})

    def set_seed(self, session: Any, seed: int) -> dict[str, Any]:
        return self.invoke(session, "set_seed", {"seed": int(seed)})


class ScanlineOverlay(Component):
    control_type = "scanline_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *,
        spacing: float | None = None,
        thickness: float | None = None,
        opacity: float | None = None,
        color: Any | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing,
            thickness=thickness,
            opacity=opacity,
            color=color,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)


class Vignette(Component):
    control_type = "vignette"

    def __init__(
        self,
        child: Any | None = None,
        *,
        intensity: float | None = None,
        opacity: float | None = None,
        color: Any | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            intensity=intensity,
            opacity=opacity,
            color=color,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)


class GlowEffect(Component):
    control_type = "glow_effect"

    def __init__(
        self,
        child: Any | None = None,
        *,
        color: Any | None = None,
        blur: float | None = None,
        spread: float | None = None,
        radius: float | None = None,
        offset_x: float | None = None,
        offset_y: float | None = None,
        clip: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            blur=blur,
            spread=spread,
            radius=radius,
            offset_x=offset_x,
            offset_y=offset_y,
            clip=clip,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class GlassBlur(Component):
    control_type = "glass_blur"

    def __init__(
        self,
        child: Any | None = None,
        *,
        blur: float | None = None,
        opacity: float | None = None,
        color: Any | None = None,
        radius: float | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            blur=blur,
            opacity=opacity,
            color=color,
            radius=radius,
            border_color=border_color,
            border_width=border_width,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class GradientSweep(Component):
    control_type = "gradient_sweep"

    def __init__(
        self,
        child: Any | None = None,
        *,
        colors: list[Any] | None = None,
        duration_ms: int | None = None,
        angle: float | None = None,
        opacity: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            duration_ms=duration_ms,
            angle=angle,
            opacity=opacity,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})


class ConfettiBurst(Component):
    control_type = "confetti_burst"

    def __init__(
        self,
        child: Any | None = None,
        *,
        colors: list[Any] | None = None,
        count: int | None = None,
        duration_ms: int | None = None,
        gravity: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            count=count,
            duration_ms=duration_ms,
            gravity=gravity,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def burst(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "burst", {})


class ChromaticShift(Component):
    control_type = "chromatic_shift"

    def __init__(
        self,
        child: Any | None = None,
        *,
        shift: float | None = None,
        opacity: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, shift=shift, opacity=opacity, **kwargs)
        super().__init__(child=child, props=merged, style=style, strict=strict)


class _EventfulEffect(Component):
    control_type = ""

    def __init__(
        self,
        child: Any | None = None,
        *,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, events=events, **kwargs)
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, **payload: Any) -> dict[str, Any]:
        return self.invoke(session, "trigger", payload)


class NeonEdge(_EventfulEffect):
    control_type = "neon_edge"

    def __init__(
        self,
        child: Any | None = None,
        *,
        color: Any | None = None,
        width: float | None = None,
        glow: float | None = None,
        spread: float | None = None,
        radius: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            events=events,
            props=props,
            style=style,
            strict=strict,
            color=color,
            width=width,
            glow=glow,
            spread=spread,
            radius=radius,
            **kwargs,
        )


class GrainOverlay(_EventfulEffect):
    control_type = "grain_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *,
        opacity: float | None = None,
        density: float | None = None,
        seed: int | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            events=events,
            props=props,
            style=style,
            strict=strict,
            opacity=opacity,
            density=density,
            seed=seed,
            color=color,
            **kwargs,
        )


class NoiseDisplacement(_EventfulEffect):
    control_type = "noise_displacement"

    def __init__(
        self,
        child: Any | None = None,
        *,
        strength: float | None = None,
        duration_ms: int | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            events=events,
            props=props,
            style=style,
            strict=strict,
            strength=strength,
            duration_ms=duration_ms,
            **kwargs,
        )


class NoiseField(_EventfulEffect):
    control_type = "noise_field"

    def __init__(
        self,
        child: Any | None = None,
        *,
        seed: int | None = None,
        intensity: float | None = None,
        speed: float | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            events=events,
            props=props,
            style=style,
            strict=strict,
            seed=seed,
            intensity=intensity,
            speed=speed,
            color=color,
            **kwargs,
        )



