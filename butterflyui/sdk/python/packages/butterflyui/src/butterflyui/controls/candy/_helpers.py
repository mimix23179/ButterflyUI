from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any


def _coerce_mapping(value: Mapping[str, Any] | None) -> dict[str, Any] | None:
    if value is None:
        return None
    return dict(value)


def _merge_dicts(
    left: Mapping[str, Any] | None,
    right: Mapping[str, Any] | None,
) -> dict[str, Any]:
    merged: dict[str, Any] = {}
    if left:
        merged.update(dict(left))
    if right:
        merged.update(dict(right))
    return merged


def _snapshot_control_value(value: Any) -> Any:
    from ...core.control import coerce_json_value

    return coerce_json_value(value)


def _coerce_string_list(value: Any | None) -> list[str] | None:
    if value is None:
        return None
    if isinstance(value, str):
        return [value]
    if isinstance(value, Iterable) and not isinstance(value, (str, bytes, Mapping)):
        values = [str(item) for item in value if item is not None]
        return values or None
    return [str(value)]


def _normalize_candy_module(value: Any | None) -> str | None:
    if value is None:
        return None
    normalized = str(value).strip().lower().replace("-", "_").replace(" ", "_")
    aliases = {
        "candy": "container",
        "layout": "container",
        "layout_primitive": "container",
        "layout_primitives": "container",
        "layout_system": "container",
        "surface_primitives": "surface",
        "surface_system": "surface",
        "surfaces": "surface",
        "typography": "text",
        "typography_system": "text",
        "decoration_system": "decorated_box",
        "style": "decorated_box",
        "styling": "decorated_box",
        "decoration": "decorated_box",
        "decorated": "decorated_box",
        "decoratedbox": "decorated_box",
        "aspectratio": "aspect_ratio",
        "overflowbox": "overflow_box",
        "fittedbox": "fitted_box",
        "buttonstyle": "button_style",
        "particle": "particles",
        "enhance": "effects",
        "enhancer": "effects",
        "ambient": "effects",
        "reactive": "effects",
        "polish": "effects",
        "cinematic": "effects",
        "visual_modifiers": "effects",
        "effects_pipeline": "effects",
        "motion_system": "motion",
        "animation_system": "motion",
        "interaction": "pressable",
        "interaction_wrapper": "pressable",
        "interaction_wrappers": "pressable",
        "pressable_wrapper": "pressable",
        "gesture": "gesture_area",
        "gesture_wrapper": "gesture_area",
        "hover": "hover_region",
        "hover_wrapper": "hover_region",
        "split": "split_pane",
        "layers": "layer",
        "view": "viewport",
    }
    return aliases.get(normalized, normalized)


def _bridge_candy_module_props(
    module: str | None,
    raw_props: Mapping[str, Any],
) -> dict[str, Any]:
    bridged = dict(raw_props)
    if module:
        bridged["module"] = module
    if module == "page":
        bridged.setdefault("safe_area", True)
    if module == "surface" and bridged.get("bgcolor") is None and bridged.get("background") is not None:
        bridged["bgcolor"] = bridged.get("background")
    if module == "button" and bridged.get("text") is None and bridged.get("label") is not None:
        bridged["text"] = bridged.get("label")
    if module == "text":
        if bridged.get("text") is None and bridged.get("label") is not None:
            bridged["text"] = bridged.get("label")
        if bridged.get("text") is None and bridged.get("value") is not None:
            bridged["text"] = bridged.get("value")
    if module == "effects":
        bridged.setdefault("overlay", True)
    return bridged
