from __future__ import annotations

import re
from collections.abc import Mapping
from typing import Any

__all__ = [
    "ValidationError",
    "ButterflyUIContractError",
    "CONTROL_SCHEMAS",
    "FRAME_CHILD_SCHEMA",
    "validate_props",
    "validate_frame_child",
    "ensure_valid_props",
    "ensure_valid_frame_child",
    "normalize_alignment",
    "normalize_color_matrix",
    "normalize_dimension",
    "normalize_frame",
    "normalize_offset",
    "normalize_padding",
    "normalize_scale",
    "normalize_skew",
    "normalize_frame",
]

_DIMENSION_RE = re.compile(r"^[+-]?(?:\d+(?:\.\d+)?|\.\d+)(?:%|px|vw|vh|vmin|vmax)?$")


class ValidationError(ValueError):
    def __init__(self, errors: list[str]) -> None:
        super().__init__("\n".join(errors))
        self.errors = errors


class ButterflyUIContractError(ValidationError):
    pass


def normalize_dimension(value: Any | None) -> Any | None:
    if value is None:
        return None
    if _is_number(value):
        return float(value)
    if isinstance(value, str):
        raw = value.strip()
        if not raw:
            raise ValueError("dimension cannot be empty")
        if not _DIMENSION_RE.match(raw):
            raise ValueError(f"invalid dimension: {value!r}")
        if raw.endswith("%") or raw.endswith("px") or raw.endswith("vw") or raw.endswith("vh") or raw.endswith("vmin") or raw.endswith("vmax"):
            return raw
        try:
            return float(raw)
        except ValueError as exc:
            raise ValueError(f"invalid dimension: {value!r}") from exc
    raise TypeError(f"invalid dimension type: {type(value).__name__}")


def normalize_offset(value: Any | None) -> Any | None:
    if value is None:
        return None
    if isinstance(value, (list, tuple)):
        if len(value) < 2:
            raise ValueError("offset must have at least 2 values")
        return [float(value[0]), float(value[1])]
    if isinstance(value, Mapping):
        data: dict[str, Any] = {}
        if "x" in value:
            data["x"] = float(value["x"])
        if "y" in value:
            data["y"] = float(value["y"])
        if not data:
            raise ValueError("offset must include x or y")
        return data
    raise TypeError(f"invalid offset type: {type(value).__name__}")


def normalize_alignment(value: Any | None) -> Any | None:
    if value is None:
        return None
    if isinstance(value, str):
        return value
    return normalize_offset(value)


def normalize_padding(value: Any | None) -> Any | None:
    if value is None:
        return None
    if _is_number(value):
        return float(value)
    if isinstance(value, (list, tuple)):
        if len(value) not in (1, 2, 4):
            raise ValueError("padding must have 1, 2, or 4 values")
        return [float(v) for v in value]
    if isinstance(value, Mapping):
        data: dict[str, Any] = {}
        for key in ("left", "top", "right", "bottom"):
            if key in value:
                data[key] = float(value[key])
        if not data:
            raise ValueError("padding must include at least one edge")
        return data
    raise TypeError(f"invalid padding type: {type(value).__name__}")


def normalize_scale(value: Any | None) -> Any | None:
    if value is None:
        return None
    if _is_number(value):
        return float(value)
    if isinstance(value, (list, tuple)):
        return [float(v) for v in value]
    if isinstance(value, Mapping):
        data = dict(value)
        for key in ("x", "y", "scale_x", "scale_y"):
            if key in data:
                data[key] = float(data[key])
        return data
    raise TypeError(f"invalid scale type: {type(value).__name__}")


def normalize_skew(value: Any | None) -> Any | None:
    if value is None:
        return None
    if _is_number(value):
        return float(value)
    if isinstance(value, (list, tuple)):
        return [float(v) for v in value]
    if isinstance(value, Mapping):
        data = dict(value)
        for key in ("x", "y", "skew_x", "skew_y"):
            if key in data:
                data[key] = float(data[key])
        return data
    raise TypeError(f"invalid skew type: {type(value).__name__}")


def normalize_color_matrix(value: Any | None) -> Any | None:
    if value is None:
        return None
    if isinstance(value, str):
        return value
    if isinstance(value, (list, tuple)):
        if len(value) != 20:
            raise ValueError("color_matrix must have 20 values")
        return [float(v) for v in value]
    raise TypeError(f"invalid color_matrix type: {type(value).__name__}")


def normalize_frame(value: Mapping[str, Any] | None, *, strict: bool = False) -> dict[str, Any]:
    if value is None:
        return {}
    frame: dict[str, Any] = {}
    unknown: list[str] = []
    for key, val in value.items():
        if val is None:
            continue
        if key in ("left", "top", "right", "bottom", "width", "height", "x", "y"):
            frame[key] = normalize_dimension(val)
        elif key in ("anchor", "alignment"):
            frame[key] = normalize_alignment(val)
        elif key in ("z", "z_index"):
            frame[key] = float(val)
        else:
            unknown.append(key)
    if strict and unknown:
        raise ValueError(f"unknown frame keys: {', '.join(unknown)}")
    return frame


def validate_props(control_type: str, props: Mapping[str, Any], *, strict: bool = False) -> list[str]:
    schema = CONTROL_SCHEMAS.get(control_type)
    if schema is None:
        return []
    return _validate_schema(props, schema, path=control_type, strict=strict)


def ensure_valid_props(control_type: str, props: Mapping[str, Any], *, strict: bool = False) -> None:
    errors = validate_props(control_type, props, strict=strict)
    if errors:
        raise ButterflyUIContractError(errors)


def validate_frame_child(frame: Mapping[str, Any], *, strict: bool = False) -> list[str]:
    return _validate_schema(frame, FRAME_CHILD_SCHEMA, path="frame", strict=strict)


def ensure_valid_frame_child(frame: Mapping[str, Any], *, strict: bool = False) -> None:
    errors = validate_frame_child(frame, strict=strict)
    if errors:
        raise ButterflyUIContractError(errors)


def _validate_schema(value: Any, schema: Mapping[str, Any], *, path: str, strict: bool) -> list[str]:
    if value is None:
        return []
    if "anyOf" in schema:
        for option in schema["anyOf"]:
            if not _validate_schema(value, option, path=path, strict=strict):
                return []
        return [f"{path} does not match any allowed schema"]
    if "oneOf" in schema:
        matches = 0
        for option in schema["oneOf"]:
            if not _validate_schema(value, option, path=path, strict=strict):
                matches += 1
        if matches == 1:
            return []
        return [f"{path} does not match exactly one schema"]

    expected_types = schema.get("type")
    if expected_types is not None:
        if not _matches_type(value, expected_types):
            return [f"{path} expected {expected_types}"]

    if "enum" in schema:
        if value not in schema["enum"]:
            return [f"{path} must be one of {schema['enum']}"]

    errors: list[str] = []
    if schema.get("type") == "object" or (isinstance(expected_types, list) and "object" in expected_types):
        if not isinstance(value, Mapping):
            return [f"{path} must be an object"]
        props_schema = schema.get("properties", {})
        required = schema.get("required", [])
        for key in required:
            if key not in value:
                errors.append(f"{path}.{key} is required")
        for key, child_value in value.items():
            child_schema = props_schema.get(key)
            if child_schema is not None:
                errors.extend(_validate_schema(child_value, child_schema, path=f"{path}.{key}", strict=strict))
            elif strict and schema.get("additionalProperties") is False:
                errors.append(f"{path}.{key} is not allowed")
        return errors

    if schema.get("type") == "array" or (isinstance(expected_types, list) and "array" in expected_types):
        if not isinstance(value, (list, tuple)):
            return [f"{path} must be an array"]
        min_items = schema.get("minItems")
        if min_items is not None and len(value) < min_items:
            errors.append(f"{path} must have at least {min_items} items")
        max_items = schema.get("maxItems")
        if max_items is not None and len(value) > max_items:
            errors.append(f"{path} must have at most {max_items} items")
        items_schema = schema.get("items")
        if items_schema is not None:
            for index, item in enumerate(value):
                errors.extend(_validate_schema(item, items_schema, path=f"{path}[{index}]", strict=strict))
        return errors

    if _is_number(value):
        minimum = schema.get("minimum")
        if minimum is not None and value < minimum:
            errors.append(f"{path} must be >= {minimum}")
        maximum = schema.get("maximum")
        if maximum is not None and value > maximum:
            errors.append(f"{path} must be <= {maximum}")
        return errors

    if isinstance(value, str):
        pattern = schema.get("pattern")
        if pattern and not re.match(pattern, value):
            errors.append(f"{path} does not match pattern {pattern!r}")
        return errors

    return errors


def _matches_type(value: Any, expected: Any) -> bool:
    if isinstance(expected, list):
        return any(_matches_type(value, item) for item in expected)
    if expected == "null":
        return value is None
    if expected == "boolean":
        return isinstance(value, bool)
    if expected == "integer":
        return isinstance(value, int) and not isinstance(value, bool)
    if expected == "number":
        return _is_number(value)
    if expected == "string":
        return isinstance(value, str)
    if expected == "array":
        return isinstance(value, (list, tuple))
    if expected == "object":
        return isinstance(value, Mapping)
    return False


def _is_number(value: Any) -> bool:
    return isinstance(value, (int, float)) and not isinstance(value, bool)


NUMBER_SCHEMA = {"type": "number"}
INTEGER_SCHEMA = {"type": "integer"}
BOOL_SCHEMA = {"type": "boolean"}
STRING_SCHEMA = {"type": "string"}

COLOR_SCHEMA = {
    "anyOf": [
        NUMBER_SCHEMA,
        STRING_SCHEMA,
        {
            "type": "object",
            "properties": {
                "r": NUMBER_SCHEMA,
                "g": NUMBER_SCHEMA,
                "b": NUMBER_SCHEMA,
                "a": NUMBER_SCHEMA,
                "red": NUMBER_SCHEMA,
                "green": NUMBER_SCHEMA,
                "blue": NUMBER_SCHEMA,
                "alpha": NUMBER_SCHEMA,
            },
            "additionalProperties": True,
        },
    ]
}

DIMENSION_SCHEMA = {
    "anyOf": [
        NUMBER_SCHEMA,
        {"type": "string", "pattern": _DIMENSION_RE.pattern},
    ]
}

OFFSET_SCHEMA = {
    "anyOf": [
        {"type": "array", "items": NUMBER_SCHEMA, "minItems": 2},
        {"type": "object", "properties": {"x": NUMBER_SCHEMA, "y": NUMBER_SCHEMA}},
    ]
}

RECT_SCHEMA = {
    "anyOf": [
        {"type": "array", "items": NUMBER_SCHEMA, "minItems": 4},
        {
            "type": "object",
            "properties": {
                "x": NUMBER_SCHEMA,
                "y": NUMBER_SCHEMA,
                "left": NUMBER_SCHEMA,
                "top": NUMBER_SCHEMA,
                "width": NUMBER_SCHEMA,
                "height": NUMBER_SCHEMA,
            },
        },
    ]
}

ALIGNMENT_SCHEMA = {
    "anyOf": [
        STRING_SCHEMA,
        OFFSET_SCHEMA,
    ]
}

PADDING_SCHEMA = {
    "anyOf": [
        NUMBER_SCHEMA,
        {"type": "array", "items": NUMBER_SCHEMA, "minItems": 1},
        {
            "type": "object",
            "properties": {
                "left": NUMBER_SCHEMA,
                "top": NUMBER_SCHEMA,
                "right": NUMBER_SCHEMA,
                "bottom": NUMBER_SCHEMA,
            },
        },
    ]
}

SCALE_SCHEMA = {
    "anyOf": [
        NUMBER_SCHEMA,
        {"type": "array", "items": NUMBER_SCHEMA, "minItems": 1},
        {"type": "object"},
    ]
}

SKEW_SCHEMA = SCALE_SCHEMA

ANY_SCHEMA: dict[str, Any] = {}


def _merge_universal(schema: Mapping[str, Any]) -> dict[str, Any]:
    """Merge universal ButterflyUI contracts into a control schema.

    This keeps the framework consistent: every control can participate in the
    same event subscription mechanism and can accept the same style/a11y/focus
    props, even if some controls choose not to use them.
    """

    base = dict(schema) if isinstance(schema, Mapping) else {}
    props = dict(base.get("properties", {})) if isinstance(base.get("properties"), Mapping) else {}

    # Event subscription list: runtime installs listeners only for listed events.
    props.setdefault(
        "events",
        {
            "type": "array",
            "items": {"type": "string"},
        },
    )

    # Common style / visibility / cursor / tooltip.
    props.setdefault("bgcolor", ANY_SCHEMA)
    props.setdefault("background", ANY_SCHEMA)
    props.setdefault("color", ANY_SCHEMA)
    props.setdefault("text_color", ANY_SCHEMA)
    props.setdefault("border_color", ANY_SCHEMA)
    props.setdefault("border_width", NUMBER_SCHEMA)
    props.setdefault("radius", NUMBER_SCHEMA)
    props.setdefault("border_radius", NUMBER_SCHEMA)
    props.setdefault("elevation", NUMBER_SCHEMA)
    props.setdefault("opacity", NUMBER_SCHEMA)
    props.setdefault("visible", BOOL_SCHEMA)
    props.setdefault("enabled", BOOL_SCHEMA)
    props.setdefault("disabled", BOOL_SCHEMA)
    props.setdefault("cursor", STRING_SCHEMA)
    props.setdefault("tooltip", ANY_SCHEMA)
    props.setdefault("style_pack", STRING_SCHEMA)
    props.setdefault("style", {"type": "object", "additionalProperties": True})
    props.setdefault(
        "variant",
        {
            "anyOf": [
                STRING_SCHEMA,
                {"type": "object", "additionalProperties": True},
            ]
        },
    )
    props.setdefault("modifiers", {"type": "array", "items": ANY_SCHEMA})
    props.setdefault("motion", ANY_SCHEMA)
    props.setdefault("slots", {"type": "object", "additionalProperties": True})
    props.setdefault("state", STRING_SCHEMA)

    # Accessibility semantics.
    props.setdefault("semantic_label", STRING_SCHEMA)
    props.setdefault("role", STRING_SCHEMA)
    props.setdefault("hint", STRING_SCHEMA)

    # Focus + keyboard navigation.
    props.setdefault("focusable", BOOL_SCHEMA)
    props.setdefault("autofocus", BOOL_SCHEMA)
    props.setdefault("tab_index", INTEGER_SCHEMA)

    # Input-like binding fields.
    props.setdefault("value", ANY_SCHEMA)
    props.setdefault("default_value", ANY_SCHEMA)
    props.setdefault("emit_on_change", BOOL_SCHEMA)
    props.setdefault("debounce_ms", INTEGER_SCHEMA)
    props.setdefault("dirty", BOOL_SCHEMA)
    props.setdefault("touched", BOOL_SCHEMA)
    props.setdefault("error_text", STRING_SCHEMA)
    props.setdefault("warnings", {"type": "array", "items": ANY_SCHEMA})
    props.setdefault("status", STRING_SCHEMA)

    base["properties"] = props
    return base

AXIS_SCHEMA = {"type": "string", "enum": ["horizontal", "vertical", "x", "y"]}
CURVE_SCHEMA = STRING_SCHEMA
BLEND_MODE_SCHEMA = STRING_SCHEMA

LAYOUT_PROPS_SCHEMA = {
    "expand": BOOL_SCHEMA,
    "flex": INTEGER_SCHEMA,
    "width": DIMENSION_SCHEMA,
    "height": DIMENSION_SCHEMA,
    "min_width": DIMENSION_SCHEMA,
    "min_height": DIMENSION_SCHEMA,
    "max_width": DIMENSION_SCHEMA,
    "max_height": DIMENSION_SCHEMA,
    "padding": PADDING_SCHEMA,
    "margin": PADDING_SCHEMA,
    "alignment": ALIGNMENT_SCHEMA,
    "animation": {"type": "object", "additionalProperties": True},
}


def _control_schema(props: Mapping[str, Any] | None = None, *, additional: bool = True) -> dict[str, Any]:
    merged = dict(LAYOUT_PROPS_SCHEMA)
    if props:
        merged.update(props)
    return {"type": "object", "properties": merged, "additionalProperties": additional}


CONTAINER_SCHEMA = _control_schema(
    {
        "child": ANY_SCHEMA,
        "children": {"type": "array", "items": ANY_SCHEMA},
        "content_alignment": ALIGNMENT_SCHEMA,
        "content_padding": PADDING_SCHEMA,
        "content_gap": NUMBER_SCHEMA,
        "content_layout": STRING_SCHEMA,
        "content_scroll": AXIS_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "color": COLOR_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "shape": STRING_SCHEMA,
        "shadow": ANY_SCHEMA,
        "gradient": ANY_SCHEMA,
        "image": ANY_SCHEMA,
        "opacity": NUMBER_SCHEMA,
        "blur": NUMBER_SCHEMA,
        "clip_behavior": STRING_SCHEMA,
    }
)

COLOR_MATRIX_SCHEMA = {
    "anyOf": [
        {"type": "array", "items": NUMBER_SCHEMA, "minItems": 20, "maxItems": 20},
        STRING_SCHEMA,
    ]
}

MOTION_VALUE_SCHEMA = {
    "type": "object",
    "properties": {
        "opacity": NUMBER_SCHEMA,
        "alpha": NUMBER_SCHEMA,
        "translate": OFFSET_SCHEMA,
        "offset": OFFSET_SCHEMA,
        "position": OFFSET_SCHEMA,
        "x": NUMBER_SCHEMA,
        "y": NUMBER_SCHEMA,
        "translate_x": NUMBER_SCHEMA,
        "translate_y": NUMBER_SCHEMA,
        "scale": SCALE_SCHEMA,
        "scale_x": NUMBER_SCHEMA,
        "scale_y": NUMBER_SCHEMA,
        "rotation": NUMBER_SCHEMA,
        "rotate": NUMBER_SCHEMA,
        "angle": NUMBER_SCHEMA,
        "rotation_radians": NUMBER_SCHEMA,
        "rotate_radians": NUMBER_SCHEMA,
        "angle_radians": NUMBER_SCHEMA,
    },
    "additionalProperties": True,
}

KEYFRAME_SCHEMA = {
    "type": "object",
    "properties": {
        "t": NUMBER_SCHEMA,
        "time": NUMBER_SCHEMA,
        "at": NUMBER_SCHEMA,
        "progress": NUMBER_SCHEMA,
        "props": MOTION_VALUE_SCHEMA,
    },
    "additionalProperties": True,
}

FRAME_CHILD_SCHEMA = {
    "type": "object",
    "properties": {
        "left": DIMENSION_SCHEMA,
        "top": DIMENSION_SCHEMA,
        "right": DIMENSION_SCHEMA,
        "bottom": DIMENSION_SCHEMA,
        "width": DIMENSION_SCHEMA,
        "height": DIMENSION_SCHEMA,
        "x": DIMENSION_SCHEMA,
        "y": DIMENSION_SCHEMA,
        "anchor": ALIGNMENT_SCHEMA,
        "alignment": ALIGNMENT_SCHEMA,
        "z": NUMBER_SCHEMA,
        "z_index": NUMBER_SCHEMA,
    },
    "additionalProperties": True,
}

