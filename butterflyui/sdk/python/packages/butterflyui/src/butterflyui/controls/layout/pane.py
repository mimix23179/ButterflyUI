from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Pane"]

@butterfly_control('pane', field_aliases={'content': 'child'})
class Pane(LayoutControl):
    """
    Named pane for use inside a slot-based layout such as ``DockLayout``.

    Declares a slot-addressed pane. The ``slot`` string tells the parent
    layout where to place this pane (e.g. ``"top"``, ``"left"``,
    ``"fill"``). ``title`` labels the pane in containers that show titles.
    ``size``, ``width``, and ``height`` hint at the preferred dimensions.

    Example:

    ```python
    import butterflyui as bui

    bui.Pane(
        bui.Text("Sidebar"),
        slot="left",
        size=240,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    slot: str | None = None
    """
    Slot identifier that controls placement within the parent layout.
    """

    title: str | None = None
    """
    Optional display title for the pane.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `pane` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `pane` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `pane` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `pane` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `pane` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `pane` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `pane` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `pane` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `pane` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `pane` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `pane` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `pane` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `pane` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `pane` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `pane` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `pane` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `pane` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `pane` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `pane` runtime control.
    """
