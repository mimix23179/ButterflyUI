from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Image"]

@butterfly_control('image', positional_fields=('src',))
class Image(LayoutControl):
    """
    Network or asset image display.

    Renders a Flutter ``Image`` widget from the URL or asset path
    given in ``src``.  Additional sizing, fit, and alignment options
    can be passed through ``props`` or ``**kwargs``.

    Example:

    ```python
    import butterflyui as bui

    img = bui.Image(src="https://example.com/photo.jpg")
    ```
    """

    src: str | None = None
    """
    Source URI, file path, or asset reference rendered by the control.
    """

    fit: Any | None = None
    """
    Fit value forwarded to the `image` runtime control.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    cache: Any | None = None
    """
    Cache value forwarded to the `image` runtime control.
    """

    placeholder: Any | None = None
    """
    Hint text shown when the control has no value.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `image` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `image` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `image` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `image` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `image` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `image` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `image` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `image` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `image` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `image` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `image` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `image` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `image` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `image` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `image` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `image` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `image` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `image` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `image` runtime control.
    """