FRAME_SCHEMA = {
    "type": "object",
    "properties": {
        "alignment": ALIGNMENT_SCHEMA,
        "fit": {"type": "string", "enum": ["expand", "passthrough", "loose"]},
        "clip": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

SAFE_AREA_SCHEMA = {
    "type": "object",
    "properties": {
        "left": BOOL_SCHEMA,
        "top": BOOL_SCHEMA,
        "right": BOOL_SCHEMA,
        "bottom": BOOL_SCHEMA,
        "minimum": PADDING_SCHEMA,
        "maintain_bottom_view_padding": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

POSE_SCHEMA = {
    "type": "object",
    "properties": {
        "translate": OFFSET_SCHEMA,
        "translate_x": NUMBER_SCHEMA,
        "translate_y": NUMBER_SCHEMA,
        "scale": SCALE_SCHEMA,
        "scale_x": NUMBER_SCHEMA,
        "scale_y": NUMBER_SCHEMA,
        "rotation": NUMBER_SCHEMA,
        "rotation_radians": NUMBER_SCHEMA,
        "skew": SKEW_SCHEMA,
        "skew_x": NUMBER_SCHEMA,
        "skew_y": NUMBER_SCHEMA,
        "skew_radians": SKEW_SCHEMA,
        "skew_x_radians": NUMBER_SCHEMA,
        "skew_y_radians": NUMBER_SCHEMA,
        "alignment": ALIGNMENT_SCHEMA,
        "origin": OFFSET_SCHEMA,
        "pivot": OFFSET_SCHEMA,
    },
    "additionalProperties": True,
}

LAYER_SCHEMA = {
    "type": "object",
    "properties": {
        "clip": BOOL_SCHEMA,
        "clip_shape": STRING_SCHEMA,
        "shape": STRING_SCHEMA,
        "clip_radius": NUMBER_SCHEMA,
        "border_radius": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "ignore_pointer": BOOL_SCHEMA,
        "absorb_pointer": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

LAYER_ITEM_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "visible": BOOL_SCHEMA,
        "locked": BOOL_SCHEMA,
        "thumbnail": STRING_SCHEMA,
    },
    "additionalProperties": True,
}

LAYER_LIST_SCHEMA = _control_schema(
    {
        "layers": {"type": "array", "items": LAYER_ITEM_SCHEMA},
        "selected_id": STRING_SCHEMA,
        "allow_reorder": BOOL_SCHEMA,
        "show_visibility": BOOL_SCHEMA,
        "show_lock": BOOL_SCHEMA,
        "show_thumbnail": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

BOUNDS_PROBE_SCHEMA = {
    "type": "object",
    "properties": {
        "emit_on_mount": BOOL_SCHEMA,
        "throttle_ms": INTEGER_SCHEMA,
    },
    "additionalProperties": True,
}

CANDY_MODULE_ENUM = [
    "button",
    "card",
    "column",
    "container",
    "row",
    "stack",
    "surface",
    "wrap",
    "align",
    "center",
    "spacer",
    "aspect_ratio",
    "overflow_box",
    "fitted_box",
    "effects",
    "particles",
    "border",
    "shadow",
    "outline",
    "gradient",
    "animation",
    "transition",
    "canvas",
    "clip",
    "decorated_box",
    "badge",
    "avatar",
    "icon",
    "text",
    "motion",
]

CANDY_STATE_ENUM = ["idle", "hover", "pressed", "focused", "disabled", "selected", "loading"]

CANDY_EVENT_ENUM = [
    "change",
    "state_change",
    "module_change",
    "click",
    "tap",
    "double_tap",
    "long_press",
    "hover_enter",
    "hover_exit",
    "hover_move",
    "focus",
    "blur",
    "focus_change",
    "animation_start",
    "animation_end",
    "transition_start",
    "transition_end",
    "gesture_pan_start",
    "gesture_pan_update",
    "gesture_pan_end",
    "gesture_scale_start",
    "gesture_scale_update",
    "gesture_scale_end",
]

CANDY_SLOTS_SCHEMA = {
    "type": "object",
    "properties": {
        "leading": ANY_SCHEMA,
        "trailing": ANY_SCHEMA,
        "overlay": ANY_SCHEMA,
        "background": ANY_SCHEMA,
        "content": ANY_SCHEMA,
    },
    "additionalProperties": False,
}

CANDY_SEMANTICS_SCHEMA = {
    "type": "object",
    "properties": {
        "label": STRING_SCHEMA,
        "hint": STRING_SCHEMA,
        "value": STRING_SCHEMA,
        "button": BOOL_SCHEMA,
        "focusable": BOOL_SCHEMA,
        "live_region": BOOL_SCHEMA,
    },
    "additionalProperties": False,
}

CANDY_ACCESSIBILITY_SCHEMA = {
    "type": "object",
    "properties": {
        "label": STRING_SCHEMA,
        "hint": STRING_SCHEMA,
        "value": STRING_SCHEMA,
        "button": BOOL_SCHEMA,
        "focusable": BOOL_SCHEMA,
        "live_region": BOOL_SCHEMA,
    },
    "additionalProperties": False,
}

CANDY_PERFORMANCE_SCHEMA = {
    "type": "object",
    "properties": {
        "cache": BOOL_SCHEMA,
        "repaint_boundary": BOOL_SCHEMA,
        "revision": ANY_SCHEMA,
    },
    "additionalProperties": False,
}


def _candy_module_schema(extra_properties: Mapping[str, Any]) -> dict[str, Any]:
    payload_schema = {
        "type": "object",
        "properties": {
            "enabled": BOOL_SCHEMA,
            "variant": STRING_SCHEMA,
            "state": {"type": "string", "enum": CANDY_STATE_ENUM},
            "slots": CANDY_SLOTS_SCHEMA,
            "leading": ANY_SCHEMA,
            "trailing": ANY_SCHEMA,
            "overlay": ANY_SCHEMA,
            "background": ANY_SCHEMA,
            "content": ANY_SCHEMA,
            "animation": ANY_SCHEMA,
            "transition": ANY_SCHEMA,
            "motion": ANY_SCHEMA,
            "events": {"type": "array", "items": {"type": "string", "enum": CANDY_EVENT_ENUM}},
            "semantics": CANDY_SEMANTICS_SCHEMA,
            "accessibility": CANDY_ACCESSIBILITY_SCHEMA,
            "performance": CANDY_PERFORMANCE_SCHEMA,
            **dict(extra_properties),
        },
        "additionalProperties": False,
    }
    return {
        "anyOf": [
            BOOL_SCHEMA,
            payload_schema,
        ]
    }


CANDY_MODULE_SCHEMAS = {
    "button": _candy_module_schema(
        {
            "label": STRING_SCHEMA,
            "text": STRING_SCHEMA,
            "icon": STRING_SCHEMA,
            "loading": BOOL_SCHEMA,
            "disabled": BOOL_SCHEMA,
            "radius": NUMBER_SCHEMA,
            "padding": PADDING_SCHEMA,
            "bgcolor": COLOR_SCHEMA,
            "text_color": COLOR_SCHEMA,
        }
    ),
    "card": _candy_module_schema(
        {
            "elevation": NUMBER_SCHEMA,
            "radius": NUMBER_SCHEMA,
            "padding": PADDING_SCHEMA,
            "margin": PADDING_SCHEMA,
            "bgcolor": COLOR_SCHEMA,
        }
    ),
    "column": _candy_module_schema(
        {
            "spacing": NUMBER_SCHEMA,
            "alignment": STRING_SCHEMA,
            "main_axis": STRING_SCHEMA,
            "cross_axis": STRING_SCHEMA,
        }
    ),
    "container": _candy_module_schema(
        {
            "width": DIMENSION_SCHEMA,
            "height": DIMENSION_SCHEMA,
            "padding": PADDING_SCHEMA,
            "margin": PADDING_SCHEMA,
            "alignment": ALIGNMENT_SCHEMA,
            "bgcolor": COLOR_SCHEMA,
            "radius": NUMBER_SCHEMA,
        }
    ),
    "row": _candy_module_schema(
        {
            "spacing": NUMBER_SCHEMA,
            "alignment": STRING_SCHEMA,
            "main_axis": STRING_SCHEMA,
            "cross_axis": STRING_SCHEMA,
        }
    ),
    "stack": _candy_module_schema({"alignment": ALIGNMENT_SCHEMA, "fit": STRING_SCHEMA}),
    "surface": _candy_module_schema(
        {
            "bgcolor": COLOR_SCHEMA,
            "elevation": NUMBER_SCHEMA,
            "radius": NUMBER_SCHEMA,
            "border_color": COLOR_SCHEMA,
            "border_width": NUMBER_SCHEMA,
        }
    ),
    "wrap": _candy_module_schema(
        {
            "spacing": NUMBER_SCHEMA,
            "run_spacing": NUMBER_SCHEMA,
            "alignment": STRING_SCHEMA,
            "run_alignment": STRING_SCHEMA,
        }
    ),
    "align": _candy_module_schema(
        {"alignment": ALIGNMENT_SCHEMA, "width_factor": NUMBER_SCHEMA, "height_factor": NUMBER_SCHEMA}
    ),
    "center": _candy_module_schema({"width_factor": NUMBER_SCHEMA, "height_factor": NUMBER_SCHEMA}),
    "spacer": _candy_module_schema({"width": DIMENSION_SCHEMA, "height": DIMENSION_SCHEMA, "flex": INTEGER_SCHEMA}),
    "aspect_ratio": _candy_module_schema({"ratio": NUMBER_SCHEMA, "value": NUMBER_SCHEMA}),
    "overflow_box": _candy_module_schema(
        {
            "alignment": ALIGNMENT_SCHEMA,
            "min_width": DIMENSION_SCHEMA,
            "max_width": DIMENSION_SCHEMA,
            "min_height": DIMENSION_SCHEMA,
            "max_height": DIMENSION_SCHEMA,
        }
    ),
    "fitted_box": _candy_module_schema(
        {
            "fit": STRING_SCHEMA,
            "alignment": ALIGNMENT_SCHEMA,
            "clip_behavior": STRING_SCHEMA,
        }
    ),
    "effects": _candy_module_schema(
        {
            "shimmer": BOOL_SCHEMA,
            "blur": NUMBER_SCHEMA,
            "opacity": NUMBER_SCHEMA,
            "overlay": BOOL_SCHEMA,
        }
    ),
    "particles": _candy_module_schema(
        {
            "count": INTEGER_SCHEMA,
            "speed": NUMBER_SCHEMA,
            "size": NUMBER_SCHEMA,
            "gravity": NUMBER_SCHEMA,
            "drift": NUMBER_SCHEMA,
            "overlay": BOOL_SCHEMA,
            "colors": {"type": "array", "items": COLOR_SCHEMA},
        }
    ),
    "border": _candy_module_schema(
        {
            "color": COLOR_SCHEMA,
            "width": NUMBER_SCHEMA,
            "radius": NUMBER_SCHEMA,
            "side": STRING_SCHEMA,
            "padding": PADDING_SCHEMA,
        }
    ),
    "shadow": _candy_module_schema(
        {
            "color": COLOR_SCHEMA,
            "blur": NUMBER_SCHEMA,
            "spread": NUMBER_SCHEMA,
            "dx": NUMBER_SCHEMA,
            "dy": NUMBER_SCHEMA,
        }
    ),
    "outline": _candy_module_schema(
        {
            "outline_color": COLOR_SCHEMA,
            "outline_width": NUMBER_SCHEMA,
            "radius": NUMBER_SCHEMA,
        }
    ),
    "gradient": _candy_module_schema(
        {
            "variant": STRING_SCHEMA,
            "colors": {"type": "array", "items": COLOR_SCHEMA},
            "stops": {"type": "array", "items": NUMBER_SCHEMA},
            "begin": ANY_SCHEMA,
            "end": ANY_SCHEMA,
            "angle": NUMBER_SCHEMA,
        }
    ),
    "animation": _candy_module_schema(
        {
            "duration_ms": INTEGER_SCHEMA,
            "curve": STRING_SCHEMA,
            "opacity": NUMBER_SCHEMA,
            "scale": NUMBER_SCHEMA,
            "autoplay": BOOL_SCHEMA,
            "loop": BOOL_SCHEMA,
            "reverse": BOOL_SCHEMA,
        }
    ),
    "transition": _candy_module_schema(
        {
            "duration_ms": INTEGER_SCHEMA,
            "curve": STRING_SCHEMA,
            "preset": STRING_SCHEMA,
            "key": ANY_SCHEMA,
        }
    ),
    "canvas": _candy_module_schema(
        {
            "width": DIMENSION_SCHEMA,
            "height": DIMENSION_SCHEMA,
            "commands": {"type": "array", "items": {"type": "object", "additionalProperties": True}},
        }
    ),
    "clip": _candy_module_schema(
        {
            "shape": STRING_SCHEMA,
            "clip_shape": STRING_SCHEMA,
            "clip_behavior": STRING_SCHEMA,
            "radius": NUMBER_SCHEMA,
        }
    ),
    "decorated_box": _candy_module_schema(
        {
            "bgcolor": COLOR_SCHEMA,
            "gradient": ANY_SCHEMA,
            "border_color": COLOR_SCHEMA,
            "border_width": NUMBER_SCHEMA,
            "radius": NUMBER_SCHEMA,
            "shadow": ANY_SCHEMA,
        }
    ),
    "badge": _candy_module_schema(
        {
            "label": STRING_SCHEMA,
            "text": STRING_SCHEMA,
            "value": ANY_SCHEMA,
            "color": COLOR_SCHEMA,
            "bgcolor": COLOR_SCHEMA,
            "text_color": COLOR_SCHEMA,
            "radius": NUMBER_SCHEMA,
        }
    ),
    "avatar": _candy_module_schema(
        {
            "src": STRING_SCHEMA,
            "label": STRING_SCHEMA,
            "text": STRING_SCHEMA,
            "size": NUMBER_SCHEMA,
            "color": COLOR_SCHEMA,
            "bgcolor": COLOR_SCHEMA,
        }
    ),
    "icon": _candy_module_schema({"icon": STRING_SCHEMA, "size": NUMBER_SCHEMA, "color": COLOR_SCHEMA}),
    "text": _candy_module_schema(
        {
            "text": STRING_SCHEMA,
            "value": STRING_SCHEMA,
            "color": COLOR_SCHEMA,
            "font_size": NUMBER_SCHEMA,
            "size": NUMBER_SCHEMA,
            "font_weight": ANY_SCHEMA,
            "weight": ANY_SCHEMA,
            "align": STRING_SCHEMA,
            "max_lines": INTEGER_SCHEMA,
            "overflow": STRING_SCHEMA,
        }
    ),
    "motion": _candy_module_schema(
        {
            "duration_ms": INTEGER_SCHEMA,
            "curve": STRING_SCHEMA,
            "opacity": NUMBER_SCHEMA,
            "scale": NUMBER_SCHEMA,
            "autoplay": BOOL_SCHEMA,
            "loop": BOOL_SCHEMA,
            "reverse": BOOL_SCHEMA,
        }
    ),
}

CANDY_MODULE_PAYLOAD_SCHEMA = {
    "anyOf": [CANDY_MODULE_SCHEMAS[name] for name in CANDY_MODULE_ENUM],
}

CANDY_SCHEMA = _control_schema(
    {
        "schema_version": INTEGER_SCHEMA,
        "module": {"type": "string", "enum": CANDY_MODULE_ENUM},
        "state": {"type": "string", "enum": CANDY_STATE_ENUM},
        "custom_layout": BOOL_SCHEMA,
        "layout": STRING_SCHEMA,
        "manifest": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "registries": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "variant": STRING_SCHEMA,
        "events": {"type": "array", "items": {"type": "string", "enum": CANDY_EVENT_ENUM}},
        "theme": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "tokens": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "token_overrides": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "modules": {
            "type": "object",
            "properties": {name: CANDY_MODULE_SCHEMAS[name] for name in CANDY_MODULE_ENUM},
            "additionalProperties": False,
        },
        "slots": CANDY_SLOTS_SCHEMA,
        "semantics": CANDY_SEMANTICS_SCHEMA,
        "accessibility": CANDY_ACCESSIBILITY_SCHEMA,
        "interaction": {
            "type": "object",
            "properties": {
                "enabled": BOOL_SCHEMA,
                "hover": BOOL_SCHEMA,
                "focus": BOOL_SCHEMA,
                "press": BOOL_SCHEMA,
                "tap": BOOL_SCHEMA,
                "double_tap": BOOL_SCHEMA,
                "long_press": BOOL_SCHEMA,
            },
            "additionalProperties": False,
        },
        "performance": CANDY_PERFORMANCE_SCHEMA,
        "quality": STRING_SCHEMA,
        "cache": BOOL_SCHEMA,
        "button": CANDY_MODULE_SCHEMAS["button"],
        "card": CANDY_MODULE_SCHEMAS["card"],
        "column": CANDY_MODULE_SCHEMAS["column"],
        "container": CANDY_MODULE_SCHEMAS["container"],
        "row": CANDY_MODULE_SCHEMAS["row"],
        "stack": CANDY_MODULE_SCHEMAS["stack"],
        "surface": CANDY_MODULE_SCHEMAS["surface"],
        "wrap": CANDY_MODULE_SCHEMAS["wrap"],
        "align": CANDY_MODULE_SCHEMAS["align"],
        "center": CANDY_MODULE_SCHEMAS["center"],
        "spacer": CANDY_MODULE_SCHEMAS["spacer"],
        "aspect_ratio": CANDY_MODULE_SCHEMAS["aspect_ratio"],
        "overflow_box": CANDY_MODULE_SCHEMAS["overflow_box"],
        "fitted_box": CANDY_MODULE_SCHEMAS["fitted_box"],
        "effects": CANDY_MODULE_SCHEMAS["effects"],
        "particles": CANDY_MODULE_SCHEMAS["particles"],
        "border": CANDY_MODULE_SCHEMAS["border"],
        "shadow": CANDY_MODULE_SCHEMAS["shadow"],
        "outline": CANDY_MODULE_SCHEMAS["outline"],
        "gradient": CANDY_MODULE_SCHEMAS["gradient"],
        "animation": CANDY_MODULE_SCHEMAS["animation"],
        "transition": CANDY_MODULE_SCHEMAS["transition"],
        "canvas": CANDY_MODULE_SCHEMAS["canvas"],
        "clip": CANDY_MODULE_SCHEMAS["clip"],
        "decorated_box": CANDY_MODULE_SCHEMAS["decorated_box"],
        "badge": CANDY_MODULE_SCHEMAS["badge"],
        "avatar": CANDY_MODULE_SCHEMAS["avatar"],
        "icon": CANDY_MODULE_SCHEMAS["icon"],
        "text": CANDY_MODULE_SCHEMAS["text"],
        "motion": CANDY_MODULE_SCHEMAS["motion"],
    }
)

PAN_ZOOM_SCHEMA = {
    "type": "object",
    "properties": {
        "enabled": BOOL_SCHEMA,
        "scale": NUMBER_SCHEMA,
        "x": NUMBER_SCHEMA,
        "y": NUMBER_SCHEMA,
        "min_scale": {"type": "number", "minimum": 0.0},
        "max_scale": {"type": "number", "minimum": 0.0},
        "boundary_margin": PADDING_SCHEMA,
        "pan_enabled": BOOL_SCHEMA,
        "zoom_enabled": BOOL_SCHEMA,
        "emit_on_start": BOOL_SCHEMA,
        "emit_on_update": BOOL_SCHEMA,
        "emit_on_end": BOOL_SCHEMA,
        "events": {"type": "array", "items": STRING_SCHEMA},
        "throttle_ms": INTEGER_SCHEMA,
        "clip": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

SNAP_GRID_SCHEMA = {
    "type": "object",
    "properties": {
        "show_grid": BOOL_SCHEMA,
        "spacing": NUMBER_SCHEMA,
        "subdivisions": INTEGER_SCHEMA,
        "line_color": COLOR_SCHEMA,
        "major_line_color": COLOR_SCHEMA,
        "line_width": NUMBER_SCHEMA,
        "major_line_width": NUMBER_SCHEMA,
        "background": COLOR_SCHEMA,
        "origin": OFFSET_SCHEMA,
        "snap": BOOL_SCHEMA,
        "snap_spacing": NUMBER_SCHEMA,
        "snap_mode": {"type": "string", "enum": ["nearest", "round", "floor", "ceil", "ceiling"]},
        "enabled": BOOL_SCHEMA,
        "emit_on_hover": BOOL_SCHEMA,
        "emit_on_press": BOOL_SCHEMA,
        "emit_on_drag": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

MOTION_SCHEMA = {
    "type": "object",
    "properties": {
        **MOTION_VALUE_SCHEMA["properties"],
        "from": MOTION_VALUE_SCHEMA,
        "to": MOTION_VALUE_SCHEMA,
        "keyframes": {"type": "array", "items": KEYFRAME_SCHEMA},
        "curve": CURVE_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
        "duration": INTEGER_SCHEMA,
        "duration_s": NUMBER_SCHEMA,
        "delay_ms": INTEGER_SCHEMA,
        "delay": INTEGER_SCHEMA,
        "delay_s": NUMBER_SCHEMA,
        "repeat": BOOL_SCHEMA,
        "loop": BOOL_SCHEMA,
        "yoyo": BOOL_SCHEMA,
        "reverse": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "emit_on_tick": BOOL_SCHEMA,
        "emit_on_start": BOOL_SCHEMA,
        "emit_on_complete": BOOL_SCHEMA,
        "throttle_ms": INTEGER_SCHEMA,
        "alignment": ALIGNMENT_SCHEMA,
        "origin": OFFSET_SCHEMA,
        "pivot": OFFSET_SCHEMA,
    },
    "additionalProperties": True,
}

TIMELINE_TRACK_SCHEMA = {
    "type": "object",
    "properties": {
        **MOTION_VALUE_SCHEMA["properties"],
        "from": MOTION_VALUE_SCHEMA,
        "to": MOTION_VALUE_SCHEMA,
        "keyframes": {"type": "array", "items": KEYFRAME_SCHEMA},
        "index": INTEGER_SCHEMA,
        "child": INTEGER_SCHEMA,
        "child_index": INTEGER_SCHEMA,
        "target": STRING_SCHEMA,
        "id": STRING_SCHEMA,
        "control": STRING_SCHEMA,
        "start": NUMBER_SCHEMA,
        "end": NUMBER_SCHEMA,
        "begin": NUMBER_SCHEMA,
        "alignment": ALIGNMENT_SCHEMA,
        "origin": OFFSET_SCHEMA,
        "pivot": OFFSET_SCHEMA,
    },
    "additionalProperties": True,
}

TIMELINE_SCHEMA = {
    "type": "object",
    "properties": {
        "tracks": {"type": "array", "items": TIMELINE_TRACK_SCHEMA},
        "direction": {"type": "string", "enum": ["horizontal", "vertical"]},
        "spacing": NUMBER_SCHEMA,
        "main_axis": STRING_SCHEMA,
        "cross_axis": STRING_SCHEMA,
        "curve": CURVE_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
        "duration": INTEGER_SCHEMA,
        "duration_s": NUMBER_SCHEMA,
        "delay_ms": INTEGER_SCHEMA,
        "delay": INTEGER_SCHEMA,
        "delay_s": NUMBER_SCHEMA,
        "repeat": BOOL_SCHEMA,
        "loop": BOOL_SCHEMA,
        "yoyo": BOOL_SCHEMA,
        "reverse": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "emit_on_tick": BOOL_SCHEMA,
        "emit_on_start": BOOL_SCHEMA,
        "emit_on_complete": BOOL_SCHEMA,
        "throttle_ms": INTEGER_SCHEMA,
    },
    "additionalProperties": True,
}

STAGGER_SCHEMA = {
    "type": "object",
    "properties": {
        **MOTION_SCHEMA["properties"],
        "stagger_ms": INTEGER_SCHEMA,
        "stagger": INTEGER_SCHEMA,
        "direction": AXIS_SCHEMA,
    },
    "additionalProperties": True,
}

GESTURE_AREA_SCHEMA = {
    "type": "object",
    "properties": {
        "enabled": BOOL_SCHEMA,
        "tap_enabled": BOOL_SCHEMA,
        "double_tap_enabled": BOOL_SCHEMA,
        "long_press_enabled": BOOL_SCHEMA,
        "pan_enabled": BOOL_SCHEMA,
        "scale_enabled": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

DRAG_PAYLOAD_SCHEMA = {
    "type": "object",
    "properties": {
        "data": {
            "type": ["string", "number", "boolean", "object", "array", "null"],
        },
        "drag_type": STRING_SCHEMA,
        "mime": STRING_SCHEMA,
        "axis": AXIS_SCHEMA,
        "max_simultaneous": INTEGER_SCHEMA,
        "max_simultaneous_drags": INTEGER_SCHEMA,
        "drag_anchor": {"type": "string", "enum": ["child", "pointer"]},
    },
    "additionalProperties": True,
}

DROP_ZONE_SCHEMA = {
    "type": "object",
    "properties": {
        "accept_types": {"type": "array", "items": STRING_SCHEMA},
        "accept_mimes": {"type": "array", "items": STRING_SCHEMA},
    },
    "additionalProperties": True,
}

LIST_SURFACE_SCHEMA = {
    "type": "object",
    "properties": {
        "direction": {"type": "string", "enum": ["horizontal", "vertical"]},
        "scrollable": BOOL_SCHEMA,
        "spacing": NUMBER_SCHEMA,
        "separator": BOOL_SCHEMA,
        "virtual": BOOL_SCHEMA,
        "virtualized": BOOL_SCHEMA,
        "shrink_wrap": BOOL_SCHEMA,
        "padding": PADDING_SCHEMA,
        "reverse": BOOL_SCHEMA,
        "item_extent": NUMBER_SCHEMA,
        "cache_extent": NUMBER_SCHEMA,
    },
    "additionalProperties": True,
}

STICKY_SECTION_SCHEMA = {
    "type": "object",
    "properties": {
        "header": {"type": "object"},
        "items": {"type": "array", "items": {"type": "object"}},
        "header_extent": NUMBER_SCHEMA,
        "spacing": NUMBER_SCHEMA,
    },
    "additionalProperties": True,
}

STICKY_LIST_SCHEMA = {
    "type": "object",
    "properties": {
        "sections": {"type": "array", "items": STICKY_SECTION_SCHEMA},
        "spacing": NUMBER_SCHEMA,
        "padding": PADDING_SCHEMA,
        "scrollable": BOOL_SCHEMA,
        "shrink_wrap": BOOL_SCHEMA,
        "reverse": BOOL_SCHEMA,
        "cache_extent": NUMBER_SCHEMA,
        "header_extent": NUMBER_SCHEMA,
    },
    "additionalProperties": True,
}

UX_ROOT_SCHEMA = _control_schema(
    {
        "ux_type": {
            "type": "string",
            "enum": [
                "splash",
                "stack",
                "panel",
                "workspace",
                "stage",
                "flow",
                "overlay",
                "terminal",
            ],
        },
        "slots": {"type": "array", "items": STRING_SCHEMA},
        "config": ANY_SCHEMA,
        "index": INTEGER_SCHEMA,
        "active_index": INTEGER_SCHEMA,
    }
)

GRID_VIEW_SCHEMA = {
    "type": "object",
    "properties": {
        "columns": {"type": "array", "items": STRING_SCHEMA},
        "rows": {"type": "array", "items": ANY_SCHEMA},
        "dense": BOOL_SCHEMA,
        "striped": BOOL_SCHEMA,
        "show_header": BOOL_SCHEMA,
        "sortable": BOOL_SCHEMA,
        "selectable": BOOL_SCHEMA,
        "selected_index": INTEGER_SCHEMA,
        "auto_sort": BOOL_SCHEMA,
        "sort_column": INTEGER_SCHEMA,
        "sort_ascending": BOOL_SCHEMA,
        "filter_query": STRING_SCHEMA,
        "filter_column": INTEGER_SCHEMA,
        "filter_case_sensitive": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

EFFECT_LAYER_SCHEMA = {
    "type": "object",
    "properties": {
        "blur_sigma": NUMBER_SCHEMA,
        "blur": NUMBER_SCHEMA,
        "blur_radius": NUMBER_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "tint": COLOR_SCHEMA,
        "tint_blend_mode": BLEND_MODE_SCHEMA,
        "shadow_color": COLOR_SCHEMA,
        "shadow_blur": NUMBER_SCHEMA,
        "shadow_spread": NUMBER_SCHEMA,
        "shadow_offset": OFFSET_SCHEMA,
        "color_matrix": COLOR_MATRIX_SCHEMA,
        "filter": STRING_SCHEMA,
    },
    "additionalProperties": True,
}

CANVAS_SCHEMA = {
    "type": "object",
    "properties": {
        "commands": {"type": "array", "items": {"type": "object"}},
        "background_color": COLOR_SCHEMA,
    },
    "additionalProperties": True,
}

VECTOR_VIEW_SCHEMA = {
    "type": "object",
    "properties": {
        "src": STRING_SCHEMA,
        "data": STRING_SCHEMA,
        "fit": STRING_SCHEMA,
        "color": COLOR_SCHEMA,
        "tint": COLOR_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "width": NUMBER_SCHEMA,
        "height": NUMBER_SCHEMA,
        "alignment": ALIGNMENT_SCHEMA,
    },
    "additionalProperties": True,
}

MESH_POINT_SCHEMA = {
    "type": "object",
    "properties": {
        "x": NUMBER_SCHEMA,
        "y": NUMBER_SCHEMA,
        "x_px": NUMBER_SCHEMA,
        "y_px": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "radius_px": NUMBER_SCHEMA,
        "color": COLOR_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "blend_mode": STRING_SCHEMA,
    },
    "additionalProperties": True,
}

GRADIENT_SCHEMA = _control_schema(
    {
        "variant": STRING_SCHEMA,
        "colors": {"type": "array", "items": COLOR_SCHEMA},
        "stops": {"type": "array", "items": NUMBER_SCHEMA},
        "tile_mode": STRING_SCHEMA,
        "begin": ALIGNMENT_SCHEMA,
        "end": ALIGNMENT_SCHEMA,
        "center": ALIGNMENT_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "focal": ALIGNMENT_SCHEMA,
        "focal_radius": NUMBER_SCHEMA,
        "start_angle": NUMBER_SCHEMA,
        "end_angle": NUMBER_SCHEMA,
        "start_degrees": NUMBER_SCHEMA,
        "end_degrees": NUMBER_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "background_color": COLOR_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "mesh": {"type": "array", "items": MESH_POINT_SCHEMA},
        "mesh_points": {"type": "array", "items": MESH_POINT_SCHEMA},
        "points": {"type": "array", "items": MESH_POINT_SCHEMA},
    }
)

ANIMATED_GRADIENT_SCHEMA = _control_schema(
    {
        "variant": STRING_SCHEMA,
        "kind": STRING_SCHEMA,
        "gradient": STRING_SCHEMA,
        "type": STRING_SCHEMA,
        "colors": {"type": "array", "items": COLOR_SCHEMA},
        "stops": {"type": "array", "items": NUMBER_SCHEMA},
        "begin": ALIGNMENT_SCHEMA,
        "end": ALIGNMENT_SCHEMA,
        "angle": NUMBER_SCHEMA,
        "start_angle": NUMBER_SCHEMA,
        "end_angle": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "bgcolor": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "background_color": COLOR_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
        "duration": INTEGER_SCHEMA,
        "loop": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "ping_pong": BOOL_SCHEMA,
        "shift": BOOL_SCHEMA,
        "throttle_ms": INTEGER_SCHEMA,
    }
)

PARTICLE_FIELD_SCHEMA = _control_schema(
    {
        "count": INTEGER_SCHEMA,
        "colors": {"type": "array", "items": COLOR_SCHEMA},
        "size": NUMBER_SCHEMA,
        "min_size": NUMBER_SCHEMA,
        "max_size": NUMBER_SCHEMA,
        "speed": NUMBER_SCHEMA,
        "min_speed": NUMBER_SCHEMA,
        "max_speed": NUMBER_SCHEMA,
        "direction": NUMBER_SCHEMA,
        "direction_deg": NUMBER_SCHEMA,
        "direction_degrees": NUMBER_SCHEMA,
        "spread": NUMBER_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "seed": INTEGER_SCHEMA,
        "loop": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "shape": STRING_SCHEMA,
    }
)

NOISE_FIELD_SCHEMA = _control_schema(
    {
        "cell_size": NUMBER_SCHEMA,
        "scale": NUMBER_SCHEMA,
        "speed": NUMBER_SCHEMA,
        "intensity": NUMBER_SCHEMA,
        "height": NUMBER_SCHEMA,
        "kind": STRING_SCHEMA,
        "animated": BOOL_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "seed": INTEGER_SCHEMA,
        "loop": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "colors": {"type": "array", "items": COLOR_SCHEMA},
        "color": COLOR_SCHEMA,
    }
)

FLOW_FIELD_SCHEMA = _control_schema(
    {
        "count": INTEGER_SCHEMA,
        "colors": {"type": "array", "items": COLOR_SCHEMA},
        "size": NUMBER_SCHEMA,
        "min_size": NUMBER_SCHEMA,
        "max_size": NUMBER_SCHEMA,
        "speed": NUMBER_SCHEMA,
        "min_speed": NUMBER_SCHEMA,
        "max_speed": NUMBER_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "seed": INTEGER_SCHEMA,
        "scale": NUMBER_SCHEMA,
        "turn": NUMBER_SCHEMA,
        "loop": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "shape": STRING_SCHEMA,
        "progress": NUMBER_SCHEMA,
    }
)

BLOB_FIELD_SCHEMA = _control_schema(
    {
        "count": INTEGER_SCHEMA,
        "color": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "colors": {"type": "array", "items": COLOR_SCHEMA},
        "min_radius": NUMBER_SCHEMA,
        "max_radius": NUMBER_SCHEMA,
        "speed": NUMBER_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "blur_sigma": NUMBER_SCHEMA,
        "blur": NUMBER_SCHEMA,
        "seed": INTEGER_SCHEMA,
        "loop": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "progress": NUMBER_SCHEMA,
    }
)

SPRITE_SCHEMA = _control_schema(
    {
        "src": STRING_SCHEMA,
        "frame_width": NUMBER_SCHEMA,
        "frame_height": NUMBER_SCHEMA,
        "frames": INTEGER_SCHEMA,
        "fps": NUMBER_SCHEMA,
        "loop": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "columns": INTEGER_SCHEMA,
        "rows": INTEGER_SCHEMA,
        "fit": STRING_SCHEMA,
        "opacity": {"type": "number", "minimum": 0.0, "maximum": 1.0},
        "progress": NUMBER_SCHEMA,
    }
)

TRANSFORM_BOX_SCHEMA = _control_schema(
    {
        "rect": {"type": "object", "additionalProperties": True},
        "enabled": BOOL_SCHEMA,
    }
)

WEBVIEW_ADAPTER_SCHEMA = _control_schema()

AUDIO_SCHEMA = {
    "type": "object",
    "properties": {
        "src": STRING_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "loop": BOOL_SCHEMA,
        "volume": NUMBER_SCHEMA,
        "show_controls": BOOL_SCHEMA,
        "muted": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "seek": NUMBER_SCHEMA,
        "seek_ms": INTEGER_SCHEMA,
        "position": NUMBER_SCHEMA,
        "position_ms": INTEGER_SCHEMA,
        "emit_on_position": BOOL_SCHEMA,
        "emit_on_state": BOOL_SCHEMA,
        "emit_on_duration": BOOL_SCHEMA,
        "throttle_ms": INTEGER_SCHEMA,
    },
    "additionalProperties": True,
}

VIDEO_SCHEMA = {
    "type": "object",
    "properties": {
        "src": STRING_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "loop": BOOL_SCHEMA,
        "volume": NUMBER_SCHEMA,
        "show_controls": BOOL_SCHEMA,
        "muted": BOOL_SCHEMA,
        "fit": STRING_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
        "seek": NUMBER_SCHEMA,
        "seek_ms": INTEGER_SCHEMA,
        "position": NUMBER_SCHEMA,
        "position_ms": INTEGER_SCHEMA,
        "emit_on_position": BOOL_SCHEMA,
        "emit_on_state": BOOL_SCHEMA,
        "emit_on_duration": BOOL_SCHEMA,
        "throttle_ms": INTEGER_SCHEMA,
    },
    "additionalProperties": True,
}

TEXT_SCHEMA = _control_schema(
    {
        "text": STRING_SCHEMA,
        "value": STRING_SCHEMA,
        "size": NUMBER_SCHEMA,
        "font_size": NUMBER_SCHEMA,
        "color": COLOR_SCHEMA,
        "weight": STRING_SCHEMA,
        "font_weight": STRING_SCHEMA,
        "italic": BOOL_SCHEMA,
        "align": STRING_SCHEMA,
        "max_lines": INTEGER_SCHEMA,
        "muted": BOOL_SCHEMA,
    }
)

BUTTON_SCHEMA = _control_schema(
    {
        "text": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "variant": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "color": COLOR_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "text_color": COLOR_SCHEMA,
        "fgcolor": COLOR_SCHEMA,
        "foreground": COLOR_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "content_padding": PADDING_SCHEMA,
        "border_color": COLOR_SCHEMA,
    }
)

TEXT_FIELD_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "helper_text": STRING_SCHEMA,
        "error_text": STRING_SCHEMA,
        "multiline": BOOL_SCHEMA,
        "min_lines": INTEGER_SCHEMA,
        "max_lines": INTEGER_SCHEMA,
        "password": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "read_only": BOOL_SCHEMA,
        "autofocus": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "expand": BOOL_SCHEMA,
    }
)

TEXT_AREA_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "helper_text": STRING_SCHEMA,
        "error_text": STRING_SCHEMA,
        "min_lines": INTEGER_SCHEMA,
        "max_lines": INTEGER_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "read_only": BOOL_SCHEMA,
        "autofocus": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

CHECKBOX_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "value": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "tristate": BOOL_SCHEMA,
    }
)

SWITCH_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "value": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "inline": BOOL_SCHEMA,
    }
)

SLIDER_SCHEMA = _control_schema(
    {
        "value": NUMBER_SCHEMA,
        "min": NUMBER_SCHEMA,
        "max": NUMBER_SCHEMA,
        "divisions": INTEGER_SCHEMA,
        "label": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

SELECT_SCHEMA = _control_schema(
    {
        "options": {"type": "array", "items": ANY_SCHEMA},
        "items": {"type": "array", "items": ANY_SCHEMA},
        "groups": {"type": "array", "items": {"type": "object"}},
        "index": INTEGER_SCHEMA,
        "value": ANY_SCHEMA,
        "values": {"type": "array", "items": ANY_SCHEMA},
        "selected": ANY_SCHEMA,
        "label": STRING_SCHEMA,
        "hint": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "loading": BOOL_SCHEMA,
        "async_source": STRING_SCHEMA,
        "debounce_ms": INTEGER_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "animation": {"type": "object", "additionalProperties": True},
    }
)

RADIO_SCHEMA = _control_schema(
    {
        "options": {"type": "array", "items": ANY_SCHEMA},
        "index": INTEGER_SCHEMA,
        "value": ANY_SCHEMA,
        "label": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

FILE_PICKER_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "mode": STRING_SCHEMA,
        "file_type": STRING_SCHEMA,
        "extensions": {"type": "array", "items": STRING_SCHEMA},
        "allowed_extensions": {"type": "array", "items": STRING_SCHEMA},
        "multiple": BOOL_SCHEMA,
        "allow_multiple": BOOL_SCHEMA,
        "with_data": BOOL_SCHEMA,
        "with_path": BOOL_SCHEMA,
        "pick_directory": BOOL_SCHEMA,
        "save_file": BOOL_SCHEMA,
        "file_name": STRING_SCHEMA,
        "dialog_title": STRING_SCHEMA,
        "initial_directory": STRING_SCHEMA,
        "lock_parent_window": BOOL_SCHEMA,
        "show_selection": BOOL_SCHEMA,
        "drop_enabled": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

IMAGE_SCHEMA = _control_schema(
    {
        "src": STRING_SCHEMA,
        "fit": STRING_SCHEMA,
        "radius": NUMBER_SCHEMA,
    }
)

GALLERY_SCHEMA_VERSION = 2

GALLERY_MODULE_ENUM = [
    "toolbar",
    "filter_bar",
    "grid_layout",
    "item_actions",
    "item_badge",
    "item_meta_row",
    "item_preview",
    "item_selectable",
    "item_tile",
    "pagination",
    "section_header",
    "sort_bar",
    "empty_state",
    "loading_skeleton",
    "search_bar",
    "fonts",
    "font_picker",
    "font_renderer",
    "audio",
    "audio_picker",
    "audio_renderer",
    "video",
    "video_picker",
    "video_renderer",
    "image",
    "image_picker",
    "image_renderer",
    "document",
    "document_picker",
    "document_renderer",
    "item_drag_handle",
    "item_drop_target",
    "item_reorder_handle",
    "item_selection_checkbox",
    "item_selection_radio",
    "item_selection_switch",
    "apply",
    "clear",
    "select_all",
    "deselect_all",
    "apply_font",
    "apply_image",
    "set_as_wallpaper",
    "presets",
    "skins",
]

GALLERY_STATE_ENUM = ["idle", "loading", "empty", "ready", "disabled"]

GALLERY_EVENT_ENUM = [
    "change",
    "select",
    "select_change",
    "page_change",
    "sort_change",
    "filter_change",
    "action",
    "apply",
    "clear",
    "select_all",
    "deselect_all",
    "apply_font",
    "apply_image",
    "set_as_wallpaper",
    "pick",
    "drag_handle",
    "drop_target",
    "section_action",
    "font_change",
]

SKINS_MODULE_ENUM = [
    "selector",
    "preset",
    "editor",
    "preview",
    "apply",
    "clear",
    "token_mapper",
    "create_skin",
    "edit_skin",
    "delete_skin",
    "effects",
    "particles",
    "shaders",
    "materials",
    "icons",
    "fonts",
    "colors",
    "background",
    "border",
    "shadow",
    "outline",
    "animation",
    "transition",
    "interaction",
    "layout",
    "responsive",
    "effect_editor",
    "particle_editor",
    "shader_editor",
    "material_editor",
    "icon_editor",
    "font_editor",
    "color_editor",
    "background_editor",
    "border_editor",
    "shadow_editor",
    "outline_editor",
]

SKINS_STATE_ENUM = ["idle", "loading", "ready", "editing", "preview", "disabled"]

SKINS_EVENT_ENUM = [
    "change",
    "select",
    "apply",
    "clear",
    "create_skin",
    "edit_skin",
    "delete_skin",
    "state_change",
    "module_change",
    "token_map",
]

CODE_EDITOR_MODULE_ENUM = [
    "editor_intent_router",
    "editor_minimap",
    "editor_surface",
    "editor_view",
    "diff",
    "editor_tabs",
    "empty_state_view",
    "explorer_tree",
    "ide",
    "code_buffer",
    "code_category_layer",
    "code_document",
    "file_tabs",
    "file_tree",
    "smart_search_bar",
    "semantic_search",
    "search_box",
    "search_everything_panel",
    "search_field",
    "search_history",
    "search_intent",
    "search_item",
    "search_provider",
    "search_results_view",
    "search_scope_selector",
    "search_source",
    "query_token",
    "document_tab_strip",
    "command_search",
    "tree",
    "workbench_editor",
    "workspace_explorer",
    "command_bar",
    "diagnostic_stream",
    "diff_narrator",
    "dock_graph",
    "dock",
    "dock_pane",
    "empty_view",
    "export_panel",
    "gutter",
    "hint",
    "mini_map",
    "scope_picker",
    "scoped_search_replace",
    "diagnostics_panel",
    "ghost_editor",
    "inline_error_view",
    "inline_search_overlay",
    "inline_widget",
    "inspector",
    "intent_panel",
    "intent_router",
    "intent_search",
]

CODE_EDITOR_STATE_ENUM = ["idle", "loading", "ready", "searching", "diff", "disabled"]

CODE_EDITOR_EVENT_ENUM = [
    "ready",
    "change",
    "submit",
    "save",
    "format_request",
    "search",
    "open_document",
    "close_document",
    "select",
    "state_change",
    "module_change",
]

TERMINAL_MODULE_ENUM = [
    "capabilities",
    "command_builder",
    "flow_gate",
    "output_mapper",
    "presets",
    "progress",
    "progress_view",
    "prompt",
    "raw_view",
    "replay",
    "session",
    "stdin",
    "stdin_injector",
    "stream",
    "stream_view",
    "tabs",
    "timeline",
    "view",
    "workbench",
    "process_bridge",
    "execution_lane",
    "log_viewer",
    "log_panel",
]

TERMINAL_STATE_ENUM = ["idle", "loading", "ready", "running", "paused", "disabled"]

TERMINAL_EVENT_ENUM = [
    "ready",
    "change",
    "submit",
    "input",
    "output",
    "state_change",
    "module_change",
]

STUDIO_MODULE_ENUM = [
    "actions_editor",
    "asset_browser",
    "bindings_editor",
    "block_palette",
    "builder",
    "canvas",
    "timeline_surface",
    "node_surface",
    "preview_surface",
    "component_palette",
    "inspector",
    "outline_tree",
    "project_panel",
    "properties_panel",
    "responsive_toolbar",
    "tokens_editor",
    "selection_tools",
    "transform_box",
    "transform_toolbar",
]

STUDIO_STATE_ENUM = ["idle", "loading", "ready", "editing", "preview", "disabled"]

STUDIO_EVENT_ENUM = [
    "ready",
    "change",
    "submit",
    "select",
    "state_change",
    "module_change",
]


def _gallery_module_schema(extra_properties: Mapping[str, Any]) -> dict[str, Any]:
    payload_schema = {
        "type": "object",
        "properties": {
            "enabled": BOOL_SCHEMA,
            "label": STRING_SCHEMA,
            "title": STRING_SCHEMA,
            "subtitle": STRING_SCHEMA,
            "value": ANY_SCHEMA,
            "payload": ANY_SCHEMA,
            **dict(extra_properties),
        },
        "additionalProperties": False,
    }
    return {
        "anyOf": [
            BOOL_SCHEMA,
            payload_schema,
        ]
    }


def _skins_module_schema(extra_properties: Mapping[str, Any]) -> dict[str, Any]:
    payload_schema = {
        "type": "object",
        "properties": {
            "enabled": BOOL_SCHEMA,
            "label": STRING_SCHEMA,
            "title": STRING_SCHEMA,
            "subtitle": STRING_SCHEMA,
            "value": ANY_SCHEMA,
            "payload": ANY_SCHEMA,
            **dict(extra_properties),
        },
        "additionalProperties": False,
    }
    return {
        "anyOf": [
            BOOL_SCHEMA,
            payload_schema,
        ]
    }


def _code_editor_module_schema(extra_properties: Mapping[str, Any]) -> dict[str, Any]:
    payload_schema = {
        "type": "object",
        "properties": {
            "enabled": BOOL_SCHEMA,
            "label": STRING_SCHEMA,
            "title": STRING_SCHEMA,
            "subtitle": STRING_SCHEMA,
            "value": ANY_SCHEMA,
            "payload": ANY_SCHEMA,
            **dict(extra_properties),
        },
        "additionalProperties": False,
    }
    return {
        "anyOf": [
            BOOL_SCHEMA,
            payload_schema,
        ]
    }


def _terminal_module_schema(extra_properties: Mapping[str, Any]) -> dict[str, Any]:
    payload_schema = {
        "type": "object",
        "properties": {
            "enabled": BOOL_SCHEMA,
            "label": STRING_SCHEMA,
            "title": STRING_SCHEMA,
            "subtitle": STRING_SCHEMA,
            "value": ANY_SCHEMA,
            "payload": ANY_SCHEMA,
            **dict(extra_properties),
        },
        "additionalProperties": False,
    }
    return {
        "anyOf": [
            BOOL_SCHEMA,
            payload_schema,
        ]
    }


def _studio_module_schema(extra_properties: Mapping[str, Any]) -> dict[str, Any]:
    payload_schema = {
        "type": "object",
        "properties": {
            "enabled": BOOL_SCHEMA,
            "label": STRING_SCHEMA,
            "title": STRING_SCHEMA,
            "subtitle": STRING_SCHEMA,
            "value": ANY_SCHEMA,
            "payload": ANY_SCHEMA,
            **dict(extra_properties),
        },
        "additionalProperties": False,
    }
    return {
        "anyOf": [
            BOOL_SCHEMA,
            payload_schema,
        ]
    }


GALLERY_MODULE_SCHEMAS = {
    "toolbar": _gallery_module_schema({"actions": {"type": "array", "items": ANY_SCHEMA}}),
    "filter_bar": _gallery_module_schema(
        {"filters": {"type": "array", "items": ANY_SCHEMA}, "values": {"type": "array", "items": ANY_SCHEMA}}
    ),
    "grid_layout": _gallery_module_schema({"columns": INTEGER_SCHEMA, "spacing": NUMBER_SCHEMA}),
    "item_actions": _gallery_module_schema({"actions": {"type": "array", "items": ANY_SCHEMA}}),
    "item_badge": _gallery_module_schema({"text": STRING_SCHEMA}),
    "item_meta_row": _gallery_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "item_preview": _gallery_module_schema({"height": NUMBER_SCHEMA}),
    "item_selectable": _gallery_module_schema({"selected": BOOL_SCHEMA}),
    "item_tile": _gallery_module_schema({"id": STRING_SCHEMA}),
    "pagination": _gallery_module_schema({"page": INTEGER_SCHEMA, "page_count": INTEGER_SCHEMA, "pages": INTEGER_SCHEMA}),
    "section_header": _gallery_module_schema({"count": ANY_SCHEMA, "id": STRING_SCHEMA}),
    "sort_bar": _gallery_module_schema({"options": {"type": "array", "items": STRING_SCHEMA}, "selected": STRING_SCHEMA}),
    "empty_state": _gallery_module_schema({}),
    "loading_skeleton": _gallery_module_schema({}),
    "search_bar": _gallery_module_schema({"query": STRING_SCHEMA, "placeholder": STRING_SCHEMA}),
    "fonts": _gallery_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "font_picker": _gallery_module_schema({"options": {"type": "array", "items": STRING_SCHEMA}}),
    "font_renderer": _gallery_module_schema({"font": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "audio": _gallery_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "audio_picker": _gallery_module_schema({"accept": STRING_SCHEMA}),
    "audio_renderer": _gallery_module_schema({"src": STRING_SCHEMA}),
    "video": _gallery_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "video_picker": _gallery_module_schema({"accept": STRING_SCHEMA}),
    "video_renderer": _gallery_module_schema({"src": STRING_SCHEMA}),
    "image": _gallery_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "image_picker": _gallery_module_schema({"accept": STRING_SCHEMA}),
    "image_renderer": _gallery_module_schema({"src": STRING_SCHEMA}),
    "document": _gallery_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "document_picker": _gallery_module_schema({"accept": STRING_SCHEMA}),
    "document_renderer": _gallery_module_schema({"src": STRING_SCHEMA}),
    "item_drag_handle": _gallery_module_schema({}),
    "item_drop_target": _gallery_module_schema({"height": NUMBER_SCHEMA}),
    "item_reorder_handle": _gallery_module_schema({}),
    "item_selection_checkbox": _gallery_module_schema({"selected": BOOL_SCHEMA}),
    "item_selection_radio": _gallery_module_schema({"selected": BOOL_SCHEMA}),
    "item_selection_switch": _gallery_module_schema({"selected": BOOL_SCHEMA}),
    "apply": _gallery_module_schema({}),
    "clear": _gallery_module_schema({}),
    "select_all": _gallery_module_schema({}),
    "deselect_all": _gallery_module_schema({}),
    "apply_font": _gallery_module_schema({"font": STRING_SCHEMA}),
    "apply_image": _gallery_module_schema({"image": ANY_SCHEMA}),
    "set_as_wallpaper": _gallery_module_schema({}),
    "presets": _gallery_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "skins": _gallery_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
}

SKINS_MODULE_SCHEMAS = {
    "selector": _skins_module_schema(
        {
            "skins": {"type": "array", "items": ANY_SCHEMA},
            "options": {"type": "array", "items": ANY_SCHEMA},
            "items": {"type": "array", "items": ANY_SCHEMA},
            "selected_skin": STRING_SCHEMA,
        }
    ),
    "preset": _skins_module_schema({"presets": {"type": "array", "items": ANY_SCHEMA}}),
    "editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "preview": _skins_module_schema({"skin": STRING_SCHEMA}),
    "apply": _skins_module_schema({"skin": STRING_SCHEMA}),
    "clear": _skins_module_schema({}),
    "token_mapper": _skins_module_schema({"mapping": {"type": "object", "additionalProperties": ANY_SCHEMA}}),
    "create_skin": _skins_module_schema({"name": STRING_SCHEMA}),
    "edit_skin": _skins_module_schema({"name": STRING_SCHEMA}),
    "delete_skin": _skins_module_schema({"name": STRING_SCHEMA}),
    "effects": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "particles": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "shaders": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "materials": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "icons": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "fonts": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "colors": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "background": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "border": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "shadow": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "outline": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "animation": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "transition": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "interaction": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "layout": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "responsive": _skins_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "effect_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "particle_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "shader_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "material_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "icon_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "font_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "color_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "background_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "border_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "shadow_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "outline_editor": _skins_module_schema({"name": STRING_SCHEMA, "text": STRING_SCHEMA}),
}

CODE_EDITOR_MODULE_SCHEMAS = {
    "editor_intent_router": _code_editor_module_schema({"shortcuts": {"type": "array", "items": ANY_SCHEMA}}),
    "editor_minimap": _code_editor_module_schema({"visible": BOOL_SCHEMA}),
    "editor_surface": _code_editor_module_schema({"read_only": BOOL_SCHEMA, "show_gutter": BOOL_SCHEMA}),
    "editor_view": _code_editor_module_schema({"document_id": STRING_SCHEMA, "language": STRING_SCHEMA}),
    "diff": _code_editor_module_schema({"left": STRING_SCHEMA, "right": STRING_SCHEMA}),
    "editor_tabs": _code_editor_module_schema({"tabs": {"type": "array", "items": ANY_SCHEMA}}),
    "empty_state_view": _code_editor_module_schema({"message": STRING_SCHEMA, "title": STRING_SCHEMA}),
    "explorer_tree": _code_editor_module_schema({"nodes": {"type": "array", "items": ANY_SCHEMA}}),
    "ide": _code_editor_module_schema({"documents": {"type": "array", "items": ANY_SCHEMA}}),
    "code_buffer": _code_editor_module_schema({"buffer_id": STRING_SCHEMA, "text": STRING_SCHEMA}),
    "code_category_layer": _code_editor_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "code_document": _code_editor_module_schema({"document_id": STRING_SCHEMA, "uri": STRING_SCHEMA}),
    "file_tabs": _code_editor_module_schema({"tabs": {"type": "array", "items": ANY_SCHEMA}}),
    "file_tree": _code_editor_module_schema({"nodes": {"type": "array", "items": ANY_SCHEMA}}),
    "smart_search_bar": _code_editor_module_schema({"query": STRING_SCHEMA}),
    "semantic_search": _code_editor_module_schema({"query": STRING_SCHEMA}),
    "search_box": _code_editor_module_schema({"query": STRING_SCHEMA}),
    "search_everything_panel": _code_editor_module_schema({"results": {"type": "array", "items": ANY_SCHEMA}}),
    "search_field": _code_editor_module_schema({"query": STRING_SCHEMA}),
    "search_history": _code_editor_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "search_intent": _code_editor_module_schema({"intent": STRING_SCHEMA}),
    "search_item": _code_editor_module_schema({"id": STRING_SCHEMA, "label": STRING_SCHEMA}),
    "search_provider": _code_editor_module_schema({"sources": {"type": "array", "items": ANY_SCHEMA}}),
    "search_results_view": _code_editor_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "search_scope_selector": _code_editor_module_schema({"options": {"type": "array", "items": ANY_SCHEMA}}),
    "search_source": _code_editor_module_schema({"source": STRING_SCHEMA}),
    "query_token": _code_editor_module_schema({"tokens": {"type": "array", "items": ANY_SCHEMA}}),
    "document_tab_strip": _code_editor_module_schema({"tabs": {"type": "array", "items": ANY_SCHEMA}}),
    "command_search": _code_editor_module_schema({"query": STRING_SCHEMA}),
    "tree": _code_editor_module_schema({"nodes": {"type": "array", "items": ANY_SCHEMA}}),
    "workbench_editor": _code_editor_module_schema({"documents": {"type": "array", "items": ANY_SCHEMA}}),
    "workspace_explorer": _code_editor_module_schema({"nodes": {"type": "array", "items": ANY_SCHEMA}}),
    "command_bar": _code_editor_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "diagnostic_stream": _code_editor_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "diff_narrator": _code_editor_module_schema({"text": STRING_SCHEMA}),
    "dock_graph": _code_editor_module_schema({"nodes": {"type": "array", "items": ANY_SCHEMA}}),
    "dock": _code_editor_module_schema({"panes": {"type": "array", "items": ANY_SCHEMA}}),
    "dock_pane": _code_editor_module_schema({"pane_id": STRING_SCHEMA}),
    "empty_view": _code_editor_module_schema({"message": STRING_SCHEMA, "title": STRING_SCHEMA}),
    "export_panel": _code_editor_module_schema({"options": {"type": "array", "items": ANY_SCHEMA}}),
    "gutter": _code_editor_module_schema({"line_count": INTEGER_SCHEMA}),
    "hint": _code_editor_module_schema({"text": STRING_SCHEMA}),
    "mini_map": _code_editor_module_schema({"visible": BOOL_SCHEMA}),
    "scope_picker": _code_editor_module_schema({"options": {"type": "array", "items": ANY_SCHEMA}}),
    "scoped_search_replace": _code_editor_module_schema({"query": STRING_SCHEMA, "replace_text": STRING_SCHEMA}),
    "diagnostics_panel": _code_editor_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "ghost_editor": _code_editor_module_schema({"text": STRING_SCHEMA}),
    "inline_error_view": _code_editor_module_schema({"message": STRING_SCHEMA}),
    "inline_search_overlay": _code_editor_module_schema({"query": STRING_SCHEMA}),
    "inline_widget": _code_editor_module_schema({"line": INTEGER_SCHEMA, "column": INTEGER_SCHEMA}),
    "inspector": _code_editor_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "intent_panel": _code_editor_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "intent_router": _code_editor_module_schema({"routes": {"type": "array", "items": ANY_SCHEMA}}),
    "intent_search": _code_editor_module_schema({"query": STRING_SCHEMA}),
}

STUDIO_MODULE_SCHEMAS = {
    "actions_editor": _studio_module_schema(
        {
            "actions": {"type": "object", "additionalProperties": ANY_SCHEMA},
            "target_id": STRING_SCHEMA,
        }
    ),
    "asset_browser": _studio_module_schema(
        {
            "assets": {"type": "array", "items": ANY_SCHEMA},
            "selected_id": STRING_SCHEMA,
            "show_header": BOOL_SCHEMA,
        }
    ),
    "bindings_editor": _studio_module_schema(
        {
            "bindings": {"type": "object", "additionalProperties": ANY_SCHEMA},
            "target_id": STRING_SCHEMA,
        }
    ),
    "block_palette": _studio_module_schema(
        {
            "query": STRING_SCHEMA,
            "blocks": {"type": "array", "items": ANY_SCHEMA},
            "show_search": BOOL_SCHEMA,
        }
    ),
    "builder": _studio_module_schema(
        {
            "project": {"type": "object", "additionalProperties": ANY_SCHEMA},
            "blocks": {"type": "array", "items": ANY_SCHEMA},
            "assets": {"type": "array", "items": ANY_SCHEMA},
            "breakpoints": {"type": "array", "items": ANY_SCHEMA},
            "selected_id": STRING_SCHEMA,
        }
    ),
    "canvas": _studio_module_schema(
        {
            "selected_id": STRING_SCHEMA,
            "hovered_id": STRING_SCHEMA,
            "show_grid": BOOL_SCHEMA,
            "snap_to_grid": BOOL_SCHEMA,
            "grid_size": NUMBER_SCHEMA,
            "show_drop_hints": BOOL_SCHEMA,
        }
    ),
    "timeline_surface": _studio_module_schema(
        {
            "tracks": {"type": "array", "items": ANY_SCHEMA},
            "playhead_seconds": NUMBER_SCHEMA,
            "duration_seconds": NUMBER_SCHEMA,
            "pixels_per_second": NUMBER_SCHEMA,
            "snap_enabled": BOOL_SCHEMA,
        }
    ),
    "node_surface": _studio_module_schema(
        {
            "nodes": {"type": "array", "items": ANY_SCHEMA},
            "edges": {"type": "array", "items": ANY_SCHEMA},
            "world_width": NUMBER_SCHEMA,
            "world_height": NUMBER_SCHEMA,
        }
    ),
    "preview_surface": _studio_module_schema(
        {
            "title": STRING_SCHEMA,
            "subtitle": STRING_SCHEMA,
            "status": STRING_SCHEMA,
            "source": STRING_SCHEMA,
        }
    ),
    "component_palette": _studio_module_schema(
        {
            "query": STRING_SCHEMA,
            "blocks": {"type": "array", "items": ANY_SCHEMA},
            "show_search": BOOL_SCHEMA,
        }
    ),
    "inspector": _studio_module_schema(
        {
            "node": {"type": "object", "additionalProperties": ANY_SCHEMA},
            "show_raw": BOOL_SCHEMA,
            "show_actions": BOOL_SCHEMA,
            "show_bindings": BOOL_SCHEMA,
        }
    ),
    "outline_tree": _studio_module_schema(
        {
            "nodes": {"type": "array", "items": ANY_SCHEMA},
            "selected_id": STRING_SCHEMA,
            "dense": BOOL_SCHEMA,
        }
    ),
    "project_panel": _studio_module_schema(
        {
            "project": {"type": "object", "additionalProperties": ANY_SCHEMA},
        }
    ),
    "properties_panel": _studio_module_schema(
        {
            "schema": {"type": "object", "additionalProperties": ANY_SCHEMA},
            "value": {"type": "object", "additionalProperties": ANY_SCHEMA},
            "dense": BOOL_SCHEMA,
        }
    ),
    "responsive_toolbar": _studio_module_schema(
        {
            "breakpoints": {"type": "array", "items": ANY_SCHEMA},
            "current_id": STRING_SCHEMA,
        }
    ),
    "tokens_editor": _studio_module_schema(
        {
            "height": NUMBER_SCHEMA,
            "json": STRING_SCHEMA,
            "tokens": {"type": "object", "additionalProperties": ANY_SCHEMA},
        }
    ),
    "selection_tools": _studio_module_schema(
        {
            "items": {"type": "array", "items": ANY_SCHEMA},
            "active": STRING_SCHEMA,
        }
    ),
    "transform_box": _studio_module_schema(
        {
            "x": NUMBER_SCHEMA,
            "y": NUMBER_SCHEMA,
            "width": NUMBER_SCHEMA,
            "height": NUMBER_SCHEMA,
            "rotation": NUMBER_SCHEMA,
        }
    ),
    "transform_toolbar": _studio_module_schema(
        {
            "items": {"type": "array", "items": ANY_SCHEMA},
            "active": STRING_SCHEMA,
        }
    ),
}

TERMINAL_MODULE_SCHEMAS = {
    "capabilities": _terminal_module_schema(
        {
            "items": {"type": "array", "items": ANY_SCHEMA},
            "supports": {"type": "array", "items": STRING_SCHEMA},
        }
    ),
    "command_builder": _terminal_module_schema(
        {
            "command": STRING_SCHEMA,
            "args": {"type": "array", "items": STRING_SCHEMA},
            "cwd": STRING_SCHEMA,
        }
    ),
    "flow_gate": _terminal_module_schema(
        {
            "enabled": BOOL_SCHEMA,
            "blocked": BOOL_SCHEMA,
            "reason": STRING_SCHEMA,
        }
    ),
    "output_mapper": _terminal_module_schema(
        {
            "mode": STRING_SCHEMA,
            "items": {"type": "array", "items": ANY_SCHEMA},
        }
    ),
    "presets": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "progress": _terminal_module_schema({"value": NUMBER_SCHEMA, "total": NUMBER_SCHEMA}),
    "progress_view": _terminal_module_schema({"value": NUMBER_SCHEMA, "label": STRING_SCHEMA}),
    "prompt": _terminal_module_schema({"value": STRING_SCHEMA, "placeholder": STRING_SCHEMA}),
    "raw_view": _terminal_module_schema({"text": STRING_SCHEMA, "raw_text": STRING_SCHEMA}),
    "replay": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "session": _terminal_module_schema({"session_id": STRING_SCHEMA, "status": STRING_SCHEMA}),
    "stdin": _terminal_module_schema({"value": STRING_SCHEMA}),
    "stdin_injector": _terminal_module_schema({"value": STRING_SCHEMA}),
    "stream": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "stream_view": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "tabs": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "timeline": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "view": _terminal_module_schema({"mode": STRING_SCHEMA}),
    "workbench": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "process_bridge": _terminal_module_schema(
        {
            "command": STRING_SCHEMA,
            "args": {"type": "array", "items": STRING_SCHEMA},
            "cwd": STRING_SCHEMA,
            "env": {"type": "object", "additionalProperties": ANY_SCHEMA},
            "auto_start": BOOL_SCHEMA,
        }
    ),
    "execution_lane": _terminal_module_schema(
        {
            "items": {"type": "array", "items": ANY_SCHEMA},
            "active_id": STRING_SCHEMA,
        }
    ),
    "log_viewer": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
    "log_panel": _terminal_module_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
}

GALLERY_SCHEMA = _control_schema(
    {
        "schema_version": INTEGER_SCHEMA,
        "module": {"type": "string", "enum": GALLERY_MODULE_ENUM},
        "state": {"type": "string", "enum": GALLERY_STATE_ENUM},
        "custom_layout": BOOL_SCHEMA,
        "layout": STRING_SCHEMA,
        "manifest": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "registries": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "radius": NUMBER_SCHEMA,
        "items": {"type": "array", "items": ANY_SCHEMA},
        "spacing": NUMBER_SCHEMA,
        "run_spacing": NUMBER_SCHEMA,
        "tile_width": NUMBER_SCHEMA,
        "tile_height": NUMBER_SCHEMA,
        "selectable": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "events": {"type": "array", "items": {"type": "string", "enum": GALLERY_EVENT_ENUM}},
        "modules": {
            "type": "object",
            "properties": {name: GALLERY_MODULE_SCHEMAS[name] for name in GALLERY_MODULE_ENUM},
            "additionalProperties": False,
        },
        "toolbar": GALLERY_MODULE_SCHEMAS["toolbar"],
        "filter_bar": GALLERY_MODULE_SCHEMAS["filter_bar"],
        "grid_layout": GALLERY_MODULE_SCHEMAS["grid_layout"],
        "item_actions": GALLERY_MODULE_SCHEMAS["item_actions"],
        "item_badge": GALLERY_MODULE_SCHEMAS["item_badge"],
        "item_meta_row": GALLERY_MODULE_SCHEMAS["item_meta_row"],
        "item_preview": GALLERY_MODULE_SCHEMAS["item_preview"],
        "item_selectable": GALLERY_MODULE_SCHEMAS["item_selectable"],
        "item_tile": GALLERY_MODULE_SCHEMAS["item_tile"],
        "pagination": GALLERY_MODULE_SCHEMAS["pagination"],
        "section_header": GALLERY_MODULE_SCHEMAS["section_header"],
        "sort_bar": GALLERY_MODULE_SCHEMAS["sort_bar"],
        "empty_state": GALLERY_MODULE_SCHEMAS["empty_state"],
        "loading_skeleton": GALLERY_MODULE_SCHEMAS["loading_skeleton"],
        "search_bar": GALLERY_MODULE_SCHEMAS["search_bar"],
        "fonts": GALLERY_MODULE_SCHEMAS["fonts"],
        "font_picker": GALLERY_MODULE_SCHEMAS["font_picker"],
        "font_renderer": GALLERY_MODULE_SCHEMAS["font_renderer"],
        "audio": GALLERY_MODULE_SCHEMAS["audio"],
        "audio_picker": GALLERY_MODULE_SCHEMAS["audio_picker"],
        "audio_renderer": GALLERY_MODULE_SCHEMAS["audio_renderer"],
        "video": GALLERY_MODULE_SCHEMAS["video"],
        "video_picker": GALLERY_MODULE_SCHEMAS["video_picker"],
        "video_renderer": GALLERY_MODULE_SCHEMAS["video_renderer"],
        "image": GALLERY_MODULE_SCHEMAS["image"],
        "image_picker": GALLERY_MODULE_SCHEMAS["image_picker"],
        "image_renderer": GALLERY_MODULE_SCHEMAS["image_renderer"],
        "document": GALLERY_MODULE_SCHEMAS["document"],
        "document_picker": GALLERY_MODULE_SCHEMAS["document_picker"],
        "document_renderer": GALLERY_MODULE_SCHEMAS["document_renderer"],
        "item_drag_handle": GALLERY_MODULE_SCHEMAS["item_drag_handle"],
        "item_drop_target": GALLERY_MODULE_SCHEMAS["item_drop_target"],
        "item_reorder_handle": GALLERY_MODULE_SCHEMAS["item_reorder_handle"],
        "item_selection_checkbox": GALLERY_MODULE_SCHEMAS["item_selection_checkbox"],
        "item_selection_radio": GALLERY_MODULE_SCHEMAS["item_selection_radio"],
        "item_selection_switch": GALLERY_MODULE_SCHEMAS["item_selection_switch"],
        "apply": GALLERY_MODULE_SCHEMAS["apply"],
        "clear": GALLERY_MODULE_SCHEMAS["clear"],
        "select_all": GALLERY_MODULE_SCHEMAS["select_all"],
        "deselect_all": GALLERY_MODULE_SCHEMAS["deselect_all"],
        "apply_font": GALLERY_MODULE_SCHEMAS["apply_font"],
        "apply_image": GALLERY_MODULE_SCHEMAS["apply_image"],
        "set_as_wallpaper": GALLERY_MODULE_SCHEMAS["set_as_wallpaper"],
        "presets": GALLERY_MODULE_SCHEMAS["presets"],
        "skins": GALLERY_MODULE_SCHEMAS["skins"],
    }
)

SKINS_SCHEMA = _control_schema(
    {
        "schema_version": INTEGER_SCHEMA,
        "module": {"type": "string", "enum": SKINS_MODULE_ENUM},
        "state": {"type": "string", "enum": SKINS_STATE_ENUM},
        "custom_layout": BOOL_SCHEMA,
        "manifest": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "registries": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "radius": NUMBER_SCHEMA,
        "skins": {"type": "array", "items": ANY_SCHEMA},
        "selected_skin": STRING_SCHEMA,
        "presets": {"type": "array", "items": ANY_SCHEMA},
        "value": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "events": {"type": "array", "items": {"type": "string", "enum": SKINS_EVENT_ENUM}},
        "modules": {
            "type": "object",
            "properties": {name: SKINS_MODULE_SCHEMAS[name] for name in SKINS_MODULE_ENUM},
            "additionalProperties": False,
        },
        "selector": SKINS_MODULE_SCHEMAS["selector"],
        "preset": SKINS_MODULE_SCHEMAS["preset"],
        "editor": SKINS_MODULE_SCHEMAS["editor"],
        "preview": SKINS_MODULE_SCHEMAS["preview"],
        "apply": SKINS_MODULE_SCHEMAS["apply"],
        "clear": SKINS_MODULE_SCHEMAS["clear"],
        "token_mapper": SKINS_MODULE_SCHEMAS["token_mapper"],
        "create_skin": SKINS_MODULE_SCHEMAS["create_skin"],
        "edit_skin": SKINS_MODULE_SCHEMAS["edit_skin"],
        "delete_skin": SKINS_MODULE_SCHEMAS["delete_skin"],
        "effects": SKINS_MODULE_SCHEMAS["effects"],
        "particles": SKINS_MODULE_SCHEMAS["particles"],
        "shaders": SKINS_MODULE_SCHEMAS["shaders"],
        "materials": SKINS_MODULE_SCHEMAS["materials"],
        "icons": SKINS_MODULE_SCHEMAS["icons"],
        "fonts": SKINS_MODULE_SCHEMAS["fonts"],
        "colors": SKINS_MODULE_SCHEMAS["colors"],
        "background": SKINS_MODULE_SCHEMAS["background"],
        "border": SKINS_MODULE_SCHEMAS["border"],
        "shadow": SKINS_MODULE_SCHEMAS["shadow"],
        "outline": SKINS_MODULE_SCHEMAS["outline"],
        "animation": SKINS_MODULE_SCHEMAS["animation"],
        "transition": SKINS_MODULE_SCHEMAS["transition"],
        "interaction": SKINS_MODULE_SCHEMAS["interaction"],
        "layout": SKINS_MODULE_SCHEMAS["layout"],
        "responsive": SKINS_MODULE_SCHEMAS["responsive"],
        "effect_editor": SKINS_MODULE_SCHEMAS["effect_editor"],
        "particle_editor": SKINS_MODULE_SCHEMAS["particle_editor"],
        "shader_editor": SKINS_MODULE_SCHEMAS["shader_editor"],
        "material_editor": SKINS_MODULE_SCHEMAS["material_editor"],
        "icon_editor": SKINS_MODULE_SCHEMAS["icon_editor"],
        "font_editor": SKINS_MODULE_SCHEMAS["font_editor"],
        "color_editor": SKINS_MODULE_SCHEMAS["color_editor"],
        "background_editor": SKINS_MODULE_SCHEMAS["background_editor"],
        "border_editor": SKINS_MODULE_SCHEMAS["border_editor"],
        "shadow_editor": SKINS_MODULE_SCHEMAS["shadow_editor"],
        "outline_editor": SKINS_MODULE_SCHEMAS["outline_editor"],
    }
)

CODE_EDITOR_SCHEMA = _control_schema(
    {
        "schema_version": INTEGER_SCHEMA,
        "module": {"type": "string", "enum": CODE_EDITOR_MODULE_ENUM},
        "state": {"type": "string", "enum": CODE_EDITOR_STATE_ENUM},
        "custom_layout": BOOL_SCHEMA,
        "layout": STRING_SCHEMA,
        "manifest": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "registries": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "events": {"type": "array", "items": {"type": "string", "enum": CODE_EDITOR_EVENT_ENUM}},
        "modules": {
            "type": "object",
            "properties": {name: CODE_EDITOR_MODULE_SCHEMAS[name] for name in CODE_EDITOR_MODULE_ENUM},
            "additionalProperties": False,
        },
        "value": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "code": STRING_SCHEMA,
        "language": STRING_SCHEMA,
        "theme": STRING_SCHEMA,
        "read_only": BOOL_SCHEMA,
        "wrap": BOOL_SCHEMA,
        "word_wrap": BOOL_SCHEMA,
        "show_gutter": BOOL_SCHEMA,
        "line_numbers": BOOL_SCHEMA,
        "show_minimap": BOOL_SCHEMA,
        "minimap": BOOL_SCHEMA,
        "tab_size": INTEGER_SCHEMA,
        "font_size": NUMBER_SCHEMA,
        "font_family": STRING_SCHEMA,
        "cursor_color": COLOR_SCHEMA,
        "selection_color": COLOR_SCHEMA,
        "editor_bg": COLOR_SCHEMA,
        "editor_background": COLOR_SCHEMA,
        "editor_text_color": COLOR_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "engine": STRING_SCHEMA,
        "webview_engine": STRING_SCHEMA,
        "document_uri": STRING_SCHEMA,
        "documents": {"type": "array", "items": ANY_SCHEMA},
        "glyph_margin": BOOL_SCHEMA,
        "show_breakpoints": BOOL_SCHEMA,
        "render_whitespace": STRING_SCHEMA,
        "format_on_type": BOOL_SCHEMA,
        "format_on_paste": BOOL_SCHEMA,
        "emit_on_change": BOOL_SCHEMA,
        "debounce_ms": INTEGER_SCHEMA,
        **{name: CODE_EDITOR_MODULE_SCHEMAS[name] for name in CODE_EDITOR_MODULE_ENUM},
    }
)

STUDIO_SCHEMA = _control_schema(
    {
        "schema_version": INTEGER_SCHEMA,
        "module": {"type": "string", "enum": STUDIO_MODULE_ENUM},
        "state": {"type": "string", "enum": STUDIO_STATE_ENUM},
        "custom_layout": BOOL_SCHEMA,
        "layout": STRING_SCHEMA,
        "show_modules": BOOL_SCHEMA,
        "show_chrome": BOOL_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "events": {"type": "array", "items": {"type": "string", "enum": STUDIO_EVENT_ENUM}},
        "modules": {
            "type": "object",
            "properties": {name: STUDIO_MODULE_SCHEMAS[name] for name in STUDIO_MODULE_ENUM},
            "additionalProperties": False,
        },
        **{name: STUDIO_MODULE_SCHEMAS[name] for name in STUDIO_MODULE_ENUM},
    }
)

ROW_SCHEMA = _control_schema(
    {
        "spacing": NUMBER_SCHEMA,
        "main_axis": STRING_SCHEMA,
        "cross_axis": STRING_SCHEMA,
    }
)

COLUMN_SCHEMA = _control_schema(
    {
        "spacing": NUMBER_SCHEMA,
        "main_axis": STRING_SCHEMA,
        "cross_axis": STRING_SCHEMA,
    }
)

STACK_SCHEMA = _control_schema(
    {
        "alignment": ALIGNMENT_SCHEMA,
        "fit": STRING_SCHEMA,
        "clip": BOOL_SCHEMA,
    }
)

WRAP_SCHEMA = _control_schema(
    {
        "spacing": NUMBER_SCHEMA,
        "run_spacing": NUMBER_SCHEMA,
        "alignment": STRING_SCHEMA,
        "run_alignment": STRING_SCHEMA,
        "cross_axis": STRING_SCHEMA,
        "direction": STRING_SCHEMA,
    }
)

GRID_SCHEMA = _control_schema(
    {
        "columns": INTEGER_SCHEMA,
        "spacing": NUMBER_SCHEMA,
        "run_spacing": NUMBER_SCHEMA,
        "child_aspect_ratio": NUMBER_SCHEMA,
        "scrollable": BOOL_SCHEMA,
        "virtual": BOOL_SCHEMA,
    }
)

SCROLL_VIEW_SCHEMA = _control_schema(
    {
        "direction": STRING_SCHEMA,
        "content_padding": PADDING_SCHEMA,
        "reverse": BOOL_SCHEMA,
        "initial_offset": NUMBER_SCHEMA,
    }
)

EXPANDED_SCHEMA = _control_schema(
    {
        "flex": INTEGER_SCHEMA,
        "fit": STRING_SCHEMA,
    }
)

SPACER_SCHEMA = _control_schema(
    {
        "size": NUMBER_SCHEMA,
    }
)

MARKDOWN_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "selectable": BOOL_SCHEMA,
        "scrollable": BOOL_SCHEMA,
    }
)

HTML_SCHEMA = _control_schema(
    {
        "html": STRING_SCHEMA,
        "value": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "html_file": STRING_SCHEMA,
        "base_url": STRING_SCHEMA,
    }
)

CODE_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "language": STRING_SCHEMA,
        "wrap": BOOL_SCHEMA,
        "selectable": BOOL_SCHEMA,
    }
)

JSON_VIEW_SCHEMA = _control_schema(
    {
        "value": ANY_SCHEMA,
        "json": ANY_SCHEMA,
        "selectable": BOOL_SCHEMA,
    }
)

JSON_TREE_SCHEMA = _control_schema(
    {
        "value": ANY_SCHEMA,
        "json": ANY_SCHEMA,
        "selected_path": STRING_SCHEMA,
        "expand_all": BOOL_SCHEMA,
        "show_types": BOOL_SCHEMA,
        "show_counts": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "max_depth": INTEGER_SCHEMA,
    }
)

JSON_INSPECTOR_SCHEMA = _control_schema(
    {
        "value": ANY_SCHEMA,
        "json": ANY_SCHEMA,
        "path": STRING_SCHEMA,
        "schema": ANY_SCHEMA,
        "show_path": BOOL_SCHEMA,
        "show_type": BOOL_SCHEMA,
        "show_size": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "max_items": INTEGER_SCHEMA,
    }
)

JSON_TABLE_SCHEMA = _control_schema(
    {
        "value": ANY_SCHEMA,
        "json": ANY_SCHEMA,
        "max_rows": INTEGER_SCHEMA,
        "show_index": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

JSON_DIFF_SCHEMA = _control_schema(
    {
        "before": ANY_SCHEMA,
        "after": ANY_SCHEMA,
        "left": ANY_SCHEMA,
        "right": ANY_SCHEMA,
        "max_depth": INTEGER_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

JSON_EDITOR_SCHEMA = _control_schema(
    {
        "value": ANY_SCHEMA,
        "json": ANY_SCHEMA,
        "text": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "read_only": BOOL_SCHEMA,
        "show_toolbar": BOOL_SCHEMA,
        "emit_on_change": BOOL_SCHEMA,
        "renderer": STRING_SCHEMA,
        "engine": STRING_SCHEMA,
    }
)

JSON_PATH_PICKER_SCHEMA = _control_schema(
    {
        "value": ANY_SCHEMA,
        "json": ANY_SCHEMA,
        "path": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "show_tree": BOOL_SCHEMA,
        "expand_all": BOOL_SCHEMA,
        "max_matches": INTEGER_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

PROGRESS_SCHEMA = _control_schema(
    {
        "value": NUMBER_SCHEMA,
        "label": STRING_SCHEMA,
        "variant": STRING_SCHEMA,
        "color": COLOR_SCHEMA,
        "background_color": COLOR_SCHEMA,
        "stroke_width": NUMBER_SCHEMA,
    }
)

EMOJI_ICON_SCHEMA = _control_schema(
    {
        "emoji": STRING_SCHEMA,
        "value": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "fallback": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "text": STRING_SCHEMA,
        "size": NUMBER_SCHEMA,
        "color": COLOR_SCHEMA,
        "text_color": COLOR_SCHEMA,
        "fgcolor": COLOR_SCHEMA,
        "variant": STRING_SCHEMA,
        "outline_width": NUMBER_SCHEMA,
        "outline_color": COLOR_SCHEMA,
        "stroke_width": NUMBER_SCHEMA,
        "stroke_color": COLOR_SCHEMA,
        "shadow_color": COLOR_SCHEMA,
        "shadow_blur": NUMBER_SCHEMA,
        "shadow_dx": NUMBER_SCHEMA,
        "shadow_dy": NUMBER_SCHEMA,
        "glow_color": COLOR_SCHEMA,
        "glow_blur": NUMBER_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "bg_color": COLOR_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "shape": STRING_SCHEMA,
        "content_padding": PADDING_SCHEMA,
        "inner_padding": PADDING_SCHEMA,
        "icon_padding": PADDING_SCHEMA,
        "animation": {"type": "object"},
    }
)

COLOR_PICKER_SCHEMA = _control_schema(
    {
        "value": COLOR_SCHEMA,
        "color": COLOR_SCHEMA,
        "mode": STRING_SCHEMA,
        "picker_mode": STRING_SCHEMA,
        "show_alpha": BOOL_SCHEMA,
        "alpha": BOOL_SCHEMA,
        "presets": {"type": "array", "items": COLOR_SCHEMA},
        "emit_on_change": BOOL_SCHEMA,
        "show_actions": BOOL_SCHEMA,
        "show_input": BOOL_SCHEMA,
        "show_hex": BOOL_SCHEMA,
        "show_presets": BOOL_SCHEMA,
        "preset_size": NUMBER_SCHEMA,
        "preset_spacing": NUMBER_SCHEMA,
        "preview_height": NUMBER_SCHEMA,
        "input_label": STRING_SCHEMA,
        "input_placeholder": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "commit_text": STRING_SCHEMA,
        "cancel_text": STRING_SCHEMA,
    }
)

COLOR_SWATCH_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "color": COLOR_SCHEMA,
        "value": COLOR_SCHEMA,
    },
    "additionalProperties": True,
}

COLOR_SWATCH_GRID_SCHEMA = _control_schema(
    {
        "swatches": {"type": "array", "items": COLOR_SWATCH_SCHEMA},
        "selected_id": STRING_SCHEMA,
        "selected_index": INTEGER_SCHEMA,
        "columns": INTEGER_SCHEMA,
        "size": NUMBER_SCHEMA,
        "spacing": NUMBER_SCHEMA,
        "show_labels": BOOL_SCHEMA,
        "show_add": BOOL_SCHEMA,
        "show_remove": BOOL_SCHEMA,
        "groups": {"type": "array", "items": ANY_SCHEMA},
        "group_by": STRING_SCHEMA,
        "responsive": BOOL_SCHEMA,
    }
)

GRADIENT_STOP_SCHEMA = {
    "type": "object",
    "properties": {
        "position": NUMBER_SCHEMA,
        "color": COLOR_SCHEMA,
    },
    "additionalProperties": True,
}

GRADIENT_EDITOR_SCHEMA = _control_schema(
    {
        "stops": {"type": "array", "items": GRADIENT_STOP_SCHEMA},
        "angle": NUMBER_SCHEMA,
        "show_angle": BOOL_SCHEMA,
        "show_add": BOOL_SCHEMA,
        "show_remove": BOOL_SCHEMA,
        "live_preview": BOOL_SCHEMA,
        "export_format": STRING_SCHEMA,
    }
)

HISTOGRAM_SERIES_SCHEMA = {
    "type": "object",
    "properties": {
        "values": {"type": "array", "items": NUMBER_SCHEMA},
        "color": COLOR_SCHEMA,
    },
    "additionalProperties": True,
}

HISTOGRAM_VIEW_SCHEMA = _control_schema(
    {
        "values": {"type": "array", "items": NUMBER_SCHEMA},
        "series": {"type": "array", "items": HISTOGRAM_SERIES_SCHEMA},
        "color": COLOR_SCHEMA,
        "bar_width": NUMBER_SCHEMA,
    }
)

CROP_BOX_SCHEMA = _control_schema(
    {
        "rect": RECT_SCHEMA,
        "shade_color": COLOR_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

RULER_GUIDES_SCHEMA = _control_schema(
    {
        "h_guides": {"type": "array", "items": NUMBER_SCHEMA},
        "v_guides": {"type": "array", "items": NUMBER_SCHEMA},
        "ruler_size": NUMBER_SCHEMA,
        "show_labels": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "guide_color": COLOR_SCHEMA,
    }
)

ADJUSTMENT_ITEM_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "value": NUMBER_SCHEMA,
        "min": NUMBER_SCHEMA,
        "max": NUMBER_SCHEMA,
        "step": NUMBER_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "show_toggle": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

ADJUSTMENT_PANEL_SCHEMA = _control_schema(
    {
        "adjustments": {"type": "array", "items": ADJUSTMENT_ITEM_SCHEMA},
        "title": STRING_SCHEMA,
        "show_reset": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

CURVE_POINT_SCHEMA = {
    "type": "object",
    "properties": {
        "x": NUMBER_SCHEMA,
        "y": NUMBER_SCHEMA,
    },
    "additionalProperties": True,
}

CURVE_EDITOR_SCHEMA = _control_schema(
    {
        "points": {"type": "array", "items": CURVE_POINT_SCHEMA},
        "color": COLOR_SCHEMA,
        "show_grid": BOOL_SCHEMA,
        "show_points": BOOL_SCHEMA,
        "allow_add": BOOL_SCHEMA,
        "allow_remove": BOOL_SCHEMA,
        "line_width": NUMBER_SCHEMA,
        "point_size": NUMBER_SCHEMA,
        "height": NUMBER_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

HISTOGRAM_OVERLAY_SCHEMA = _control_schema(
    {
        "values": {"type": "array", "items": NUMBER_SCHEMA},
        "series": {"type": "array", "items": HISTOGRAM_SERIES_SCHEMA},
        "color": COLOR_SCHEMA,
        "bar_width": NUMBER_SCHEMA,
        "height": NUMBER_SCHEMA,
        "width": NUMBER_SCHEMA,
        "opacity": NUMBER_SCHEMA,
        "alignment": ALIGNMENT_SCHEMA,
        "padding": PADDING_SCHEMA,
    }
)

BRUSH_PANEL_SCHEMA = _control_schema(
    {
        "size": NUMBER_SCHEMA,
        "min_size": NUMBER_SCHEMA,
        "max_size": NUMBER_SCHEMA,
        "hardness": NUMBER_SCHEMA,
        "opacity": NUMBER_SCHEMA,
        "flow": NUMBER_SCHEMA,
        "spacing": NUMBER_SCHEMA,
        "smoothing": NUMBER_SCHEMA,
        "shape": STRING_SCHEMA,
        "shapes": {"type": "array", "items": STRING_SCHEMA},
        "show_preview": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

LAYER_MASK_EDITOR_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "src": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "inverted": BOOL_SCHEMA,
        "show_toggle": BOOL_SCHEMA,
        "show_invert": BOOL_SCHEMA,
        "show_clear": BOOL_SCHEMA,
        "show_edit": BOOL_SCHEMA,
        "preview_size": NUMBER_SCHEMA,
        "background": COLOR_SCHEMA,
    }
)

BLEND_MODE_PICKER_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "options": {"type": "array", "items": STRING_SCHEMA},
        "items": {"type": "array", "items": ANY_SCHEMA},
        "label": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
        "preview": BOOL_SCHEMA,
        "sample": {"type": "object"},
        "enabled": BOOL_SCHEMA,
    }
)

HISTORY_ENTRY_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "timestamp": STRING_SCHEMA,
        "active": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

HISTORY_STACK_SCHEMA = _control_schema(
    {
        "entries": {"type": "array", "items": HISTORY_ENTRY_SCHEMA},
        "selected_id": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
        "show_index": BOOL_SCHEMA,
        "show_timestamp": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

TRANSFORM_ACTION_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "icon": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

TRANSFORM_TOOLBAR_SCHEMA = _control_schema(
    {
        "actions": {"type": "array", "items": TRANSFORM_ACTION_SCHEMA},
        "active_id": STRING_SCHEMA,
        "show_labels": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

GUIDE_ITEM_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "axis": STRING_SCHEMA,
        "position": NUMBER_SCHEMA,
        "min": NUMBER_SCHEMA,
        "max": NUMBER_SCHEMA,
        "locked": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

GUIDES_MANAGER_SCHEMA = _control_schema(
    {
        "guides": {"type": "array", "items": GUIDE_ITEM_SCHEMA},
        "show_add": BOOL_SCHEMA,
        "show_remove": BOOL_SCHEMA,
        "show_lock": BOOL_SCHEMA,
        "show_axis": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

RULERS_OVERLAY_SCHEMA = _control_schema(
    {
        "ruler_size": NUMBER_SCHEMA,
        "tick_spacing": NUMBER_SCHEMA,
        "major_tick": INTEGER_SCHEMA,
        "show_labels": BOOL_SCHEMA,
        "zoom": NUMBER_SCHEMA,
        "origin": OFFSET_SCHEMA,
        "background": COLOR_SCHEMA,
        "tick_color": COLOR_SCHEMA,
        "label_color": COLOR_SCHEMA,
    }
)

SELECTION_TOOL_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "icon": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

SELECTION_TOOLS_SCHEMA = _control_schema(
    {
        "tools": {"type": "array", "items": SELECTION_TOOL_SCHEMA},
        "selected_id": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
        "show_labels": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

PRESET_ITEM_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "thumbnail": STRING_SCHEMA,
        "src": STRING_SCHEMA,
        "color": COLOR_SCHEMA,
        "description": STRING_SCHEMA,
    },
    "additionalProperties": True,
}

PRESET_GALLERY_SCHEMA = _control_schema(
    {
        "presets": {"type": "array", "items": PRESET_ITEM_SCHEMA},
        "selected_id": STRING_SCHEMA,
        "columns": INTEGER_SCHEMA,
        "spacing": NUMBER_SCHEMA,
        "tile_size": NUMBER_SCHEMA,
        "show_labels": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

EXPORT_PANEL_SCHEMA = _control_schema(
    {
        "formats": {"type": "array", "items": STRING_SCHEMA},
        "format": STRING_SCHEMA,
        "width": NUMBER_SCHEMA,
        "height": NUMBER_SCHEMA,
        "quality": NUMBER_SCHEMA,
        "show_size": BOOL_SCHEMA,
        "show_quality": BOOL_SCHEMA,
        "show_export": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

INFO_ITEM_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "value": STRING_SCHEMA,
        "icon": STRING_SCHEMA,
        "color": COLOR_SCHEMA,
        "clickable": BOOL_SCHEMA,
    },
    "additionalProperties": True,
}

INFO_BAR_SCHEMA = _control_schema(
    {
        "items": {"type": "array", "items": INFO_ITEM_SCHEMA},
        "dense": BOOL_SCHEMA,
    }
)

MINI_MAP_SCHEMA = _control_schema(
    {
        "viewport": RECT_SCHEMA,
        "background": COLOR_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "viewport_color": COLOR_SCHEMA,
        "show_viewport": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

STUDIO_CANVAS_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "selected_id": STRING_SCHEMA,
        "hovered_id": STRING_SCHEMA,
        "allow_drop": BOOL_SCHEMA,
        "show_grid": BOOL_SCHEMA,
        "snap_to_grid": BOOL_SCHEMA,
        "grid_size": NUMBER_SCHEMA,
        "show_drop_hints": BOOL_SCHEMA,
        "use_native_drag": BOOL_SCHEMA,
        "expand_child": BOOL_SCHEMA,
    }
)

STUDIO_TIMELINE_SURFACE_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "tracks": {"type": "array", "items": {"type": "object"}},
        "playhead_seconds": NUMBER_SCHEMA,
        "duration_seconds": NUMBER_SCHEMA,
        "pixels_per_second": NUMBER_SCHEMA,
        "snap_enabled": BOOL_SCHEMA,
    }
)

STUDIO_NODE_SURFACE_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "nodes": {"type": "array", "items": {"type": "object"}},
        "edges": {"type": "array", "items": {"type": "object"}},
        "world_width": NUMBER_SCHEMA,
        "world_height": NUMBER_SCHEMA,
    }
)

STUDIO_PREVIEW_SURFACE_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "title": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "status": STRING_SCHEMA,
        "source": STRING_SCHEMA,
    }
)

STUDIO_TOKENS_EDITOR_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "height": NUMBER_SCHEMA,
        "json": STRING_SCHEMA,
        "tokens": {"type": "object"},
    }
)

STUDIO_BUILDER_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "project": {"type": "object"},
        "blocks": {"type": "array", "items": {"type": "object"}},
        "assets": {"type": "array", "items": {"type": "object"}},
        "breakpoints": {"type": "array", "items": {"type": "object"}},
        "selected_id": STRING_SCHEMA,
        "show_palette": BOOL_SCHEMA,
        "show_inspector": BOOL_SCHEMA,
        "show_assets": BOOL_SCHEMA,
        "show_actions": BOOL_SCHEMA,
        "show_bindings": BOOL_SCHEMA,
        "show_responsive": BOOL_SCHEMA,
        "show_project_panel": BOOL_SCHEMA,
        "palette_width": NUMBER_SCHEMA,
        "inspector_width": NUMBER_SCHEMA,
        "bottom_panel_height": NUMBER_SCHEMA,
        "show_grid": BOOL_SCHEMA,
        "snap_to_grid": BOOL_SCHEMA,
        "grid_size": NUMBER_SCHEMA,
        "show_drop_hints": BOOL_SCHEMA,
        "sync_mode": STRING_SCHEMA,
        "use_native_drag": BOOL_SCHEMA,
        "expand_canvas_child": BOOL_SCHEMA,
    }
)

STUDIO_BLOCK_PALETTE_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "query": STRING_SCHEMA,
        "blocks": {"type": "array", "items": {"type": "object"}},
        "show_search": BOOL_SCHEMA,
        "title": STRING_SCHEMA,
        "use_native_drag": BOOL_SCHEMA,
    }
)

STUDIO_INSPECTOR_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "node": {"type": "object"},
        "show_raw": BOOL_SCHEMA,
        "show_actions": BOOL_SCHEMA,
        "show_bindings": BOOL_SCHEMA,
    }
)

STUDIO_ASSET_BROWSER_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "assets": {"type": "array", "items": {"type": "object"}},
        "selected_id": STRING_SCHEMA,
        "show_header": BOOL_SCHEMA,
    }
)

STUDIO_ACTIONS_EDITOR_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "actions": {"type": "object"},
        "target_id": STRING_SCHEMA,
    }
)

STUDIO_BINDINGS_EDITOR_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "bindings": {"type": "object"},
        "target_id": STRING_SCHEMA,
    }
)

STUDIO_RESPONSIVE_TOOLBAR_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "breakpoints": {"type": "array", "items": {"type": "object"}},
        "current_id": STRING_SCHEMA,
    }
)

STUDIO_PROJECT_PANEL_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "project": {"type": "object"},
    }
)

STUDIO_OUTLINE_TREE_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "nodes": {"type": "array", "items": {"type": "object"}},
        "selected_id": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

STUDIO_PROPERTIES_PANEL_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "schema": {"type": "object"},
        "value": {"type": "object"},
        "title": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

MARKDOWN_VIEW_SCHEMA = MARKDOWN_SCHEMA
HTML_VIEW_SCHEMA = HTML_SCHEMA

CODE_BLOCK_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "language": STRING_SCHEMA,
        "wrap": BOOL_SCHEMA,
        "selectable": BOOL_SCHEMA,
        "show_header": BOOL_SCHEMA,
        "show_copy": BOOL_SCHEMA,
        "show_language": BOOL_SCHEMA,
        "show_wrap_toggle": BOOL_SCHEMA,
    }
)

