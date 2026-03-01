from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["WindowFrame"]

class WindowFrame(Component):
    """
    Custom window chrome frame with title bar, controls, and optional acrylic.

    The runtime renders a full custom window frame around its child content.
    ``title`` sets the window title bar text. ``show_close``,
    ``show_maximize``, and ``show_minimize`` toggle the window control
    buttons. ``draggable`` makes the title bar a drag region.
    ``acrylic_effect`` enables a translucent background; ``acrylic_opacity``
    controls its strength. ``custom_frame`` opts in to a fully custom
    window border. ``use_native_title_bar`` reverts to the OS title bar.
    ``native_window_actions`` delegates minimize/maximize/close to the OS.
    ``show_default_controls`` toggles the built-in control button row.
    ``emit_move_events`` fires window-position events; ``move_event_throttle_ms``
    rate-limits them. ``title_leading``, ``title_content``, and
    ``title_trailing`` slot arbitrary widgets into the title bar.

    ```python
    import butterflyui as bui

    bui.WindowFrame(
        bui.Text("App content"),
        title="My App",
        draggable=True,
        show_close=True,
        show_maximize=True,
        show_minimize=True,
    )
    ```

    Args:
        title:
            Text displayed in the window title bar.
        show_close:
            When ``True`` the close button is shown in the title bar.
        show_maximize:
            When ``True`` the maximize/restore button is shown.
        show_minimize:
            When ``True`` the minimize button is shown.
        draggable:
            When ``True`` the title bar acts as a window-drag region.
        acrylic_effect:
            When ``True`` an acrylic (translucent blur) background is applied.
        acrylic_opacity:
            Opacity of the acrylic background (0.0--1.0).
        custom_frame:
            When ``True`` a fully custom window border is rendered.
        use_native_title_bar:
            When ``True`` the OS native title bar is used instead.
        native_window_actions:
            When ``True`` window control actions are delegated to the OS.
        show_default_controls:
            When ``True`` the built-in window control button row is shown.
        emit_move_events:
            When ``True`` window-position events are emitted to Python.
        move_event_throttle_ms:
            Minimum milliseconds between consecutive move events.
        title_leading:
            Widget placed at the leading (left) end of the title bar.
        title_content:
            Widget replacing the default title text in the title bar.
        title_trailing:
            Widget placed at the trailing (right) end of the title bar.
    """

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
