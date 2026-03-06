from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Column"]

@butterfly_control('column', field_aliases={'controls': 'children', 'gap': 'spacing'})
class Column(LayoutControl):
    """
    Vertical flex container that arranges children in a column.

    The runtime renders a Flutter ``Column`` widget.  Children are laid
    out vertically with configurable ``spacing`` (alias ``gap``) between
    them.  ``main_axis`` controls vertical alignment (start, center, end,
    space_between, etc.) and ``cross_axis`` controls horizontal alignment
    (start, center, end, stretch).  Child controls may use ``expanded``
    or set ``flex`` in their props to fill available space.

    Example:

    ```python
    import butterflyui as bui

    bui.Column(
        bui.Text("First item"),
        bui.Text("Second item"),
        bui.Text("Third item"),
        spacing=12,
        main_axis="center",
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    spacing: float | None = None
    """
    Vertical gap between children in logical pixels.  Aliased as ``gap``.
    """

    main_axis: str | None = None
    """
    Main-axis alignment for the column.  Values: ``start``, ``center``,
    ``end``, ``space_between``, ``space_around``, ``space_evenly``.
    """

    cross_axis: str | None = None
    """
    Cross-axis alignment for children.  Values: ``start``, ``center``,
    ``end``, ``stretch``, ``baseline``.
    """

    horizontal_alignment: Any | None = None
    """
    Horizontal alignment value forwarded to the `column` runtime control.
    """

    vertical_alignment: Any | None = None
    """
    Vertical alignment value forwarded to the `column` runtime control.
    """

    run_alignment: Any | None = None
    """
    Run alignment value forwarded to the `column` runtime control.
    """

    reverse: Any | None = None
    """
    Reverse value forwarded to the `column` runtime control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `column` runtime control.
    """

    gap: Any | None = None
    """
    Gap value forwarded to the `column` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `column` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `column` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `column` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `column` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `column` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `column` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `column` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `column` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `column` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `column` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `column` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `column` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `column` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `column` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `column` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `column` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `column` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `column` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `column` runtime control.
    """