ARTIFACT_CARD_SCHEMA = _control_schema(
    {
        "title": STRING_SCHEMA,
        "message": STRING_SCHEMA,
        "variant": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "action_label": STRING_SCHEMA,
        "clickable": BOOL_SCHEMA,
    }
)

MESSAGE_BUBBLE_SCHEMA = _control_schema(
    {
        "text": STRING_SCHEMA,
        "value": STRING_SCHEMA,
        "role": STRING_SCHEMA,
        "align": STRING_SCHEMA,
        "status": STRING_SCHEMA,
        "timestamp": STRING_SCHEMA,
        "markdown": BOOL_SCHEMA,
        "show_role": BOOL_SCHEMA,
        "show_name": BOOL_SCHEMA,
        "show_avatar": BOOL_SCHEMA,
        "grouped": BOOL_SCHEMA,
        "name": STRING_SCHEMA,
        "avatar": STRING_SCHEMA,
        "clickable": BOOL_SCHEMA,
        "padding": {"type": "array"},
        "radius": NUMBER_SCHEMA,
        "bgcolor": STRING_SCHEMA,
        "text_color": STRING_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "border_color": COLOR_SCHEMA,
    }
)

CHAT_THREAD_SCHEMA = _control_schema(
    {
        "messages": {"type": "array", "items": ANY_SCHEMA},
        "spacing": NUMBER_SCHEMA,
        "padding": {"type": "array"},
        "reverse": BOOL_SCHEMA,
        "scrollable": BOOL_SCHEMA,
        "align": STRING_SCHEMA,
        "group_messages": BOOL_SCHEMA,
        "show_timestamps": BOOL_SCHEMA,
        "auto_scroll": BOOL_SCHEMA,
        "input_placeholder": STRING_SCHEMA,
    }
)

