from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Callable

from ..core.schema import CONTROL_SCHEMAS
from .capabilities import (
    CAPABILITY_PROP_NAMES,
    EFFECT_CAPABLE_CONTROLS,
    MODIFIER_CAPABLE_CONTROLS,
    MOTION_CAPABLE_CONTROLS,
    PROP_CAPABILITY_OWNERS,
    STYLE_CAPABLE_CONTROLS,
    slots_for_control,
)
from .common_events import COMMON_EVENT_NAMES
from .common_props import COMMON_CORE_PROPS, COMMON_LAYOUT_PROPS, COMMON_STYLE_PROPS

__all__ = [
    "PropSpec",
    "EventSpec",
    "ControlSpec",
    "CONTROL_SPECS",
    "get_control_spec",
    "iter_control_specs",
    "control_specs_for_category",
    "control_category_map",
]


@dataclass(frozen=True, slots=True)
class PropSpec:
    name: str
    type_hint: Any = Any
    default: Any = None
    nullable: bool = True
    wire_name: str | None = None
    serializer: Callable[[Any], Any] | None = None
    affects: frozenset[str] = frozenset()
    doc: str = ""


@dataclass(frozen=True, slots=True)
class EventSpec:
    name: str
    payload_type: Any | None = None
    doc: str = ""


@dataclass(frozen=True, slots=True)
class ControlSpec:
    type_name: str
    category: str
    capabilities: tuple[str, ...] = ()
    props: tuple[PropSpec, ...] = ()
    events: tuple[EventSpec, ...] = ()
    child_mode: str = "multiple"
    slots: tuple[str, ...] = ()
    tags: tuple[str, ...] = ()
    doc: str = ""
    schema: dict[str, Any] = field(default_factory=dict)


def _root_controls_dir() -> Path:
    return Path(__file__).resolve().parent.parent / "controls"


_CATEGORY_PREFERENCE = {
    name: index
    for index, name in enumerate(
        (
            "layout",
            "display",
            "inputs",
            "data",
            "navigation",
            "overlay",
            "interaction",
            "shell",
            "web",
            "forms",
            "effects",
            "scopes",
            "tools",
            "productivity",
            "webview",
            "candy",
            "gallery",
            "skins",
            "customization",
        )
    )
}


def control_category_map() -> dict[str, str]:
    controls_dir = _root_controls_dir()
    mapping: dict[str, str] = {}
    for category_dir in sorted(
        controls_dir.iterdir(),
        key=lambda path: (_CATEGORY_PREFERENCE.get(path.name, len(_CATEGORY_PREFERENCE)), path.name),
    ):
        if not category_dir.is_dir():
            continue
        if category_dir.name in {"__pycache__"}:
            continue
        for file_path in category_dir.glob("*.py"):
            if file_path.name == "__init__.py":
                continue
            mapping.setdefault(file_path.stem, category_dir.name)
    return mapping


_CATEGORY_MAP = control_category_map()


def _affects_flags(name: str) -> frozenset[str]:
    flags: set[str] = set()
    if name in COMMON_LAYOUT_PROPS:
        flags.add("layout")
    if name in COMMON_STYLE_PROPS:
        flags.add("style")
    owner = PROP_CAPABILITY_OWNERS.get(name)
    if owner:
        flags.add(owner)
    if name in {"color", "bgcolor", "background", "foreground", "border_color", "gradient"}:
        flags.add("paint")
    if name in {"events"}:
        flags.add("events")
    return frozenset(flags)


def _schema_to_type_hint(schema: Any) -> Any:
    if not isinstance(schema, dict):
        return Any
    schema_type = schema.get("type")
    if schema_type == "string":
        return str
    if schema_type == "integer":
        return int
    if schema_type == "number":
        return float
    if schema_type == "boolean":
        return bool
    if schema_type == "array":
        return list[Any]
    if schema_type == "object":
        return dict[str, Any]
    if isinstance(schema_type, list):
        return Any
    return Any


