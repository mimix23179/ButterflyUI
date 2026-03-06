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
