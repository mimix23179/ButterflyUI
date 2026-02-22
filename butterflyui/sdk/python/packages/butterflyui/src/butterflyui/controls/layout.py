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


