from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Wrap"]

@butterfly_control('wrap', field_aliases={'controls': 'children'})
class Wrap(LayoutControl):
    """
    Flow layout that wraps children onto additional lines when space runs out.

    The runtime wraps Flutter's ``Wrap`` widget. ``spacing`` adds inline gaps
    between children; ``run_spacing`` adds gaps between lines (or columns
    when ``direction`` is ``"vertical"``). ``alignment`` controls positioning
    within each run; ``run_alignment`` places the runs along the cross axis.
    ``cross_axis`` sets alignment of children within a single run.
    ``direction`` switches the main axis to horizontal (default) or vertical.

    Example:

    ```python
    import butterflyui as bui

    bui.Wrap(
        *[bui.Chip(label=f"Tag {i}") for i in range(10)],
        spacing=8,
        run_spacing=8,
        alignment="start",
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    spacing: float | None = None
    """
    Gap between consecutive children along the main axis.
    """

    run_spacing: float | None = None
    """
    Gap between consecutive runs along the cross axis.
    """

    run_alignment: str | None = None
    """
    Alignment of runs along the cross axis.
    """

    cross_axis: str | None = None
    """
    Alignment of children within a run along the cross axis.
    """

    direction: str | None = None
    """
    Main-axis direction. Values: ``"horizontal"`` (default),
    ``"vertical"``.
    """

    cross_alignment: Any | None = None
    """
    Cross alignment value forwarded to the `wrap` runtime control.
    """

    vertical_direction: Any | None = None
    """
    Vertical direction value forwarded to the `wrap` runtime control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `wrap` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `wrap` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `wrap` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `wrap` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `wrap` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `wrap` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `wrap` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `wrap` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `wrap` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `wrap` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `wrap` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `wrap` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `wrap` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `wrap` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `wrap` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `wrap` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `wrap` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `wrap` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `wrap` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `wrap` runtime control.
    """
