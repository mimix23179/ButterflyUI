from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["OverlayHost"]

class OverlayHost(Component):
    """
    Layer compositor that stacks overlay widgets on top of a base widget.

    The runtime renders ``base`` as the background layer and composites one
    or more overlay widgets from ``overlays`` above it. ``active_overlay``
    controls which overlay(s) are visible by ID or list of IDs.
    ``active_id`` and ``active_index`` are alternative selectors.
    ``show_all_overlays`` makes all overlays visible simultaneously.
    ``show_default_overlay`` shows the first overlay by default.
    ``max_visible_overlays`` caps concurrent overlay count.
    ``transition`` and ``transition_type`` animate overlay changes.
    ``transition_ms`` sets the transition duration. ``clip`` clips
    children to the host bounds.

    ```python
    import butterflyui as bui

    bui.OverlayHost(
        base=bui.Text("Main content"),
        overlays=[bui.Modal(open=True)],
        active_index=0,
        transition_type="fade",
        transition_ms=200,
    )
    ```

    Args:
        base:
            The base (background) widget rendered beneath all overlays.
        overlays:
            List of overlay widgets composited above the base.
        active_overlay:
            ID or list of IDs of overlays that should be visible.
        active_id:
            ID of the single active overlay.
        active_index:
            Zero-based index of the active overlay in ``overlays``.
        show_all_overlays:
            When ``True`` all overlays are rendered simultaneously.
        show_default_overlay:
            When ``True`` the first overlay is shown by default.
        max_visible_overlays:
            Maximum number of overlays visible at the same time.
        transition:
            Transition spec mapping applied when switching overlays.
        transition_type:
            Named transition animation type, e.g. ``"fade"``.
        transition_ms:
            Transition animation duration in milliseconds.
        clip:
            When ``True`` overlay children are clipped to the host bounds.
    """

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
