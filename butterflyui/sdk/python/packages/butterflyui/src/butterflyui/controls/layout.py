from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Align",
    "PageControl",
    "Surface",
    "Box",
    "Container",
    "Row",
    "Column",
    "Stack",
    "Wrap",
    "Expanded",
    "ScrollView",
    "SplitView",
    "SplitPane",
    "Accordion",
    "AdjustmentPanel",
    "BoundsProbe",
    "DockLayout",
    "Pane",
    "InspectorPanel",
]


class Align(Component):
    control_type = "align"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        alignment: Any | None = None,
        width_factor: float | None = None,
        height_factor: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            alignment=alignment,
            width_factor=width_factor,
            height_factor=height_factor,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_alignment(self, session: Any, alignment: Any) -> dict[str, Any]:
        return self.invoke(session, "set_alignment", {"alignment": alignment})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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

    def __init__(
        self,
        *children: Any,
        padding: Any | None = None,
        radius: float | None = None,
        bgcolor: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            padding=padding,
            radius=radius,
            bgcolor=bgcolor,
            border_color=border_color,
            border_width=border_width,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Box(Component):
    control_type = "box"

    def __init__(
        self,
        *children: Any,
        width: Any | None = None,
        height: Any | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        alignment: Any | None = None,
        bgcolor: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            width=width,
            height=height,
            padding=padding,
            margin=margin,
            alignment=alignment,
            bgcolor=bgcolor,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Container(Component):
    control_type = "container"

    def __init__(
        self,
        *children: Any,
        width: Any | None = None,
        height: Any | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        alignment: Any | None = None,
        bgcolor: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            width=width,
            height=height,
            padding=padding,
            margin=margin,
            alignment=alignment,
            bgcolor=bgcolor,
            border_color=border_color,
            border_width=border_width,
            radius=radius,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Row(Component):
    control_type = "row"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        gap: float | None = None,
        main_axis: str | None = None,
        cross_axis: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing if spacing is not None else gap,
            gap=gap if gap is not None else spacing,
            main_axis=main_axis,
            cross_axis=cross_axis,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Column(Component):
    control_type = "column"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        gap: float | None = None,
        main_axis: str | None = None,
        cross_axis: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing if spacing is not None else gap,
            gap=gap if gap is not None else spacing,
            main_axis=main_axis,
            cross_axis=cross_axis,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Stack(Component):
    control_type = "stack"

    def __init__(
        self,
        *children: Any,
        alignment: Any | None = None,
        fit: str | None = None,
        clip: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            alignment=alignment,
            fit=fit,
            clip=clip,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Wrap(Component):
    control_type = "wrap"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        run_spacing: float | None = None,
        alignment: str | None = None,
        run_alignment: str | None = None,
        cross_axis: str | None = None,
        direction: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing,
            run_spacing=run_spacing,
            alignment=alignment,
            run_alignment=run_alignment,
            cross_axis=cross_axis,
            direction=direction,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


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

    def __init__(
        self,
        *children: Any,
        direction: str | None = None,
        reverse: bool | None = None,
        content_padding: Any | None = None,
        initial_offset: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            direction=direction,
            reverse=reverse,
            content_padding=content_padding,
            initial_offset=initial_offset,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_scroll_metrics(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_scroll_metrics", {})

    def scroll_to(
        self,
        session: Any,
        offset: float,
        *,
        animate: bool = True,
        duration_ms: int = 250,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "scroll_to",
            {
                "offset": offset,
                "animate": animate,
                "duration_ms": duration_ms,
            },
        )

    def scroll_by(
        self,
        session: Any,
        delta: float,
        *,
        animate: bool = True,
        duration_ms: int = 250,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "scroll_by",
            {
                "delta": delta,
                "animate": animate,
                "duration_ms": duration_ms,
            },
        )

    def scroll_to_start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_start", {})

    def scroll_to_end(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_end", {})


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


class SplitPane(SplitView):
    control_type = "split_pane"

    def __init__(
        self,
        *children: Any,
        axis: str | None = None,
        ratio: float | None = None,
        min_ratio: float | None = None,
        max_ratio: float | None = None,
        draggable: bool | None = None,
        divider_size: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            axis=axis,
            ratio=ratio,
            min_ratio=min_ratio,
            max_ratio=max_ratio,
            draggable=draggable,
            divider_size=divider_size,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_ratio(self, session: Any, ratio: float) -> dict[str, Any]:
        return self.invoke(session, "set_ratio", {"ratio": float(ratio)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Accordion(Component):
    control_type = "accordion"

    def __init__(
        self,
        *children: Any,
        sections: list[Mapping[str, Any]] | None = None,
        labels: list[str] | None = None,
        index: int | list[int] | None = None,
        expanded: int | list[int] | None = None,
        multiple: bool | None = None,
        allow_empty: bool | None = None,
        dense: bool | None = None,
        show_dividers: bool | None = None,
        spacing: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            sections=sections,
            labels=labels,
            index=index if index is not None else expanded,
            expanded=expanded if expanded is not None else index,
            multiple=multiple,
            allow_empty=allow_empty,
            dense=dense,
            show_dividers=show_dividers,
            spacing=spacing,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_expanded(self, session: Any, index: int | list[int]) -> dict[str, Any]:
        return self.invoke(session, "set_expanded", {"index": index, "expanded": index})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class AdjustmentPanel(Component):
    control_type = "adjustment_panel"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        adjustments: list[Mapping[str, Any]] | None = None,
        title: str | None = None,
        show_reset: bool | None = None,
        dense: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items if items is not None else adjustments,
            adjustments=adjustments if adjustments is not None else items,
            title=title,
            show_reset=show_reset,
            dense=dense,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_item(self, session: Any, item_id: str, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_item", {"id": item_id, "value": float(value)})

    def reset(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "reset", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class BoundsProbe(Component):
    control_type = "bounds_probe"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        enabled: bool | None = None,
        emit_initial: bool | None = None,
        emit_on_change: bool | None = None,
        debounce_ms: int | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            emit_initial=emit_initial,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def get_bounds(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_bounds", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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


