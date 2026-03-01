from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AnimationAsset"]

class AnimationAsset(Component):
    control_type = "animation_asset"

    def __init__(
        self,
        *,
        src: str | None = None,
        kind: str | None = None,
        engine: str | None = None,
        frames: list[str] | None = None,
        autoplay: bool | None = None,
        loop: bool | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            kind=kind,
            engine=engine,
            frames=frames,
            autoplay=autoplay,
            loop=loop,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
