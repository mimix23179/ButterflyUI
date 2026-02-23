from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "FocusAnchor",
    "GestureArea",
    "KeyListener",
    "ShortcutMap",
    "Cursor",
    "DragHandle",
    "DragPayload",
    "DropZone",
]


class KeyListener(Component):
    control_type = "key_listener"

    def __init__(
        self,
        child: Any | None = None,
        *,
        autofocus: bool | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            autofocus=autofocus,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class FocusAnchor(Component):
    control_type = "focus_anchor"

    def __init__(
        self,
        child: Any | None = None,
        *,
        autofocus: bool | None = None,
        enabled: bool | None = None,
        can_request_focus: bool | None = None,
        skip_traversal: bool | None = None,
        descendants_are_focusable: bool | None = None,
        descendants_are_traversable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            autofocus=autofocus,
            enabled=enabled,
            can_request_focus=can_request_focus,
            skip_traversal=skip_traversal,
            descendants_are_focusable=descendants_are_focusable,
            descendants_are_traversable=descendants_are_traversable,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def unfocus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "unfocus", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class GestureArea(Component):
    control_type = "gesture_area"

    def __init__(
        self,
        child: Any | None = None,
        *,
        enabled: bool | None = None,
        tap_enabled: bool | None = None,
        double_tap_enabled: bool | None = None,
        long_press_enabled: bool | None = None,
        pan_enabled: bool | None = None,
        scale_enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            tap_enabled=tap_enabled,
            double_tap_enabled=double_tap_enabled,
            long_press_enabled=long_press_enabled,
            pan_enabled=pan_enabled,
            scale_enabled=scale_enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ShortcutMap(Component):
    control_type = "shortcut_map"

    def __init__(
        self,
        child: Any | None = None,
        *,
        shortcuts: list[Mapping[str, Any]] | None = None,
        enabled: bool | None = None,
        use_global_hotkeys: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            shortcuts=shortcuts,
            enabled=enabled,
            use_global_hotkeys=use_global_hotkeys,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class Cursor(Component):
    control_type = "cursor"

    def __init__(
        self,
        child: Any | None = None,
        *,
        cursor: str | None = None,
        enabled: bool | None = None,
        opaque: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            cursor=cursor,
            enabled=enabled,
            opaque=opaque,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_cursor(self, session: Any, cursor: str) -> dict[str, Any]:
        return self.invoke(session, "set_cursor", {"cursor": cursor})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class DragHandle(Component):
    control_type = "drag_handle"

    def __init__(
        self,
        child: Any | None = None,
        *,
        index: int | None = None,
        enabled: bool | None = None,
        payload: Mapping[str, Any] | None = None,
        drag_type: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            index=index,
            enabled=enabled,
            payload=dict(payload or {}),
            drag_type=drag_type,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class DragPayload(Component):
    control_type = "drag_payload"

    def __init__(
        self,
        child: Any | None = None,
        *,
        data: Any | None = None,
        drag_type: str | None = None,
        mime: str | None = None,
        axis: str | None = None,
        max_simultaneous: int | None = None,
        drag_anchor: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            data=data,
            drag_type=drag_type,
            mime=mime,
            axis=axis,
            max_simultaneous=max_simultaneous,
            drag_anchor=drag_anchor,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class DropZone(Component):
    control_type = "drop_zone"

    def __init__(
        self,
        child: Any | None = None,
        *,
        enabled: bool | None = None,
        accepts: list[str] | None = None,
        accept_types: list[str] | None = None,
        accept_mimes: list[str] | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        use_desktop_drop: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            accepts=accepts,
            accept_types=accept_types if accept_types is not None else accepts,
            accept_mimes=accept_mimes,
            title=title,
            subtitle=subtitle,
            use_desktop_drop=use_desktop_drop,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})



