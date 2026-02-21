from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "PageControl",
    "Surface",
    "Box",
    "Row",
    "Column",
    "Stack",
    "Wrap",
    "Expanded",
    "ScrollView",
    "SplitView",
    "DockLayout",
    "Pane",
    "InspectorPanel",
]


class PageControl(Component):
    control_type = "page"

    def __init__(
        self,
        *children: Any,
        safe_area: bool = True,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, safe_area=safe_area, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)


class Surface(Component):
    control_type = "surface"


class Box(Component):
    control_type = "box"


class Row(Component):
    control_type = "row"


class Column(Component):
    control_type = "column"


class Stack(Component):
    control_type = "stack"


class Wrap(Component):
    control_type = "wrap"


class Expanded(Component):
    control_type = "expanded"

    def __init__(
        self,
        child: Any | None = None,
        *,
        flex: int = 1,
        fit: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, flex=int(flex), fit=fit, **kwargs)
        super().__init__(
            child=child,
            props=merged,
            style=style,
            strict=strict,
        )


class ScrollView(Component):
    control_type = "scroll_view"


class SplitView(Component):
    control_type = "split_view"

    def __init__(
        self,
        *children: Any,
        axis: str | None = None,
        ratio: float | None = None,
        min_ratio: float | None = None,
        max_ratio: float | None = None,
        draggable: bool | None = None,
        divider_size: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            axis=axis,
            ratio=ratio,
            min_ratio=min_ratio,
            max_ratio=max_ratio,
            draggable=draggable,
            divider_size=divider_size,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class DockLayout(Component):
    control_type = "dock_layout"

    def __init__(
        self,
        *children: Any,
        panes: list[Mapping[str, Any]] | None = None,
        gap: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, panes=panes, gap=gap, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)


class Pane(Component):
    control_type = "pane"

    def __init__(
        self,
        child: Any | None = None,
        *,
        slot: str | None = None,
        title: str | None = None,
        size: float | None = None,
        width: float | None = None,
        height: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            slot=slot,
            title=title,
            size=size,
            width=width,
            height=height,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class InspectorPanel(Component):
    control_type = "inspector_panel"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        sections: list[Mapping[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, title=title, sections=sections, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)


