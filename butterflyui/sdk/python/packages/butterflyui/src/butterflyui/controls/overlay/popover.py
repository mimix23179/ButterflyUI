from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

__all__ = ["Popover"]

@butterfly_control('popover', positional_fields=('anchor', 'content',))
class Popover(OverlayControl):
    """
    Anchored floating popover panel positioned relative to a target widget.

    The runtime renders a floating panel tied to an ``anchor`` widget.
    ``content`` is the popover body. ``position`` sets the preferred side
    relative to the anchor (``"top"``, ``"bottom"``, ``"left"``,
    ``"right"``). ``offset`` nudges the popover from the anchor edge.
    ``dismissible`` closes on outside tap. ``transition_type`` and
    ``duration_ms`` configure animation.

    Example:

    ```python
    import butterflyui as bui

    bui.Popover(
        anchor=bui.Button(label="Help"),
        content=bui.Text("Tooltip-style help text."),
        open=False,
        position="bottom",
    )
    ```
    """

    content: Any | None = None
    """
    The widget rendered inside the popover panel.
    """

    position: str | None = None
    """
    Preferred placement relative to the anchor. Values:
    ``"top"``, ``"bottom"``, ``"left"``, ``"right"``.
    """

    transition: Mapping[str, Any] | None = None
    """
    Explicit transition spec mapping.
    """

    transition_type: str | None = None
    """
    Named animation type. Values: ``"fade"``, ``"scale"``.
    """

    duration_ms: int | None = None
    """
    Duration of the show/hide animation in milliseconds.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `popover` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `popover` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `popover` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `popover` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `popover` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `popover` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `popover` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `popover` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `popover` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `popover` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `popover` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `popover` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `popover` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `popover` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `popover` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `popover` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `popover` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `popover` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `popover` runtime control.
    """
