from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

__all__ = ["ListView"]

@butterfly_control('list_view', field_aliases={'controls': 'children'})
class ListView(ScrollableControl):
    """
    Vertical scrollable list container for child controls or data-item
    payloads with optional separator dividers.

    When explicit ``children`` are passed they are rendered directly as
    list rows.  Alternatively an ``items`` payload list lets the runtime
    build rows from data.  Setting ``separator`` to ``True`` inserts
    ``Divider`` widgets between rows.

    ```python
    import butterflyui as bui

    bui.ListView(
        bui.ListTile(title="Item 1"),
        bui.ListTile(title="Item 2"),
        bui.ListTile(title="Item 3"),
        separator=True,
    )
    ```

    Args:
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    items: list[Any] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    separator: bool | None = None
    """
    If ``True``, a ``Divider`` is inserted between each row.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `list_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `list_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `list_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `list_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `list_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `list_view` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `list_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `list_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `list_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `list_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `list_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `list_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `list_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `list_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `list_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `list_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `list_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `list_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `list_view` runtime control.
    """
