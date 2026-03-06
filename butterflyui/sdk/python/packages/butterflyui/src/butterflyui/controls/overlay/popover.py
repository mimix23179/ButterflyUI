from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

from ..single_child_control import SingleChildControl
__all__ = ["Popover"]

@butterfly_control('popover', positional_fields=('anchor', 'content',))
class Popover(OverlayControl, SingleChildControl):
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
