from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from .layout_control import LayoutControl


def _normalize_token(value: str) -> str:
    return value.strip().lower().replace("-", "_").replace(" ", "_")


def _canonical_control_type(value: str) -> str:
    return _normalize_token(value)


_INTERACTIVE_CONTROLS = {
    "candy",
    "skins",
    "style",
    "modifier",
    "button",
    "elevated_button",
    "filled_button",
    "outlined_button",
    "text_button",
    "checkbox",
    "switch",
    "slider",
    "text_field",
    "radio",
    "select",
    "combo_box",
    "date_picker",
    "chip",
    "file_picker",
    "directory_picker",
    "tabs",
    "menu_item",
    "list_tile",
    "item_tile",
    "pagination",
    "notification_center",
    "snack_bar",
    "drawer",
    "sidebar",
    "alert_dialog",
    "bubble",
    "display",
}

_GLASS_CONTROLS = {
    "candy",
    "style",
    "modifier",
    "card",
    "row",
    "column",
    "stack",
    "wrap",
    "scroll_view",
    "split_view",
    "split_pane",
    "pane",
    "grid_view",
    "virtual_grid",
    "list_view",
    "virtual_list",
    "table",
    "data_table",
    "data_grid",
    "table_view",
    "overlay",
    "alert_dialog",
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
    "style",
    "modifier",
    "overlay",
    "alert_dialog",
    "popover",
    "portal",
    "context_menu",
    "tooltip",
    "toast",
    "toast_host",
    "slide_panel",
}

_STYLE_CONTROLS = set(_INTERACTIVE_CONTROLS) | set(_GLASS_CONTROLS) | set(
    _TRANSITION_CONTROLS
) | {
    "text",
    "icon",
    "image",
    "video",
    "audio",
    "markdown_view",
    "html_view",
    "gallery",
    "gallery_scope",
    "candy_scope",
    "skins_scope",
    "bubble",
    "display",
    "route",
    "page_view",
}

_MOTION_CONTROLS = set(_STYLE_CONTROLS) - {
    "spacer",
    "flex_spacer",
    "expanded",
}
_EFFECT_CONTROLS = set(_STYLE_CONTROLS) - {
    "spacer",
    "flex_spacer",
    "expanded",
}

