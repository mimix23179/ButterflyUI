from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Align",
    "Center",
    "AspectRatio",
    "OverflowBox",
    "FittedBox",
    "DecoratedBox",
    "Clip",
    "PageControl",
    "Surface",
    "Box",
    "Container",
    "Row",
    "Column",
    "Stack",
    "ViewStack",
    "Viewport",
    "Visibility",
    "Wrap",
    "Expanded",
    "ScrollView",
    "ScrollableColumn",
    "ScrollableRow",
    "SafeArea",
    "ResizablePanel",
    "SplitView",
    "SplitPane",
    "Accordion",
    "AdjustmentPanel",
    "BoundsProbe",
    "DockLayout",
    "Pane",
    "PaneSpec",
    "InspectorPanel",
    "Frame",
    "Grid",
    "DetailsPane",
    "FlexSpacer",
    "Spacer",
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


class DetailsPane(Component):
    control_type = "details_pane"

    def __init__(
        self,
        *children: Any,
        mode: str | None = None,
        split_ratio: float | None = None,
        stack_breakpoint: float | None = None,
        show_details: bool | None = None,
        show_back: bool | None = None,
        back_label: str | None = None,
        divider: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            mode=mode,
            split_ratio=split_ratio,
            stack_breakpoint=stack_breakpoint,
            show_details=show_details,
            show_back=show_back,
            back_label=back_label,
            divider=divider,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_show_details(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_show_details", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class FlexSpacer(Component):
    control_type = "flex_spacer"

    def __init__(
        self,
        *,
        flex: int = 1,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, flex=int(flex), **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class Spacer(Component):
    control_type = "spacer"

    def __init__(
        self,
        *,
        flex: int = 1,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            flex=int(flex),
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_flex(self, session: Any, flex: int) -> dict[str, Any]:
        return self.invoke(session, "set_flex", {"flex": int(flex)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Frame(Component):
    control_type = "frame"

    def __init__(
        self,
        *children: Any,
        width: float | None = None,
        height: float | None = None,
        min_width: float | None = None,
        min_height: float | None = None,
        max_width: float | None = None,
        max_height: float | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        alignment: Any | None = None,
        bgcolor: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: float | None = None,
        clip_behavior: str | None = None,
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
            min_width=min_width,
            min_height=min_height,
            max_width=max_width,
            max_height=max_height,
            padding=padding,
            margin=margin,
            alignment=alignment,
            bgcolor=bgcolor,
            border_color=border_color,
            border_width=border_width,
            radius=radius,
            clip_behavior=clip_behavior,
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


class Grid(Component):
    control_type = "grid"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        columns: int | None = None,
        spacing: float | None = None,
        run_spacing: float | None = None,
        child_aspect_ratio: float | None = None,
        direction: str | None = None,
        reverse: bool | None = None,
        shrink_wrap: bool | None = None,
        events: list[str] | None = None,
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
            direction=direction,
            reverse=reverse,
            shrink_wrap=shrink_wrap,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Center(Align):
    control_type = "center"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        width_factor: float | None = None,
        height_factor: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            *children,
            alignment="center",
            width_factor=width_factor,
            height_factor=height_factor,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


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

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

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


class ViewStack(Component):
    control_type = "view_stack"

    def __init__(
        self,
        *children: Any,
        index: int | None = None,
        animate: bool | None = None,
        duration_ms: int | None = None,
        keep_alive: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            index=index,
            animate=animate,
            duration_ms=duration_ms,
            keep_alive=keep_alive,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_index(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "set_index", {"index": int(index)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Viewport(Component):
    control_type = "viewport"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        width: float | None = None,
        height: float | None = None,
        x: float | None = None,
        y: float | None = None,
        clip: bool | None = None,
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
            x=x,
            y=y,
            clip=clip,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_offset(self, session: Any, *, x: float, y: float) -> dict[str, Any]:
        return self.invoke(session, "set_offset", {"x": float(x), "y": float(y)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Visibility(Component):
    control_type = "visibility"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        visible: bool | None = None,
        maintain_state: bool | None = None,
        maintain_size: bool | None = None,
        maintain_animation: bool | None = None,
        replacement: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            visible=visible,
            maintain_state=maintain_state,
            maintain_size=maintain_size,
            maintain_animation=maintain_animation,
            replacement=replacement,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_visible(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_visible", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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


class ScrollableColumn(Component):
    control_type = "scrollable_column"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
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
            spacing=spacing,
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

    def scroll_to_start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_start", {})

    def scroll_to_end(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_end", {})


class ScrollableRow(Component):
    control_type = "scrollable_row"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
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
            spacing=spacing,
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

    def scroll_to_start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_start", {})

    def scroll_to_end(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_end", {})


class SafeArea(Component):
    control_type = "safe_area"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        left: bool | None = None,
        top: bool | None = None,
        right: bool | None = None,
        bottom: bool | None = None,
        minimum: Any | None = None,
        maintain_bottom_view_padding: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            left=left,
            top=top,
            right=right,
            bottom=bottom,
            minimum=minimum,
            maintain_bottom_view_padding=maintain_bottom_view_padding,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


class ResizablePanel(Component):
    control_type = "resizable_panel"

    def __init__(
        self,
        *children: Any,
        axis: str | None = None,
        size: float | None = None,
        min_size: float | None = None,
        max_size: float | None = None,
        drag_handle_size: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            axis=axis,
            size=size,
            min_size=min_size,
            max_size=max_size,
            drag_handle_size=drag_handle_size,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_size(self, session: Any, size: float) -> dict[str, Any]:
        return self.invoke(session, "set_size", {"size": float(size)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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


class PaneSpec(Component):
    control_type = "pane_spec"

    def __init__(
        self,
        child: Any | None = None,
        *,
        slot: str | None = None,
        title: str | None = None,
        size: float | None = None,
        width: float | None = None,
        height: float | None = None,
        min_size: float | None = None,
        max_size: float | None = None,
        collapsible: bool | None = None,
        collapsed: bool | None = None,
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
            min_size=min_size,
            max_size=max_size,
            collapsible=collapsible,
            collapsed=collapsed,
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


class AspectRatio(Component):
    control_type = "aspect_ratio"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        ratio: float | None = None,
        aspect_ratio: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            ratio=ratio if ratio is not None else aspect_ratio,
            aspect_ratio=aspect_ratio if aspect_ratio is not None else ratio,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


class OverflowBox(Component):
    control_type = "overflow_box"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        min_width: float | None = None,
        min_height: float | None = None,
        max_width: float | None = None,
        max_height: float | None = None,
        alignment: Any | None = None,
        fit: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            min_width=min_width,
            min_height=min_height,
            max_width=max_width,
            max_height=max_height,
            alignment=alignment,
            fit=fit,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


class FittedBox(Component):
    control_type = "fitted_box"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        fit: str | None = None,
        alignment: Any | None = None,
        clip_behavior: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            fit=fit,
            alignment=alignment,
            clip_behavior=clip_behavior,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


class DecoratedBox(Component):
    control_type = "decorated_box"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        color: Any | None = None,
        bgcolor: Any | None = None,
        gradient: Mapping[str, Any] | None = None,
        image: Mapping[str, Any] | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: float | None = None,
        shape: str | None = None,
        shadow: Any | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        clip_behavior: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            bgcolor=bgcolor if bgcolor is not None else color,
            gradient=dict(gradient) if gradient is not None else None,
            image=dict(image) if image is not None else None,
            border_color=border_color,
            border_width=border_width,
            radius=radius,
            shape=shape,
            shadow=shadow,
            padding=padding,
            margin=margin,
            clip_behavior=clip_behavior,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


class Clip(Component):
    control_type = "clip"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        shape: str | None = None,
        radius: float | None = None,
        clip_behavior: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            shape=shape,
            radius=radius,
            clip_behavior=clip_behavior,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


