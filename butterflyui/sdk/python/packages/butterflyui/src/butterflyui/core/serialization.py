from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .control import coerce_child_json, coerce_control_map, coerce_json_value

__all__ = [
    "coerce_child_json",
    "coerce_control_map",
    "coerce_json_value",
    "serialize_control",
    "serialize_child",
    "serialize_value",
]


def serialize_control(control: Any) -> dict[str, Any]:
    if hasattr(control, "to_json"):
        return control.to_json()
    if isinstance(control, Mapping):
        return coerce_control_map(control)
    raise TypeError(f"Unsupported control payload: {type(control).__name__}")


def serialize_child(child: Any) -> dict[str, Any] | None:
    return coerce_child_json(child)


def serialize_value(value: Any) -> Any:
    return coerce_json_value(value)
