from __future__ import annotations

from collections.abc import Mapping
from typing import Any

__all__ = [
    "control_children_from_slots",
    "replace_control_children",
]


def control_children_from_slots(control_type: str, props: Mapping[str, Any], children: list[Any]) -> list[Any]:
    if children:
        return list(children)

    from .control import Control

    def is_control_like(value: Any) -> bool:
        return isinstance(value, Control) or (isinstance(value, Mapping) and "type" in value)

    def add_child(target: list[Any], value: Any) -> None:
        if not is_control_like(value):
            return
        if isinstance(value, Control):
            if any(value is existing for existing in target):
                return
        elif any(isinstance(existing, Mapping) and existing == value for existing in target):
            return
        target.append(value)

    merged_children: list[Any] = []
    props_child = props.get("child")
    props_children = props.get("children")

    if control_type in ("app_bar", "top_bar"):
        leading = props.get("leading")
        actions = props.get("actions")
        if leading is not None:
            add_child(merged_children, leading)
        if isinstance(actions, (list, tuple)):
            for item in actions:
                add_child(merged_children, item)
        elif actions is not None:
            add_child(merged_children, actions)
    elif control_type == "overlay":
        base_child = props.get("base_child")
        overlay_child = props.get("overlay_child")
        if base_child is not None:
            add_child(merged_children, base_child)
        if overlay_child is not None:
            add_child(merged_children, overlay_child)
    else:
        if props_child is not None:
            add_child(merged_children, props_child)
        if isinstance(props_children, (list, tuple)):
            for item in props_children:
                add_child(merged_children, item)
        elif props_children is not None:
            add_child(merged_children, props_children)
    return merged_children


def replace_control_children(control: Any, children: list[Any]) -> None:
    if hasattr(control, "set_children"):
        control.set_children(children)
    else:
        control.children = children
