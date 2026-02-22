from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Splash",
    "Modal",
    "Popover",
    "Portal",
    "BottomSheet",
    "ContextMenu",
    "Tooltip",
    "Toast",
    "ToastHost",
    "NotificationCenter",
    "NotificationHost",
]


class Splash(Component):
    control_type = "splash"

    def __init__(
        self,
        child: Any | None = None,
        *,
        active: bool | None = None,
        color: Any | None = None,
        duration_ms: int | None = None,
        radius: float | None = None,
        centered: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            active=active,
            color=color,
            duration_ms=duration_ms,
            radius=radius,
            centered=centered,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def trigger(self, session: Any, x: float | None = None, y: float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if x is not None:
            payload["x"] = x
        if y is not None:
            payload["y"] = y
        return self.invoke(session, "trigger", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Modal(Component):
    control_type = "modal"

    def __init__(
        self,
        child: Any | None = None,
        *,
        open: bool | None = None,
        dismissible: bool | None = None,
        close_on_escape: bool | None = None,
        trap_focus: bool | None = None,
        duration_ms: int | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = None,
        source_rect: Mapping[str, Any] | list[float] | tuple[float, ...] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            open=open,
            dismissible=dismissible,
            close_on_escape=close_on_escape,
            trap_focus=trap_focus,
            duration_ms=duration_ms,
            transition=transition,
            transition_type=transition_type,
            source_rect=source_rect,
            **kwargs,
        )
        super().__init__(
            child=child,
            props=merged,
            style=style,
            strict=strict,
        )


class Popover(Component):
    control_type = "popover"

    def __init__(
        self,
        anchor: Any | None = None,
        content: Any | None = None,
        *,
        open: bool | None = None,
        position: str | None = None,
        offset: Any | None = None,
        dismissible: bool | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            anchor=anchor,
            content=content,
            open=open,
            position=position,
            offset=offset,
            dismissible=dismissible,
            transition=transition,
            transition_type=transition_type,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Portal(Component):
    control_type = "portal"

    def __init__(
        self,
        child: Any | None = None,
        portal: Any | None = None,
        *,
        open: bool | None = None,
        dismissible: bool | None = None,
        passthrough: bool | None = None,
        alignment: Any | None = None,
        offset: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            child=child,
            portal=portal,
            open=open,
            dismissible=dismissible,
            passthrough=passthrough,
            alignment=alignment,
            offset=offset,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class BottomSheet(Component):
    control_type = "bottom_sheet"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        open: bool | None = None,
        dismissible: bool | None = None,
        scrim_color: Any | None = None,
        height: float | None = None,
        max_height: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            open=open,
            dismissible=dismissible,
            scrim_color=scrim_color,
            height=height,
            max_height=max_height,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ContextMenu(Component):
    control_type = "context_menu"

    def __init__(
        self,
        child: Any | None = None,
        *,
        items: list[Any] | None = None,
        trigger: str | None = None,
        open_on_tap: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            trigger=trigger,
            open_on_tap=open_on_tap,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class Tooltip(Component):
    control_type = "tooltip"

    def __init__(
        self,
        child: Any | None = None,
        *,
        message: str | None = None,
        prefer_below: bool | None = None,
        wait_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            message=message,
            prefer_below=prefer_below,
            wait_ms=wait_ms,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class Toast(Component):
    control_type = "toast"

    def __init__(
        self,
        message: str | None = None,
        *,
        open: bool | None = None,
        duration_ms: int | None = None,
        action_label: str | None = None,
        variant: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            message=message,
            open=open,
            duration_ms=duration_ms,
            action_label=action_label,
            variant=variant,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class ToastHost(Component):
    control_type = "toast_host"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        position: str | None = None,
        max_items: int | None = None,
        latest_on_top: bool | None = None,
        dismissible: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            position=position,
            max_items=max_items,
            latest_on_top=latest_on_top,
            dismissible=dismissible,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class NotificationHost(ToastHost):
    control_type = "notification_host"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        position: str | None = None,
        max_items: int | None = None,
        latest_on_top: bool | None = None,
        dismissible: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            items=items,
            position=position,
            max_items=max_items,
            latest_on_top=latest_on_top,
            dismissible=dismissible,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def push(self, session: Any, item: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "push", {"item": dict(item)})

    def dismiss(self, session: Any, item_id: str) -> dict[str, Any]:
        return self.invoke(session, "dismiss", {"id": item_id})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_items(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_items", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class NotificationCenter(Component):
    control_type = "notification_center"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        notifications: list[Mapping[str, Any]] | None = None,
        title: str | None = None,
        show_clear_all: bool | None = None,
        max_items: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items if items is not None else notifications,
            notifications=notifications if notifications is not None else items,
            title=title,
            show_clear_all=show_clear_all,
            max_items=max_items,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def push(self, session: Any, item: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "push", {"item": dict(item)})

    def dismiss(self, session: Any, item_id: str) -> dict[str, Any]:
        return self.invoke(session, "dismiss", {"id": item_id})

    def get_items(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_items", {})



