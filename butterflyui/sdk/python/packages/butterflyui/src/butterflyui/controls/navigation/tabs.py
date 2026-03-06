from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Tabs"]

@butterfly_control('tabs', field_aliases={'controls': 'children'})
class Tabs(LayoutControl):
    """
    Horizontal tab bar for switching between views.

    The runtime renders a Flutter tab bar. ``labels`` supplies the tab
    label strings. ``index`` sets the active tab (0-based). ``scrollable``
    allows the tab bar to scroll horizontally when there are more tabs than
    fit in the available width. Positional children can inject custom tab
    content.

    Example:

    ```python
    import butterflyui as bui

    bui.Tabs(
        bui.Text("Content A"),
        bui.Text("Content B"),
        labels=["Tab A", "Tab B"],
        index=0,
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    scrollable: bool | None = None
    """
    When ``True`` the tab bar scrolls horizontally on overflow.
    """

    labels: list[str] | None = None
    """
    Ordered list of label strings rendered by the control.
    """

    index: int | None = None
    """
    Zero-based index of the currently selected tab.
    """

    closable: Any | None = None
    """
    Closable value forwarded to the `tabs` runtime control.
    """

    show_add: Any | None = None
    """
    Show add value forwarded to the `tabs` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `tabs` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `tabs` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `tabs` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `tabs` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `tabs` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `tabs` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `tabs` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `tabs` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `tabs` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `tabs` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `tabs` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `tabs` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `tabs` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `tabs` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `tabs` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `tabs` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `tabs` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `tabs` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `tabs` runtime control.
    """
