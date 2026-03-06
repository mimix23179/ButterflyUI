from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Row"]

@butterfly_control('row', field_aliases={'controls': 'children', 'gap': 'spacing'})
class Row(LayoutControl):
    """
    Horizontal flex container that arranges children in a row.

    The runtime renders a Flutter ``Row`` widget.  Children are laid
    out horizontally with configurable ``spacing`` (alias ``gap``) between
    them.  ``main_axis`` controls horizontal alignment (start, center, end,
    space_between, etc.) and ``cross_axis`` controls vertical alignment
    (start, center, end, stretch).  Child controls may use ``expanded``
    or set ``flex`` in their props to fill available space.

    Example:

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.Text("Center"),
        bui.Text("Right"),
        spacing=16,
        main_axis="space_between",
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    spacing: float | None = None
    """
    Horizontal gap between children in logical pixels.  Aliased as ``gap``.
    """

    main_axis: str | None = None
    """
    Main-axis alignment for the row.  Values: ``start``, ``center``,
    ``end``, ``space_between``, ``space_around``, ``space_evenly``.
    """

    cross_axis: str | None = None
    """
    Cross-axis alignment for children.  Values: ``start``, ``center``,
    ``end``, ``stretch``, ``baseline``.
    """

    horizontal_alignment: Any | None = None
    """
    Horizontal alignment value forwarded to the `row` runtime control.
    """

    vertical_alignment: Any | None = None
    """
    Vertical alignment value forwarded to the `row` runtime control.
    """

    run_alignment: Any | None = None
    """
    Run alignment value forwarded to the `row` runtime control.
    """

    wrap: Any | None = None
    """
    Wrap value forwarded to the `row` runtime control.
    """

    reverse: Any | None = None
    """
    Reverse value forwarded to the `row` runtime control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `row` runtime control.
    """

    gap: Any | None = None
    """
    Gap value forwarded to the `row` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `row` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `row` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `row` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `row` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `row` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `row` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `row` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `row` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `row` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `row` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `row` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `row` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `row` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `row` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `row` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `row` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `row` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `row` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `row` runtime control.
    """