_SLOT_MANIFEST = {
    "*": [
        "root",
        "background",
        "border",
        "content",
        "label",
        "icon",
        "leading",
        "trailing",
        "overlay",
    ],
    "button": [
        "root",
        "background",
        "border",
        "content",
        "label",
        "icon",
        "leading",
        "trailing",
        "overlay",
    ],
    "bubble": [
        "root",
        "background",
        "border",
        "content",
        "label",
        "leading",
        "trailing",
        "overlay",
        "message",
        "thread",
        "composer",
        "attachment",
        "meta",
    ],
    "display": [
        "root",
        "background",
        "border",
        "content",
        "label",
        "leading",
        "trailing",
        "overlay",
        "identity",
        "status",
        "rating",
        "reactions",
        "check",
        "ownership",
    ],
    "gallery": [
        "root",
        "background",
        "border",
        "content",
        "overlay",
        "toolbar",
        "panel",
        "item_root",
        "item_media",
        "item_meta",
        "item_actions",
        "leading",
        "trailing",
        "label",
        "icon",
    ],
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

_MODIFIER_CAPABILITIES_MANIFEST_VERSION = 4


def modifier_capabilities_manifest() -> dict[str, Any]:
    return {
        "version": _MODIFIER_CAPABILITIES_MANIFEST_VERSION,
        "controls": {
            "interactive": sorted(_INTERACTIVE_CONTROLS),
            "glass": sorted(_GLASS_CONTROLS),
            "transition": sorted(_TRANSITION_CONTROLS),
            "style": sorted(_STYLE_CONTROLS),
            "motion": sorted(_MOTION_CONTROLS),
            "effects": sorted(_EFFECT_CONTROLS),
            "slots": {key: list(values) for key, values in _SLOT_MANIFEST.items()},
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


class Component(LayoutControl):
    """Base class for all Python-side ButterflyUI controls.
    
    Besides regular control props, ``Component`` also carries the universal
    styling pipeline contract used by Candy/Skins/Style/Modifier/Gallery:
    
    - style layer: ``variant``, ``tone``, ``size``, ``density``, ``classes``,
      ``style``, ``style_slots``.
    - modifier layer: ``modifiers``, ``on_hover_modifiers``,
      ``on_pressed_modifiers``, ``on_focus_modifiers``.
    - motion layer: ``motion``, ``enter_motion``, ``exit_motion``,
      ``hover_motion``, ``press_motion``.
    - effect layer: ``effects``, ``effect_order``, ``effect_clip``,
      ``effect_target``.
    
    Any non-``None`` keyword arguments are merged into the outgoing ``props``
    payload, which keeps Python wrappers and Dart runtime props loosely coupled.
    
    Args:
        child:
            Single convenience child appended to the control tree.
        variant:
            Variant token forwarded into the shared style pipeline.
        tone:
            Tone token forwarded into the shared style pipeline.
        size:
            Size token forwarded into the shared style pipeline.
        density:
            Density token forwarded into the shared style pipeline.
        classes:
            Class tokens used by recipes, packs, or runtime selectors.
        modifiers:
            Base modifier list applied to the control.
        on_hover_modifiers:
            Modifiers activated while the pointer hovers the control.
        on_pressed_modifiers:
            Modifiers activated while the control is pressed.
        on_focus_modifiers:
            Modifiers activated while the control is focused.
        motion:
            Base motion configuration for the control.
        enter_motion:
            Motion played when the control enters.
        exit_motion:
            Motion played when the control exits.
        hover_motion:
            Motion played while the pointer hovers the control, such as lift, opacity, or highlight feedback.
        press_motion:
            Motion played while the control is being pressed, such as scale, opacity, or elevation feedback.
        effects:
            Visual effects applied by the shared renderer pipeline.
        effect_order:
            Ordering hint controlling when effects are applied.
        effect_clip:
            Clip behavior or shape used when rendering effects.
        effect_target:
            Target surface for shared effects.
        style_slots:
            Slot-specific local style overrides.
        state:
            Active state token forwarded into styling and motion resolution.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
    """
    control_type: str = ""

    child: Any = None
    """
    Single convenience child appended to the control tree.
    """

    variant: Any = None
    """
    Variant token forwarded into the shared style pipeline.
    """

    tone: str | None = None
    """
    Tone token forwarded into the shared style pipeline.
    """

    size: str | None = None
    """
    Size token forwarded into the shared style pipeline.
    """

    density: str | None = None
    """
    Density token forwarded into the shared style pipeline.
    """

    classes: str | Iterable[str] | None = None
    """
    Class tokens used by recipes, packs, or runtime selectors.
    """

    modifiers: Iterable[Any] | None = None
    """
    Base modifier list applied to the control.
    """

    on_hover_modifiers: Iterable[Any] | None = None
    """
    Modifiers activated while the pointer hovers the control.
    """

    on_pressed_modifiers: Iterable[Any] | None = None
    """
    Modifiers activated while the control is pressed.
    """

    on_focus_modifiers: Iterable[Any] | None = None
    """
    Modifiers activated while the control is focused.
    """

    motion: Any | None = None
    """
    Base motion configuration for the control.
    """

    enter_motion: Any | None = None
    """
    Motion played when the control enters.
    """

    exit_motion: Any | None = None
    """
    Motion played when the control exits.
    """

    hover_motion: Any | None = None
    """
    Motion played while the pointer hovers the control, such as lift, opacity, or highlight feedback.
    """

    press_motion: Any | None = None
    """
    Motion played while the control is being pressed, such as scale, opacity, or elevation feedback.
    """

    effects: Any | None = None
    """
    Visual effects applied by the shared renderer pipeline.
    """

    effect_order: str | None = None
    """
    Ordering hint controlling when effects are applied.
    """

    effect_clip: Any | None = None
    """
    Clip behavior or shape used when rendering effects.
    """

    effect_target: str | None = None
    """
    Target surface for shared effects.
    """

    style_slots: Mapping[str, Any] | None = None
    """
    Slot-specific local style overrides.
    """

    state: str | None = None
    """
    Active state token forwarded into styling and motion resolution.
    """

    style: Mapping[str, Any] | None = None
    """
    Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
    """

    def __init__(
        self,
        *children_args: Any,
        child: Any | None = None,
        children: Iterable[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        variant: Any | None = None,
        tone: str | None = None,
        size: str | None = None,
        density: str | None = None,
        classes: str | Iterable[str] | None = None,
        modifiers: Iterable[Any] | None = None,
        on_hover_modifiers: Iterable[Any] | None = None,
        on_pressed_modifiers: Iterable[Any] | None = None,
        on_focus_modifiers: Iterable[Any] | None = None,
        motion: Any | None = None,
        enter_motion: Any | None = None,
        exit_motion: Any | None = None,
        hover_motion: Any | None = None,
        press_motion: Any | None = None,
        effects: Any | None = None,
        effect_order: str | None = None,
        effect_clip: Any | None = None,
        effect_target: str | None = None,
        style_slots: Mapping[str, Any] | None = None,
        state: str | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        inline_handlers: dict[str, Any] = {}
        for key in list(kwargs):
            value = kwargs.get(key)
            if not callable(value):
                continue
            if key.startswith("on_") and len(key) > 3:
                inline_handlers[key[3:]] = value
                kwargs.pop(key, None)
                continue
            if key == "action":
                inline_handlers["click"] = value
                kwargs.pop(key, None)

        control_props = merge_props(
            props,
            variant=variant,
            tone=tone,
            size=size,
            density=density,
            classes=classes,
            motion=motion,
            enter_motion=enter_motion,
            exit_motion=exit_motion,
            hover_motion=hover_motion,
            press_motion=press_motion,
            on_hover_modifiers=on_hover_modifiers,
            on_pressed_modifiers=on_pressed_modifiers,
            on_focus_modifiers=on_focus_modifiers,
            effects=effects,
            effect_order=effect_order,
            effect_clip=effect_clip,
            effect_target=effect_target,
            state=state,
            **kwargs,
        )
        control_props = _normalize_component_props(control_props)
        inferred_style_slots: Mapping[str, Any] | None = None
        if style_slots is None:
            candidate = control_props.pop("style_slots", None)
            if isinstance(candidate, Mapping):
                inferred_style_slots = candidate
        else:
            control_props.pop("style_slots", None)
        resolved_style_slots = style_slots or inferred_style_slots
        if modifiers is not None:
            control_props["modifiers"] = _sanitize_modifiers_for_control(
                self.control_type,
                list(modifiers),
            )
        local_style: dict[str, Any] = {}
        existing_style = control_props.get("style")
        if isinstance(existing_style, Mapping):
            local_style.update(dict(existing_style))

        style_map: dict[str, Any] | None = None
        if isinstance(style, Mapping):
            style_map = dict(style)
        elif style is not None and hasattr(style, "to_json"):
            try:
                payload = style.to_json()
                if isinstance(payload, Mapping):
                    style_map = dict(payload)
            except Exception:
                style_map = None
        if style_map:
            local_style.update(style_map)
        if resolved_style_slots is not None:
            slots = local_style.get("slots")
            slot_map = dict(slots) if isinstance(slots, Mapping) else {}
            slot_map.update(dict(resolved_style_slots))
            local_style["slots"] = slot_map
        if local_style:
            # Keep backward compatibility for `style=` while also exposing
            # the explicit local-style contract used by the style resolver.
            control_props["style"] = local_style

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
        for event, handler in inline_handlers.items():
            self.add_inline_event_handler(event, handler)