AVATAR_STACK_SCHEMA = _control_schema(
    {
        "avatars": {"type": "array", "items": {"type": "object"}},
        "size": NUMBER_SCHEMA,
        "overlap": NUMBER_SCHEMA,
        "max": INTEGER_SCHEMA,
        "max_visible": INTEGER_SCHEMA,
        "max_count": INTEGER_SCHEMA,
        "overflow_label": STRING_SCHEMA,
        "stack_order": STRING_SCHEMA,
        "expand_on_hover": BOOL_SCHEMA,
    }
)

MESSAGE_META_SCHEMA = _control_schema(
    {
        "timestamp": STRING_SCHEMA,
        "status": STRING_SCHEMA,
        "edited": BOOL_SCHEMA,
        "pinned": BOOL_SCHEMA,
        "align": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

ATTACHMENT_TILE_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "type": STRING_SCHEMA,
        "src": STRING_SCHEMA,
        "clickable": BOOL_SCHEMA,
        "show_remove": BOOL_SCHEMA,
    }
)

REACTION_BAR_SCHEMA = _control_schema(
    {
        "reactions": {"type": "array", "items": {"type": "object"}},
        "show_add": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "selected_color": STRING_SCHEMA,
    }
)

QUOTED_MESSAGE_SCHEMA = _control_schema(
    {
        "author": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "max_lines": INTEGER_SCHEMA,
        "accent_color": STRING_SCHEMA,
    }
)

TYPING_INDICATOR_SCHEMA = _control_schema(
    {
        "size": NUMBER_SCHEMA,
        "color": STRING_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
    }
)

MESSAGE_COMPOSER_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "show_attachments": BOOL_SCHEMA,
        "show_attach": BOOL_SCHEMA,
        "emit_on_change": BOOL_SCHEMA,
        "clear_on_send": BOOL_SCHEMA,
        "min_lines": INTEGER_SCHEMA,
        "max_lines": INTEGER_SCHEMA,
        "send_label": STRING_SCHEMA,
        "attachments": {"type": "array", "items": {"type": "object"}},
    }
)

MENTION_PILL_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "color": STRING_SCHEMA,
        "text_color": STRING_SCHEMA,
        "clickable": BOOL_SCHEMA,
    }
)

MESSAGE_DIVIDER_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "padding": {"type": "array"},
        "color": STRING_SCHEMA,
        "text_color": STRING_SCHEMA,
    }
)

PROMPT_COMPOSER_SCHEMA = MESSAGE_COMPOSER_SCHEMA

GLOW_EFFECT_SCHEMA = _control_schema(
    {
        "color": COLOR_SCHEMA,
        "blur": NUMBER_SCHEMA,
        "spread": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "offset_x": NUMBER_SCHEMA,
        "offset_y": NUMBER_SCHEMA,
        "clip": BOOL_SCHEMA,
        "intensity": NUMBER_SCHEMA,
        "direction": OFFSET_SCHEMA,
        "animated": BOOL_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
    }
)

NEON_EDGE_SCHEMA = _control_schema(
    {
        "color": COLOR_SCHEMA,
        "width": NUMBER_SCHEMA,
        "glow": NUMBER_SCHEMA,
        "spread": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "animated": BOOL_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
    }
)

GLASS_BLUR_SCHEMA = _control_schema(
    {
        "blur": NUMBER_SCHEMA,
        "opacity": NUMBER_SCHEMA,
        "color": COLOR_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "noise_opacity": NUMBER_SCHEMA,
        "border_glow": COLOR_SCHEMA,
    }
)

GRAIN_OVERLAY_SCHEMA = _control_schema(
    {
        "opacity": NUMBER_SCHEMA,
        "density": NUMBER_SCHEMA,
        "seed": INTEGER_SCHEMA,
        "color": COLOR_SCHEMA,
        "animated": BOOL_SCHEMA,
        "fps": INTEGER_SCHEMA,
    }
)

GRADIENT_SWEEP_SCHEMA = _control_schema(
    {
        "colors": {"type": "array", "items": COLOR_SCHEMA},
        "stops": {"type": "array", "items": NUMBER_SCHEMA},
        "duration_ms": INTEGER_SCHEMA,
        "duration": INTEGER_SCHEMA,
        "angle": NUMBER_SCHEMA,
        "start_angle": NUMBER_SCHEMA,
        "end_angle": NUMBER_SCHEMA,
        "opacity": NUMBER_SCHEMA,
        "loop": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "playing": BOOL_SCHEMA,
    }
)

SHIMMER_SCHEMA = _control_schema(
    {
        "base_color": STRING_SCHEMA,
        "highlight_color": STRING_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
        "angle": NUMBER_SCHEMA,
        "opacity": NUMBER_SCHEMA,
    }
)

SHADOW_STACK_SCHEMA = _control_schema(
    {
        "shadows": {"type": "array", "items": {"type": "object"}},
        "radius": NUMBER_SCHEMA,
    }
)

OUTLINE_REVEAL_SCHEMA = _control_schema(
    {
        "color": STRING_SCHEMA,
        "width": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "progress": NUMBER_SCHEMA,
        "animate": BOOL_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
    }
)

RIPPLE_BURST_SCHEMA = _control_schema(
    {
        "color": STRING_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
    }
)

CONFETTI_BURST_SCHEMA = _control_schema(
    {
        "colors": {"type": "array", "items": COLOR_SCHEMA},
        "count": INTEGER_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
        "duration": INTEGER_SCHEMA,
        "gravity": NUMBER_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "loop": BOOL_SCHEMA,
        "emit_on_complete": BOOL_SCHEMA,
        "hide_button": BOOL_SCHEMA,
    }
)

NOISE_DISPLACEMENT_SCHEMA = _control_schema(
    {
        "strength": NUMBER_SCHEMA,
        "speed": NUMBER_SCHEMA,
        "axis": STRING_SCHEMA,
        "seed": INTEGER_SCHEMA,
        "animated": BOOL_SCHEMA,
        "loop": BOOL_SCHEMA,
        "play": BOOL_SCHEMA,
        "autoplay": BOOL_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
    }
)

PARALLAX_OFFSET_SCHEMA = _control_schema(
    {
        "x": NUMBER_SCHEMA,
        "y": NUMBER_SCHEMA,
        "depth": NUMBER_SCHEMA,
    }
)

PARALLAX_SCHEMA = _control_schema(
    {
        "max_offset": NUMBER_SCHEMA,
        "reset_on_exit": BOOL_SCHEMA,
        "depths": {"type": "array", "items": NUMBER_SCHEMA},
    }
)

LIQUID_MORPH_SCHEMA = _control_schema(
    {
        "min_radius": NUMBER_SCHEMA,
        "max_radius": NUMBER_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
        "animate": BOOL_SCHEMA,
    }
)

CHROMATIC_SHIFT_SCHEMA = _control_schema(
    {
        "shift": NUMBER_SCHEMA,
        "opacity": NUMBER_SCHEMA,
        "axis": STRING_SCHEMA,
        "red": COLOR_SCHEMA,
        "blue": COLOR_SCHEMA,
    }
)

BORDER_SCHEMA = _control_schema(
    {
        "color": COLOR_SCHEMA,
        "width": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "side": STRING_SCHEMA,
        "sides": {"type": "object", "additionalProperties": True},
        "animated": BOOL_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
    }
)

BORDER_SIDE_SCHEMA = _control_schema(
    {
        "side": STRING_SCHEMA,
        "color": COLOR_SCHEMA,
        "width": NUMBER_SCHEMA,
        "length": NUMBER_SCHEMA,
        "top": {"type": "object", "additionalProperties": True},
        "right": {"type": "object", "additionalProperties": True},
        "bottom": {"type": "object", "additionalProperties": True},
        "left": {"type": "object", "additionalProperties": True},
        "animated": BOOL_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
    }
)

BUTTON_STYLE_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "options": {"type": "array", "items": ANY_SCHEMA},
        "items": {"type": "array", "items": ANY_SCHEMA},
        "base": {"type": "object", "additionalProperties": True},
        "hover": {"type": "object", "additionalProperties": True},
        "pressed": {"type": "object", "additionalProperties": True},
        "disabled": {"type": "object", "additionalProperties": True},
        "focus_ring": {"type": "object", "additionalProperties": True},
        "motion_behavior": {"type": "object", "additionalProperties": True},
    }
)

SCANLINE_OVERLAY_SCHEMA = _control_schema(
    {
        "spacing": NUMBER_SCHEMA,
        "thickness": NUMBER_SCHEMA,
        "opacity": NUMBER_SCHEMA,
        "color": STRING_SCHEMA,
    }
)

PIXELATE_SCHEMA = _control_schema(
    {
        "pixel_size": NUMBER_SCHEMA,
    }
)

VIGNETTE_SCHEMA = _control_schema(
    {
        "intensity": NUMBER_SCHEMA,
        "color": STRING_SCHEMA,
    }
)

TILT_HOVER_SCHEMA = _control_schema(
    {
        "max_angle": NUMBER_SCHEMA,
        "perspective": NUMBER_SCHEMA,
        "scale": NUMBER_SCHEMA,
    }
)

MORPHING_BORDER_SCHEMA = _control_schema(
    {
        "min_radius": NUMBER_SCHEMA,
        "max_radius": NUMBER_SCHEMA,
        "duration_ms": INTEGER_SCHEMA,
        "animate": BOOL_SCHEMA,
        "color": STRING_SCHEMA,
        "width": NUMBER_SCHEMA,
    }
)

SEARCH_BOX_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "show_clear": BOOL_SCHEMA,
    }
)

SEARCH_BAR_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "query": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "hint": STRING_SCHEMA,
        "suggestions": {"type": "array", "items": ANY_SCHEMA},
        "filters": {"type": "array", "items": ANY_SCHEMA},
        "debounce_ms": INTEGER_SCHEMA,
        "show_clear": BOOL_SCHEMA,
        "show_suggestions": BOOL_SCHEMA,
        "max_suggestions": INTEGER_SCHEMA,
        "loading": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

SEARCH_ITEM_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "title": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "description": STRING_SCHEMA,
        "group": STRING_SCHEMA,
        "scope": STRING_SCHEMA,
        "icon": STRING_SCHEMA,
        "emoji": STRING_SCHEMA,
        "badge": STRING_SCHEMA,
        "shortcut": STRING_SCHEMA,
        "image": STRING_SCHEMA,
        "kind": STRING_SCHEMA,
        "tags": {"type": "array", "items": STRING_SCHEMA},
        "keywords": {"type": "array", "items": STRING_SCHEMA},
        "meta": {"type": "object"},
        "score": NUMBER_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "payload": ANY_SCHEMA,
    },
    "additionalProperties": True,
}

SEARCH_SOURCE_SCHEMA = {
    "type": "object",
    "properties": {
        "id": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "icon": STRING_SCHEMA,
        "emoji": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "priority": NUMBER_SCHEMA,
        "limit": INTEGER_SCHEMA,
        "items": {"type": "array", "items": SEARCH_ITEM_SCHEMA},
    },
    "additionalProperties": True,
}

SMART_SEARCH_BAR_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "hint": STRING_SCHEMA,
        "debounce_ms": INTEGER_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "show_clear": BOOL_SCHEMA,
        "loading": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "autofocus": BOOL_SCHEMA,
        "emit_on_empty": BOOL_SCHEMA,
        "show_history": BOOL_SCHEMA,
        "history_limit": INTEGER_SCHEMA,
        "history_id": STRING_SCHEMA,
        "provider_id": STRING_SCHEMA,
    }
)

SEARCH_SCOPE_SELECTOR_SCHEMA = _control_schema(
    {
        "scopes": {"type": "array", "items": ANY_SCHEMA},
        "selected": STRING_SCHEMA,
        "selected_index": INTEGER_SCHEMA,
        "default_scope": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "provider_id": STRING_SCHEMA,
    }
)

FILTER_CHIPS_BAR_SCHEMA = _control_schema(
    {
        "filters": {"type": "array", "items": ANY_SCHEMA},
        "values": {"type": "array", "items": ANY_SCHEMA},
        "indices": {"type": "array", "items": INTEGER_SCHEMA},
        "multi_select": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "spacing": NUMBER_SCHEMA,
    }
)

INTENT_SEARCH_SCHEMA = _control_schema(
    {
        "intents": {"type": "array", "items": SEARCH_ITEM_SCHEMA},
        "value": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "hint": STRING_SCHEMA,
        "debounce_ms": INTEGER_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "autofocus": BOOL_SCHEMA,
        "fuzzy": BOOL_SCHEMA,
        "show_all_on_empty": BOOL_SCHEMA,
        "max_results": INTEGER_SCHEMA,
        "emit_on_empty": BOOL_SCHEMA,
    }
)

