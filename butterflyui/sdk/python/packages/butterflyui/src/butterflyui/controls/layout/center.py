from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .align import Align
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Center"]

@butterfly_control('center', field_aliases={'content': 'child'})
class Center(LayoutControl):
    """
    Centers its child within the available space.

    A convenience specialization of ``Align`` that defaults ``alignment`` to
    ``"center"``. Inherits the ``width_factor`` and ``height_factor``
    shrink-wrap behaviour from ``Align``.

    Example:

    ```python
    import butterflyui as bui

    bui.Center(
        bui.Text("Centered"),
        events=["layout"],
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    width_factor: float | None = None
    """
    If set, the widget's width is this multiple of the child's width.
    """

    height_factor: float | None = None
    """
    If set, the widget's height is this multiple of the child's height.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `center` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `center` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `center` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `center` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `center` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `center` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `center` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `center` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `center` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `center` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `center` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `center` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `center` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `center` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `center` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `center` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `center` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `center` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `center` runtime control.
    """
