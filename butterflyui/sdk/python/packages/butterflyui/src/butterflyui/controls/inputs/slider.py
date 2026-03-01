from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Slider"]

class Slider(Component):
    """
    Single-handle continuous or discrete value slider.

    Renders a Flutter ``Slider`` widget.  The thumb position maps
    linearly between ``min`` and ``max``.  When ``divisions`` is set
    the range is divided into equal discrete steps and a tick-mark
    is shown at each division.  A ``label`` can be displayed in the
    thumb tooltip while dragging.  Dragging the thumb emits
    ``change`` events with the current numeric value.

    ```python
    import butterflyui as bui

    bui.Slider(value=0.5, min=0.0, max=1.0, divisions=10)
    ```

    Args:
        value:
            Current thumb position.
        min:
            Minimum value of the slider range (defaults to ``0.0``).
        max:
            Maximum value of the slider range (defaults to ``1.0``).
        divisions:
            Number of discrete segments.  When set, the thumb snaps
            to division boundaries.
        label:
            Text shown in the thumb tooltip while dragging (may
            reference the current value via the Flutter format string).
    """
    control_type = "slider"

    def __init__(
        self,
        value: float | None = None,
        *,
        min: float | None = None,
        max: float | None = None,
        divisions: int | None = None,
        label: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            min=min,
            max=max,
            divisions=divisions,
            label=label,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
