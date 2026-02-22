from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "AnimatedBackground",
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



