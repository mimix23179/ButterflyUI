from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["FlexSpacer"]

@butterfly_control('flex_spacer')
class FlexSpacer(LayoutControl):
    """
    Invisible spacer that consumes flex space inside a ``Row`` or ``Column``.

    The runtime maps to Flutter's ``Spacer`` (a zero-sized ``Expanded``).
    ``flex`` is the flex factor; larger values claim more of the available
    space relative to sibling flex children.

    Example:

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.FlexSpacer(flex=1),
        bui.Text("Right"),
    )
    ```
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `flex_spacer` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `flex_spacer` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `flex_spacer` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `flex_spacer` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `flex_spacer` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `flex_spacer` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `flex_spacer` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `flex_spacer` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `flex_spacer` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `flex_spacer` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `flex_spacer` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `flex_spacer` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `flex_spacer` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `flex_spacer` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `flex_spacer` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `flex_spacer` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `flex_spacer` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `flex_spacer` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `flex_spacer` runtime control.
    """