SEARCH_RESULTS_VIEW_SCHEMA = _control_schema(
    {
        "results": {"type": "array", "items": SEARCH_ITEM_SCHEMA},
        "state": STRING_SCHEMA,
        "layout": STRING_SCHEMA,
        "grouped": BOOL_SCHEMA,
        "grid_columns": INTEGER_SCHEMA,
        "grid_spacing": NUMBER_SCHEMA,
        "grid_aspect_ratio": NUMBER_SCHEMA,
        "dense": BOOL_SCHEMA,
        "show_icons": BOOL_SCHEMA,
        "show_tags": BOOL_SCHEMA,
        "show_badges": BOOL_SCHEMA,
        "show_meta": BOOL_SCHEMA,
        "show_scores": BOOL_SCHEMA,
        "show_descriptions": BOOL_SCHEMA,
        "selected_id": STRING_SCHEMA,
        "query": STRING_SCHEMA,
        "empty_title": STRING_SCHEMA,
        "empty_message": STRING_SCHEMA,
        "error_title": STRING_SCHEMA,
        "error_message": STRING_SCHEMA,
        "loading": BOOL_SCHEMA,
        "loading_count": INTEGER_SCHEMA,
        "provider_id": STRING_SCHEMA,
    }
)

COMMAND_SEARCH_SCHEMA = _control_schema(
    {
        "commands": {"type": "array", "items": SEARCH_ITEM_SCHEMA},
        "open": BOOL_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "title": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "hotkeys": {"type": "array", "items": STRING_SCHEMA},
        "dense": BOOL_SCHEMA,
        "fuzzy": BOOL_SCHEMA,
        "show_all_on_empty": BOOL_SCHEMA,
        "max_results": INTEGER_SCHEMA,
        "dismiss_on_select": BOOL_SCHEMA,
        "close_on_escape": BOOL_SCHEMA,
        "max_width": NUMBER_SCHEMA,
        "max_height": NUMBER_SCHEMA,
        "scrim_color": COLOR_SCHEMA,
    }
)

INLINE_SEARCH_OVERLAY_SCHEMA = _control_schema(
    {
        "open": BOOL_SCHEMA,
        "position": STRING_SCHEMA,
        "offset": {"type": "array"},
        "dismissible": BOOL_SCHEMA,
        "close_on_escape": BOOL_SCHEMA,
        "match_width": BOOL_SCHEMA,
        "max_width": NUMBER_SCHEMA,
        "max_height": NUMBER_SCHEMA,
        "elevation": NUMBER_SCHEMA,
        "scrim_color": COLOR_SCHEMA,
    }
)

RESULT_PREVIEW_PANE_SCHEMA = _control_schema(
    {
        "item": {"type": "object"},
        "selected_item": {"type": "object"},
        "dense": BOOL_SCHEMA,
        "empty_title": STRING_SCHEMA,
        "empty_message": STRING_SCHEMA,
    }
)

SEARCH_PROVIDER_SCHEMA = _control_schema(
    {
        "sources": {"type": "array", "items": SEARCH_SOURCE_SCHEMA},
        "query": STRING_SCHEMA,
        "scope": STRING_SCHEMA,
        "fuzzy": BOOL_SCHEMA,
        "include_empty": BOOL_SCHEMA,
        "limit": INTEGER_SCHEMA,
        "min_score": NUMBER_SCHEMA,
        "emit_on_change": BOOL_SCHEMA,
    }
)

SEARCH_HISTORY_SCHEMA = _control_schema(
    {
        "items": {"type": "array", "items": STRING_SCHEMA},
        "max_items": INTEGER_SCHEMA,
        "persist": BOOL_SCHEMA,
        "storage_key": STRING_SCHEMA,
        "dedupe": BOOL_SCHEMA,
    }
)

DIRECTORY_PICKER_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

PATH_FIELD_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "label": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "mode": STRING_SCHEMA,
        "file_type": STRING_SCHEMA,
        "extensions": {"type": "array", "items": STRING_SCHEMA},
        "suggested_name": STRING_SCHEMA,
        "show_browse": BOOL_SCHEMA,
        "show_clear": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

KEYBIND_RECORDER_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "show_clear": BOOL_SCHEMA,
    }
)

IDE_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "code": STRING_SCHEMA,
        "language": STRING_SCHEMA,
        "theme": STRING_SCHEMA,
        "read_only": BOOL_SCHEMA,
        "events": {"type": "array", "items": STRING_SCHEMA},
        "emit_on_search_change": BOOL_SCHEMA,
        "search_debounce_ms": INTEGER_SCHEMA,
        "wrap": BOOL_SCHEMA,
        "word_wrap": BOOL_SCHEMA,
        "show_gutter": BOOL_SCHEMA,
        "line_numbers": BOOL_SCHEMA,
        "glyph_margin": BOOL_SCHEMA,
        "show_breakpoints": BOOL_SCHEMA,
        "show_minimap": BOOL_SCHEMA,
        "minimap": BOOL_SCHEMA,
        "render_whitespace": STRING_SCHEMA,
        "format_on_type": BOOL_SCHEMA,
        "format_on_paste": BOOL_SCHEMA,
        "document_uri": STRING_SCHEMA,
        "documents": {"type": "array", "items": {"type": "object"}},
        "tab_size": INTEGER_SCHEMA,
        "font_family": STRING_SCHEMA,
        "font_size": NUMBER_SCHEMA,
        "cursor_blink": BOOL_SCHEMA,
        "cursor_color": COLOR_SCHEMA,
        "selection_color": COLOR_SCHEMA,
        "line_highlight_color": COLOR_SCHEMA,
        "editor_bg": COLOR_SCHEMA,
        "editor_background": COLOR_SCHEMA,
        "editor_text_color": COLOR_SCHEMA,
        "padding_top": NUMBER_SCHEMA,
        "padding_bottom": NUMBER_SCHEMA,
        "chrome_padding": PADDING_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "engine": STRING_SCHEMA,
        "webview_engine": STRING_SCHEMA,
    }
)

TERMINAL_SCHEMA = _control_schema(
    {
        "schema_version": INTEGER_SCHEMA,
        "module": {"type": "string", "enum": TERMINAL_MODULE_ENUM},
        "state": {"type": "string", "enum": TERMINAL_STATE_ENUM},
        "custom_layout": BOOL_SCHEMA,
        "layout": STRING_SCHEMA,
        "manifest": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "registries": {"type": "object", "additionalProperties": ANY_SCHEMA},
        "events": {"type": "array", "items": {"type": "string", "enum": TERMINAL_EVENT_ENUM}},
        "modules": {
            "type": "object",
            "properties": {name: TERMINAL_MODULE_SCHEMAS[name] for name in TERMINAL_MODULE_ENUM},
            "additionalProperties": False,
        },
        "lines": {"type": "array", "items": ANY_SCHEMA},
        "history": {"type": "array", "items": STRING_SCHEMA},
        "history_items": {"type": "array", "items": STRING_SCHEMA},
        "history_limit": INTEGER_SCHEMA,
        "history_key": STRING_SCHEMA,
        "persist_history": BOOL_SCHEMA,
        "prompt": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "submit_label": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "show_prompt": BOOL_SCHEMA,
        "show_input": BOOL_SCHEMA,
        "read_only": BOOL_SCHEMA,
        "cursor_blink": BOOL_SCHEMA,
        "auto_scroll": BOOL_SCHEMA,
        "wrap_lines": BOOL_SCHEMA,
        "show_timestamps": BOOL_SCHEMA,
        "strip_ansi": BOOL_SCHEMA,
        "clear_on_submit": BOOL_SCHEMA,
        "auto_focus": BOOL_SCHEMA,
        "max_lines": INTEGER_SCHEMA,
        "font_family": STRING_SCHEMA,
        "font_size": NUMBER_SCHEMA,
        "line_height": NUMBER_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "text_color": COLOR_SCHEMA,
        "cursor_color": COLOR_SCHEMA,
        "command_color": COLOR_SCHEMA,
        "error_color": COLOR_SCHEMA,
        "stderr_color": COLOR_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "engine": STRING_SCHEMA,
        "local_command": STRING_SCHEMA,
        "local_args": {"type": "array", "items": STRING_SCHEMA},
        "local_env": {"type": "object"},
        "local_cwd": STRING_SCHEMA,
        "auto_start": BOOL_SCHEMA,
        "use_pty": BOOL_SCHEMA,
        "pipe_input": BOOL_SCHEMA,
        "emit_local_events": BOOL_SCHEMA,
        "local_allowlist": {"type": "array", "items": STRING_SCHEMA},
        "local_blocklist": {"type": "array", "items": STRING_SCHEMA},
        "local_allow_patterns": {"type": "array", "items": STRING_SCHEMA},
        "local_block_patterns": {"type": "array", "items": STRING_SCHEMA},
        "output": STRING_SCHEMA,
        "raw_text": STRING_SCHEMA,
        "webview_engine": STRING_SCHEMA,
        **{name: TERMINAL_MODULE_SCHEMAS[name] for name in TERMINAL_MODULE_ENUM},
    }
)

OUTPUT_PANEL_SCHEMA = _control_schema(
    {
        "channels": {"type": "object"},
        "active_channel": STRING_SCHEMA,
    }
)

EDITOR_TAB_STRIP_SCHEMA = _control_schema(
    {
        "tabs": {"type": "array", "items": {"type": "object"}},
    }
)

WORKSPACE_TREE_SCHEMA = _control_schema(
    {
        "nodes": {"type": "array", "items": {"type": "object"}},
        "items": {"type": "array", "items": {"type": "object"}},
        "roots": {"type": "array", "items": {"type": "object"}},
    }
)

PROBLEMS_PANEL_SCHEMA = _control_schema(
    {
        "problems": {"type": "array", "items": {"type": "object"}},
        "items": {"type": "array", "items": {"type": "object"}},
    }
)

EDITOR_WORKSPACE_SCHEMA = _control_schema(
    {
        "documents": {"type": "array", "items": {"type": "object"}},
        "tabs": {"type": "array", "items": {"type": "object"}},
        "active_id": STRING_SCHEMA,
        "workspace_nodes": {"type": "array", "items": {"type": "object"}},
        "problems": {"type": "array", "items": {"type": "object"}},
        "show_explorer": BOOL_SCHEMA,
        "show_problems": BOOL_SCHEMA,
        "show_status_bar": BOOL_SCHEMA,
        "status_text": STRING_SCHEMA,
    }
)

SIDEBAR_SCHEMA = _control_schema(
    {
        "sections": {"type": "array", "items": {"type": "object"}},
        "selected_id": STRING_SCHEMA,
        "show_search": BOOL_SCHEMA,
        "query": STRING_SCHEMA,
        "collapsible": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "events": {"type": "array", "items": STRING_SCHEMA},
        "emit_on_search_change": BOOL_SCHEMA,
        "search_debounce_ms": INTEGER_SCHEMA,
        "open": BOOL_SCHEMA,
        "side": STRING_SCHEMA,
        "size": NUMBER_SCHEMA,
        "dismissible": BOOL_SCHEMA,
        "scrim_color": COLOR_SCHEMA,
    }
)

APP_BAR_SCHEMA = _control_schema(
    {
        "title": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "center_title": BOOL_SCHEMA,
        "height": NUMBER_SCHEMA,
        "bgcolor": STRING_SCHEMA,
        "elevation": NUMBER_SCHEMA,
        "padding": {"type": "array"},
        "show_search": BOOL_SCHEMA,
        "search_value": STRING_SCHEMA,
        "search_placeholder": STRING_SCHEMA,
        "search_enabled": BOOL_SCHEMA,
        "events": {"type": "array", "items": STRING_SCHEMA},
        "emit_on_search_change": BOOL_SCHEMA,
        "search_debounce_ms": INTEGER_SCHEMA,
    }
)

OVERLAY_SCHEMA = _control_schema(
    {
        "open": BOOL_SCHEMA,
        "dismissible": BOOL_SCHEMA,
        "alignment": ANY_SCHEMA,
        "scrim_color": COLOR_SCHEMA,
    }
)

MODAL_SCHEMA = _control_schema(
    {
        "open": BOOL_SCHEMA,
        "dismissible": BOOL_SCHEMA,
        "scrim_color": COLOR_SCHEMA,
    }
)

PROBLEM_SCREEN_SCHEMA = _control_schema(
    {
        "title": STRING_SCHEMA,
        "message": STRING_SCHEMA,
        "severity": {"type": "string", "enum": ["error", "fatal", "warning", "info"]},
        "traceback": STRING_SCHEMA,
        "files": {"type": "array", "items": {"type": "object"}},
        "related_files": {"type": "array", "items": STRING_SCHEMA},
        "related_modules": {"type": "array", "items": {"type": "object"}},
        "session_id": STRING_SCHEMA,
        "ui_snapshot": {"type": "object"},
        "error_classes": {"type": "array", "items": STRING_SCHEMA},
        "actions": {"type": "array", "items": {"type": "object"}},
        "variant": STRING_SCHEMA,
    }
)

BOOT_HOST_SCHEMA = _control_schema(
    {
        "message": STRING_SCHEMA,
        "progress": NUMBER_SCHEMA,
        "actions": {"type": "array", "items": {"type": "object"}},
    }
)

POPOVER_SCHEMA = _control_schema(
    {
        "open": BOOL_SCHEMA,
        "position": STRING_SCHEMA,
        "offset": {"type": "array"},
        "dismissible": BOOL_SCHEMA,
        "scrim_color": COLOR_SCHEMA,
        "events": {"type": "array", "items": STRING_SCHEMA},
    }
)

SLIDE_PANEL_SCHEMA = _control_schema(
    {
        "open": BOOL_SCHEMA,
        "emit_on_search_change": BOOL_SCHEMA,
        "search_debounce_ms": INTEGER_SCHEMA,
        "side": STRING_SCHEMA,
        "size": NUMBER_SCHEMA,
        "scrim_color": COLOR_SCHEMA,
        "dismissible": BOOL_SCHEMA,
    }
)

SIDE_DRAWER_SCHEMA = _control_schema(
    {
        "open": BOOL_SCHEMA,
        "side": STRING_SCHEMA,
        "size": NUMBER_SCHEMA,
        "scrim_color": COLOR_SCHEMA,
        "dismissible": BOOL_SCHEMA,
    }
)

BOTTOM_SHEET_SCHEMA = _control_schema(
    {
        "open": BOOL_SCHEMA,
        "dismissible": BOOL_SCHEMA,
        "scrim_color": STRING_SCHEMA,
        "height": NUMBER_SCHEMA,
        "max_height": NUMBER_SCHEMA,
    }
)

CRUMB_TRAIL_SCHEMA = _control_schema(
    {
        "items": {"type": "array", "items": ANY_SCHEMA},
        "current_index": INTEGER_SCHEMA,
        "separator": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

RESIZABLE_PANEL_SCHEMA = _control_schema(
    {
        "axis": STRING_SCHEMA,
        "size": NUMBER_SCHEMA,
        "min_size": NUMBER_SCHEMA,
        "max_size": NUMBER_SCHEMA,
        "resizable": BOOL_SCHEMA,
        "reverse": BOOL_SCHEMA,
        "handle_size": NUMBER_SCHEMA,
        "handle_color": STRING_SCHEMA,
        "emit_on_change": BOOL_SCHEMA,
    }
)

SCROLLABLE_COLUMN_SCHEMA = _control_schema(
    {
        "spacing": NUMBER_SCHEMA,
        "padding": {"type": "array"},
        "reverse": BOOL_SCHEMA,
        "sticky_header": BOOL_SCHEMA,
    }
)

SCROLLABLE_ROW_SCHEMA = _control_schema(
    {
        "spacing": NUMBER_SCHEMA,
        "padding": {"type": "array"},
        "reverse": BOOL_SCHEMA,
        "sticky_header": BOOL_SCHEMA,
    }
)

FILE_TREE_SCHEMA = _control_schema(
    {
        "nodes": {"type": "array", "items": {"type": "object"}},
        "expanded": {"type": "array", "items": STRING_SCHEMA},
        "selected_id": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

LOG_VIEWER_SCHEMA = _control_schema(
    {
        "entries": {"type": "array", "items": {"type": "object"}},
        "dense": BOOL_SCHEMA,
        "show_filters": BOOL_SCHEMA,
        "level": STRING_SCHEMA,
    }
)

NOTIFICATION_CENTER_SCHEMA = _control_schema(
    {
        "items": {"type": "array", "items": {"type": "object"}},
        "dense": BOOL_SCHEMA,
    }
)

PROGRESS_OVERLAY_SCHEMA = _control_schema(
    {
        "open": BOOL_SCHEMA,
        "message": STRING_SCHEMA,
        "value": NUMBER_SCHEMA,
        "scrim_color": STRING_SCHEMA,
    }
)

DOWNLOAD_ITEM_SCHEMA = _control_schema(
    {
        "id": STRING_SCHEMA,
        "title": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "progress": NUMBER_SCHEMA,
        "status": STRING_SCHEMA,
        "speed": STRING_SCHEMA,
        "eta": STRING_SCHEMA,
        "paused": BOOL_SCHEMA,
    }
)

QUEUE_LIST_SCHEMA = _control_schema(
    {
        "items": {"type": "array", "items": {"type": "object"}},
    }
)

EMOJI_PICKER_SCHEMA = _control_schema(
    {
        "value": STRING_SCHEMA,
        "emojis": {"type": "array", "items": STRING_SCHEMA},
        "items": {"type": "array", "items": STRING_SCHEMA},
        "categories": {"type": "array", "items": STRING_SCHEMA},
        "recent": {"type": "array", "items": STRING_SCHEMA},
        "skin_tone": STRING_SCHEMA,
        "show_search": BOOL_SCHEMA,
        "show_recent": BOOL_SCHEMA,
        "category": STRING_SCHEMA,
        "query": STRING_SCHEMA,
        "include_metadata": BOOL_SCHEMA,
        "recent_limit": INTEGER_SCHEMA,
        "columns": INTEGER_SCHEMA,
        "size": NUMBER_SCHEMA,
        "selected": STRING_SCHEMA,
    }
)

ICON_PICKER_SCHEMA = EMOJI_PICKER_SCHEMA

REORDERABLE_LIST_SCHEMA = _control_schema(
    {
        "axis": STRING_SCHEMA,
        "padding": {"type": "array"},
        "build_default_handles": BOOL_SCHEMA,
    }
)

REORDERABLE_TREE_SCHEMA = _control_schema(
    {
        "nodes": {"type": "array", "items": {"type": "object"}},
        "build_default_handles": BOOL_SCHEMA,
    }
)

DRAG_HANDLE_SCHEMA = _control_schema(
    {
        "index": INTEGER_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

AUTO_FORM_SCHEMA = _control_schema(
    {
        "schema": {"type": "object"},
        "fields": {"type": "array", "items": {"type": "object"}},
        "value": {"type": "object"},
        "values": {"type": "object"},
        "title": STRING_SCHEMA,
        "description": STRING_SCHEMA,
        "submit_label": STRING_SCHEMA,
        "layout": STRING_SCHEMA,
        "columns": INTEGER_SCHEMA,
        "show_labels": BOOL_SCHEMA,
        "label_width": NUMBER_SCHEMA,
        "dense": BOOL_SCHEMA,
        "validation_rules": {"type": "object"},
        "visibility_rules": {"type": "object"},
    }
)

SURFACE_SCHEMA = _control_schema(
    {
        "bgcolor": STRING_SCHEMA,
        "border_color": STRING_SCHEMA,
        "border_width": NUMBER_SCHEMA,
        "radius": NUMBER_SCHEMA,
        "elevation": NUMBER_SCHEMA,
        "content_alignment": STRING_SCHEMA,
        "content_padding": {"type": "array"},
    }
)

# IDE controls
CODE_BUFFER_SCHEMA = _control_schema(
    {
        "text": STRING_SCHEMA,
        "buffer_id": STRING_SCHEMA,
        "version": INTEGER_SCHEMA,
        "dirty": BOOL_SCHEMA,
        "metadata": {"type": "object"},
    }
)

CODE_DOCUMENT_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "buffer_id": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "language": STRING_SCHEMA,
        "cursors": {"type": "array", "items": {"type": "object"}},
        "selections": {"type": "array", "items": {"type": "object"}},
        "diagnostics": {"type": "array", "items": {"type": "object"}},
        "tokens": {"type": "array", "items": {"type": "object"}},
        "semantic_items": {"type": "array", "items": {"type": "object"}},
        "category_items": {"type": "array", "items": {"type": "object"}},
        "ownership_items": {"type": "array", "items": {"type": "object"}},
        "metadata": {"type": "object"},
    }
)

MULTI_CURSOR_CONTROLLER_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "cursors": {"type": "array", "items": {"type": "object"}},
        "selections": {"type": "array", "items": {"type": "object"}},
        "enabled": BOOL_SCHEMA,
    }
)

SYNTAX_LAYER_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "tokens": {"type": "array", "items": {"type": "object"}},
        "enabled": BOOL_SCHEMA,
    }
)

FOLD_LAYER_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "ranges": {"type": "array", "items": {"type": "object"}},
        "folded_ids": {"type": "array", "items": STRING_SCHEMA},
        "enabled": BOOL_SCHEMA,
    }
)

SEMANTIC_LAYER_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "items": {"type": "array", "items": {"type": "object"}},
        "semantic_items": {"type": "array", "items": {"type": "object"}},
        "enabled": BOOL_SCHEMA,
    }
)

CODE_CATEGORY_LAYER_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "items": {"type": "array", "items": {"type": "object"}},
        "enabled": BOOL_SCHEMA,
    }
)

OWNERSHIP_MARKER_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "items": {"type": "array", "items": {"type": "object"}},
        "enabled": BOOL_SCHEMA,
    }
)

INLINE_WIDGET_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "line": INTEGER_SCHEMA,
        "column": INTEGER_SCHEMA,
        "offset_y": NUMBER_SCHEMA,
        "offset": NUMBER_SCHEMA,
        "alignment": ALIGNMENT_SCHEMA,
    }
)

VIRTUAL_FILE_SYSTEM_SCHEMA = _control_schema(
    {
        "vfs_id": STRING_SCHEMA,
        "nodes": {"type": "array", "items": {"type": "object"}},
        "root_id": STRING_SCHEMA,
        "selected_id": STRING_SCHEMA,
        "expanded": {"type": "array", "items": STRING_SCHEMA},
        "version": INTEGER_SCHEMA,
    }
)

FILE_SYSTEM_SCHEMA = _control_schema(
    {
        "root": STRING_SCHEMA,
        "nodes": {"type": "array", "items": {"type": "object"}},
        "selected_path": STRING_SCHEMA,
        "show_hidden": BOOL_SCHEMA,
        "readonly": BOOL_SCHEMA,
        "events": {"type": "array", "items": STRING_SCHEMA},
        "vfs_id": STRING_SCHEMA,
        "root_id": STRING_SCHEMA,
        "selected_id": STRING_SCHEMA,
        "expanded": {"type": "array", "items": STRING_SCHEMA},
        "version": INTEGER_SCHEMA,
    }
)

EDITOR_INTENT_ROUTER_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "shortcuts": {"type": "array", "items": {"type": "object"}},
        "enabled": BOOL_SCHEMA,
    }
)

FOCUS_MODE_CONTROLLER_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "hidden_panels": {"type": "array", "items": STRING_SCHEMA},
        "hidden": {"type": "array", "items": STRING_SCHEMA},
    }
)

CONTROL_PRESET_SCHEMA = _control_schema(
    {
        "preset_id": STRING_SCHEMA,
        "props": {"type": "object"},
        "target_types": {"type": "array", "items": STRING_SCHEMA},
    }
)

BEHAVIOR_MIXINS_SCHEMA = _control_schema(
    {
        "mixins_id": STRING_SCHEMA,
        "mixins": {"type": "array", "items": STRING_SCHEMA},
    }
)

EDITOR_VIEW_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "buffer_id": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "language": STRING_SCHEMA,
        "read_only": BOOL_SCHEMA,
        "wrap": BOOL_SCHEMA,
        "line_height": NUMBER_SCHEMA,
        "font_size": NUMBER_SCHEMA,
        "font_family": STRING_SCHEMA,
        "tab_size": INTEGER_SCHEMA,
        "cursor_color": COLOR_SCHEMA,
        "selection_color": COLOR_SCHEMA,
        "padding": PADDING_SCHEMA,
        "background": COLOR_SCHEMA,
        "preset_id": STRING_SCHEMA,
        "behavior_ids": {"type": "array", "items": STRING_SCHEMA},
        "behaviors": {"type": "array", "items": STRING_SCHEMA},
        "current_line": INTEGER_SCHEMA,
    }
)

EDITOR_SURFACE_SCHEMA = _control_schema(
    {
        "document_id": STRING_SCHEMA,
        "buffer_id": STRING_SCHEMA,
        "text": STRING_SCHEMA,
        "language": STRING_SCHEMA,
        "read_only": BOOL_SCHEMA,
        "wrap": BOOL_SCHEMA,
        "line_height": NUMBER_SCHEMA,
        "font_size": NUMBER_SCHEMA,
        "font_family": STRING_SCHEMA,
        "tab_size": INTEGER_SCHEMA,
        "cursor_color": COLOR_SCHEMA,
        "selection_color": COLOR_SCHEMA,
        "padding": PADDING_SCHEMA,
        "background": COLOR_SCHEMA,
        "show_gutter": BOOL_SCHEMA,
        "show_minimap": BOOL_SCHEMA,
        "gutter_width": NUMBER_SCHEMA,
        "minimap_width": NUMBER_SCHEMA,
        "breakpoints": {"type": "array", "items": INTEGER_SCHEMA},
        "diagnostics": {"type": "array", "items": {"type": "object"}},
        "preset_id": STRING_SCHEMA,
        "behavior_ids": {"type": "array", "items": STRING_SCHEMA},
        "behaviors": {"type": "array", "items": STRING_SCHEMA},
        "current_line": INTEGER_SCHEMA,
    }
)

GUTTER_SCHEMA = _control_schema(
    {
        "line_count": INTEGER_SCHEMA,
        "current_line": INTEGER_SCHEMA,
        "breakpoints": {"type": "array", "items": INTEGER_SCHEMA},
        "diagnostics": {"type": "array", "items": {"type": "object"}},
        "show_line_numbers": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
        "width": NUMBER_SCHEMA,
        "font_size": NUMBER_SCHEMA,
        "font_family": STRING_SCHEMA,
    }
)

SYMBOL_TREE_SCHEMA = _control_schema(
    {
        "nodes": {"type": "array", "items": {"type": "object"}},
        "expanded": {"type": "array", "items": STRING_SCHEMA},
        "selected_id": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
        "show_icons": BOOL_SCHEMA,
    }
)

OUTLINE_VIEW_SCHEMA = SYMBOL_TREE_SCHEMA
BREADCRUMB_BAR_SCHEMA = _control_schema(
    {
        "items": {"type": "array", "items": {"type": "object"}},
        "path": STRING_SCHEMA,
        "current_index": INTEGER_SCHEMA,
        "separator": STRING_SCHEMA,
        "max_items": INTEGER_SCHEMA,
        "dense": BOOL_SCHEMA,
        "dropdown_levels": BOOL_SCHEMA,
        "show_root": BOOL_SCHEMA,
        "compact": BOOL_SCHEMA,
    }
)
STATUS_BAR_SCHEMA = _control_schema(
    {
        "items": {"type": "array", "items": INFO_ITEM_SCHEMA},
        "text": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
        "padding": PADDING_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "border_color": COLOR_SCHEMA,
    }
)
COMMAND_PALETTE_SCHEMA = COMMAND_SEARCH_SCHEMA

CONTEXT_ACTION_BAR_SCHEMA = _control_schema(
    {
        "spacing": NUMBER_SCHEMA,
        "padding": PADDING_SCHEMA,
        "bgcolor": COLOR_SCHEMA,
        "alignment": ALIGNMENT_SCHEMA,
    }
)

DIAGNOSTIC_STREAM_SCHEMA = _control_schema(
    {
        "entries": {"type": "array", "items": {"type": "object"}},
        "dense": BOOL_SCHEMA,
        "show_filters": BOOL_SCHEMA,
        "show_search": BOOL_SCHEMA,
        "level": STRING_SCHEMA,
        "query": STRING_SCHEMA,
        "selected_id": STRING_SCHEMA,
    }
)

