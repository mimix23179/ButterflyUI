from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Expanded"]

@butterfly_control('expanded', field_aliases={'content': 'child'})
class Expanded(LayoutControl):
    """
    Expands a child to fill remaining space inside a ``Row``, ``Column``, or ``Flex``.

    The runtime wraps Flutter's ``Expanded`` widget. ``flex`` determines the
    proportion of available space allocated to this child relative to sibling
    flex children. ``fit`` controls how the child is sized into the allocated
    space: ``"tight"`` forces the child to fill, ``"loose"`` allows it to be
    smaller.

    Example:

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Fixed"),
        bui.Expanded(bui.Text("Fill remaining"), flex=1),
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    fit: str | None = None
    """
    How the child fills the allocated space. Values: ``"tight"``
    (fill exactly), ``"loose"`` (at most the allocated size).
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `expanded` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `expanded` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `expanded` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `expanded` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `expanded` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `expanded` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `expanded` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `expanded` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `expanded` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `expanded` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `expanded` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `expanded` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `expanded` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `expanded` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `expanded` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `expanded` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `expanded` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `expanded` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `expanded` runtime control.
    """
