from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["WindowFrame"]

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
        emit_move_events: bool | None = None,
        move_event_throttle_ms: int | None = None,
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
            emit_move_events=emit_move_events,
            move_event_throttle_ms=move_event_throttle_ms,
            title_leading=title_leading,
            title_content=title_content,
            title_trailing=title_trailing,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
