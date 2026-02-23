from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from butterflyui.core.control import Component as CoreComponent


def _normalize_token(value: str) -> str:
    return value.strip().lower().replace("-", "_").replace(" ", "_")


def _canonical_control_type(value: str) -> str:
    normalized = _normalize_token(value)
    if normalized in {"container", "box"}:
        return "surface"
    return normalized


_INTERACTIVE_CONTROLS = {
    "candy",
    "skins",
    "button",
    "checkbox",
    "switch",
    "slider",
    "text_field",
    "rich_text_editor",
    "search_bar",
    "radio",
    "select",
    "multi_select",
    "combobox",
    "date_picker",
    "date_range_picker",
    "chip_group",
    "tag_filter_bar",
    "file_picker",
    "filepicker",
    "directory_picker",
    "tabs",
    "menu_item",
    "command_item",
    "list_tile",
    "item_tile",
    "paginator",
    "launcher",
    "notification_center",
    "code_editor",
    "terminal",
    "output_panel",
    "editor_tab_strip",
    "workspace_tree",
    "problems_panel",
    "editor_workspace",
}

_GLASS_CONTROLS = {
    "candy",
    "surface",
    "box",
    "container",
    "card",
    "row",
    "column",
    "stack",
    "wrap",
    "scroll_view",
    "split_view",
    "split_pane",
    "dock_layout",
    "pane",
    "inspector_panel",
    "page_scene",
    "grid_view",
    "virtual_grid",
    "list_view",
    "virtual_list",
    "table",
    "data_table",
    "data_grid",
    "table_view",
    "file_browser",
    "task_list",
    "overlay_host",
    "modal",
    "popover",
    "portal",
    "context_menu",
    "tooltip",
    "toast",
    "toast_host",
    "window_frame",
}

_TRANSITION_CONTROLS = {
    "candy",
    "overlay_host",
    "modal",
    "popover",
    "portal",
    "context_menu",
    "tooltip",
    "toast",
    "toast_host",
    "slide_panel",
    "page_scene",
}

_INTERACTIVE_MODIFIERS = {
    "hovereffectmodifier",
    "hovereffect",
    "hover_lift",
    "hoverlift",
    "presseffectmodifier",
    "presseffect",
    "press_scale",
    "pressscale",
    "focusringmodifier",
    "focusring",
    "focus_ring",
    "elevationmodifier",
    "elevation",
    "clickburstmodifier",
    "clickburst",
    "click_burst",
    "burstparticles",
    "soundmodifier",
    "sound",
    "soundonclick",
    "hapticsmodifier",
    "haptics",
}

_GLASS_MODIFIERS = {
    "glassmodifier",
    "glass",
    "glass_overlay",
    "glassoverlay",
}

_TRANSITION_MODIFIERS = {
    "transitionmodifier",
    "transition",
}

_MODIFIER_CAPABILITIES_MANIFEST_VERSION = 1


def modifier_capabilities_manifest() -> dict[str, Any]:
    return {
        "version": _MODIFIER_CAPABILITIES_MANIFEST_VERSION,
        "controls": {
            "interactive": sorted(_INTERACTIVE_CONTROLS),
            "glass": sorted(_GLASS_CONTROLS),
            "transition": sorted(_TRANSITION_CONTROLS),
        },
        "modifiers": {
            "interactive": sorted(_INTERACTIVE_MODIFIERS),
            "glass": sorted(_GLASS_MODIFIERS),
            "transition": sorted(_TRANSITION_MODIFIERS),
        },
    }


def _modifier_type(value: Any) -> str:
    if isinstance(value, str):
        return _normalize_token(value)
    if isinstance(value, Mapping):
        raw = value.get("type") or value.get("id") or value.get("name")
        if raw is None:
            return ""
        return _normalize_token(str(raw))
    return ""


def _sanitize_modifiers_for_control(control_type: str, modifiers: Any) -> list[Any]:
    if not isinstance(modifiers, Iterable) or isinstance(modifiers, (str, bytes, Mapping)):
        return []

    normalized_control = _canonical_control_type(control_type)
    allow_interactive = normalized_control in _INTERACTIVE_CONTROLS
    allow_glass = normalized_control in _GLASS_CONTROLS
    allow_transition = normalized_control in _TRANSITION_CONTROLS

    filtered: list[Any] = []
    for modifier in modifiers:
        kind = _modifier_type(modifier)
        if not kind:
            filtered.append(modifier)
            continue
        if kind in _INTERACTIVE_MODIFIERS and not allow_interactive:
            continue
        if kind in _GLASS_MODIFIERS and not allow_glass:
            continue
        if kind in _TRANSITION_MODIFIERS and not allow_transition:
            continue
        filtered.append(modifier)
    return filtered


def _normalize_component_props(props: Mapping[str, Any] | None) -> dict[str, Any]:
    return dict(props or {})


def merge_props(
    props: Mapping[str, Any] | None = None,
    **kwargs: Any,
) -> dict[str, Any]:
    out: dict[str, Any] = {}
    if isinstance(props, Mapping):
        out.update(dict(props))
    for key, value in kwargs.items():
        if value is not None:
            out[key] = value
    return out


def collect_children(
    positional: tuple[Any, ...],
    *,
    child: Any | None = None,
    children: Iterable[Any] | None = None,
) -> list[Any]:
    out = [item for item in positional if item is not None]
    if child is not None:
        out.append(child)
    if children is not None:
        out.extend(item for item in children if item is not None)
    return out


class Component(CoreComponent):
    control_type: str = ""

    def __init__(
        self,
        *children_args: Any,
        child: Any | None = None,
        children: Iterable[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        variant: Any | None = None,
        modifiers: Iterable[Any] | None = None,
        motion: Any | None = None,
        style_slots: Mapping[str, Any] | None = None,
        state: str | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        control_props = merge_props(
            props,
            variant=variant,
            motion=motion,
            state=state,
            **kwargs,
        )
        control_props = _normalize_component_props(control_props)
        if modifiers is not None:
            control_props["modifiers"] = _sanitize_modifiers_for_control(
                self.control_type,
                list(modifiers),
            )
        if style_slots is not None:
            style_map = dict(control_props.get("style", {}))
            style_map["slots"] = dict(style_slots)
            control_props["style"] = style_map
        if isinstance(style, Mapping) and "style" not in control_props:
            # Keep backward compatibility for `style=` while also exposing
            # the explicit local-style contract used by the new style resolver.
            control_props["style"] = dict(style)

        if "modifiers" in control_props:
            control_props["modifiers"] = _sanitize_modifiers_for_control(
                self.control_type,
                control_props.get("modifiers"),
            )
        control_children = collect_children(
            children_args,
            child=child,
            children=children,
        )
        super().__init__(
            control_type=self.control_type,
            props=control_props,
            children=control_children,
            style=style,
            strict=strict,
        )