EXECUTION_LANE_SCHEMA = _control_schema(
    {
        "entries": {"type": "array", "items": {"type": "object"}},
        "state": STRING_SCHEMA,
        "position": INTEGER_SCHEMA,
        "show_controls": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

STATE_INSPECTOR_SCHEMA = _control_schema(
    {
        "value": ANY_SCHEMA,
        "scopes": {"type": "array", "items": {"type": "object"}},
        "selected_scope": STRING_SCHEMA,
        "show_path": BOOL_SCHEMA,
        "show_type": BOOL_SCHEMA,
        "show_size": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

DOCK_GRAPH_SCHEMA = _control_schema(
    {
        "layout": {"type": "object"},
        "panels": {"type": "array", "items": {"type": "object"}},
        "focus_mode_id": STRING_SCHEMA,
        "divider_size": NUMBER_SCHEMA,
        "tab_height": NUMBER_SCHEMA,
    }
)

INTENT_PANEL_SCHEMA = _control_schema(
    {
        "intents": {"type": "array", "items": {"type": "object"}},
        "dense": BOOL_SCHEMA,
        "show_search": BOOL_SCHEMA,
        "query": STRING_SCHEMA,
    }
)

DIFF_NARRATOR_SCHEMA = _control_schema(
    {
        "summary": STRING_SCHEMA,
        "risk": STRING_SCHEMA,
        "changes": {"type": "array", "items": {"type": "object"}},
        "before": STRING_SCHEMA,
        "after": STRING_SCHEMA,
        "show_diff": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

GHOST_EDITOR_SCHEMA = _control_schema(
    {
        "base_document_id": STRING_SCHEMA,
        "ghost_document_id": STRING_SCHEMA,
        "show_diff": BOOL_SCHEMA,
        "diff_mode": STRING_SCHEMA,
        "split_ratio": NUMBER_SCHEMA,
        "read_only": BOOL_SCHEMA,
    }
)

PREVIEW_SURFACE_SCHEMA = _control_schema(
    {
        "title": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "status": STRING_SCHEMA,
        "active": BOOL_SCHEMA,
        "show_border": BOOL_SCHEMA,
        "background": COLOR_SCHEMA,
        "padding": PADDING_SCHEMA,
        "empty_title": STRING_SCHEMA,
        "empty_message": STRING_SCHEMA,
        "actions": {"type": "array", "items": {"type": "object"}},
    }
)

NATIVE_PREVIEW_HOST_SCHEMA = _control_schema(
    {
        "window_handle": INTEGER_SCHEMA,
        "process_id": INTEGER_SCHEMA,
        "visible": BOOL_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "background": COLOR_SCHEMA,
    }
)

STATE_SNAPSHOT_SCHEMA = _control_schema(
    {
        "snapshots": {"type": "array", "items": {"type": "object"}},
        "entries": {"type": "array", "items": {"type": "object"}},
        "selected_id": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
        "show_controls": BOOL_SCHEMA,
    }
)

HOT_RELOAD_BOUNDARY_SCHEMA = _control_schema(
    {
        "label": STRING_SCHEMA,
        "description": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "mode": STRING_SCHEMA,
        "show_switch": BOOL_SCHEMA,
        "action_label": STRING_SCHEMA,
        "border_color": COLOR_SCHEMA,
        "background": COLOR_SCHEMA,
        "padding": PADDING_SCHEMA,
    }
)

SEMANTIC_SEARCH_SCHEMA = _control_schema(
    {
        "query": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "scopes": {"type": "array", "items": {"type": "object"}},
        "selected_scope": STRING_SCHEMA,
        "results": {"type": "array", "items": {"type": "object"}},
        "dense": BOOL_SCHEMA,
        "show_scopes": BOOL_SCHEMA,
        "show_results": BOOL_SCHEMA,
        "loading": BOOL_SCHEMA,
        "empty_title": STRING_SCHEMA,
        "empty_message": STRING_SCHEMA,
    }
)

SCOPED_SEARCH_REPLACE_SCHEMA = _control_schema(
    {
        "query": STRING_SCHEMA,
        "replace": STRING_SCHEMA,
        "scopes": {"type": "array", "items": {"type": "object"}},
        "selected_scope": STRING_SCHEMA,
        "regex": BOOL_SCHEMA,
        "case_sensitive": BOOL_SCHEMA,
        "whole_word": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

INTENT_ROUTER_SCHEMA = _control_schema(
    {
        "intents": {"type": "array", "items": {"type": "object"}},
        "query": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
        "show_search": BOOL_SCHEMA,
        "selected_id": STRING_SCHEMA,
    }
)

PREVIEW_INTENT_INTERCEPTOR_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "mode": STRING_SCHEMA,
        "intents": {"type": "array", "items": {"type": "object"}},
        "dense": BOOL_SCHEMA,
    }
)

PREVIEW_PRESETS_SCHEMA = _control_schema(
    {
        "presets": {"type": "array", "items": {"type": "object"}},
        "selected_id": STRING_SCHEMA,
        "dense": BOOL_SCHEMA,
    }
)

LAYOUT_FREEZE_SCHEMA = _control_schema(
    {
        "enabled": BOOL_SCHEMA,
        "label": STRING_SCHEMA,
        "description": STRING_SCHEMA,
        "show_toggle": BOOL_SCHEMA,
    }
)

TIME_TRAVEL_LITE_SCHEMA = _control_schema(
    {
        "steps": {"type": "array", "items": {"type": "object"}},
        "entries": {"type": "array", "items": {"type": "object"}},
        "position": INTEGER_SCHEMA,
        "state": STRING_SCHEMA,
        "show_controls": BOOL_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

LIVE_CONTROL_PICKER_SCHEMA = _control_schema(
    {
        "active": BOOL_SCHEMA,
        "selected_id": STRING_SCHEMA,
        "selected_path": STRING_SCHEMA,
        "enabled": BOOL_SCHEMA,
    }
)

PREVIEW_ERROR_OVERLAY_SCHEMA = _control_schema(
    {
        "visible": BOOL_SCHEMA,
        "title": STRING_SCHEMA,
        "message": STRING_SCHEMA,
        "details": STRING_SCHEMA,
        "severity": STRING_SCHEMA,
        "actions": {"type": "array", "items": {"type": "object"}},
    }
)

SEARCH_EVERYTHING_PANEL_SCHEMA = _control_schema(
    {
        "query": STRING_SCHEMA,
        "placeholder": STRING_SCHEMA,
        "filters": {"type": "array", "items": {"type": "object"}},
        "categories": {"type": "array", "items": {"type": "object"}},
        "selected_filters": {"type": "array", "items": STRING_SCHEMA},
        "results": {"type": "array", "items": {"type": "object"}},
        "dense": BOOL_SCHEMA,
        "show_filters": BOOL_SCHEMA,
        "show_results": BOOL_SCHEMA,
        "loading": BOOL_SCHEMA,
        "empty_title": STRING_SCHEMA,
        "empty_message": STRING_SCHEMA,
    }
)

CONTROL_SCHEMAS = {
    "align": _control_schema({"alignment": ALIGNMENT_SCHEMA, "width_factor": NUMBER_SCHEMA, "height_factor": NUMBER_SCHEMA}),
    "center": _control_schema({"width_factor": NUMBER_SCHEMA, "height_factor": NUMBER_SCHEMA, "enabled": BOOL_SCHEMA}),
    "text": TEXT_SCHEMA,
    "markdown": MARKDOWN_SCHEMA,
    "markdown_view": MARKDOWN_VIEW_SCHEMA,
    "html": HTML_SCHEMA,
    "html_view": HTML_VIEW_SCHEMA,
    "code": CODE_SCHEMA,
    "code_view": CODE_SCHEMA,
    "code_block": CODE_BLOCK_SCHEMA,
    "diff": JSON_DIFF_SCHEMA,
    "diff_view": JSON_DIFF_SCHEMA,
    "rich_text_editor": _control_schema({"value": STRING_SCHEMA, "text": STRING_SCHEMA, "read_only": BOOL_SCHEMA}),
    "rich_text": _control_schema({"value": STRING_SCHEMA, "text": STRING_SCHEMA, "read_only": BOOL_SCHEMA}),
    "rte": _control_schema({"value": STRING_SCHEMA, "text": STRING_SCHEMA, "read_only": BOOL_SCHEMA}),
    "chart": _control_schema({"series": {"type": "array", "items": {"type": "object"}}, "data": ANY_SCHEMA, "kind": STRING_SCHEMA}),
    "bar_chart": _control_schema(
        {
            "values": {"type": "array", "items": NUMBER_SCHEMA},
            "points": {"type": "array", "items": ANY_SCHEMA},
            "labels": {"type": "array", "items": STRING_SCHEMA},
            "datasets": {"type": "array", "items": {"type": "object"}},
            "grouped": BOOL_SCHEMA,
            "stacked": BOOL_SCHEMA,
            "animate": BOOL_SCHEMA,
            "show_tooltip": BOOL_SCHEMA,
            "fill": BOOL_SCHEMA,
            "color": COLOR_SCHEMA,
            "height": NUMBER_SCHEMA,
        }
    ),
    "line_plot": _control_schema({"values": {"type": "array", "items": NUMBER_SCHEMA}, "points": {"type": "array", "items": ANY_SCHEMA}, "fill": BOOL_SCHEMA, "color": COLOR_SCHEMA}),
    "line_chart": _control_schema({"values": {"type": "array", "items": NUMBER_SCHEMA}, "points": {"type": "array", "items": ANY_SCHEMA}, "fill": BOOL_SCHEMA, "color": COLOR_SCHEMA}),
    "pie_plot": _control_schema({"values": {"type": "array", "items": NUMBER_SCHEMA}, "labels": {"type": "array", "items": STRING_SCHEMA}, "colors": {"type": "array", "items": COLOR_SCHEMA}, "donut": BOOL_SCHEMA, "hole": NUMBER_SCHEMA, "start_angle": NUMBER_SCHEMA, "clockwise": BOOL_SCHEMA}),
    "bar_plot": _control_schema({"values": {"type": "array", "items": NUMBER_SCHEMA}, "labels": {"type": "array", "items": STRING_SCHEMA}, "color": COLOR_SCHEMA, "spacing": NUMBER_SCHEMA, "min": NUMBER_SCHEMA, "max": NUMBER_SCHEMA}),
    "sparkline": _control_schema({"values": {"type": "array", "items": NUMBER_SCHEMA}, "data": ANY_SCHEMA}),
    "spark_plot": _control_schema({"values": {"type": "array", "items": NUMBER_SCHEMA}, "data": ANY_SCHEMA}),
    "empty_state": _control_schema({"title": STRING_SCHEMA, "message": STRING_SCHEMA, "action_label": STRING_SCHEMA, "icon": STRING_SCHEMA}),
    "error_state": _control_schema({"title": STRING_SCHEMA, "message": STRING_SCHEMA, "error": STRING_SCHEMA, "action_label": STRING_SCHEMA, "icon": STRING_SCHEMA}),
    "artifact_card": ARTIFACT_CARD_SCHEMA,
    "result_card": ARTIFACT_CARD_SCHEMA,
    "message_bubble": MESSAGE_BUBBLE_SCHEMA,
    "chat_message": MESSAGE_BUBBLE_SCHEMA,
    "chat_bubble": MESSAGE_BUBBLE_SCHEMA,
    "chat_thread": CHAT_THREAD_SCHEMA,
    "avatar_stack": AVATAR_STACK_SCHEMA,
    "badge": _control_schema({"label": STRING_SCHEMA, "text": STRING_SCHEMA, "value": STRING_SCHEMA}),
    "border": BORDER_SCHEMA,
    "border_side": BORDER_SIDE_SCHEMA,
    "button_style": BUTTON_STYLE_SCHEMA,
    "message_meta": MESSAGE_META_SCHEMA,
    "attachment_tile": ATTACHMENT_TILE_SCHEMA,
    "reaction_bar": REACTION_BAR_SCHEMA,
    "quoted_message": QUOTED_MESSAGE_SCHEMA,
    "rating_display": _control_schema({"value": NUMBER_SCHEMA, "max": INTEGER_SCHEMA, "allow_half": BOOL_SCHEMA, "dense": BOOL_SCHEMA}),
    "typing_indicator": TYPING_INDICATOR_SCHEMA,
    "message_composer": MESSAGE_COMPOSER_SCHEMA,
    "async_action_button": _control_schema({"label": STRING_SCHEMA, "text": STRING_SCHEMA, "value": ANY_SCHEMA, "variant": STRING_SCHEMA, "busy": BOOL_SCHEMA, "loading": BOOL_SCHEMA, "disabled_while_busy": BOOL_SCHEMA, "busy_label": STRING_SCHEMA}),
    "prompt_composer": PROMPT_COMPOSER_SCHEMA,
    "mention_pill": MENTION_PILL_SCHEMA,
    "persona": _control_schema({
        "name": STRING_SCHEMA,
        "subtitle": STRING_SCHEMA,
        "avatar": STRING_SCHEMA,
        "status": STRING_SCHEMA,
        "initials": STRING_SCHEMA,
        "layout": STRING_SCHEMA,
        "show_avatar": BOOL_SCHEMA,
        "avatar_color": COLOR_SCHEMA,
        "leading": ANY_SCHEMA,
        "title_widget": ANY_SCHEMA,
        "subtitle_widget": ANY_SCHEMA,
        "trailing": ANY_SCHEMA,
        "content": ANY_SCHEMA,
        "dense": BOOL_SCHEMA,
    }),
    "message_divider": MESSAGE_DIVIDER_SCHEMA,
    "glow_effect": GLOW_EFFECT_SCHEMA,
    "neon_edge": NEON_EDGE_SCHEMA,
    "glass_blur": GLASS_BLUR_SCHEMA,
    "grain_overlay": GRAIN_OVERLAY_SCHEMA,
    "gradient_sweep": GRADIENT_SWEEP_SCHEMA,
    "shimmer": SHIMMER_SCHEMA,
    "shadow_stack": SHADOW_STACK_SCHEMA,
    "outline_reveal": OUTLINE_REVEAL_SCHEMA,
    "ripple_burst": RIPPLE_BURST_SCHEMA,
    "confetti_burst": CONFETTI_BURST_SCHEMA,
    "noise_displacement": NOISE_DISPLACEMENT_SCHEMA,
    "animated_gradient": ANIMATED_GRADIENT_SCHEMA,
    "noise_field": NOISE_FIELD_SCHEMA,
    "flow_field": FLOW_FIELD_SCHEMA,
    "blob_field": BLOB_FIELD_SCHEMA,
    "parallax_offset": PARALLAX_OFFSET_SCHEMA,
    "parallax": PARALLAX_SCHEMA,
    "pan_zoom": _control_schema(PAN_ZOOM_SCHEMA["properties"]),
    "pose": POSE_SCHEMA,
    "liquid_morph": LIQUID_MORPH_SCHEMA,
    "motion": MOTION_SCHEMA,
    "timeline": _control_schema(TIMELINE_SCHEMA["properties"]),
    "chromatic_shift": CHROMATIC_SHIFT_SCHEMA,
    "scanline_overlay": SCANLINE_OVERLAY_SCHEMA,
    "pixelate": PIXELATE_SCHEMA,
    "vignette": VIGNETTE_SCHEMA,
    "tilt_hover": TILT_HOVER_SCHEMA,
    "morphing_border": MORPHING_BORDER_SCHEMA,
    "json_view": JSON_VIEW_SCHEMA,
    "json_tree": JSON_TREE_SCHEMA,
    "json_inspector": JSON_INSPECTOR_SCHEMA,
    "json_table": JSON_TABLE_SCHEMA,
    "json_diff": JSON_DIFF_SCHEMA,
    "json_editor": JSON_EDITOR_SCHEMA,
    "json_path_picker": JSON_PATH_PICKER_SCHEMA,
    "progress": PROGRESS_SCHEMA,
    "progress_indicator": PROGRESS_SCHEMA,
    "button": BUTTON_SCHEMA,
    "icon_button": _control_schema({"icon": STRING_SCHEMA, "glyph": STRING_SCHEMA, "tooltip": STRING_SCHEMA, "size": NUMBER_SCHEMA, "color": COLOR_SCHEMA, "enabled": BOOL_SCHEMA}),
    "elevated_button": BUTTON_SCHEMA,
    "glyph_button": _control_schema({"glyph": STRING_SCHEMA, "icon": STRING_SCHEMA, "size": NUMBER_SCHEMA, "color": COLOR_SCHEMA, "tooltip": STRING_SCHEMA, "enabled": BOOL_SCHEMA}),
    "text_field": TEXT_FIELD_SCHEMA,
    "text_area": TEXT_AREA_SCHEMA,
    "text_field_style": _control_schema({"variant": STRING_SCHEMA, "dense": BOOL_SCHEMA, "filled": BOOL_SCHEMA, "outlined": BOOL_SCHEMA, "radius": NUMBER_SCHEMA, "border_width": NUMBER_SCHEMA, "color": COLOR_SCHEMA, "border_color": COLOR_SCHEMA, "hint_color": COLOR_SCHEMA, "label_color": COLOR_SCHEMA, "text_color": COLOR_SCHEMA}),
    "search_box": SEARCH_BOX_SCHEMA,
    "search_bar": SEARCH_BAR_SCHEMA,
    "smart_search_bar": SMART_SEARCH_BAR_SCHEMA,
    "search_scope_selector": SEARCH_SCOPE_SELECTOR_SCHEMA,
    "filter_chips_bar": FILTER_CHIPS_BAR_SCHEMA,
    "chip_group": FILTER_CHIPS_BAR_SCHEMA,
    "check_list": _control_schema({"options": {"type": "array", "items": ANY_SCHEMA}, "values": {"type": "array", "items": ANY_SCHEMA}, "dense": BOOL_SCHEMA, "enabled": BOOL_SCHEMA}),
    "chip": _control_schema({"label": STRING_SCHEMA, "value": ANY_SCHEMA, "selected": BOOL_SCHEMA, "enabled": BOOL_SCHEMA, "dismissible": BOOL_SCHEMA, "color": COLOR_SCHEMA}),
    "tag_chip": _control_schema({"label": STRING_SCHEMA, "value": ANY_SCHEMA, "selected": BOOL_SCHEMA, "enabled": BOOL_SCHEMA, "dismissible": BOOL_SCHEMA, "color": COLOR_SCHEMA, "icon": STRING_SCHEMA}),
    "option": _control_schema({"label": STRING_SCHEMA, "value": ANY_SCHEMA, "description": STRING_SCHEMA, "icon": STRING_SCHEMA, "selected": BOOL_SCHEMA, "enabled": BOOL_SCHEMA, "dense": BOOL_SCHEMA}),
    "select_option": _control_schema({"label": STRING_SCHEMA, "value": ANY_SCHEMA, "description": STRING_SCHEMA, "icon": STRING_SCHEMA, "selected": BOOL_SCHEMA, "enabled": BOOL_SCHEMA, "dense": BOOL_SCHEMA}),
    "tag_filter_bar": FILTER_CHIPS_BAR_SCHEMA,
    "intent_search": INTENT_SEARCH_SCHEMA,
    "checkbox": CHECKBOX_SCHEMA,
    "switch": SWITCH_SCHEMA,
    "segmented_switch": SWITCH_SCHEMA,
    "slider": SLIDER_SCHEMA,
    "span_slider": _control_schema({"start": NUMBER_SCHEMA, "end": NUMBER_SCHEMA, "min": NUMBER_SCHEMA, "max": NUMBER_SCHEMA, "divisions": INTEGER_SCHEMA, "enabled": BOOL_SCHEMA, "labels": BOOL_SCHEMA}),
    "count_stepper": _control_schema({"value": NUMBER_SCHEMA, "min": NUMBER_SCHEMA, "max": NUMBER_SCHEMA, "step": NUMBER_SCHEMA, "wrap": BOOL_SCHEMA, "enabled": BOOL_SCHEMA}),
    "select": SELECT_SCHEMA,
    "segment_bar": SELECT_SCHEMA,
    "combobox": SELECT_SCHEMA,
    "combo_box": SELECT_SCHEMA,
    "dropdown": SELECT_SCHEMA,
    "multi_select": SELECT_SCHEMA,
    "multi_pick": SELECT_SCHEMA,
    "radio": RADIO_SCHEMA,
    "file_picker": FILE_PICKER_SCHEMA,
    "filepicker": FILE_PICKER_SCHEMA,
    "date_picker": _control_schema(
        {
            "value": ANY_SCHEMA,
            "date": ANY_SCHEMA,
            "label": STRING_SCHEMA,
            "placeholder": STRING_SCHEMA,
            "min_date": STRING_SCHEMA,
            "max_date": STRING_SCHEMA,
            "dense": BOOL_SCHEMA,
            "enabled": BOOL_SCHEMA,
        }
    ),
    "date_select": _control_schema(
        {
            "value": ANY_SCHEMA,
            "date": ANY_SCHEMA,
            "label": STRING_SCHEMA,
            "placeholder": STRING_SCHEMA,
            "min_date": STRING_SCHEMA,
            "max_date": STRING_SCHEMA,
            "dense": BOOL_SCHEMA,
            "enabled": BOOL_SCHEMA,
        }
    ),
    "time_select": _control_schema({"value": STRING_SCHEMA, "label": STRING_SCHEMA, "placeholder": STRING_SCHEMA, "minute_step": INTEGER_SCHEMA, "use_24h": BOOL_SCHEMA, "enabled": BOOL_SCHEMA}),
    "date_range_picker": _control_schema(
        {
            "value": ANY_SCHEMA,
            "start": ANY_SCHEMA,
            "end": ANY_SCHEMA,
            "start_date": ANY_SCHEMA,
            "end_date": ANY_SCHEMA,
            "label": STRING_SCHEMA,
            "placeholder": STRING_SCHEMA,
            "min_date": STRING_SCHEMA,
            "max_date": STRING_SCHEMA,
            "dense": BOOL_SCHEMA,
            "enabled": BOOL_SCHEMA,
        }
    ),
    "date_range": _control_schema(
        {
            "value": ANY_SCHEMA,
            "start": ANY_SCHEMA,
            "end": ANY_SCHEMA,
            "start_date": ANY_SCHEMA,
            "end_date": ANY_SCHEMA,
            "label": STRING_SCHEMA,
            "placeholder": STRING_SCHEMA,
            "min_date": STRING_SCHEMA,
            "max_date": STRING_SCHEMA,
            "dense": BOOL_SCHEMA,
            "enabled": BOOL_SCHEMA,
        }
    ),
    "date_span": _control_schema(
        {
            "value": ANY_SCHEMA,
            "start": ANY_SCHEMA,
            "end": ANY_SCHEMA,
            "start_date": ANY_SCHEMA,
            "end_date": ANY_SCHEMA,
            "label": STRING_SCHEMA,
            "placeholder": STRING_SCHEMA,
            "min_date": STRING_SCHEMA,
            "max_date": STRING_SCHEMA,
            "dense": BOOL_SCHEMA,
            "enabled": BOOL_SCHEMA,
        }
    ),
    "directory_picker": DIRECTORY_PICKER_SCHEMA,
    "path_field": PATH_FIELD_SCHEMA,
    "keybind_recorder": KEYBIND_RECORDER_SCHEMA,
    "glyph": _control_schema({"glyph": STRING_SCHEMA, "icon": STRING_SCHEMA, "size": NUMBER_SCHEMA, "color": COLOR_SCHEMA, "tooltip": STRING_SCHEMA}),
    "search_results_view": SEARCH_RESULTS_VIEW_SCHEMA,
    "image": IMAGE_SCHEMA,
    "audio": AUDIO_SCHEMA,
    "canvas": CANVAS_SCHEMA,
    "vector_view": VECTOR_VIEW_SCHEMA,
    "gallery": GALLERY_SCHEMA,
    "skins": SKINS_SCHEMA,
    "video": VIDEO_SCHEMA,
    "sprite": SPRITE_SCHEMA,
    "snap_grid": _control_schema(SNAP_GRID_SCHEMA["properties"]),
    "stagger": _control_schema(STAGGER_SCHEMA["properties"]),
    "transform_box": TRANSFORM_BOX_SCHEMA,
    "dock_layout": _control_schema(),
    "dock": _control_schema(),
    "pane": _control_schema(),
    "pane_spec": _control_schema({"slot": STRING_SCHEMA, "title": STRING_SCHEMA, "size": NUMBER_SCHEMA, "width": NUMBER_SCHEMA, "height": NUMBER_SCHEMA, "min_size": NUMBER_SCHEMA, "max_size": NUMBER_SCHEMA, "collapsible": BOOL_SCHEMA, "collapsed": BOOL_SCHEMA}),
    "dock_pane": _control_schema(),
    "split_view": _control_schema({"axis": STRING_SCHEMA, "ratio": NUMBER_SCHEMA, "min_ratio": NUMBER_SCHEMA, "max_ratio": NUMBER_SCHEMA, "draggable": BOOL_SCHEMA, "divider_size": NUMBER_SCHEMA}),
    "split_pane": _control_schema({"axis": STRING_SCHEMA, "ratio": NUMBER_SCHEMA, "min_ratio": NUMBER_SCHEMA, "max_ratio": NUMBER_SCHEMA, "draggable": BOOL_SCHEMA, "divider_size": NUMBER_SCHEMA}),
    "resizable_panel": RESIZABLE_PANEL_SCHEMA,
    "scrollable_column": SCROLLABLE_COLUMN_SCHEMA,
    "scrollable_row": SCROLLABLE_ROW_SCHEMA,
    "safe_area": SAFE_AREA_SCHEMA,
    "frame": CONTAINER_SCHEMA,
    "grid": _control_schema({"columns": INTEGER_SCHEMA, "spacing": NUMBER_SCHEMA, "run_spacing": NUMBER_SCHEMA, "child_aspect_ratio": NUMBER_SCHEMA, "direction": STRING_SCHEMA, "reverse": BOOL_SCHEMA, "shrink_wrap": BOOL_SCHEMA}),
    "accordion": _control_schema({"sections": {"type": "array", "items": {"type": "object"}}, "labels": {"type": "array", "items": STRING_SCHEMA}, "index": ANY_SCHEMA, "expanded": ANY_SCHEMA, "multiple": BOOL_SCHEMA, "allow_empty": BOOL_SCHEMA, "dense": BOOL_SCHEMA, "show_dividers": BOOL_SCHEMA, "spacing": NUMBER_SCHEMA}),
    "action_bar": _control_schema({"items": {"type": "array", "items": {"type": "object"}}, "dense": BOOL_SCHEMA, "spacing": NUMBER_SCHEMA, "wrap": BOOL_SCHEMA, "alignment": STRING_SCHEMA, "bgcolor": COLOR_SCHEMA}),
    "inspector_panel": _control_schema(),
    "route": _control_schema({"route_id": STRING_SCHEMA, "title": STRING_SCHEMA, "label": STRING_SCHEMA}),
    "route_view": _control_schema({"route_id": STRING_SCHEMA, "title": STRING_SCHEMA, "label": STRING_SCHEMA, "child": ANY_SCHEMA, "children": {"type": "array", "items": ANY_SCHEMA}, "layout": STRING_SCHEMA, "spacing": NUMBER_SCHEMA}),
    "route_host": _control_schema({"route_id": STRING_SCHEMA, "title": STRING_SCHEMA, "label": STRING_SCHEMA, "child": ANY_SCHEMA}),
    "sidebar": SIDEBAR_SCHEMA,
    "app_bar": APP_BAR_SCHEMA,
    "top_bar": APP_BAR_SCHEMA,
    "overlay": OVERLAY_SCHEMA,
    "portal": _control_schema(),
    "modal": MODAL_SCHEMA,
    "problem_screen": PROBLEM_SCREEN_SCHEMA,
    "boot_host": BOOT_HOST_SCHEMA,
    "popover": POPOVER_SCHEMA,
    "inline_search_overlay": INLINE_SEARCH_OVERLAY_SCHEMA,
    "command_search": COMMAND_SEARCH_SCHEMA,
    "slide_panel": SLIDE_PANEL_SCHEMA,
    "side_panel": SLIDE_PANEL_SCHEMA,
    "drawer": SIDE_DRAWER_SCHEMA,
    "side_drawer": SIDE_DRAWER_SCHEMA,
    "snackbar": _control_schema({"message": STRING_SCHEMA, "label": STRING_SCHEMA, "open": BOOL_SCHEMA, "duration_ms": INTEGER_SCHEMA, "action_label": STRING_SCHEMA, "variant": STRING_SCHEMA, "style": STRING_SCHEMA, "icon": STRING_SCHEMA, "instant": BOOL_SCHEMA, "priority": INTEGER_SCHEMA, "use_flushbar": BOOL_SCHEMA, "use_fluttertoast": BOOL_SCHEMA, "toast_position": STRING_SCHEMA}),
    "bottom_sheet": BOTTOM_SHEET_SCHEMA,
    "bounds_probe": BOUNDS_PROBE_SCHEMA,
    "notification_center": NOTIFICATION_CENTER_SCHEMA,
    "notification_host": _control_schema(
        {
            "items": {"type": "array", "items": {"type": "object"}},
            "toasts": {"type": "array", "items": {"type": "object"}},
            "position": STRING_SCHEMA,
            "max_items": INTEGER_SCHEMA,
            "latest_on_top": BOOL_SCHEMA,
            "dismissible": BOOL_SCHEMA,
            "spacing": NUMBER_SCHEMA,
            "padding": PADDING_SCHEMA,
            "events": {"type": "array", "items": STRING_SCHEMA},
        }
    ),
    "progress_overlay": PROGRESS_OVERLAY_SCHEMA,
    "download_item": DOWNLOAD_ITEM_SCHEMA,
    "queue_list": QUEUE_LIST_SCHEMA,
    "result_preview_pane": RESULT_PREVIEW_PANE_SCHEMA,
    "color_swatch_grid": COLOR_SWATCH_GRID_SCHEMA,
    "gradient_editor": GRADIENT_EDITOR_SCHEMA,
    "histogram_view": HISTOGRAM_VIEW_SCHEMA,
    "crop_box": CROP_BOX_SCHEMA,
    "ruler_guides": RULER_GUIDES_SCHEMA,
    "adjustment_panel": ADJUSTMENT_PANEL_SCHEMA,
    "curve_editor": CURVE_EDITOR_SCHEMA,
    "histogram_overlay": HISTOGRAM_OVERLAY_SCHEMA,
    "brush_panel": BRUSH_PANEL_SCHEMA,
    "layer_mask_editor": LAYER_MASK_EDITOR_SCHEMA,
    "blend_mode_picker": BLEND_MODE_PICKER_SCHEMA,
    "history_stack": HISTORY_STACK_SCHEMA,
    "transform_toolbar": TRANSFORM_TOOLBAR_SCHEMA,
    "guides_manager": GUIDES_MANAGER_SCHEMA,
    "rulers_overlay": RULERS_OVERLAY_SCHEMA,
    "selection_tools": SELECTION_TOOLS_SCHEMA,
    "preset_gallery": PRESET_GALLERY_SCHEMA,
    "export_panel": EXPORT_PANEL_SCHEMA,
    "info_bar": INFO_BAR_SCHEMA,
    "mini_map": MINI_MAP_SCHEMA,
    "ide": IDE_SCHEMA,
    "code_editor": CODE_EDITOR_SCHEMA,
    "studio": STUDIO_SCHEMA,
    "code_buffer": CODE_BUFFER_SCHEMA,
    "code_document": CODE_DOCUMENT_SCHEMA,
    "multi_cursor_controller": MULTI_CURSOR_CONTROLLER_SCHEMA,
    "syntax_layer": SYNTAX_LAYER_SCHEMA,
    "fold_layer": FOLD_LAYER_SCHEMA,
    "layer": LAYER_SCHEMA,
    "layer_list": _control_schema({"layers": {"type": "array", "items": {"type": "object"}}, "active_layer": STRING_SCHEMA, "active_id": STRING_SCHEMA, "max_visible_overlays": INTEGER_SCHEMA, "mode": STRING_SCHEMA}),
    "semantic_layer": SEMANTIC_LAYER_SCHEMA,
    "code_category_layer": CODE_CATEGORY_LAYER_SCHEMA,
    "ownership_marker": OWNERSHIP_MARKER_SCHEMA,
    "inline_widget": INLINE_WIDGET_SCHEMA,
    "virtual_file_system": VIRTUAL_FILE_SYSTEM_SCHEMA,
    "file_system": FILE_SYSTEM_SCHEMA,
    "editor_intent_router": EDITOR_INTENT_ROUTER_SCHEMA,
    "focus_mode_controller": FOCUS_MODE_CONTROLLER_SCHEMA,
    "control_preset": CONTROL_PRESET_SCHEMA,
    "behavior_mixins": BEHAVIOR_MIXINS_SCHEMA,
    "editor_view": EDITOR_VIEW_SCHEMA,
    "editor_surface": EDITOR_SURFACE_SCHEMA,
    "gutter": GUTTER_SCHEMA,
    "symbol_tree": SYMBOL_TREE_SCHEMA,
    "outline_view": OUTLINE_VIEW_SCHEMA,
    "outline": OUTLINE_VIEW_SCHEMA,
    "breadcrumb_bar": BREADCRUMB_BAR_SCHEMA,
    "crumb_trail": CRUMB_TRAIL_SCHEMA,
    "status_bar": STATUS_BAR_SCHEMA,
    "status_mark": _control_schema({"label": STRING_SCHEMA, "status": STRING_SCHEMA, "value": STRING_SCHEMA, "icon": STRING_SCHEMA, "dense": BOOL_SCHEMA, "align": STRING_SCHEMA, "color": COLOR_SCHEMA}),
    "context_action_bar": CONTEXT_ACTION_BAR_SCHEMA,
    "command_palette": COMMAND_PALETTE_SCHEMA,
    "diagnostic_stream": DIAGNOSTIC_STREAM_SCHEMA,
    "execution_lane": EXECUTION_LANE_SCHEMA,
    "preview_surface": PREVIEW_SURFACE_SCHEMA,
    "native_preview_host": NATIVE_PREVIEW_HOST_SCHEMA,
    "state_snapshot": STATE_SNAPSHOT_SCHEMA,
    "hot_reload_boundary": HOT_RELOAD_BOUNDARY_SCHEMA,
    "semantic_search": SEMANTIC_SEARCH_SCHEMA,
    "scoped_search_replace": SCOPED_SEARCH_REPLACE_SCHEMA,
    "intent_router": INTENT_ROUTER_SCHEMA,
    "preview_intent_interceptor": PREVIEW_INTENT_INTERCEPTOR_SCHEMA,
    "preview_presets": PREVIEW_PRESETS_SCHEMA,
    "layout_freeze": LAYOUT_FREEZE_SCHEMA,
    "time_travel_lite": TIME_TRAVEL_LITE_SCHEMA,
    "time_travel": TIME_TRAVEL_LITE_SCHEMA,
    "live_control_picker": LIVE_CONTROL_PICKER_SCHEMA,
    "preview_error_overlay": PREVIEW_ERROR_OVERLAY_SCHEMA,
    "search_everything_panel": SEARCH_EVERYTHING_PANEL_SCHEMA,
    "state_inspector": STATE_INSPECTOR_SCHEMA,
    "dock_graph": DOCK_GRAPH_SCHEMA,
    "intent_panel": INTENT_PANEL_SCHEMA,
    "diff_narrator": DIFF_NARRATOR_SCHEMA,
    "ghost_editor": GHOST_EDITOR_SCHEMA,
    "emoji_picker": EMOJI_PICKER_SCHEMA,
    "field_group": _control_schema({"label": STRING_SCHEMA, "helper_text": STRING_SCHEMA, "error_text": STRING_SCHEMA, "spacing": NUMBER_SCHEMA, "required": BOOL_SCHEMA}),
    "filter_drawer": _control_schema({"title": STRING_SCHEMA, "open": BOOL_SCHEMA, "schema": {"type": "object"}, "state": {"type": "object"}, "show_actions": BOOL_SCHEMA, "apply_label": STRING_SCHEMA, "clear_label": STRING_SCHEMA, "dense": BOOL_SCHEMA, "events": {"type": "array", "items": STRING_SCHEMA}}),
    "icon_picker": ICON_PICKER_SCHEMA,
    "file_tree": FILE_TREE_SCHEMA,
    "log_viewer": LOG_VIEWER_SCHEMA,
    "reorderable_list": REORDERABLE_LIST_SCHEMA,
    "reorderable_tree": REORDERABLE_TREE_SCHEMA,
    "drag_handle": DRAG_HANDLE_SCHEMA,
    "drag_payload": DRAG_PAYLOAD_SCHEMA,
    "drop_zone": DROP_ZONE_SCHEMA,
    "focus_anchor": _control_schema({"autofocus": BOOL_SCHEMA, "enabled": BOOL_SCHEMA, "can_request_focus": BOOL_SCHEMA, "skip_traversal": BOOL_SCHEMA, "descendants_are_focusable": BOOL_SCHEMA, "descendants_are_traversable": BOOL_SCHEMA}),
    "gesture_area": _control_schema({"enabled": BOOL_SCHEMA, "tap_enabled": BOOL_SCHEMA, "double_tap_enabled": BOOL_SCHEMA, "long_press_enabled": BOOL_SCHEMA, "pan_enabled": BOOL_SCHEMA, "scale_enabled": BOOL_SCHEMA}),
    "pressable": _control_schema({"enabled": BOOL_SCHEMA, "autofocus": BOOL_SCHEMA, "hover_enabled": BOOL_SCHEMA, "focus_enabled": BOOL_SCHEMA}),
    "hover_region": _control_schema({"enabled": BOOL_SCHEMA, "opaque": BOOL_SCHEMA, "cursor": STRING_SCHEMA, "events": {"type": "array", "items": STRING_SCHEMA}, "throttle_ms": INTEGER_SCHEMA}),
    "details_pane": _control_schema({"mode": STRING_SCHEMA, "split_ratio": NUMBER_SCHEMA, "stack_breakpoint": NUMBER_SCHEMA, "show_details": BOOL_SCHEMA, "show_back": BOOL_SCHEMA, "back_label": STRING_SCHEMA, "divider": BOOL_SCHEMA}),
    "flex_spacer": _control_schema({"flex": INTEGER_SCHEMA}),
    "spacer": _control_schema({"flex": INTEGER_SCHEMA}),
    "view_stack": _control_schema({"index": INTEGER_SCHEMA, "animate": BOOL_SCHEMA, "duration_ms": INTEGER_SCHEMA, "keep_alive": BOOL_SCHEMA}),
    "viewport": _control_schema({"width": NUMBER_SCHEMA, "height": NUMBER_SCHEMA, "x": NUMBER_SCHEMA, "y": NUMBER_SCHEMA, "clip": BOOL_SCHEMA}),
    "visibility": _control_schema({"visible": BOOL_SCHEMA, "maintain_state": BOOL_SCHEMA, "maintain_size": BOOL_SCHEMA, "maintain_animation": BOOL_SCHEMA, "replacement": ANY_SCHEMA}),
    "cursor": _control_schema({"cursor": STRING_SCHEMA, "enabled": BOOL_SCHEMA, "opaque": BOOL_SCHEMA}),
    "nav_ring": _control_schema({"items": {"type": "array", "items": {"type": "object"}}, "selected_id": STRING_SCHEMA, "policy": STRING_SCHEMA, "dense": BOOL_SCHEMA}),
    "rail_nav": _control_schema({"items": {"type": "array", "items": {"type": "object"}}, "selected_id": STRING_SCHEMA, "selected_index": INTEGER_SCHEMA, "dense": BOOL_SCHEMA, "extended": BOOL_SCHEMA}),
    "navigator": SIDEBAR_SCHEMA,
    "notice_bar": _control_schema({"text": STRING_SCHEMA, "variant": STRING_SCHEMA, "icon": STRING_SCHEMA, "dismissible": BOOL_SCHEMA, "action_label": STRING_SCHEMA, "action_id": STRING_SCHEMA}),
    "numeric_field": _control_schema({"value": NUMBER_SCHEMA, "min": NUMBER_SCHEMA, "max": NUMBER_SCHEMA, "step": NUMBER_SCHEMA, "decimals": INTEGER_SCHEMA, "label": STRING_SCHEMA, "placeholder": STRING_SCHEMA, "enabled": BOOL_SCHEMA, "dense": BOOL_SCHEMA}),
    "data_source_view": _control_schema({"sources": {"type": "array", "items": {"type": "object"}}, "selected_id": STRING_SCHEMA, "query": STRING_SCHEMA, "show_search": BOOL_SCHEMA, "dense": BOOL_SCHEMA}),
    "sortable_header": _control_schema({"columns": {"type": "array", "items": {"type": "object"}}, "sort_column": STRING_SCHEMA, "sort_ascending": BOOL_SCHEMA, "dense": BOOL_SCHEMA}),
    "sticky_list": _control_schema(STICKY_LIST_SCHEMA["properties"]),
    "auto_form": AUTO_FORM_SCHEMA,
    "form": _control_schema({"title": STRING_SCHEMA, "description": STRING_SCHEMA, "spacing": NUMBER_SCHEMA}),
    "form_field": _control_schema({"label": STRING_SCHEMA, "description": STRING_SCHEMA, "required": BOOL_SCHEMA, "helper_text": STRING_SCHEMA, "error_text": STRING_SCHEMA, "spacing": NUMBER_SCHEMA}),
    "validation_summary": _control_schema({"title": STRING_SCHEMA, "errors": {"type": "array", "items": STRING_SCHEMA}, "messages": {"type": "array", "items": STRING_SCHEMA}, "items": {"type": "array", "items": ANY_SCHEMA}}),
    "submit_scope": _control_schema({"enabled": BOOL_SCHEMA, "submit_on_enter": BOOL_SCHEMA, "submit_on_ctrl_enter": BOOL_SCHEMA, "debounce_ms": INTEGER_SCHEMA, "payload": {"type": "object"}}),
    "surface": SURFACE_SCHEMA,
    "paginator": _control_schema({"page": INTEGER_SCHEMA, "page_count": INTEGER_SCHEMA, "enabled": BOOL_SCHEMA}),
    "page_nav": _control_schema({"page": INTEGER_SCHEMA, "page_count": INTEGER_SCHEMA, "page_size": INTEGER_SCHEMA, "total_items": INTEGER_SCHEMA, "max_visible": INTEGER_SCHEMA, "show_edges": BOOL_SCHEMA, "dense": BOOL_SCHEMA, "enabled": BOOL_SCHEMA}),
    "page_stepper": _control_schema({"page": INTEGER_SCHEMA, "page_count": INTEGER_SCHEMA, "page_size": INTEGER_SCHEMA, "total_items": INTEGER_SCHEMA, "max_visible": INTEGER_SCHEMA, "show_edges": BOOL_SCHEMA, "dense": BOOL_SCHEMA, "enabled": BOOL_SCHEMA}),
    "toast_host": _control_schema(
        {
            "items": {"type": "array", "items": {"type": "object"}},
            "toasts": {"type": "array", "items": {"type": "object"}},
            "position": STRING_SCHEMA,
            "max_items": INTEGER_SCHEMA,
            "latest_on_top": BOOL_SCHEMA,
            "dismissible": BOOL_SCHEMA,
            "spacing": NUMBER_SCHEMA,
            "padding": PADDING_SCHEMA,
            "events": {"type": "array", "items": STRING_SCHEMA},
        }
    ),
    "drag_region": _control_schema({"draggable": BOOL_SCHEMA, "maximize_on_double_tap": BOOL_SCHEMA, "emit_move": BOOL_SCHEMA}),
    "window_controls": _control_schema(),
    "terminal": TERMINAL_SCHEMA,
    "output_panel": OUTPUT_PANEL_SCHEMA,
    "log_panel": OUTPUT_PANEL_SCHEMA,
    "editor_tab_strip": EDITOR_TAB_STRIP_SCHEMA,
    "editor_tabs": EDITOR_TAB_STRIP_SCHEMA,
    "document_tab_strip": EDITOR_TAB_STRIP_SCHEMA,
    "workspace_tree": WORKSPACE_TREE_SCHEMA,
    "workspace_explorer": WORKSPACE_TREE_SCHEMA,
    "explorer_tree": WORKSPACE_TREE_SCHEMA,
    "problems_panel": PROBLEMS_PANEL_SCHEMA,
    "diagnostics_panel": PROBLEMS_PANEL_SCHEMA,
    "editor_workspace": EDITOR_WORKSPACE_SCHEMA,
    "workbench_editor": EDITOR_WORKSPACE_SCHEMA,
    "breadcrumbs": CRUMB_TRAIL_SCHEMA,
    "menu_bar": _control_schema({"items": {"type": "array", "items": {"type": "object"}}, "dense": BOOL_SCHEMA, "show_dividers": BOOL_SCHEMA, "enabled": BOOL_SCHEMA}),
    "command_item": _control_schema({"id": STRING_SCHEMA, "label": STRING_SCHEMA, "value": ANY_SCHEMA, "description": STRING_SCHEMA, "icon": STRING_SCHEMA, "shortcut": STRING_SCHEMA, "enabled": BOOL_SCHEMA}),
    "table_view": _control_schema({"columns": {"type": "array", "items": ANY_SCHEMA}, "rows": {"type": "array", "items": ANY_SCHEMA}, "sortable": BOOL_SCHEMA, "filterable": BOOL_SCHEMA, "selectable": BOOL_SCHEMA, "dense": BOOL_SCHEMA, "striped": BOOL_SCHEMA, "show_header": BOOL_SCHEMA, "sort_column": STRING_SCHEMA, "sort_ascending": BOOL_SCHEMA, "filter_query": STRING_SCHEMA}),
    "tree_view": _control_schema({"nodes": {"type": "array", "items": ANY_SCHEMA}, "expanded": {"type": "array", "items": STRING_SCHEMA}, "dense": BOOL_SCHEMA, "multi_select": BOOL_SCHEMA, "show_root": BOOL_SCHEMA, "expand_all": BOOL_SCHEMA, "show_search": BOOL_SCHEMA, "show_expand_collapse_all": BOOL_SCHEMA, "search_placeholder": STRING_SCHEMA, "search_hint": STRING_SCHEMA, "auto_expand_search_hits": BOOL_SCHEMA}),
    "virtual_list": _control_schema({"item_count": INTEGER_SCHEMA, "item_extent": NUMBER_SCHEMA, "cache_extent": NUMBER_SCHEMA, "padding": PADDING_SCHEMA, "reverse": BOOL_SCHEMA, "shrink_wrap": BOOL_SCHEMA, "physics": STRING_SCHEMA}),
    "virtual_grid": _control_schema({"item_count": INTEGER_SCHEMA, "cross_axis_count": INTEGER_SCHEMA, "main_axis_extent": NUMBER_SCHEMA, "child_aspect_ratio": NUMBER_SCHEMA, "cross_axis_spacing": NUMBER_SCHEMA, "main_axis_spacing": NUMBER_SCHEMA, "padding": PADDING_SCHEMA, "reverse": BOOL_SCHEMA, "shrink_wrap": BOOL_SCHEMA, "physics": STRING_SCHEMA}),
    "scene_view": _control_schema({"background": ANY_SCHEMA, "show_grid": BOOL_SCHEMA, "show_axes": BOOL_SCHEMA, "camera": {"type": "object"}}),
    "search_provider": SEARCH_PROVIDER_SCHEMA,
    "search_history": SEARCH_HISTORY_SCHEMA,

    "webview": _control_schema({"url": STRING_SCHEMA, "html": STRING_SCHEMA, "initial_url": STRING_SCHEMA, "javascript_enabled": BOOL_SCHEMA, "transparent": BOOL_SCHEMA, "allow_navigation": BOOL_SCHEMA, "headers": {"type": "object"}}),

    "webview_adapter": WEBVIEW_ADAPTER_SCHEMA,

    # Candy
    "candy": CANDY_SCHEMA,
    "emoji_icon": EMOJI_ICON_SCHEMA,
    "color_picker": COLOR_PICKER_SCHEMA,

    # Studio
    "studio_canvas": STUDIO_CANVAS_SCHEMA,
    "studio_timeline_surface": STUDIO_TIMELINE_SURFACE_SCHEMA,
    "studio_node_surface": STUDIO_NODE_SURFACE_SCHEMA,
    "studio_preview_surface": STUDIO_PREVIEW_SURFACE_SCHEMA,
    "studio_tokens_editor": STUDIO_TOKENS_EDITOR_SCHEMA,
    "studio_builder": STUDIO_BUILDER_SCHEMA,
    "studio_block_palette": STUDIO_BLOCK_PALETTE_SCHEMA,
    "studio_component_palette": STUDIO_BLOCK_PALETTE_SCHEMA,
    "studio_inspector": STUDIO_INSPECTOR_SCHEMA,
    "studio_asset_browser": STUDIO_ASSET_BROWSER_SCHEMA,
    "studio_actions_editor": STUDIO_ACTIONS_EDITOR_SCHEMA,
    "studio_bindings_editor": STUDIO_BINDINGS_EDITOR_SCHEMA,
    "studio_responsive_toolbar": STUDIO_RESPONSIVE_TOOLBAR_SCHEMA,
    "studio_project_panel": STUDIO_PROJECT_PANEL_SCHEMA,
    "studio_outline_tree": STUDIO_OUTLINE_TREE_SCHEMA,
    "studio_properties_panel": STUDIO_PROPERTIES_PANEL_SCHEMA,
}

# Compatibility mappings for renderer-wired controls that share existing
# contracts or only require permissive property acceptance in 0.1.0.
CONTROL_SCHEMAS.update(
    {
        "animated_background": _control_schema({"layers": {"type": "array", "items": ANY_SCHEMA}, "speed": NUMBER_SCHEMA}),
        "animation_asset": _control_schema({"src": STRING_SCHEMA, "asset": STRING_SCHEMA, "autoplay": BOOL_SCHEMA, "loop": BOOL_SCHEMA}),
        "box": CONTAINER_SCHEMA,
        "card": CONTAINER_SCHEMA,
        "chat": CHAT_THREAD_SCHEMA,
        "column": COLUMN_SCHEMA,
        "container": CONTAINER_SCHEMA,
        "container_style": _control_schema(
            {
                "variant": STRING_SCHEMA,
                "outline_width": NUMBER_SCHEMA,
                "outline_color": COLOR_SCHEMA,
                "stroke_width": NUMBER_SCHEMA,
                "stroke_color": COLOR_SCHEMA,
                "shadow_color": COLOR_SCHEMA,
                "shadow_blur": NUMBER_SCHEMA,
                "shadow_dx": NUMBER_SCHEMA,
                "shadow_dy": NUMBER_SCHEMA,
                "glow_color": COLOR_SCHEMA,
                "glow_blur": NUMBER_SCHEMA,
                "bgcolor": COLOR_SCHEMA,
                "background": COLOR_SCHEMA,
                "bg_color": COLOR_SCHEMA,
                "border_color": COLOR_SCHEMA,
                "border_width": NUMBER_SCHEMA,
                "radius": NUMBER_SCHEMA,
                "shape": STRING_SCHEMA,
                "content_padding": PADDING_SCHEMA,
                "inner_padding": PADDING_SCHEMA,
                "icon_padding": PADDING_SCHEMA,
                "animation": {"type": "object"},
            }
        ),
        "context_menu": _control_schema({"items": {"type": "array", "items": ANY_SCHEMA}, "open": BOOL_SCHEMA}),
        "data_grid": JSON_TABLE_SCHEMA,
        "data_table": JSON_TABLE_SCHEMA,
        "divider": _control_schema({"orientation": STRING_SCHEMA, "thickness": NUMBER_SCHEMA, "indent": NUMBER_SCHEMA}),
        "expanded": _control_schema({"flex": INTEGER_SCHEMA}),
        "file_browser": _control_schema({"items": {"type": "array", "items": ANY_SCHEMA}, "path": STRING_SCHEMA}),
        "gradient": GRADIENT_SCHEMA,
        "grid_view": GRID_VIEW_SCHEMA,
        "icon": _control_schema({"name": STRING_SCHEMA, "value": STRING_SCHEMA, "size": NUMBER_SCHEMA, "color": COLOR_SCHEMA}),
        "item_tile": _control_schema({"title": STRING_SCHEMA, "subtitle": STRING_SCHEMA, "leading": ANY_SCHEMA, "trailing": ANY_SCHEMA}),
        "key_listener": _control_schema({"autofocus": BOOL_SCHEMA, "enabled": BOOL_SCHEMA}),
        "launcher": _control_schema({"items": {"type": "array", "items": ANY_SCHEMA}, "query": STRING_SCHEMA, "open": BOOL_SCHEMA}),
        "list_tile": _control_schema({"title": STRING_SCHEMA, "subtitle": STRING_SCHEMA, "leading": ANY_SCHEMA, "trailing": ANY_SCHEMA}),
        "list_view": _control_schema({"reverse": BOOL_SCHEMA, "shrink_wrap": BOOL_SCHEMA, "padding": PADDING_SCHEMA, "spacing": NUMBER_SCHEMA}),
        "menu_item": _control_schema({"id": STRING_SCHEMA, "label": STRING_SCHEMA, "icon": STRING_SCHEMA, "enabled": BOOL_SCHEMA}),
        "overlay_host": _control_schema({"items": {"type": "array", "items": ANY_SCHEMA}}),
        "page": _control_schema({"title": STRING_SCHEMA, "bgcolor": COLOR_SCHEMA, "safe_area": BOOL_SCHEMA}),
        "page_scene": _control_schema({"title": STRING_SCHEMA, "subtitle": STRING_SCHEMA, "show_header": BOOL_SCHEMA}),
        "particle_field": PARTICLE_FIELD_SCHEMA,
        "progress_timeline": _control_schema({"items": {"type": "array", "items": ANY_SCHEMA}, "current": INTEGER_SCHEMA}),
        "router": _control_schema({"route": STRING_SCHEMA, "routes": {"type": "array", "items": ANY_SCHEMA}}),
        "row": ROW_SCHEMA,
        "scroll_view": SCROLL_VIEW_SCHEMA,
        "shortcut_map": _control_schema({"bindings": {"type": "array", "items": ANY_SCHEMA}, "enabled": BOOL_SCHEMA}),
        "skeleton": _control_schema({"enabled": BOOL_SCHEMA, "lines": INTEGER_SCHEMA, "height": NUMBER_SCHEMA}),
        "skeleton_loader": _control_schema({"enabled": BOOL_SCHEMA, "lines": INTEGER_SCHEMA, "height": NUMBER_SCHEMA}),
        "splash": _control_schema(
            {
                "active": BOOL_SCHEMA,
                "color": COLOR_SCHEMA,
                "duration_ms": INTEGER_SCHEMA,
                "radius": NUMBER_SCHEMA,
                "centered": BOOL_SCHEMA,
                "title": STRING_SCHEMA,
                "subtitle": STRING_SCHEMA,
                "message": STRING_SCHEMA,
                "loading": BOOL_SCHEMA,
                "progress": NUMBER_SCHEMA,
                "show_progress": BOOL_SCHEMA,
                "skip_enabled": BOOL_SCHEMA,
                "auto_start": BOOL_SCHEMA,
                "hide_on_complete": BOOL_SCHEMA,
                "min_duration_ms": INTEGER_SCHEMA,
                "background": COLOR_SCHEMA,
                "effect": STRING_SCHEMA,
            }
        ),
        "stack": STACK_SCHEMA,
        "table": JSON_TABLE_SCHEMA,
        "tabs": _control_schema({"items": {"type": "array", "items": ANY_SCHEMA}, "selected": INTEGER_SCHEMA}),
        "task_list": _control_schema({"items": {"type": "array", "items": ANY_SCHEMA}, "dense": BOOL_SCHEMA}),
        "toast": _control_schema({"message": STRING_SCHEMA, "title": STRING_SCHEMA, "variant": STRING_SCHEMA, "open": BOOL_SCHEMA}),
        "tooltip": _control_schema({"message": STRING_SCHEMA, "text": STRING_SCHEMA, "placement": STRING_SCHEMA}),
        "tree_node": _control_schema({"id": STRING_SCHEMA, "label": STRING_SCHEMA, "children": {"type": "array", "items": ANY_SCHEMA}}),
        "window_drag_region": _control_schema({"draggable": BOOL_SCHEMA, "maximize_on_double_tap": BOOL_SCHEMA, "emit_move": BOOL_SCHEMA}),
        "window_frame": _control_schema({
            "title": STRING_SCHEMA,
            "show_controls": BOOL_SCHEMA,
            "dense": BOOL_SCHEMA,
            "show_close": BOOL_SCHEMA,
            "show_maximize": BOOL_SCHEMA,
            "show_minimize": BOOL_SCHEMA,
            "draggable": BOOL_SCHEMA,
            "custom_frame": BOOL_SCHEMA,
            "use_native_title_bar": BOOL_SCHEMA,
            "native_window_actions": BOOL_SCHEMA,
            "show_default_controls": BOOL_SCHEMA,
            "emit_move": BOOL_SCHEMA,
            "emit_move_events": BOOL_SCHEMA,
            "move_event_throttle_ms": INTEGER_SCHEMA,
            "title_leading": ANY_SCHEMA,
            "title_content": ANY_SCHEMA,
            "title_trailing": ANY_SCHEMA,
        }),
        "wrap": WRAP_SCHEMA,
        "empty_state_view": CONTROL_SCHEMAS["empty_state"],
        "tree": CONTROL_SCHEMAS["tree_view"],
    }
)


def _merge_layout(schema: dict[str, Any]) -> dict[str, Any]:
    props = dict(LAYOUT_PROPS_SCHEMA)
    props.update(schema.get("properties", {}))
    schema["properties"] = props
    schema.setdefault("additionalProperties", True)
    return schema


_ALL_CONTROL_TYPES = {
    "AdjustmentPanel",
    "AnimatedGradient",
    "BlendModePicker",
    "BlobField",
    "Clipboard",
    "Cursor",
    "DownloadItem",
    "EffectLayer",
    "EmojiPicker",
    "FileTree",
    "FlowField",
    "Gradient",
    "GuidesManager",
    "HistoryStack",
    "Layer",
    "Lifecycle",
    "LogViewer",
    "Motion",
    "NativePreviewHost",
    "NoiseField",
    "Parallax",
    "ParticleField",
    "Pose",
    "PresetGallery",
    "QueueList",
    "SceneView",
    "Sprite",
    "Stagger",
    "StickyList",
    "Timeline",
    "timeline_track",
    "TrayItem",
    "VectorView",
    "Visibility",
    "When",
    "WindowFrame",
    "accordion",
    "action_bar",
    "align",
    "border",
    "border_side",
    "animated_background",
    "app_bar",
    "artifact_card",
    "async_action_button",
    "attachment_tile",
    "audio",
    "auto_form",
    "avatar_stack",
    "badge",
    "bar_plot",
    "behavior_mixins",
    "bottom_sheet",
    "bounds_probe",
    "breadcrumb_bar",
    "breadcrumbs",
    "brush_panel",
    "button",
    "elevated_button",
    "button_style",
    "callout",
    "candy",
    "gallery",
    "skins",
    "canvas",
    "card",
    "center",
    "chat_bubble",
    "chat_message",
    "chat_thread",
    "check_list",
    "checkbox",
    "chip",
    "chromatic_shift",
    "code",
    "code_block",
    "code_buffer",
    "code_category_layer",
    "code_document",
    "code_editor",
    "color_picker",
    "color_swatch_grid",
    "column",
    "command_bar",
    "command_item",
    "command_palette",
    "command_search",
    "confetti_burst",
    "confirm_dialog",
    "container",
    "container_style",
    "context_action_bar",
    "context_menu",
    "control_preset",
    "count_stepper",
    "crop_box",
    "crumb_trail",
    "curve_editor",
    "data_grid",
    "data_source_view",
    "date_select",
    "date_span",
    "details_pane",
    "diagnostic_stream",
    "diff_narrator",
    "directory_picker",
    "divider",
    "dock_graph",
    "drag_handle",
    "drag_payload",
    "drop_zone",
    "dropdown",
    "editor_intent_router",
    "editor_minimap",
    "editor_surface",
    "editor_view",
    "emoji_icon",
    "empty_state_view",
    "empty_view",
    "execution_lane",
    "expanded",
    "export_panel",
    "field_group",
    "file_picker",
    "file_tabs",
    "filter_chips_bar",
    "filter_drawer",
    "flex_spacer",
    "flow_page",
    "focus_anchor",
    "focus_mode_controller",
    "fold_layer",
    "form",
    "frame",
    "gallery",
    "gesture_area",
    "ghost_editor",
    "glass_blur",
    "glow_effect",
    "glyph",
    "glyph_button",
    "icon",
    "gradient_editor",
    "gradient_sweep",
    "grain_overlay",
    "grid",
    "grid_view",
    "gutter",
    "hint",
    "histogram_overlay",
    "histogram_view",
    "hot_reload_boundary",
    "hover_region",
    "html",
    "icon_button",
    "icon_picker",
    "image",
    "info_bar",
    "inline_error_view",
    "inline_search_overlay",
    "inspector",
    "intent_panel",
    "intent_router",
    "intent_search",
    "item_tile",
    "json_diff",
    "json_editor",
    "json_inspector",
    "json_path_picker",
    "json_table",
    "json_tree",
    "json_view",
    "key_listener",
    "keybind_recorder",
    "layer",
    "layer_list",
    "layer_mask_editor",
    "layout_freeze",
    "line_chart",
    "line_plot",
    "liquid_morph",
    "list_surface",
    "list_tile",
    "live_control_picker",
    "markdown",
    "mentioned_pill",
    "menu_bar",
    "menu_item",
    "message_bubble",
    "message_composer",
    "message_divider",
    "message_meta",
    "mini_map",
    "modal",
    "morphing_border",
    "multi_cursor_controller",
    "multi_pick",
    "multi_source_merge_view",
    "nav_ring",
    "navigator",
    "neon_edge",
    "noise_displacement",
    "notice_bar",
    "notification_center",
    "numeric_field",
    "option",
    "outline_reveal",
    "outline_view",
    "overlay",
    "overlay_page",
    "ownership_marker",
    "page_nav",
    "page_route",
    "page_stepper",
    "pan_zoom",
    "panel_page",
    "parallax_offset",
    "path_field",
    "persona",
    "pie_plot",
    "pixelate",
    "popover",
    "pressable",
    "preview_error_overlay",
    "preview_intent_interceptor",
    "preview_presets",
    "preview_surface",
    "progress",
    "progress_indicator",
    "progress_overlay",
    "query_token",
    "quoted_message",
    "radio",
    "rail_nav",
    "rating_display",
    "reaction_bar",
    "reorderable_list",
    "reorderable_tree",
    "resizable_panel",
    "result_card",
    "result_preview_pane",
    "ripple_burst",
    "row",
    "ruler_guides",
    "rulers_overlay",
    "safe_area",
    "scanline_overlay",
    "scope_picker",
    "scoped_search_replace",
    "scroll_view",
    "scrollable_column",
    "scrollable_row",
    "search_bar",
    "search_box",
    "search_everything_panel",
    "search_field",
    "search_history",
    "search_intent",
    "search_item",
    "search_provider",
    "search_results_view",
    "search_scope_selector",
    "search_source",
    "segment_bar",
    "segmented_switch",
    "select",
    "select_option",
    "selection_tools",
    "semantic_layer",
    "semantic_search",
    "shadow_stack",
    "shimmer",
    "shortcut_map",
    "side_drawer",
    "side_panel",
    "sidebar",
    "skeleton",
    "skeleton_loader",
    "slide_panel",
    "slider",
    "smart_search_bar",
    "snackbar",
    "snap_grid",
    "sortable_header",
    "spacer",
    "span_slider",
    "spark_plot",
    "splash",
    "splash_page",
    "split_pane",
    "split_view",
    "stack",
    "stack_page",
    "stage_page",
    "state_inspector",
    "state_snapshot",
    "status_bar",
    "status_mark",
    "studio",
    "studio_actions_editor",
    "studio_asset_browser",
    "studio_bindings_editor",
    "studio_block_palette",
    "studio_builder",
    "studio_canvas",
    "studio_timeline_surface",
    "studio_node_surface",
    "studio_preview_surface",
    "studio_component_palette",
    "studio_inspector",
    "studio_outline_tree",
    "studio_project_panel",
    "studio_properties_panel",
    "studio_responsive_toolbar",
    "studio_tokens_editor",
    "submit_scope",
    "surface",
    "switch",
    "symbol_tree",
    "syntax_layer",
    "table",
    "table_view",
    "tabs",
    "tag_chip",
    "terminal",
    "output_panel",
    "log_panel",
    "text",
    "text_area",
    "text_field",
    "text_field_style",
    "tilt_hover",
    "time_select",
    "time_travel_lite",
    "toast",
    "toggle_set",
    "tooltip",
    "top_bar",
    "transform_box",
    "transform_toolbar",
    "tree",
    "tree_node",
    "tree_view",
    "typing_indicator",
    "ux_root",
    "validator",
    "video",
    "view_stack",
    "viewport",
    "vignette",
    "virtual_file_system",
    "virtual_list",
    "webview",
    "workspace_page",
    "wrap",
}


# --- RUNTIME_PROP_HINTS START ---
RUNTIME_PROP_HINTS = {
    'accordion': ['accent_color', 'allowEmpty', 'allow_empty', 'body_color', 'body_padding', 'border_color', 'content_padding', 'dense', 'divider_color', 'elevation', 'expanded', 'glass_blur', 'glass_opacity', 'header_bg', 'header_color', 'header_padding', 'index', 'labels', 'multiple', 'radius', 'show_dividers', 'spacing', 'style', 'variant'],
    'action_bar': ['bgcolor', 'spacing'],
    'adjustment_panel': ['items'],
    'attachment_tile': ['kind', 'name', 'url'],
    'avatar_stack': ['avatars', 'items', 'size', 'overlap', 'max'],
    'badge': ['label', 'text', 'value', 'color', 'bgcolor', 'offset', 'radius', 'text_color', 'padding', 'clickable'],
    'bar_plot': ['color', 'colors', 'max', 'min', 'spacing', 'values'],
    'blend_mode_picker': ['value', 'options', 'items', 'label', 'enabled', 'dense'],
    'blob_field': ['count', 'seed', 'color', 'background', 'bgcolor'],
    'border': ['color', 'width', 'radius', 'side', 'padding'],
    'border_side': ['side', 'color', 'width', 'length'],
    'button_style': ['value', 'options'],
    'gallery': [
        'schema_version', 'module', 'state', 'items', 'spacing', 'run_spacing', 'tile_width', 'tile_height', 'selectable', 'enabled', 'events', 'modules',
        'manifest', 'registries',
        'toolbar', 'filter_bar', 'grid_layout', 'item_actions', 'item_badge',
        'item_meta_row', 'item_preview', 'item_selectable', 'item_tile',
        'pagination', 'section_header', 'sort_bar', 'empty_state',
        'loading_skeleton', 'search_bar', 'font_picker', 'audio_picker',
        'video_picker', 'image_picker', 'document_picker',
        'fonts', 'font_renderer', 'audio', 'audio_renderer', 'video', 'video_renderer', 'image', 'image_renderer',
        'document', 'document_renderer',
        'item_drag_handle', 'item_drop_target',
        'item_reorder_handle', 'item_selection_checkbox', 'item_selection_radio',
        'item_selection_switch', 'apply', 'clear', 'select_all',
        'deselect_all', 'apply_font', 'apply_image', 'set_as_wallpaper',
        'presets', 'skins', 'payload'
    ],
    'skins': [
        'schema_version', 'module', 'state', 'skins', 'selected_skin', 'presets', 'value', 'enabled', 'events', 'modules',
        'manifest', 'registries',
        'selector', 'preset', 'editor', 'preview', 'apply', 'clear', 'token_mapper',
        'create_skin', 'edit_skin', 'delete_skin',
        'effects', 'particles', 'shaders', 'materials', 'icons', 'fonts', 'colors', 'background',
        'border', 'shadow', 'outline', 'animation', 'transition', 'interaction', 'layout', 'responsive',
        'effect_editor', 'particle_editor', 'shader_editor', 'material_editor', 'icon_editor', 'font_editor',
        'color_editor', 'background_editor', 'border_editor', 'shadow_editor', 'outline_editor', 'payload'
    ],
    'callout': ['action_id', 'action_label', 'dismissible', 'icon', 'text', 'title', 'variant'],
    'chat_bubble': ['content', 'value'],
    'check_list': ['enabled', 'indices', 'options', 'spacing', 'values'],
    'code_block': ['text'],
    'color_picker': ['value', 'color', 'mode', 'picker_mode', 'show_alpha', 'alpha', 'presets', 'emit_on_change', 'show_actions', 'show_input', 'show_hex', 'show_presets', 'preset_size', 'preset_spacing', 'preview_height', 'input_label', 'input_placeholder', 'enabled', 'commit_text', 'cancel_text'],
    'color_swatch_grid': ['swatches', 'selected_id', 'selected_index', 'columns', 'size', 'spacing', 'show_labels', 'show_add', 'show_remove'],
    'container_style': ['variant', 'outline_width', 'outline_color', 'stroke_width', 'stroke_color', 'shadow_color', 'shadow_blur', 'shadow_dx', 'shadow_dy', 'glow_color', 'glow_blur', 'bgcolor', 'background', 'bg_color', 'border_color', 'border_width', 'radius', 'shape', 'content_padding', 'inner_padding', 'icon_padding', 'animation'],
    'glow_effect': ['color', 'blur', 'spread', 'radius', 'offset_x', 'offset_y', 'clip'],
    'glass_blur': ['blur', 'opacity', 'color', 'radius', 'border_color', 'border_width'],
    'gradient': ['variant', 'colors', 'stops', 'tile_mode', 'begin', 'end', 'center', 'radius', 'focal', 'focal_radius', 'start_angle', 'end_angle', 'start_degrees', 'end_degrees', 'bgcolor', 'background', 'background_color', 'opacity', 'mesh', 'mesh_points', 'points'],
    'gradient_editor': ['stops', 'angle', 'show_angle', 'show_add', 'show_remove'],
    'gradient_sweep': ['colors', 'duration_ms', 'angle', 'opacity'],
    'confetti_burst': ['colors', 'count', 'duration_ms', 'gravity'],
    'chromatic_shift': ['shift', 'opacity'],
    'command_bar': ['dense', 'items', 'bgcolor', 'text_color', 'icon_color', 'item_bgcolor', 'selected_color', 'backdrop', 'backdrop_blur'],
    'menu_bar': ['menus', 'items', 'bgcolor', 'text_color', 'icon_color', 'item_bgcolor', 'divider_color', 'height', 'dense', 'padding', 'backdrop', 'backdrop_blur', 'use_menu_bar', 'use_mac_menu_bar'],
    'menu_item': ['id', 'label', 'title', 'icon', 'shortcut', 'enabled', 'selected'],
    'butterflyui_candy': ['allow_gif', 'images'],
    'context_menu': ['items', 'bgcolor', 'text_color', 'icon_color', 'item_bgcolor', 'divider_color', 'backdrop', 'backdrop_blur', 'use_contextmenu'],
    'context_action_bar': ['items', 'open', 'anchor', 'position', 'offset', 'dismissible', 'scrim_color', 'bgcolor', 'text_color', 'icon_color', 'item_bgcolor', 'spacing', 'padding', 'alignment', 'backdrop', 'backdrop_blur'],
    'count_stepper': ['enabled', 'label', 'max', 'min', 'step', 'value'],
    'cursor': ['cursor'],
    'date_select': ['enabled', 'label', 'max_date', 'min_date', 'placeholder', 'value'],
    'date_span': ['enabled', 'end', 'label', 'max_date', 'min_date', 'placeholder', 'start'],
    'empty_view': ['icon', 'message', 'title'],
    'empty_state_view': ['icon', 'message', 'title', 'action_label'],
    'inline_error_view': ['icon', 'message', 'title', 'action_label'],
    'export_panel': ['options'],
    'field_group': ['error_text', 'helper_text', 'label', 'spacing'],
    'file_picker': [
        'label',
        'file_type',
        'extensions',
        'allowed_extensions',
        'multiple',
        'allow_multiple',
        'with_data',
        'with_path',
        'enabled',
        'mode',
        'pick_directory',
        'save_file',
        'file_name',
        'dialog_title',
        'initial_directory',
        'lock_parent_window',
        'show_selection',
    ],
    'directory_picker': [
        'label',
        'mode',
        'pick_directory',
        'enabled',
        'initial_directory',
        'dialog_title',
        'lock_parent_window',
    ],
    'focus_anchor': ['autofocus', 'can_request_focus', 'request_focus'],
    'form': ['description', 'spacing', 'title'],
    'glyph': ['color', 'icon', 'size'],
    'glyph_button': ['bgcolor', 'color', 'enabled', 'icon', 'size', 'tooltip'],
    'guides_manager': ['items'],
    'hint': ['dense', 'message', 'text', 'variant'],
    'history_stack': ['items'],
    'hover_region': ['cursor', 'enabled'],
    'inspector': ['dense', 'items', 'show_dividers'],
    'item_tile': ['dense', 'enabled', 'leading_icon', 'leading_text', 'leading_image', 'selected', 'subtitle', 'title', 'meta', 'badges', 'actions', 'trailing_icon', 'trailing_text'],
    'list_tile': ['dense', 'enabled', 'leading_icon', 'leading_text', 'leading_image', 'selected', 'subtitle', 'title', 'meta', 'badges', 'actions', 'trailing_icon', 'trailing_text'],
    'json_editor': ['mode', 'use_inapp', 'webview_engine'],
    'key_listener': ['autofocus', 'enabled'],
    'layer_list': ['items'],
    'layer_mask_editor': ['bgcolor', 'thumbnail'],
    'line_plot': ['color', 'fill', 'fill_color', 'max', 'min', 'stroke_width', 'values'],
    'message_divider': ['line_color'],
    'multi_pick': ['enabled', 'indices', 'options', 'spacing', 'values'],
    'nav_ring': ['policy'],
    'notice_bar': ['action_id', 'action_label', 'dismissible', 'icon', 'text', 'variant'],
    'numeric_field': ['decimals', 'dense', 'enabled', 'label', 'max', 'min', 'placeholder', 'step', 'value'],
    'page_nav': ['enabled', 'next_label', 'page', 'page_count', 'prev_label'],
    'page_stepper': ['enabled', 'max_visible', 'page', 'page_count', 'show_edges'],
    'path_field': ['allowed_extensions', 'file_name'],
    'persona': ['bgcolor', 'border_color', 'border_width', 'label', 'size', 'src', 'text_color'],
    'pie_plot': ['colors', 'inner_radius', 'start_angle', 'values'],
    'preset_gallery': ['items'],
    'pressable': ['enabled'],
    'quoted_message': ['value'],
    'rail_nav': ['items'],
    'reaction_bar': ['items'],
    'ruler_guides': ['horizontal_guides', 'vertical_guides'],
    'rulers_overlay': ['bgcolor'],
    'scene_view': ['background', 'show_grid'],
    'segment_bar': ['dense', 'enabled', 'index', 'options', 'value'],
    'selection_tools': ['items'],
    'shortcut_map': ['enabled', 'shortcuts', 'use_global_hotkeys'],
    'side_panel': ['bgcolor', 'cross_axis', 'spacing'],
    'skeleton': ['radius', 'variant'],
    'skeleton_loader': ['radius', 'variant', 'width', 'height'],
    'snap_grid': ['background_color', 'color', 'offset'],
    'span_slider': ['divisions', 'enabled', 'end', 'max', 'min', 'start'],
    'spark_plot': ['color', 'max', 'min', 'stroke_width', 'values'],
    'split_pane': ['axis', 'ratio', 'use_split_view'],
    'split_view': ['axis', 'ratio', 'min_ratio', 'max_ratio', 'draggable', 'divider_size'],
    'status_mark': ['dot_size', 'label', 'status', 'text'],
    'submit_scope': ['autofocus', 'enabled'],
    'table': ['columns', 'rows'],
    'tabs': ['closable', 'index', 'labels', 'scrollable', 'show_add'],
    'time_select': ['enabled', 'label', 'placeholder', 'use_24h', 'value'],
    'toast': ['action_label', 'duration_ms', 'icon', 'instant', 'label', 'message', 'open', 'priority', 'style', 'variant', 'use_flushbar', 'use_fluttertoast', 'toast_position'],
    'snackbar': ['action_label', 'duration_ms', 'icon', 'instant', 'label', 'message', 'open', 'priority', 'style', 'variant', 'use_flushbar', 'use_fluttertoast', 'toast_position'],
    'share_action': ['text', 'subject', 'files', 'position'],
    'toggle_set': ['dense', 'enabled', 'indices', 'options', 'spacing', 'values'],
    'token': ['color', 'enabled', 'label', 'selectable', 'selected', 'text_color', 'removable'],
    'tooltip': ['message', 'prefer_below', 'text', 'wait_ms'],
    'top_bar': ['bgcolor', 'center_title', 'elevation', 'subtitle', 'title'],
    'transform_toolbar': ['items'],
    'tree': ['dense', 'expanded', 'nodes'],
    'validator': ['message', 'status'],
    'viewport': ['emit_on_mount', 'throttle_ms'],
    'visibility': ['maintain_space', 'visible'],
    'when': ['condition'],
    'window_frame': ['show_close', 'show_maximize', 'show_minimize', 'title', 'use_window_manager', 'use_bitsdojo', 'acrylic_effect', 'acrylic_opacity'],
    'window_drag_region': ['draggable', 'maximize_on_double_tap', 'emit_move', 'native_drag', 'native_maximize_action', 'child'],
    'smart_search_bar': ['debounce_ms', 'enabled', 'history_id', 'hint', 'loading', 'placeholder', 'provider_id', 'show_clear', 'value'],
    'search_bar': ['query', 'value', 'placeholder', 'hint', 'debounce_ms', 'enabled', 'disabled', 'show_clear', 'loading', 'dense', 'autofocus', 'auto_focus', 'tokens', 'filters', 'show_filters', 'suggestions', 'show_suggestions', 'max_suggestions'],
    'search_scope_selector': ['scopes', 'options', 'items', 'selected', 'selected_scope', 'value', 'scope', 'selected_index', 'index', 'default_scope', 'default', 'enabled', 'disabled', 'dense', 'provider_id'],
    'query_token': ['id', 'label', 'selected', 'removable', 'color', 'text_color', 'textColor', 'meta', 'enabled', 'selectable'],
    'search_item': ['id', 'title', 'label', 'subtitle', 'description', 'group', 'scope', 'icon', 'emoji', 'badge', 'shortcut', 'image', 'kind', 'tags', 'keywords', 'meta', 'score', 'enabled', 'payload'],
    'search_source': ['id', 'label', 'title', 'subtitle', 'items', 'icon', 'emoji', 'enabled', 'priority', 'limit'],
    'search_intent': ['id', 'title', 'label', 'subtitle', 'text', 'value', 'query', 'is_empty', 'is_submitted', 'trigger'],
    'search_field': ['value', 'query', 'placeholder', 'hint', 'icon', 'search_icon', 'clear_icon', 'clearIcon', 'show_clear', 'showClear', 'loading', 'disabled', 'enabled', 'read_only', 'readOnly', 'auto_focus', 'autoFocus', 'debounce_ms', 'debounceMs', 'dense', 'filled', 'bordered', 'rounded', 'width', 'bgcolor', 'border_color', 'borderColor', 'focus_color', 'focusColor', 'text_color', 'textColor', 'hint_color', 'hintColor'],
    'filter_chips_bar': ['filters', 'indices', 'multi_select', 'values'],
    'filter_drawer': ['schema', 'state', 'title', 'show_actions', 'apply_label', 'clear_label', 'dense'],
    'intent_search': ['query', 'value', 'intents', 'items', 'providers', 'results', 'selected_intent', 'placeholder', 'hint', 'empty_text', 'debounce_ms', 'max_results', 'enabled', 'disabled', 'loading', 'autofocus', 'auto_focus', 'fuzzy', 'fuzzy_match', 'show_all_on_empty', 'emit_on_empty', 'show_intents', 'show_providers', 'auto_search'],
    'search_results_view': ['results', 'items', 'data', 'state', 'status', 'layout', 'view', 'grouped', 'grid_columns', 'columns', 'grid_spacing', 'spacing', 'grid_aspect_ratio', 'aspect_ratio', 'dense', 'show_icons', 'show_tags', 'show_badges', 'show_meta', 'show_scores', 'show_descriptions', 'selected_id', 'selected', 'query', 'value', 'empty_title', 'empty_message', 'error_title', 'error_message', 'loading', 'loading_count', 'provider_id', 'source_id', 'initial_offset'],
    'semantic_search': ['query', 'value', 'placeholder', 'hint', 'scopes', 'providers', 'selected_scope', 'scope', 'results', 'items', 'dense', 'show_scopes', 'show_results', 'loading', 'empty_title', 'empty_message'],
    'intent_router': ['intents', 'items', 'query', 'value', 'dense', 'show_search', 'selected_id', 'selected', 'selected_intent'],
    'search_everything_panel': ['query', 'value', 'placeholder', 'hint', 'filters', 'categories', 'scopes', 'selected_filters', 'selected', 'filter', 'results', 'items', 'dense', 'show_filters', 'show_results', 'loading', 'empty_title', 'empty_message'],
    'data_source_view': ['state', 'loading', 'page', 'page_size', 'has_more', 'refreshable', 'prefetch_threshold', 'cache_key', 'show_content_on_loading', 'overlay_loading', 'empty_view', 'error_view', 'offline_view', 'loading_view'],
    'virtual_list': ['items', 'header', 'footer', 'scrollable', 'separator', 'spacing', 'padding', 'reverse', 'item_extent', 'cache_extent', 'loading', 'skeleton_count', 'has_more', 'prefetch_threshold', 'use_positioned_list', 'initial_index'],
    'multi_source_merge_view': ['sources', 'dedupe_key', 'merge_strategy', 'prefer_source', 'updated_key', 'spacing', 'separator', 'header', 'footer', 'padding', 'loading'],
    'details_pane': ['mode', 'split_ratio', 'stack_breakpoint', 'show_details', 'show_back', 'back_label', 'divider'],
    'card': ['color', 'elevation', 'radius', 'margin', 'padding', 'shape', 'clip_behavior', 'surface_tint_color', 'shadow_color'],
    'async_action_button': ['label', 'state', 'enabled', 'variant', 'color', 'text_color', 'radius', 'content_padding', 'success_label', 'error_label', 'progress', 'show_progress'],
    'divider': ['vertical', 'thickness', 'indent', 'end_indent', 'color'],
    'particle_field': ['count', 'speed', 'size', 'colors', 'seed', 'gravity', 'drift', 'link_distance', 'line_color', 'line_opacity', 'play', 'enabled'],
    'scanline_overlay': ['enabled', 'opacity', 'line_thickness', 'spacing', 'angle', 'speed', 'blend_mode', 'color'],
    'vignette': ['enabled', 'intensity', 'radius', 'softness', 'color', 'blend_mode'],
    'surface': ['color', 'bgcolor', 'elevation', 'radius', 'padding', 'margin', 'border', 'border_color', 'border_width', 'shadow_color', 'clip_behavior'],
    'box': ['color', 'bgcolor', 'padding', 'margin', 'alignment', 'radius', 'border', 'border_color', 'border_width', 'clip_behavior', 'gradient', 'image'],
    'row': ['spacing', 'alignment', 'horizontal_alignment', 'vertical_alignment', 'run_alignment', 'wrap', 'reverse', 'clip_behavior'],
    'column': ['spacing', 'alignment', 'horizontal_alignment', 'vertical_alignment', 'run_alignment', 'reverse', 'clip_behavior'],
    'stack': ['alignment', 'fit', 'clip_behavior'],
    'wrap': ['spacing', 'run_spacing', 'alignment', 'run_alignment', 'cross_alignment', 'direction', 'vertical_direction', 'clip_behavior'],
    'scroll_view': ['axis', 'reverse', 'primary', 'physics', 'padding', 'controller_id', 'scrollbar', 'thumb_visibility', 'track_visibility', 'initial_offset'],
    'prompt_composer': ['value', 'placeholder', 'enabled', 'multiline', 'min_lines', 'max_lines', 'submit_label', 'dense', 'show_attach', 'show_send', 'send_on_enter'],
    'confirm_dialog': ['open', 'title', 'message', 'confirm_label', 'cancel_label', 'dangerous', 'dismissible'],
    'rating_display': ['rating', 'max_rating', 'count', 'show_count', 'size', 'color', 'inactive_color'],
    'sortable_header': ['options', 'selected', 'selected_index', 'variant', 'label', 'dense'],
    'segmented_switch': ['options', 'index', 'value', 'enabled', 'dense'],
    'scope_picker': ['options', 'index', 'value', 'enabled', 'dense'],
    'tag_chip': ['label', 'selected', 'selectable', 'enabled', 'color', 'text_color', 'removable'],
    'command_search': ['commands', 'items', 'hotkeys', 'trigger_keys', 'shortcuts', 'shortcut', 'open', 'placeholder', 'empty_text', 'title', 'subtitle', 'dense', 'fuzzy', 'fuzzy_match', 'show_all_on_empty', 'max_results', 'dismiss_on_select', 'close_on_escape', 'max_width', 'width', 'max_height', 'scrim_color'],
    'inline_search_overlay': ['open', 'visible', 'position', 'offset', 'dismissible', 'close_on_escape', 'match_width', 'max_width', 'max_height', 'elevation', 'scrim_color', 'query', 'replace_text', 'case_sensitive', 'whole_word', 'use_regex', 'show_replace', 'show_options', 'match_count', 'current_match', 'placeholder', 'replace_placeholder', 'auto_focus'],
    'emoji_icon': ['emoji', 'text', 'size', 'variant', 'color', 'text_color', 'fgcolor', 'outline_width', 'stroke_width', 'outline_color', 'stroke_color', 'shadow_color', 'glow_color', 'shadow_blur', 'glow_blur', 'shadow_dx', 'shadow_dy', 'bgcolor', 'background', 'bg_color', 'border_color', 'border_width', 'content_padding', 'inner_padding', 'icon_padding', 'radius', 'shape'],
    'result_preview_pane': ['item', 'selected_item'],
    'search_provider': ['sources', 'query', 'value', 'scope', 'selected_scope', 'fuzzy', 'fuzzy_match', 'include_empty', 'limit', 'max_results', 'min_score', 'emit_on_change'],
    'search_history': ['items', 'entries', 'max_items', 'persist', 'storage_key', 'dedupe'],
    'preference_store': ['namespace'],
    'socket_client': ['url', 'protocols', 'auto_connect'],
    'data_grid': ['rows', 'columns', 'sortable', 'filterable', 'selectable', 'multi_select', 'pagination', 'page_size', 'dense', 'striped', 'show_header', 'auto_sort', 'selected_index', 'sort_column', 'sort_ascending', 'filter_query', 'filter_column', 'filter_case_sensitive'],
    'code_editor': ['schema_version', 'module', 'state', 'events', 'modules',
        'manifest', 'registries',
        'value', 'text', 'code', 'language', 'theme', 'read_only', 'wrap', 'word_wrap', 'show_gutter', 'line_numbers', 'show_minimap', 'minimap', 'tab_size', 'font_size', 'font_family', 'cursor_blink', 'cursor_color', 'selection_color', 'line_highlight_color', 'editor_bg', 'editor_background', 'editor_text_color', 'padding_top', 'padding_bottom', 'radius', 'bgcolor', 'background', 'border_color', 'border_width', 'chrome_padding', 'engine', 'webview_engine', 'document_uri', 'documents', 'glyph_margin', 'show_breakpoints', 'render_whitespace', 'format_on_type', 'format_on_paste', 'emit_on_change', 'debounce_ms',
        'editor_intent_router', 'editor_minimap', 'editor_surface', 'editor_view', 'diff', 'editor_tabs', 'empty_state_view', 'explorer_tree', 'ide', 'code_buffer', 'code_category_layer', 'code_document', 'file_tabs', 'file_tree', 'smart_search_bar', 'semantic_search', 'search_box', 'search_everything_panel', 'search_field', 'search_history', 'search_intent', 'search_item', 'search_provider', 'search_results_view', 'search_scope_selector', 'search_source', 'query_token', 'document_tab_strip', 'command_search', 'tree', 'workbench_editor', 'workspace_explorer', 'command_bar', 'diagnostic_stream', 'diff_narrator', 'dock_graph', 'dock', 'dock_pane', 'empty_view', 'export_panel', 'gutter', 'hint', 'mini_map', 'scope_picker', 'scoped_search_replace', 'diagnostics_panel', 'ghost_editor', 'inline_error_view', 'inline_search_overlay', 'inline_widget', 'inspector', 'intent_panel', 'intent_router', 'intent_search',
    ],
    'studio': ['schema_version', 'module', 'state', 'events', 'modules',
        'actions_editor', 'asset_browser', 'bindings_editor', 'block_palette',
        'builder', 'canvas', 'timeline_surface', 'node_surface', 'preview_surface',
        'component_palette', 'inspector', 'outline_tree',
        'project_panel', 'properties_panel', 'responsive_toolbar', 'tokens_editor',
        'selection_tools', 'transform_box', 'transform_toolbar',
        'manifest', 'registries', 'render', 'cache', 'media', 'shortcuts', 'panels',
        'selected_id', 'selected_ids', 'active_tool', 'focused_panel', 'documents', 'assets',
        'left_pane_ratio', 'right_pane_ratio', 'bottom_panel_height',
    ],
    'ide': ['value', 'text', 'code', 'language', 'theme', 'read_only', 'wrap', 'word_wrap', 'show_gutter', 'line_numbers', 'show_minimap', 'minimap', 'tab_size', 'font_size', 'font_family', 'cursor_blink', 'cursor_color', 'selection_color', 'line_highlight_color', 'editor_bg', 'editor_background', 'editor_text_color', 'padding_top', 'padding_bottom', 'radius', 'bgcolor', 'background', 'border_color', 'border_width', 'chrome_padding', 'engine', 'webview_engine', 'document_uri', 'documents', 'glyph_margin', 'show_breakpoints', 'render_whitespace', 'format_on_type', 'format_on_paste'],
    'editor_minimap': ['text', 'language', 'visible', 'position', 'width', 'background', 'border_color', 'text_color'],
    'file_tabs': ['items', 'active_id', 'dense'],
    'pane_spec': ['size', 'min_size', 'max_size', 'resizable', 'collapsible', 'collapsed'],
    'progress_indicator': ['value', 'indeterminate', 'label', 'color', 'background_color', 'stroke_width', 'variant', 'circular'],
    'table_view': ['rows', 'headers', 'columns', 'sortable', 'filterable', 'selectable', 'multi_select', 'dense', 'striped', 'show_header'],
    'tree_node': ['id', 'label', 'expanded', 'selected', 'disabled', 'icon', 'children'],
    'tree_view': ['nodes', 'expanded', 'dense', 'multi_select', 'show_root', 'expand_all'],
    'markdown': ['value', 'text', 'selectable', 'scrollable', 'use_flutter_markdown'],
    'markdown_view': ['value', 'text', 'selectable', 'scrollable', 'use_flutter_markdown'],
    'code': ['value', 'text', 'selectable', 'wrap', 'language', 'use_syntax_highlight', 'use_flutter_highlight'],
    'code_block': ['value', 'text', 'selectable', 'wrap', 'language', 'use_syntax_highlight', 'use_flutter_highlight'],
    'chat': ['messages', 'items', 'show_input', 'placeholder', 'send_label', 'enabled', 'dense', 'use_flutter_chat_ui', 'user_id'],
    'image': ['src', 'fit', 'radius', 'cache', 'placeholder'],
    'webview': ['url', 'html', 'base_url', 'bgcolor', 'engine', 'webview_engine', 'fallback_engine', 'use_inapp', 'prevent_links', 'request_headers', 'headers', 'user_agent', 'javascript_enabled', 'js_enabled', 'dom_storage_enabled', 'third_party_cookies_enabled', 'cache_enabled', 'clear_cache_on_start', 'incognito', 'media_playback_requires_user_gesture', 'allows_inline_media_playback', 'allow_file_access', 'allow_universal_access_from_file_urls', 'allow_popups', 'open_external_links', 'init_timeout_ms'],
    'butterflyui_webview': ['url', 'html', 'base_url', 'bgcolor', 'engine', 'webview_engine', 'fallback_engine', 'use_inapp', 'prevent_links', 'request_headers', 'headers', 'user_agent', 'javascript_enabled', 'js_enabled', 'dom_storage_enabled', 'third_party_cookies_enabled', 'cache_enabled', 'clear_cache_on_start', 'incognito', 'media_playback_requires_user_gesture', 'allows_inline_media_playback', 'allow_file_access', 'allow_universal_access_from_file_urls', 'allow_popups', 'open_external_links', 'init_timeout_ms'],
    'webview_adapter': ['url', 'html', 'base_url', 'bgcolor', 'engine', 'webview_engine', 'fallback_engine', 'use_inapp', 'prevent_links', 'request_headers', 'headers', 'user_agent', 'javascript_enabled', 'js_enabled', 'dom_storage_enabled', 'third_party_cookies_enabled', 'cache_enabled', 'clear_cache_on_start', 'incognito', 'media_playback_requires_user_gesture', 'allows_inline_media_playback', 'allow_file_access', 'allow_universal_access_from_file_urls', 'allow_popups', 'open_external_links', 'init_timeout_ms'],
    'drop_zone': ['enabled', 'accepts', 'title', 'subtitle', 'use_desktop_drop'],
    'queue_list': ['items', 'auto_download', 'download_dir', 'max_concurrent', 'use_download_manager', 'emit_local_events'],
    'download_item': ['id', 'title', 'subtitle', 'progress', 'status', 'speed', 'eta', 'paused', 'url', 'path'],
    'terminal': ['schema_version', 'module', 'state', 'events', 'modules',
        'manifest', 'registries',
        'lines', 'history', 'history_items', 'history_limit', 'history_key', 'persist_history',
        'prompt', 'placeholder', 'submit_label', 'enabled', 'dense', 'show_prompt', 'show_input',
        'read_only', 'cursor_blink', 'auto_scroll', 'wrap_lines', 'show_timestamps', 'strip_ansi',
        'clear_on_submit', 'auto_focus', 'max_lines', 'font_family', 'font_size', 'line_height',
        'bgcolor', 'background', 'text_color', 'cursor_color', 'command_color', 'error_color',
        'stderr_color', 'border_color', 'radius', 'engine', 'webview_engine',
        'local_command', 'local_args', 'local_env', 'local_cwd', 'auto_start', 'use_pty', 'pipe_input',
        'emit_local_events', 'local_allowlist', 'local_blocklist', 'local_allow_patterns', 'local_block_patterns',
        'output', 'raw_text',
        'capabilities', 'command_builder', 'flow_gate', 'output_mapper', 'presets', 'progress',
        'progress_view', 'raw_view', 'replay', 'session', 'stdin', 'stdin_injector', 'stream',
        'stream_view', 'tabs', 'timeline', 'view', 'workbench', 'process_bridge',
        'execution_lane', 'log_viewer', 'log_panel',
    ],
    'output_panel': ['channels', 'active_channel'],
    'log_panel': ['channels', 'active_channel'],
    'editor_tab_strip': ['tabs'],
    'editor_tabs': ['tabs'],
    'document_tab_strip': ['tabs'],
    'workspace_tree': ['nodes', 'items', 'roots'],
    'workspace_explorer': ['nodes', 'items', 'roots'],
    'explorer_tree': ['nodes', 'items', 'roots'],
    'problems_panel': ['problems', 'items'],
    'diagnostics_panel': ['problems', 'items'],
    'editor_workspace': ['documents', 'tabs', 'active_id', 'workspace_nodes', 'problems', 'show_explorer', 'show_problems', 'show_status_bar', 'status_text'],
    'workbench_editor': ['documents', 'tabs', 'active_id', 'workspace_nodes', 'problems', 'show_explorer', 'show_problems', 'show_status_bar', 'status_text'],
    'history_stack': ['entries', 'items', 'selected_id', 'dense', 'show_index', 'show_timestamp', 'enabled', 'use_undo', 'show_controls'],
    'grid': ['columns', 'spacing', 'run_spacing', 'child_aspect_ratio', 'layout', 'masonry', 'scrollable', 'virtual', 'virtualized'],
    'gutter': ['line_count', 'current_line', 'breakpoints', 'diagnostics', 'show_line_numbers', 'dense', 'width', 'highlight_lines', 'highlight_color', 'scroll_group'],
    'editor_view': ['document_id', 'buffer_id', 'text', 'language', 'read_only', 'wrap', 'line_height', 'font_size', 'font_family', 'tab_size', 'cursor_color', 'selection_color', 'padding', 'background', 'bgcolor', 'preset_id', 'behavior_ids', 'behaviors', 'highlight_lines', 'highlight_color', 'scroll_group'],
}

RUNTIME_PROP_HINTS.update(
    {
        "router": [
            "routes",
            "active",
            "active_route",
            "route",
            "index",
            "transition",
            "transition_type",
            "source_rect",
            "show_tabs",
            "keep_alive",
            "lightweight_transitions",
        ],
        "route_view": ["route_id", "title", "label", "child", "children", "layout", "spacing"],
        "route_host": ["route_id", "title", "label", "child"],
        "page_scene": [
            "background_layer",
            "ambient_layer",
            "hero_layer",
            "content_layer",
            "overlay_layer",
            "pages",
            "active_page",
            "active_id",
            "page",
            "value",
            "transition",
            "transition_type",
            "transition_ms",
            "ambient_opacity",
            "hero_alignment",
            "content_alignment",
            "content_padding",
        ],
        "overlay_host": [
            "base",
            "overlays",
            "layers",
            "clip",
            "transition",
            "transition_type",
            "transition_ms",
            "active_overlay",
            "active_id",
            "overlay_id",
            "active_index",
            "index",
            "show_all_overlays",
            "show_default_overlay",
            "max_visible_overlays",
            "value",
        ],
        "modal": [
            "open",
            "dismissible",
            "close_on_escape",
            "trap_focus",
            "duration_ms",
            "transition",
            "transition_type",
            "source_rect",
            "scrim_color",
            "child",
        ],
        "popover": [
            "anchor",
            "content",
            "open",
            "position",
            "offset",
            "dismissible",
            "scrim_color",
            "transition",
            "transition_type",
            "duration_ms",
        ],
        "animation_asset": [
            "src",
            "kind",
            "engine",
            "frames",
            "autoplay",
            "loop",
            "duration_ms",
            "fps",
            "fit",
            "alignment",
            "pulse_scale",
        ],
        "launcher": [
            "items",
            "selected_id",
            "layout",
            "columns",
            "spacing",
            "run_spacing",
            "icon_size",
            "tile_width",
            "tile_height",
            "radius",
            "bgcolor",
            "border_color",
        ],
        "window_frame": [
            "title",
            "show_close",
            "show_maximize",
            "show_minimize",
            "draggable",
            "acrylic_effect",
            "acrylic_opacity",
            "content_padding",
            "title_height",
            "custom_frame",
            "use_native_title_bar",
            "native_title_bar",
            "system_title_bar",
            "native_window_actions",
            "window_actions",
            "show_default_controls",
            "title_leading",
            "title_content",
            "title_widget",
            "title_trailing",
            "window_controls",
        ],
        "window_drag_region": [
            "draggable",
            "maximize_on_double_tap",
            "emit_move",
            "native_drag",
            "native_maximize_action",
            "child",
        ],
    }
)

for _prop in [
    "custom_frame",
    "use_native_title_bar",
    "native_title_bar",
    "system_title_bar",
    "native_window_actions",
    "window_actions",
    "show_default_controls",
    "title_leading",
    "title_content",
    "title_widget",
    "title_trailing",
    "window_controls",
    "child",
]:
    _window_hints = RUNTIME_PROP_HINTS.setdefault("window_frame", [])
    if _prop not in _window_hints:
        _window_hints.append(_prop)

_button_hints = RUNTIME_PROP_HINTS.setdefault("button", [])
if "window_action" not in _button_hints:
    _button_hints.append("window_action")

RUNTIME_PROP_HINTS.update(
    {
        "combo_box": [
            "value",
            "options",
            "items",
            "groups",
            "label",
            "hint",
            "placeholder",
            "loading",
            "async_source",
            "debounce_ms",
            "enabled",
        ],
        "aspect_ratio": ["ratio", "aspect_ratio", "child"],
        "overflow_box": [
            "min_width",
            "min_height",
            "max_width",
            "max_height",
            "alignment",
            "fit",
            "child",
        ],
        "fitted_box": ["fit", "alignment", "clip_behavior", "child"],
        "avatar": [
            "src",
            "image",
            "name",
            "initials",
            "icon",
            "size",
            "radius",
            "color",
            "bgcolor",
            "status",
            "badge",
            "enabled",
        ],
        "shadow": [
            "color",
            "blur",
            "spread",
            "offset_x",
            "offset_y",
            "radius",
            "shadows",
            "child",
        ],
        "decorated_box": [
            "color",
            "bgcolor",
            "gradient",
            "image",
            "border_color",
            "border_width",
            "radius",
            "shape",
            "shadow",
            "padding",
            "margin",
            "clip_behavior",
            "child",
            "children",
        ],
        "clip": ["shape", "radius", "clip_behavior", "child"],
        "effects": [
            "blur",
            "opacity",
            "color",
            "blend_mode",
            "brightness",
            "contrast",
            "saturation",
            "hue_rotate",
            "grayscale",
            "enabled",
            "child",
            "children",
        ],
        "particles": [
            "count",
            "colors",
            "min_size",
            "max_size",
            "speed",
            "min_speed",
            "max_speed",
            "direction",
            "spread",
            "opacity",
            "seed",
            "loop",
            "play",
            "shape",
        ],
        "animation": [
            "duration_ms",
            "curve",
            "opacity",
            "scale",
            "offset",
            "rotation",
            "enabled",
            "child",
            "children",
        ],
        "transition": [
            "duration_ms",
            "curve",
            "transition_type",
            "preset",
            "state",
            "mode",
            "enabled",
            "child",
            "children",
        ],
    }
)

RUNTIME_PROP_HINTS.setdefault(
    "candy",
    [
        "schema_version",
        "module",
        "variant",
        "events",
        "state",
        "payload",
        "theme",
        "tokens",
        "token_overrides",
        "modules",
        "slots",
        "semantics",
        "accessibility",
        "interaction",
        "performance",
        "quality",
        "cache",
        "button",
        "card",
        "column",
        "container",
        "row",
        "stack",
        "surface",
        "wrap",
        "align",
        "center",
        "spacer",
        "aspect_ratio",
        "overflow_box",
        "fitted_box",
        "effects",
        "particles",
        "border",
        "shadow",
        "outline",
        "gradient",
        "animation",
        "transition",
        "canvas",
        "clip",
        "decorated_box",
        "badge",
        "avatar",
        "icon",
        "text",
        "motion",
    ],
)

for _name, _props in RUNTIME_PROP_HINTS.items():
    _schema = CONTROL_SCHEMAS.setdefault(_name, _control_schema())
    _schema_props = _schema.setdefault('properties', {})
    for _prop in _props:
        _schema_props.setdefault(_prop, ANY_SCHEMA)
# --- RUNTIME_PROP_HINTS END ---

for name in _ALL_CONTROL_TYPES:
    CONTROL_SCHEMAS.setdefault(name, _control_schema())

for name, schema in list(CONTROL_SCHEMAS.items()):
    CONTROL_SCHEMAS[name] = _merge_universal(_merge_layout(schema))
