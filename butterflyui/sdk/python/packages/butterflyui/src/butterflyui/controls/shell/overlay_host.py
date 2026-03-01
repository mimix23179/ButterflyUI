from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["OverlayHost"]

class OverlayHost(Component):
    control_type = "overlay_host"

    def __init__(
        self,
        base: Any | None = None,
        *,
        overlays: list[Any] | None = None,
        active_overlay: str | list[str] | tuple[str, ...] | None = None,
        active_id: str | None = None,
        active_index: int | None = None,
        show_all_overlays: bool | None = None,
        show_default_overlay: bool | None = None,
        max_visible_overlays: int | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = None,
        transition_ms: int | None = None,
        clip: bool | None = None,
        children: Iterable[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            base=base,
            overlays=overlays,
            active_overlay=active_overlay,
            active_id=active_id,
            active_index=active_index,
            show_all_overlays=show_all_overlays,
            show_default_overlay=show_default_overlay,
            max_visible_overlays=max_visible_overlays,
            transition=transition,
            transition_type=transition_type,
            transition_ms=transition_ms,
            clip=clip,
            **kwargs,
        )
        super().__init__(children=children, props=merged, style=style, strict=strict)
