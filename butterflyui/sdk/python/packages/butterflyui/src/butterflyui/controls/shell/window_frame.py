from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["WindowFrame"]

@butterfly_control('window_frame')
class WindowFrame(LayoutControl):
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

    Example:

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
    """

    show_close: bool | None = None
    """
    When ``True`` the close button is shown in the title bar.
    """

    show_maximize: bool | None = None
    """
    When ``True`` the maximize/restore button is shown.
    """

    show_minimize: bool | None = None
    """
    When ``True`` the minimize button is shown.
    """

    draggable: bool | None = None
    """
    When ``True`` the title bar acts as a window-drag region.
    """

    acrylic_effect: bool | None = None
    """
    When ``True`` an acrylic (translucent blur) background is applied.
    """

    acrylic_opacity: float | None = None
    """
    Opacity of the acrylic background (0.0--1.0).
    """

    custom_frame: bool | None = None
    """
    When ``True`` a fully custom window border is rendered.
    """

    use_native_title_bar: bool | None = None
    """
    When ``True`` the OS native title bar is used instead.
    """

    native_window_actions: bool | None = None
    """
    When ``True`` window control actions are delegated to the OS.
    """

    show_default_controls: bool | None = None
    """
    When ``True`` the built-in window control button row is shown.
    """

    emit_move_events: bool | None = None
    """
    When ``True`` window-position events are emitted to Python.
    """

    move_event_throttle_ms: int | None = None
    """
    Minimum milliseconds between consecutive move events.
    """

    title_leading: Any | None = None
    """
    Widget placed at the leading (left) end of the title bar.
    """

    title_content: Any | None = None
    """
    Widget replacing the default title text in the title bar.
    """

    title_trailing: Any | None = None
    """
    Widget placed at the trailing (right) end of the title bar.
    """

    content_padding: Any | None = None
    """
    Content padding value forwarded to the `window_frame` runtime control.
    """

    title_height: Any | None = None
    """
    Title height value forwarded to the `window_frame` runtime control.
    """

    native_title_bar: Any | None = None
    """
    Native title bar value forwarded to the `window_frame` runtime control.
    """

    system_title_bar: Any | None = None
    """
    System title bar value forwarded to the `window_frame` runtime control.
    """

    window_actions: Any | None = None
    """
    Window actions value forwarded to the `window_frame` runtime control.
    """

    title_widget: Any | None = None
    """
    Title widget value forwarded to the `window_frame` runtime control.
    """

    window_controls: Any | None = None
    """
    Window controls value forwarded to the `window_frame` runtime control.
    """
