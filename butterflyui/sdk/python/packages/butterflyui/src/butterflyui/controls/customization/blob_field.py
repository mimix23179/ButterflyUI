from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BlobField"]

class BlobField(Component):
    """
    Paints a field of random organic blobs on a ``CustomPaint`` canvas.

    Each blob is a filled circle with a Gaussian blur mask, producing soft,
    lava-lamp-like shapes. The seed and count control the deterministic
    layout; `progress` (``0.0``–``1.0``) controls how much of the field is
    drawn.

    ```python
    import butterflyui as bui

    bui.BlobField(
        count=16,
        seed=42,
        color="#8b5cf6",
        opacity=0.35,
    )
    ```

    Args:
        count: 
            Number of blobs to generate. Defaults to ``12``.
        seed: 
            Random seed controlling blob positions and sizes. Defaults to ``7``. Change it to produce a new random layout.
        color: 
            Primary colour for the blobs (hex string or colour object). Defaults to ``"#8b5cf6"`` (violet).
        colors: 
            Optional list of colours. When provided, each blob picks from this palette.
        background: 
            Colour painted behind the blob field.
        min_radius: 
            Minimum blob radius as a fraction of the canvas size. Defaults to ``0.05``.
        max_radius: 
            Maximum blob radius as a fraction of the canvas size. Defaults to ``0.2``.
        speed: 
            Animation speed multiplier for blob motion.
        opacity: 
            Overall opacity of the blobs, ``0.0``–``1.0``. Defaults to ``0.3``.
        blur_sigma: 
            Gaussian blur sigma applied to each blob’s mask filter. Higher values produce softer edges.
        loop: 
            If ``True``, the animation loops continuously.
        play: 
            Alias for `playing`.
        playing: 
            Controls whether any animation is running.
        autoplay: 
            If ``True``, the animation starts automatically on mount.
        progress: 
            Draw progress from ``0.0`` (nothing) to ``1.0`` (full field). Defaults to ``1.0``.
    """
    control_type = "blob_field"

    def __init__(
        self,
        *,
        count: int | None = None,
        seed: int | None = None,
        color: Any | None = None,
        colors: list[Any] | None = None,
        background: Any | None = None,
        min_radius: float | None = None,
        max_radius: float | None = None,
        speed: float | None = None,
        opacity: float | None = None,
        blur_sigma: float | None = None,
        loop: bool | None = None,
        play: bool | None = None,
        playing: bool | None = None,
        autoplay: bool | None = None,
        progress: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            count=count,
            seed=seed,
            color=color,
            colors=colors,
            background=background,
            min_radius=min_radius,
            max_radius=max_radius,
            speed=speed,
            opacity=opacity,
            blur_sigma=blur_sigma,
            loop=loop,
            play=play,
            playing=playing,
            autoplay=autoplay,
            progress=progress,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def regenerate(self, session: Any, seed: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if seed is not None:
            payload["seed"] = seed
        return self.invoke(session, "regenerate", payload)

    def set_seed(self, session: Any, seed: int) -> dict[str, Any]:
        return self.invoke(session, "set_seed", {"seed": int(seed)})

    def set_progress(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"value": float(value)})

    def set_playing(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_playing", {"value": bool(value)})
