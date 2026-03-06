from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Text"]

@butterfly_control('text', field_aliases={'value': 'text'}, positional_fields=('value',))
class Text(LayoutControl):
    """
    Simple text label.

    Renders a Flutter ``Text`` widget from the ``value`` or ``text``
    parameter.  The value is coerced to a string.  Additional
    typographic options (font size, weight, colour, etc.) can be
    passed through ``props`` or ``**kwargs``.

    Example:

    ```python
    import butterflyui as bui

    label = bui.Text("Hello, world!")
    ```
    """

    value: Any = ""
    """
    Text content to display (coerced to ``str``).
    """

    text: str | None = None
    """
    Alias for ``value`` — takes precedence when both are supplied.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `text` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `text` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `text` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `text` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `text` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `text` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `text` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `text` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `text` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `text` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `text` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `text` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `text` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `text` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `text` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `text` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `text` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `text` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `text` runtime control.
    """
