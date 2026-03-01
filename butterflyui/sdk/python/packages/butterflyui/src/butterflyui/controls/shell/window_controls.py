from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["WindowControls"]

class WindowControls(Component):
    """
    Custom window control buttons (minimize, maximize, close) for desktop apps.

    The runtime renders a row of window-chrome buttons styled to match the
    app theme. ``show_minimize``, ``show_maximize``, and ``show_close``
    toggle individual buttons. ``spacing`` sets the gap between buttons.
    ``button_width``/``button_height`` fix button dimensions. ``radius``
    sets the corner radius of each button.

    ```python
    import butterflyui as bui

    bui.WindowControls(
        show_minimize=True,
        show_maximize=True,
        show_close=True,
        spacing=8,
    )
    ```

    Args:
        show_minimize:
            When ``True`` the minimize button is rendered.
        show_maximize:
            When ``True`` the maximize/restore button is rendered.
        show_close:
            When ``True`` the close button is rendered.
        spacing:
            Gap in logical pixels between adjacent control buttons.
        button_width:
            Fixed width in logical pixels for each control button.
        button_height:
            Fixed height in logical pixels for each control button.
        radius:
            Corner radius applied to each control button surface.
    """

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