def _child_mode(control_type: str, props: dict[str, Any]) -> str:
    if "child" in props and "children" not in props:
        return "single"
    if "children" in props:
        return "multiple"
    if control_type.endswith("_scope"):
        return "single"
    return "multiple"


_CAPABILITY_PREFERENCE = (
    "core",
    "layout",
    "surface",
    "style",
    "motion",
    "modifiers",
    "effects",
    "content",
    "focus",
    "input",
    "form_field",
    "selection",
    "toggle",
    "scroll",
    "overlay",
    "actions",
    "button",
)


_BUTTON_CONTROL_TYPES = {
    "async_action_button",
    "button",
    "elevated_button",
    "filled_button",
    "glyph_button",
    "icon_button",
    "outlined_button",
    "text_button",
}


def _control_capabilities(
    control_type: str,
    props: dict[str, Any],
    child_mode: str,
) -> tuple[str, ...]:
    prop_names = set(props)
    capabilities: list[str] = []
    for capability in _CAPABILITY_PREFERENCE:
        if capability == "button" and control_type not in _BUTTON_CONTROL_TYPES:
            continue
        if capability in {"input", "form_field", "selection", "toggle"} and control_type in _BUTTON_CONTROL_TYPES:
            continue
        if capability == "style" and control_type in STYLE_CAPABLE_CONTROLS:
            capabilities.append(capability)
            continue
        if capability == "modifiers" and control_type in MODIFIER_CAPABLE_CONTROLS:
            capabilities.append(capability)
            continue
        if capability == "motion" and control_type in MOTION_CAPABLE_CONTROLS:
            capabilities.append(capability)
            continue
        if capability == "effects" and control_type in EFFECT_CAPABLE_CONTROLS:
            capabilities.append(capability)
            continue
        owned = set(CAPABILITY_PROP_NAMES.get(capability, ()))
        if prop_names & owned:
            capabilities.append(capability)
    if child_mode in {"single", "multiple"} and "content" not in capabilities:
        capabilities.append("content")
    return tuple(capabilities)


def _control_spec(control_type: str, schema: dict[str, Any]) -> ControlSpec:
    properties = schema.get("properties", {}) if isinstance(schema, dict) else {}
    child_mode = _child_mode(control_type, properties)
    prop_specs = tuple(
        PropSpec(
            name=name,
            type_hint=_schema_to_type_hint(prop_schema),
            wire_name=name,
            affects=_affects_flags(name),
        )
        for name, prop_schema in sorted(properties.items())
    )
    common_events = tuple(EventSpec(name=name) for name in COMMON_EVENT_NAMES)
    category = _CATEGORY_MAP.get(control_type, "misc")
    tags = []
    if control_type.endswith("_scope"):
        tags.append("scope")
    if category in {"effects", "customization"}:
        tags.append("effect")
    if category in {"inputs", "productivity"}:
        tags.append("input")
    if category in {"overlay", "navigation"}:
        tags.append("overlay")
    if category in {"layout", "data", "display"}:
        tags.append("visual")
    return ControlSpec(
        type_name=control_type,
        category=category,
        capabilities=_control_capabilities(control_type, properties, child_mode),
        props=prop_specs,
        events=common_events,
        child_mode=child_mode,
        slots=slots_for_control(control_type),
        tags=tuple(tags),
        schema=dict(schema),
    )


CONTROL_SPECS: dict[str, ControlSpec] = {
    control_type: _control_spec(control_type, schema)
    for control_type, schema in sorted(CONTROL_SCHEMAS.items())
}


def get_control_spec(control_type: str) -> ControlSpec | None:
    return CONTROL_SPECS.get(str(control_type))


def iter_control_specs() -> tuple[ControlSpec, ...]:
    return tuple(CONTROL_SPECS.values())


def control_specs_for_category(category: str) -> tuple[ControlSpec, ...]:
    category_name = str(category)
    return tuple(spec for spec in CONTROL_SPECS.values() if spec.category == category_name)
