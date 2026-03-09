from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from .effects_control import EffectsControl
from .motion_control import MotionControl
from .overlay_control import OverlayControl
from .single_child_control import SingleChildControl
from .surface_control import SurfaceControl

__all__ = ["Component", "merge_props", "collect_children"]


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


class Component(
    OverlayControl,
    SingleChildControl,
    SurfaceControl,
    MotionControl,
    EffectsControl,
):
    """Shared compatibility base for handwritten ButterflyUI controls."""

    control_type: str = ""

    def __init__(
        self,
        *children_args: Any,
        child: Any | None = None,
        children: Iterable[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
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

        control_props = merge_props(props, **kwargs)
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


