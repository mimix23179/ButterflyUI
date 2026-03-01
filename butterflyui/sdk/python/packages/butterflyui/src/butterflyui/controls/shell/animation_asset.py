from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AnimationAsset"]

class AnimationAsset(Component):
    """
    Declarative animation asset that plays a Lottie, Rive, or frame-sequence animation.

    The runtime loads an animation from ``src`` and plays it according to
    the configured parameters. ``kind`` selects the animation engine
    (e.g. ``"lottie"``, ``"rive"``, ``"sprite"``). ``engine`` overrides
    the rendering engine. ``frames`` provides an explicit ordered list of
    image asset paths for frame-sequence animations. ``autoplay`` starts
    the animation immediately on mount. ``loop`` repeats indefinitely.
    ``duration_ms`` overrides the native animation duration.

    ```python
    import butterflyui as bui

    bui.AnimationAsset(
        src="assets/loading.json",
        kind="lottie",
        autoplay=True,
        loop=True,
    )
    ```

    Args:
        src:
            Asset path or URL of the animation file.
        kind:
            Animation type. Values: ``"lottie"``, ``"rive"``, ``"sprite"``.
        engine:
            Explicit rendering engine identifier override.
        frames:
            Ordered list of image asset paths for frame-sequence animations.
        autoplay:
            When ``True`` the animation starts playing immediately on mount.
        loop:
            When ``True`` the animation repeats indefinitely.
        duration_ms:
            Total animation duration in milliseconds, overriding the asset
            default.
    """

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
