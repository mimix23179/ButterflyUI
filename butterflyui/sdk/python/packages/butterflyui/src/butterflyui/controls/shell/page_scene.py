from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PageScene"]

class PageScene(Component):
    control_type = "page_scene"

    def __init__(
        self,
        *,
        background_layer: Any | None = None,
        ambient_layer: Any | None = None,
        hero_layer: Any | None = None,
        content_layer: Any | None = None,
        overlay_layer: Any | None = None,
        pages: Iterable[Any] | None = None,
        active_page: str | int | None = None,
        transition: Mapping[str, Any] | None = None,
        children: Iterable[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            background_layer=background_layer,
            ambient_layer=ambient_layer,
            hero_layer=hero_layer,
            content_layer=content_layer,
            overlay_layer=overlay_layer,
            pages=list(pages) if pages is not None else None,
            active_page=active_page,
            transition=transition,
            **kwargs,
        )
        super().__init__(children=children, props=merged, style=style, strict=strict)
