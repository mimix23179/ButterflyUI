from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Popover"]

class Popover(Component):
    """
    Anchored floating popover panel positioned relative to a target widget.

    The runtime renders a floating panel tied to an ``anchor`` widget.
    ``content`` is the popover body. ``position`` sets the preferred side
    relative to the anchor (``"top"``, ``"bottom"``, ``"left"``,
    ``"right"``). ``offset`` nudges the popover from the anchor edge.
    ``dismissible`` closes on outside tap. ``transition_type`` and
    ``duration_ms`` configure animation.

    ```python
    import butterflyui as bui

    bui.Popover(
        anchor=bui.Button(label="Help"),
        content=bui.Text("Tooltip-style help text."),
        open=False,
        position="bottom",
    )
    ```

    Args:
        anchor:
            The widget that the popover is visually attached to.
        content:
            The widget rendered inside the popover panel.
        open:
            When ``True`` the popover is visible.
        position:
            Preferred placement relative to the anchor. Values:
            ``"top"``, ``"bottom"``, ``"left"``, ``"right"``.
        offset:
            Additional displacement from the anchor edge in logical pixels.
        dismissible:
            When ``True`` tapping outside the popover closes it.
        transition:
            Explicit transition spec mapping.
        transition_type:
            Named animation type. Values: ``"fade"``, ``"scale"``.
        duration_ms:
            Duration of the show/hide animation in milliseconds.
    """

    control_type = "popover"

    def __init__(
        self,
        anchor: Any | None = None,
        content: Any | None = None,
        *,
        open: bool | None = None,
        position: str | None = None,
        offset: Any | None = None,
        dismissible: bool | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            anchor=anchor,
            content=content,
            open=open,
            position=position,
            offset=offset,
            dismissible=dismissible,
            transition=transition,
            transition_type=transition_type,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
