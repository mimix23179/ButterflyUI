from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "AnimatedBackground",
    "Animation",
    "Transition",
    "Effects",
    "Shadow",
    "Particles",
    "FoldLayer",
    "Layer",
    "LayerList",
    "ChromaticShift",
    "ConfettiBurst",
    "GlassBlur",
    "GlowEffect",
    "GradientSweep",
    "Shimmer",
    "ShadowStack",
    "TiltHover",
    "Timeline",
    "TimeTravel",
    "Stagger",
    "GrainOverlay",
    "NeonEdge",
    "NoiseDisplacement",
    "NoiseField",
    "FlowField",
    "LiquidMorph",
    "MorphingBorder",
    "Motion",
    "Parallax",
    "PanZoom",
    "Pose",
    "Pixelate",
    "RippleBurst",
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


class FoldLayer(Component):
    control_type = "fold_layer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        folds: int | None = None,
        progress: float | None = None,
        axis: str | None = None,
        perspective: float | None = None,
        shadow: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            folds=folds,
            progress=progress,
            axis=axis,
            perspective=perspective,
            shadow=shadow,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_progress(self, session: Any, progress: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"progress": float(progress)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class LiquidMorph(Component):
    control_type = "liquid_morph"

    def __init__(
        self,
        child: Any | None = None,
        *,
        min_radius: float | None = None,
        max_radius: float | None = None,
        duration_ms: int | None = None,
        animate: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            min_radius=min_radius,
            max_radius=max_radius,
            duration_ms=duration_ms,
            animate=animate,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class MorphingBorder(Component):
    control_type = "morphing_border"

    def __init__(
        self,
        child: Any | None = None,
        *,
        min_radius: float | None = None,
        max_radius: float | None = None,
        duration_ms: int | None = None,
        animate: bool | None = None,
        color: Any | None = None,
        width: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            min_radius=min_radius,
            max_radius=max_radius,
            duration_ms=duration_ms,
            animate=animate,
            color=color,
            width=width,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class Motion(Component):
    control_type = "motion"

    def __init__(
        self,
        child: Any | None = None,
        *,
        motion: Any | None = None,
        from_: Mapping[str, Any] | None = None,
        to: Mapping[str, Any] | None = None,
        duration_ms: int | None = None,
        curve: str | None = None,
        play: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            motion=motion,
            **({"from": dict(from_)} if from_ is not None else {}),
            to=dict(to) if to is not None else None,
            duration_ms=duration_ms,
            curve=curve,
            play=play,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class Stagger(Component):
    control_type = "stagger"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        stagger_ms: int | None = None,
        stagger: int | None = None,
        direction: str | None = None,
        play: bool | None = None,
        duration_ms: int | None = None,
        curve: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            stagger_ms=stagger_ms,
            stagger=stagger,
            direction=direction,
            play=play,
            duration_ms=duration_ms,
            curve=curve,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class TiltHover(Component):
    control_type = "tilt_hover"

    def __init__(
        self,
        child: Any | None = None,
        *,
        max_tilt: float | None = None,
        perspective: float | None = None,
        reset_on_exit: bool | None = None,
        scale: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            max_tilt=max_tilt,
            perspective=perspective,
            reset_on_exit=reset_on_exit,
            scale=scale,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Timeline(Component):
    control_type = "timeline"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        tracks: list[Mapping[str, Any]] | None = None,
        direction: str | None = None,
        spacing: float | None = None,
        autoplay: bool | None = None,
        play: bool | None = None,
        duration_ms: int | None = None,
        delay_ms: int | None = None,
        repeat: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            tracks=[dict(track) for track in (tracks or [])],
            direction=direction,
            spacing=spacing,
            autoplay=autoplay,
            play=play,
            duration_ms=duration_ms,
            delay_ms=delay_ms,
            repeat=repeat,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class TimeTravel(Component):
    control_type = "time_travel"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        min: float | int | None = None,
        max: float | int | None = None,
        value: float | int | None = None,
        step: float | int | None = None,
        playing: bool | None = None,
        speed: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            min=min,
            max=max,
            value=value,
            step=step,
            playing=playing,
            speed=speed,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_value(self, session: Any, value: float | int) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_playing(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_playing", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Parallax(Component):
    control_type = "parallax"

    def __init__(
        self,
        child: Any | None = None,
        *,
        max_offset: float | None = None,
        reset_on_exit: bool | None = None,
        depths: list[float] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            max_offset=max_offset,
            reset_on_exit=reset_on_exit,
            depths=depths,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class PanZoom(Component):
    control_type = "pan_zoom"

    def __init__(
        self,
        child: Any | None = None,
        *,
        enabled: bool | None = None,
        scale: float | None = None,
        x: float | None = None,
        y: float | None = None,
        min_scale: float | None = None,
        max_scale: float | None = None,
        boundary_margin: Any | None = None,
        pan_enabled: bool | None = None,
        zoom_enabled: bool | None = None,
        clip: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            scale=scale,
            x=x,
            y=y,
            min_scale=min_scale,
            max_scale=max_scale,
            boundary_margin=boundary_margin,
            pan_enabled=pan_enabled,
            zoom_enabled=zoom_enabled,
            clip=clip,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_transform(self, session: Any, *, scale: float | None = None, x: float | None = None, y: float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if scale is not None:
            payload["scale"] = scale
        if x is not None:
            payload["x"] = x
        if y is not None:
            payload["y"] = y
        return self.invoke(session, "set_transform", payload)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class Pose(Component):
    control_type = "pose"

    def __init__(
        self,
        child: Any | None = None,
        *,
        x: float | None = None,
        y: float | None = None,
        z: float | None = None,
        scale: float | None = None,
        rotate: float | None = None,
        opacity: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            x=x,
            y=y,
            z=z,
            scale=scale,
            rotate=rotate,
            opacity=opacity,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class Pixelate(Component):
    control_type = "pixelate"

    def __init__(
        self,
        child: Any | None = None,
        *,
        amount: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            amount=amount,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class Layer(Component):
    control_type = "layer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        clip: bool | None = None,
        clip_shape: str | None = None,
        shape: str | None = None,
        clip_radius: float | None = None,
        border_radius: float | None = None,
        radius: float | None = None,
        opacity: float | None = None,
        ignore_pointer: bool | None = None,
        absorb_pointer: bool | None = None,
        visible: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            clip=clip,
            clip_shape=clip_shape,
            shape=shape,
            clip_radius=clip_radius,
            border_radius=border_radius,
            radius=radius,
            opacity=opacity,
            ignore_pointer=ignore_pointer,
            absorb_pointer=absorb_pointer,
            visible=visible,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class LayerList(Component):
    control_type = "layer_list"

    def __init__(
        self,
        *children: Any,
        layers: list[Mapping[str, Any]] | None = None,
        active_layer: str | None = None,
        active_id: str | None = None,
        max_visible_overlays: int | None = None,
        mode: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            layers=[dict(layer) for layer in (layers or [])],
            active_layer=active_layer if active_layer is not None else active_id,
            active_id=active_id if active_id is not None else active_layer,
            max_visible_overlays=max_visible_overlays,
            mode=mode,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_active(self, session: Any, layer_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_active", {"active_id": layer_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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
        intensity: float | None = None,
        direction: Any | None = None,
        animated: bool | None = None,
        duration_ms: int | None = None,
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
            intensity=intensity,
            direction=direction,
            animated=animated,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def trigger(self, session: Any, **payload: Any) -> dict[str, Any]:
        return self.invoke(session, "trigger", payload)


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
        noise_opacity: float | None = None,
        border_glow: Any | None = None,
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
            noise_opacity=noise_opacity,
            border_glow=border_glow,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class GradientSweep(Component):
    control_type = "gradient_sweep"

    def __init__(
        self,
        child: Any | None = None,
        *,
        colors: list[Any] | None = None,
        stops: list[float] | None = None,
        duration_ms: int | None = None,
        duration: int | None = None,
        angle: float | None = None,
        start_angle: float | None = None,
        end_angle: float | None = None,
        opacity: float | None = None,
        loop: bool | None = None,
        autoplay: bool | None = None,
        play: bool | None = None,
        playing: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            stops=stops,
            duration_ms=duration_ms,
            duration=duration,
            angle=angle,
            start_angle=start_angle,
            end_angle=end_angle,
            opacity=opacity,
            loop=loop,
            autoplay=autoplay,
            play=play,
            playing=playing,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_angle(self, session: Any, angle: float) -> dict[str, Any]:
        return self.invoke(session, "set_angle", {"angle": float(angle)})

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})

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
        duration: int | None = None,
        gravity: float | None = None,
        autoplay: bool | None = None,
        loop: bool | None = None,
        emit_on_complete: bool | None = None,
        hide_button: bool | None = None,
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
            duration=duration,
            gravity=gravity,
            autoplay=autoplay,
            loop=loop,
            emit_on_complete=emit_on_complete,
            hide_button=hide_button,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def burst(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "burst", {})


class RippleBurst(Component):
    control_type = "ripple_burst"

    def __init__(
        self,
        child: Any | None = None,
        *,
        color: Any | None = None,
        count: int | None = None,
        duration_ms: int | None = None,
        max_radius: float | None = None,
        center: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            count=count,
            duration_ms=duration_ms,
            max_radius=max_radius,
            center=center,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def burst(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "burst", {"payload": dict(payload or {})})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ChromaticShift(Component):
    control_type = "chromatic_shift"

    def __init__(
        self,
        child: Any | None = None,
        *,
        shift: float | None = None,
        opacity: float | None = None,
        axis: str | None = None,
        red: Any | None = None,
        blue: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            shift=shift,
            opacity=opacity,
            axis=axis,
            red=red,
            blue=blue,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_shift(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_shift", {"value": float(value)})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


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
        animated: bool | None = None,
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
            color=color,
            width=width,
            glow=glow,
            spread=spread,
            radius=radius,
            animated=animated,
            duration_ms=duration_ms,
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
        animated: bool | None = None,
        fps: int | None = None,
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
            animated=animated,
            fps=fps,
            **kwargs,
        )


class Shimmer(_EventfulEffect):
    control_type = "shimmer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        duration_ms: int | None = None,
        angle: float | None = None,
        opacity: float | None = None,
        base_color: Any | None = None,
        highlight_color: Any | None = None,
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
            duration_ms=duration_ms,
            angle=angle,
            opacity=opacity,
            base_color=base_color,
            highlight_color=highlight_color,
            **kwargs,
        )


class ShadowStack(_EventfulEffect):
    control_type = "shadow_stack"

    def __init__(
        self,
        child: Any | None = None,
        *,
        shadows: list[Mapping[str, Any]] | None = None,
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
            shadows=[dict(shadow) for shadow in (shadows or [])],
            radius=radius,
            **kwargs,
        )


class NoiseDisplacement(_EventfulEffect):
    control_type = "noise_displacement"

    def __init__(
        self,
        child: Any | None = None,
        *,
        strength: float | None = None,
        speed: float | None = None,
        axis: str | None = None,
        seed: int | None = None,
        animated: bool | None = None,
        loop: bool | None = None,
        play: bool | None = None,
        autoplay: bool | None = None,
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
            speed=speed,
            axis=axis,
            seed=seed,
            animated=animated,
            loop=loop,
            play=play,
            autoplay=autoplay,
            duration_ms=duration_ms,
            **kwargs,
        )

    def trigger(self, session: Any, strength: float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if strength is not None:
            payload["strength"] = float(strength)
        return self.invoke(session, "trigger", payload)

    def set_strength(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_strength", {"value": float(value)})

    def set_speed(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_speed", {"value": float(value)})


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
        kind: str | None = None,
        height: float | None = None,
        animated: bool | None = None,
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
            kind=kind,
            height=height,
            animated=animated,
            **kwargs,
        )


class FlowField(_EventfulEffect):
    control_type = "flow_field"

    def __init__(
        self,
        child: Any | None = None,
        *,
        seed: int | None = None,
        density: float | None = None,
        speed: float | None = None,
        line_width: float | None = None,
        color: Any | None = None,
        opacity: float | None = None,
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
            density=density,
            speed=speed,
            line_width=line_width,
            color=color,
            opacity=opacity,
            **kwargs,
        )


class Shadow(Component):
    control_type = "shadow"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        color: Any | None = None,
        blur: float | None = None,
        spread: float | None = None,
        offset_x: float | None = None,
        offset_y: float | None = None,
        radius: float | None = None,
        shadows: list[Mapping[str, Any]] | None = None,
        events: list[str] | None = None,
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
            offset_x=offset_x,
            offset_y=offset_y,
            radius=radius,
            shadows=[dict(shadow) for shadow in (shadows or [])],
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


class Effects(Component):
    control_type = "effects"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        blur: float | None = None,
        opacity: float | None = None,
        color: Any | None = None,
        blend_mode: str | None = None,
        brightness: float | None = None,
        contrast: float | None = None,
        saturation: float | None = None,
        hue_rotate: float | None = None,
        grayscale: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
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
            blend_mode=blend_mode,
            brightness=brightness,
            contrast=contrast,
            saturation=saturation,
            hue_rotate=hue_rotate,
            grayscale=grayscale,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


class Particles(Component):
    control_type = "particles"

    def __init__(
        self,
        *,
        count: int | None = None,
        colors: list[Any] | None = None,
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
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            count=count,
            colors=colors,
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
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Animation(Component):
    control_type = "animation"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        duration_ms: int | None = None,
        curve: str | None = None,
        opacity: float | None = None,
        scale: float | None = None,
        offset: Any | None = None,
        rotation: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            duration_ms=duration_ms,
            curve=curve,
            opacity=opacity,
            scale=scale,
            offset=offset,
            rotation=rotation,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


class Transition(Component):
    control_type = "transition"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        duration_ms: int | None = None,
        curve: str | None = None,
        transition_type: str | None = None,
        preset: str | None = None,
        state: str | None = None,
        mode: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            duration_ms=duration_ms,
            curve=curve,
            transition_type=transition_type if transition_type is not None else preset,
            preset=preset if preset is not None else transition_type,
            state=state,
            mode=mode,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)



