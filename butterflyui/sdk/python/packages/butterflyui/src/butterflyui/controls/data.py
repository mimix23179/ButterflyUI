from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "ListView",
    "GridView",
    "VirtualList",
    "VirtualGrid",
    "Card",
    "Table",
    "DataTable",
    "DataGrid",
    "TableView",
    "ListTile",
    "ItemTile",
    "TreeNode",
    "TreeView",
    "FileBrowser",
    "ProgressTimeline",
    "TaskList",
    "ProgressIndicator",
    "Progress",
    "Skeleton",
    "SkeletonLoader",
]


class ListView(Component):
    control_type = "list_view"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        separator: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, items=items, separator=separator, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)


class GridView(Component):
    control_type = "grid_view"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        columns: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, items=items, columns=columns, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)


class VirtualList(Component):
    control_type = "virtual_list"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        item_extent: float | None = None,
        cache_extent: float | None = None,
        separator: bool | None = None,
        has_more: bool | None = None,
        loading: bool | None = None,
        prefetch_threshold: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            item_extent=item_extent,
            cache_extent=cache_extent,
            separator=separator,
            has_more=has_more,
            loading=loading,
            prefetch_threshold=prefetch_threshold,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class VirtualGrid(Component):
    control_type = "virtual_grid"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        columns: int | None = None,
        spacing: float | None = None,
        run_spacing: float | None = None,
        child_aspect_ratio: float | None = None,
        has_more: bool | None = None,
        loading: bool | None = None,
        prefetch_threshold: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            columns=columns,
            spacing=spacing,
            run_spacing=run_spacing,
            child_aspect_ratio=child_aspect_ratio,
            has_more=has_more,
            loading=loading,
            prefetch_threshold=prefetch_threshold,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Card(Component):
    control_type = "card"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        subtitle: str | None = None,
        elevated: bool | None = None,
        radius: float | None = None,
        content_padding: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            subtitle=subtitle,
            elevated=elevated,
            radius=radius,
            content_padding=content_padding,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Table(Component):
    control_type = "table"

    def __init__(
        self,
        *,
        columns: list[Any] | None = None,
        rows: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, columns=columns, rows=rows, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class DataTable(Component):
    control_type = "data_table"

    def __init__(
        self,
        *,
        columns: list[Any] | None = None,
        rows: list[Any] | None = None,
        sortable: bool | None = None,
        filterable: bool | None = None,
        selectable: bool | None = None,
        dense: bool | None = None,
        striped: bool | None = None,
        show_header: bool | None = None,
        sort_column: str | None = None,
        sort_ascending: bool | None = None,
        filter_query: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            columns=columns,
            rows=rows,
            sortable=sortable,
            filterable=filterable,
            selectable=selectable,
            dense=dense,
            striped=striped,
            show_header=show_header,
            sort_column=sort_column,
            sort_ascending=sort_ascending,
            filter_query=filter_query,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_sort(
        self,
        session: Any,
        *,
        column: str | None = None,
        ascending: bool = True,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_sort",
            {"column": column, "ascending": ascending},
        )

    def clear_sort(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_sort", {})

    def set_filter(self, session: Any, query: str) -> dict[str, Any]:
        return self.invoke(session, "set_filter", {"query": query})

    def clear_filter(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_filter", {})

    def clear_selection(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_selection", {})


class DataGrid(DataTable):
    control_type = "data_grid"


class TableView(DataTable):
    control_type = "table_view"

    def __init__(
        self,
        *,
        columns: list[Any] | None = None,
        rows: list[Any] | None = None,
        sortable: bool | None = None,
        filterable: bool | None = None,
        selectable: bool | None = None,
        dense: bool | None = None,
        striped: bool | None = None,
        show_header: bool | None = None,
        sort_column: str | None = None,
        sort_ascending: bool | None = None,
        filter_query: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            columns=columns,
            rows=rows,
            sortable=sortable,
            filterable=filterable,
            selectable=selectable,
            dense=dense,
            striped=striped,
            show_header=show_header,
            sort_column=sort_column,
            sort_ascending=sort_ascending,
            filter_query=filter_query,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ListTile(Component):
    control_type = "list_tile"

    def __init__(
        self,
        *,
        title: str | None = None,
        subtitle: str | None = None,
        leading_icon: str | None = None,
        trailing_icon: str | None = None,
        meta: str | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            subtitle=subtitle,
            leading_icon=leading_icon,
            trailing_icon=trailing_icon,
            meta=meta,
            selected=selected,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class ItemTile(ListTile):
    control_type = "item_tile"

    def __init__(
        self,
        *,
        title: str | None = None,
        subtitle: str | None = None,
        leading_icon: str | None = None,
        trailing_icon: str | None = None,
        meta: str | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            title=title,
            subtitle=subtitle,
            leading_icon=leading_icon,
            trailing_icon=trailing_icon,
            meta=meta,
            selected=selected,
            enabled=enabled,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class TreeNode(Component):
    control_type = "tree_node"

    def __init__(
        self,
        *,
        node_id: str | None = None,
        label: str | None = None,
        icon: str | None = None,
        expanded: bool | None = None,
        selected: bool | None = None,
        disabled: bool | None = None,
        children: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            id=node_id,
            label=label,
            icon=icon,
            expanded=expanded,
            selected=selected,
            disabled=disabled,
            children=children,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class TreeView(Component):
    control_type = "tree_view"

    def __init__(
        self,
        *,
        nodes: list[Any] | None = None,
        expanded: list[str] | None = None,
        selected: list[str] | str | None = None,
        multi_select: bool | None = None,
        show_root: bool | None = None,
        expand_all: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            nodes=nodes,
            expanded=expanded,
            selected=selected,
            multi_select=multi_select,
            show_root=show_root,
            expand_all=expand_all,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class FileBrowser(Component):
    control_type = "file_browser"

    def __init__(
        self,
        *,
        nodes: list[Any] | None = None,
        selected: list[str] | str | None = None,
        expanded: list[str] | None = None,
        show_root: bool | None = None,
        multi_select: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            nodes=nodes,
            selected=selected,
            expanded=expanded,
            show_root=show_root,
            multi_select=multi_select,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class ProgressTimeline(Component):
    control_type = "progress_timeline"

    def __init__(
        self,
        *,
        items: list[Any] | None = None,
        current_index: int | None = None,
        dense: bool | None = None,
        show_connector: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            current_index=current_index,
            dense=dense,
            show_connector=show_connector,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class TaskList(Component):
    control_type = "task_list"

    def __init__(
        self,
        *,
        items: list[Any] | None = None,
        dense: bool | None = None,
        separator: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            dense=dense,
            separator=separator,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class ProgressIndicator(Component):
    control_type = "progress_indicator"

    def __init__(
        self,
        *,
        value: float | None = None,
        indeterminate: bool | None = None,
        label: str | None = None,
        variant: str | None = None,
        circular: bool | None = None,
        stroke_width: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            indeterminate=indeterminate,
            label=label,
            variant=variant,
            circular=circular,
            stroke_width=stroke_width,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Progress(ProgressIndicator):
    control_type = "progress"

    def __init__(
        self,
        *,
        value: float | None = None,
        indeterminate: bool | None = None,
        label: str | None = None,
        variant: str | None = None,
        circular: bool | None = None,
        stroke_width: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            indeterminate=indeterminate,
            label=label,
            variant=variant,
            circular=circular,
            stroke_width=stroke_width,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_value(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": float(value)})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Skeleton(Component):
    control_type = "skeleton"

    def __init__(
        self,
        *,
        variant: str | None = None,
        radius: float | None = None,
        width: float | None = None,
        height: float | None = None,
        duration_ms: int | None = None,
        color: Any | None = None,
        highlight_color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            radius=radius,
            width=width,
            height=height,
            duration_ms=duration_ms,
            color=color,
            highlight_color=highlight_color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "start", {})

    def stop(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "stop", {})


class SkeletonLoader(Component):
    control_type = "skeleton_loader"

    def __init__(
        self,
        *,
        count: int | None = None,
        spacing: float | None = None,
        variant: str | None = None,
        radius: float | None = None,
        width: float | None = None,
        height: float | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            count=count,
            spacing=spacing,
            variant=variant,
            radius=radius,
            width=width,
            height=height,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_count(self, session: Any, count: int) -> dict[str, Any]:
        return self.invoke(session, "set_count", {"count": int(count)})



