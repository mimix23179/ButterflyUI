from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "AnimationAsset",
    "Launcher",
    "OverlayHost",
    "PageScene",
    "RouteHost",
    "RouteView",
    "Route",
    "Router",
    "WindowDragRegion",
    "DragRegion",
    "WindowFrame",
    "WindowControls",
]


class RouteView(Component):
    control_type = "route_view"

    def __init__(
        self,
        child: Any | None = None,
        *,
        route_id: str | None = None,
        title: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, route_id=route_id, title=title, **kwargs)
        super().__init__(child=child, props=merged, style=style, strict=strict)


class Route(RouteView):
    control_type = "route"

    def __init__(
        self,
        child: Any | None = None,
        *,
        route_id: str | None = None,
        title: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            route_id=route_id,
            title=title,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_route_id(self, session: Any, route_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_route_id", {"route_id": route_id})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class RouteHost(Component):
    control_type = "route_host"

    def __init__(
        self,
        child: Any | None = None,
        *,
        route_id: str | None = None,
        title: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, route_id=route_id, title=title, **kwargs)
        super().__init__(child=child, props=merged, style=style, strict=strict)


class Router(Component):
    control_type = "router"

    def __init__(
        self,
        *children: Any,
        routes: list[Mapping[str, Any]] | None = None,
        active: str | None = None,
        index: int | None = None,
        transition: Mapping[str, Any] | None = None,
        source_rect: Mapping[str, Any] | list[float] | tuple[float, ...] | None = None,
        keep_alive: bool | None = None,
        lightweight_transitions: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            routes=routes,
            active=active,
            index=index,
            transition=transition,
            source_rect=source_rect,
            keep_alive=keep_alive,
            lightweight_transitions=lightweight_transitions,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class Launcher(Component):
    control_type = "launcher"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        layout: str | None = None,
        columns: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            selected_id=selected_id,
            layout=layout,
            columns=columns,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class PageScene(Component):
    control_type = "page_scene"

    def __init__(
        self,
        *,
        background_layer: Any | None = None,
        ambient_layer: Any | None = None,
        hero_layer: Any | None = None,
        content_layer: Any | None = None,
        overlay_layer: Any | None = None,
        pages: Iterable[Any] | None = None,
        active_page: str | int | None = None,
        transition: Mapping[str, Any] | None = None,
        children: Iterable[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            background_layer=background_layer,
            ambient_layer=ambient_layer,
            hero_layer=hero_layer,
            content_layer=content_layer,
            overlay_layer=overlay_layer,
            pages=list(pages) if pages is not None else None,
            active_page=active_page,
            transition=transition,
            **kwargs,
        )
        super().__init__(children=children, props=merged, style=style, strict=strict)


class OverlayHost(Component):
    control_type = "overlay_host"

    def __init__(
        self,
        base: Any | None = None,
        *,
        overlays: list[Any] | None = None,
        active_overlay: str | list[str] | tuple[str, ...] | None = None,
        active_id: str | None = None,
        active_index: int | None = None,
        show_all_overlays: bool | None = None,
        show_default_overlay: bool | None = None,
        max_visible_overlays: int | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = None,
        transition_ms: int | None = None,
        clip: bool | None = None,
        children: Iterable[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            base=base,
            overlays=overlays,
            active_overlay=active_overlay,
            active_id=active_id,
            active_index=active_index,
            show_all_overlays=show_all_overlays,
            show_default_overlay=show_default_overlay,
            max_visible_overlays=max_visible_overlays,
            transition=transition,
            transition_type=transition_type,
            transition_ms=transition_ms,
            clip=clip,
            **kwargs,
        )
        super().__init__(children=children, props=merged, style=style, strict=strict)


class WindowFrame(Component):
    control_type = "window_frame"

    def __init__(
        self,
        child: Any | None = None,
        *,
        title: str | None = None,
        show_close: bool | None = None,
        show_maximize: bool | None = None,
        show_minimize: bool | None = None,
        draggable: bool | None = None,
        acrylic_effect: bool | None = None,
        acrylic_opacity: float | None = None,
        custom_frame: bool | None = None,
        use_native_title_bar: bool | None = None,
        native_window_actions: bool | None = None,
        show_default_controls: bool | None = None,
        title_leading: Any | None = None,
        title_content: Any | None = None,
        title_trailing: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            show_close=show_close,
            show_maximize=show_maximize,
            show_minimize=show_minimize,
            draggable=draggable,
            acrylic_effect=acrylic_effect,
            acrylic_opacity=acrylic_opacity,
            custom_frame=custom_frame,
            use_native_title_bar=use_native_title_bar,
            native_window_actions=native_window_actions,
            show_default_controls=show_default_controls,
            title_leading=title_leading,
            title_content=title_content,
            title_trailing=title_trailing,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class WindowDragRegion(Component):
    control_type = "window_drag_region"

    def __init__(
        self,
        child: Any | None = None,
        *,
        draggable: bool | None = None,
        maximize_on_double_tap: bool | None = None,
        emit_move: bool | None = None,
        native_drag: bool | None = None,
        native_maximize_action: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            draggable=draggable,
            maximize_on_double_tap=maximize_on_double_tap,
            emit_move=emit_move,
            native_drag=native_drag,
            native_maximize_action=native_maximize_action,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class DragRegion(Component):
    control_type = "drag_region"

    def __init__(
        self,
        child: Any | None = None,
        *,
        draggable: bool | None = None,
        maximize_on_double_tap: bool | None = None,
        emit_move: bool | None = None,
        native_drag: bool | None = None,
        native_maximize_action: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            draggable=draggable,
            maximize_on_double_tap=maximize_on_double_tap,
            emit_move=emit_move,
            native_drag=native_drag,
            native_maximize_action=native_maximize_action,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class WindowControls(Component):
    control_type = "window_controls"

    def __init__(
        self,
        *,
        show_minimize: bool | None = None,
        show_maximize: bool | None = None,
        show_close: bool | None = None,
        spacing: float | None = None,
        button_width: float | None = None,
        button_height: float | None = None,
        radius: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            show_minimize=show_minimize,
            show_maximize=show_maximize,
            show_close=show_close,
            spacing=spacing,
            button_width=button_width,
            button_height=button_height,
            radius=radius,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class AnimationAsset(Component):
    control_type = "animation_asset"

    def __init__(
        self,
        *,
        src: str | None = None,
        kind: str | None = None,
        engine: str | None = None,
        frames: list[str] | None = None,
        autoplay: bool | None = None,
        loop: bool | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            kind=kind,
            engine=engine,
            frames=frames,
            autoplay=autoplay,
            loop=loop,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


