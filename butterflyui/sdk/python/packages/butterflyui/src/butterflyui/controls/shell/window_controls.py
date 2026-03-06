from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["WindowControls"]

@butterfly_control('window_controls')
class WindowControls(LayoutControl):
    """
    Custom window control buttons (minimize, maximize, close) for desktop apps.

    The runtime renders a row of window-chrome buttons styled to match the
    app theme. ``show_minimize``, ``show_maximize``, and ``show_close``
    toggle individual buttons. ``spacing`` sets the gap between buttons.
    ``button_width``/``button_height`` fix button dimensions. ``radius``
    sets the corner radius of each button.

    Example:

    ```python
    import butterflyui as bui

    bui.WindowControls(
        show_minimize=True,
        show_maximize=True,
        show_close=True,
        spacing=8,
    )
    ```
    """

    show_minimize: bool | None = None
    """
    When ``True`` the minimize button is rendered.
    """

    show_maximize: bool | None = None
    """
    When ``True`` the maximize/restore button is rendered.
    """

    show_close: bool | None = None
    """
    When ``True`` the close button is rendered.
    """

    spacing: float | None = None
    """
    Gap in logical pixels between adjacent control buttons.
    """

    button_width: float | None = None
    """
    Fixed width in logical pixels for each control button.
    """

    button_height: float | None = None
    """
    Fixed height in logical pixels for each control button.
    """

    radius: float | None = None
    """
    Corner radius applied to each control button surface.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `window_controls` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `window_controls` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `window_controls` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `window_controls` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `window_controls` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `window_controls` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `window_controls` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `window_controls` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `window_controls` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `window_controls` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `window_controls` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `window_controls` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `window_controls` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `window_controls` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `window_controls` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `window_controls` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `window_controls` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `window_controls` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `window_controls` runtime control.
    """
