from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Tabs",
    "Sidebar",
    "AppBar",
    "Drawer",
    "Paginator",
    "PageNav",
    "PageStepper",
    "ActionBar",
    "MenuBar",
    "MenuItem",
    "Breadcrumbs",
    "BreadcrumbBar",
    "StatusBar",
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


class AppBar(Component):
    control_type = "app_bar"

    def __init__(
        self,
        *,
        title: str | None = None,
        subtitle: str | None = None,
        leading: Any | None = None,
        actions: list[Any] | None = None,
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
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


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
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


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



