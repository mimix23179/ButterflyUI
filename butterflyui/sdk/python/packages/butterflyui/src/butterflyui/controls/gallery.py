from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = ["Gallery"]


class Gallery(Component):
    control_type = "gallery"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        spacing: float | None = None,
        run_spacing: float | None = None,
        tile_width: float | None = None,
        tile_height: float | None = None,
        selectable: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        gallery_toolbar: Mapping[str, Any] | None = None,
        gallery_filter_bar: Mapping[str, Any] | None = None,
        gallery_grid_layout: Mapping[str, Any] | None = None,
        gallery_item_actions: Mapping[str, Any] | None = None,
        gallery_item_badge: Mapping[str, Any] | None = None,
        gallery_item_meta_row: Mapping[str, Any] | None = None,
        gallery_item_preview: Mapping[str, Any] | None = None,
        gallery_item_selectable: Mapping[str, Any] | None = None,
        gallery_item_tile: Mapping[str, Any] | None = None,
        gallery_pagination: Mapping[str, Any] | None = None,
        gallery_section_header: Mapping[str, Any] | None = None,
        gallery_sort_bar: Mapping[str, Any] | None = None,
        gallery_empty_state: Mapping[str, Any] | None = None,
        gallery_loading_skeleton: Mapping[str, Any] | None = None,
        gallery_search_bar: Mapping[str, Any] | None = None,
        gallery_font_picker: Mapping[str, Any] | None = None,
        gallery_audio_picker: Mapping[str, Any] | None = None,
        gallery_video_picker: Mapping[str, Any] | None = None,
        gallery_image_picker: Mapping[str, Any] | None = None,
        gallery_item_drag_handle: Mapping[str, Any] | None = None,
        gallery_item_drop_target: Mapping[str, Any] | None = None,
        gallery_item_reorder_handle: Mapping[str, Any] | None = None,
        gallery_item_selection_checkbox: Mapping[str, Any] | None = None,
        gallery_item_selection_radio: Mapping[str, Any] | None = None,
        gallery_item_selection_switch: Mapping[str, Any] | None = None,
        gallery_action: Mapping[str, Any] | None = None,
        gallery_apply: Mapping[str, Any] | None = None,
        gallery_clear: Mapping[str, Any] | None = None,
        gallery_select_all: Mapping[str, Any] | None = None,
        gallery_deselect_all: Mapping[str, Any] | None = None,
        gallery_apply_font: Mapping[str, Any] | None = None,
        gallery_apply_image: Mapping[str, Any] | None = None,
        gallery_set_as_wallpaper: Mapping[str, Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            spacing=spacing,
            run_spacing=run_spacing,
            tile_width=tile_width,
            tile_height=tile_height,
            selectable=selectable,
            enabled=enabled,
            events=events,
            gallery_toolbar=gallery_toolbar,
            gallery_filter_bar=gallery_filter_bar,
            gallery_grid_layout=gallery_grid_layout,
            gallery_item_actions=gallery_item_actions,
            gallery_item_badge=gallery_item_badge,
            gallery_item_meta_row=gallery_item_meta_row,
            gallery_item_preview=gallery_item_preview,
            gallery_item_selectable=gallery_item_selectable,
            gallery_item_tile=gallery_item_tile,
            gallery_pagination=gallery_pagination,
            gallery_section_header=gallery_section_header,
            gallery_sort_bar=gallery_sort_bar,
            gallery_empty_state=gallery_empty_state,
            gallery_loading_skeleton=gallery_loading_skeleton,
            gallery_search_bar=gallery_search_bar,
            gallery_font_picker=gallery_font_picker,
            gallery_audio_picker=gallery_audio_picker,
            gallery_video_picker=gallery_video_picker,
            gallery_image_picker=gallery_image_picker,
            gallery_item_drag_handle=gallery_item_drag_handle,
            gallery_item_drop_target=gallery_item_drop_target,
            gallery_item_reorder_handle=gallery_item_reorder_handle,
            gallery_item_selection_checkbox=gallery_item_selection_checkbox,
            gallery_item_selection_radio=gallery_item_selection_radio,
            gallery_item_selection_switch=gallery_item_selection_switch,
            gallery_action=gallery_action,
            gallery_apply=gallery_apply,
            gallery_clear=gallery_clear,
            gallery_select_all=gallery_select_all,
            gallery_deselect_all=gallery_deselect_all,
            gallery_apply_font=gallery_apply_font,
            gallery_apply_image=gallery_apply_image,
            gallery_set_as_wallpaper=gallery_set_as_wallpaper,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_items(self, session: Any, items: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": items})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {
                "event": event,
                "payload": dict(payload or {}),
            },
        )

    def trigger(self, session: Any, **payload: Any) -> dict[str, Any]:
        return self.invoke(session, "trigger", payload)

    def apply(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "apply", {})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def select_all(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "select_all", {})

    def deselect_all(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "deselect_all", {})

    def apply_font(self, session: Any, font: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if font is not None:
            payload["font"] = font
        return self.invoke(session, "apply_font", payload)

    def apply_image(self, session: Any, image: Any | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if image is not None:
            payload["image"] = image
        return self.invoke(session, "apply_image", payload)

    def set_as_wallpaper(self, session: Any, value: Any | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if value is not None:
            payload["value"] = value
        return self.invoke(session, "set_as_wallpaper", payload)
