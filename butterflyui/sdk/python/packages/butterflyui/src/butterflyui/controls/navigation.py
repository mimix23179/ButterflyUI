from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Tabs",
    "Sidebar",
    "AppBar",
    "TopBar",
    "Drawer",
    "SideDrawer",
    "Paginator",
    "PageNav",
    "PageStepper",
    "ActionBar",
    "MenuBar",
    "MenuItem",
    "Breadcrumbs",
    "BreadcrumbBar",
    "CrumbTrail",
    "ContextActionBar",
    "StatusBar",
    "Navigator",
    "NavRing",
    "SymbolTree",
    "RailNav",
    "NoticeBar",
    "Outline",
    "CommandPalette",
    "CommandItem",
]


class Tabs(Component):
    control_type = "tabs"

    def __init__(
        self,
        *children: Any,
        labels: list[str] | None = None,
        index: int | None = None,
        scrollable: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            labels=labels,
            index=index,
            scrollable=scrollable,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Sidebar(Component):
    control_type = "sidebar"

    def __init__(
        self,
        *,
        sections: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        selected_id: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            sections=sections,
            items=items,
            selected_id=selected_id,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Navigator(Sidebar):
    control_type = "navigator"

    def __init__(
        self,
        *,
        sections: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        selected_id: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            sections=sections,
            items=items,
            selected_id=selected_id,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )


class NavRing(Component):
    control_type = "nav_ring"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        policy: str | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            selected_id=selected_id,
            policy=policy,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class RailNav(Component):
    control_type = "rail_nav"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        dense: bool | None = None,
        extended: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            selected_id=selected_id,
            dense=dense,
            extended=extended,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class NoticeBar(Component):
    control_type = "notice_bar"

    def __init__(
        self,
        *,
        text: str | None = None,
        variant: str | None = None,
        icon: str | None = None,
        dismissible: bool | None = None,
        action_label: str | None = None,
        action_id: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            variant=variant,
            icon=icon,
            dismissible=dismissible,
            action_label=action_label,
            action_id=action_id,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_text(self, session: Any, text: str) -> dict[str, Any]:
        return self.invoke(session, "set_text", {"text": text})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Outline(Component):
    control_type = "outline"

    def __init__(
        self,
        *,
        nodes: list[Mapping[str, Any]] | None = None,
        expanded: list[str] | None = None,
        selected_id: str | None = None,
        dense: bool | None = None,
        show_icons: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            nodes=[dict(node) for node in (nodes or [])],
            expanded=expanded,
            selected_id=selected_id,
            dense=dense,
            show_icons=show_icons,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class SymbolTree(Component):
    control_type = "symbol_tree"

    def __init__(
        self,
        *,
        nodes: list[Mapping[str, Any]] | None = None,
        expanded: list[str] | None = None,
        selected_id: str | None = None,
        dense: bool | None = None,
        show_icons: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            nodes=[dict(node) for node in (nodes or [])],
            expanded=expanded,
            selected_id=selected_id,
            dense=dense,
            show_icons=show_icons,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class AppBar(Component):
    control_type = "app_bar"

    def __init__(
        self,
        *,
        title: str | None = None,
        subtitle: str | None = None,
        leading: Any | None = None,
        actions: list[Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            subtitle=subtitle,
            leading=leading,
            actions=actions,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_title(self, session: Any, title: str, subtitle: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {"title": title}
        if subtitle is not None:
            payload["subtitle"] = subtitle
        return self.invoke(session, "set_title", payload)

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)


class TopBar(Component):
    control_type = "top_bar"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        subtitle: str | None = None,
        center_title: bool | None = None,
        show_search: bool | None = None,
        search_value: str | None = None,
        search_placeholder: str | None = None,
        actions: list[Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            subtitle=subtitle,
            center_title=center_title,
            show_search=show_search,
            search_value=search_value,
            search_placeholder=search_placeholder,
            actions=actions,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_title(self, session: Any, title: str) -> dict[str, Any]:
        return self.invoke(session, "set_title", {"title": title})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)


class Drawer(Component):
    control_type = "drawer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        open: bool | None = None,
        side: str | None = None,
        size: float | None = None,
        dismissible: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            open=open,
            side=side,
            size=size,
            dismissible=dismissible,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_open(self, session: Any, open: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"open": open})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)


class SideDrawer(Drawer):
    control_type = "side_drawer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        open: bool | None = None,
        side: str | None = None,
        size: float | None = None,
        dismissible: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            open=open,
            side=side,
            size=size,
            dismissible=dismissible,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class Paginator(Component):
    control_type = "paginator"

    def __init__(
        self,
        *,
        page: int | None = None,
        page_count: int | None = None,
        page_size: int | None = None,
        total_items: int | None = None,
        max_visible: int | None = None,
        show_edges: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            page=page,
            page_count=page_count,
            page_size=page_size,
            total_items=total_items,
            max_visible=max_visible,
            show_edges=show_edges,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class PageNav(Paginator):
    control_type = "page_nav"

    def __init__(
        self,
        *,
        page: int | None = None,
        page_count: int | None = None,
        page_size: int | None = None,
        total_items: int | None = None,
        max_visible: int | None = None,
        show_edges: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            page=page,
            page_count=page_count,
            page_size=page_size,
            total_items=total_items,
            max_visible=max_visible,
            show_edges=show_edges,
            dense=dense,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_page(self, session: Any, page: int) -> dict[str, Any]:
        return self.invoke(session, "set_page", {"page": page})

    def next_page(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "next_page", {})

    def prev_page(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "prev_page", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class PageStepper(PageNav):
    control_type = "page_stepper"

    def __init__(
        self,
        *,
        page: int | None = None,
        page_count: int | None = None,
        page_size: int | None = None,
        total_items: int | None = None,
        max_visible: int | None = None,
        show_edges: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            page=page,
            page_count=page_count,
            page_size=page_size,
            total_items=total_items,
            max_visible=max_visible,
            show_edges=show_edges,
            dense=dense,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class ActionBar(Component):
    control_type = "action_bar"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        dense: bool | None = None,
        spacing: float | None = None,
        wrap: bool | None = None,
        alignment: str | None = None,
        bgcolor: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            dense=dense,
            spacing=spacing,
            wrap=wrap,
            alignment=alignment,
            bgcolor=bgcolor,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": items})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ContextActionBar(ActionBar):
    control_type = "context_action_bar"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        dense: bool | None = None,
        spacing: float | None = None,
        wrap: bool | None = None,
        alignment: str | None = None,
        bgcolor: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            items=items,
            dense=dense,
            spacing=spacing,
            wrap=wrap,
            alignment=alignment,
            bgcolor=bgcolor,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class MenuBar(Component):
    control_type = "menu_bar"

    def __init__(
        self,
        *children: Any,
        menus: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        dense: bool | None = None,
        height: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            menus=menus,
            items=items,
            dense=dense,
            height=height,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class MenuItem(Component):
    control_type = "menu_item"

    def __init__(
        self,
        *,
        label: str | None = None,
        item_id: str | None = None,
        icon: str | None = None,
        shortcut: str | None = None,
        enabled: bool | None = None,
        selected: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            id=item_id,
            icon=icon,
            shortcut=shortcut,
            enabled=enabled,
            selected=selected,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Breadcrumbs(Component):
    control_type = "breadcrumbs"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        separator: str | None = None,
        max_items: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            separator=separator,
            max_items=max_items,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class BreadcrumbBar(Component):
    control_type = "breadcrumb_bar"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        separator: str | None = None,
        max_items: int | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            separator=separator,
            max_items=max_items,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": items})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class CrumbTrail(BreadcrumbBar):
    control_type = "crumb_trail"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        current_index: int | None = None,
        separator: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            items=items,
            separator=separator,
            max_items=None,
            events=events,
            props=merge_props(props, current_index=current_index, enabled=enabled),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_index(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "set_index", {"index": int(index)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


class StatusBar(Component):
    control_type = "status_bar"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        text: str | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            text=text,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class CommandPalette(Component):
    control_type = "command_palette"

    def __init__(
        self,
        *,
        commands: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        open: bool | None = None,
        query: str | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        placeholder: str | None = None,
        max_results: int | None = None,
        dismiss_on_select: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            commands=commands,
            items=items,
            open=open,
            query=query,
            title=title,
            subtitle=subtitle,
            placeholder=placeholder,
            max_results=max_results,
            dismiss_on_select=dismiss_on_select,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class CommandItem(Component):
    control_type = "command_item"

    def __init__(
        self,
        *,
        label: str | None = None,
        item_id: str | None = None,
        subtitle: str | None = None,
        icon: str | None = None,
        shortcut: str | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            id=item_id,
            subtitle=subtitle,
            icon=icon,
            shortcut=shortcut,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)



