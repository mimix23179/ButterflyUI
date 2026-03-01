from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PageScene"]

class PageScene(Component):
    """
    Multi-layer page compositor with background, content, and overlay planes.

    The runtime stacks named layers to compose a rich page layout.
    ``background_layer`` renders behind all content. ``ambient_layer`` sits
    above the background for effects. ``hero_layer`` hosts shared-element
    transition widgets. ``content_layer`` is the primary content surface.
    ``overlay_layer`` renders above everything. ``pages`` provides an ordered
    list of page widgets; ``active_page`` selects the visible page by ID or
    index. ``transition`` animates page changes.

    ```python
    import butterflyui as bui

    bui.PageScene(
        content_layer=bui.Text("Main content"),
        pages=[bui.Text("Page 1"), bui.Text("Page 2")],
        active_page=0,
        transition={"type": "slide"},
    )
    ```

    Args:
        background_layer:
            Widget rendered at the back of the scene stack.
        ambient_layer:
            Widget rendered above the background for ambient visual effects.
        hero_layer:
            Widget hosting shared-element hero transition targets.
        content_layer:
            Primary content widget rendered in the main layer.
        overlay_layer:
            Widget rendered at the very top of the scene stack.
        pages:
            Ordered list of page widgets managed by the scene.
        active_page:
            ID string or zero-based integer index of the active page.
        transition:
            Transition spec mapping applied when switching pages.
    """

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
