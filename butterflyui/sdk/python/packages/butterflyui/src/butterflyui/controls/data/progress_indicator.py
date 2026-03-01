from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ProgressIndicator"]

class ProgressIndicator(Component):
    """
    Determinate or indeterminate progress indicator supporting linear
    and circular presentation variants.

    The runtime renders either a Flutter ``LinearProgressIndicator`` or
    ``CircularProgressIndicator`` depending on ``variant`` or the
    ``circular`` shortcut flag.  When ``indeterminate`` is ``True`` the
    indicator plays a continuous looping animation; otherwise the
    ``value`` (``0.0`` – ``1.0``) controls the fill.  An optional
    ``label`` is rendered next to the indicator and ``stroke_width``
    overrides the default arc/bar thickness.

    ```python
    import butterflyui as bui

    bui.ProgressIndicator(
        value=0.45,
        variant="linear",
        label="45 %",
        stroke_width=6,
    )
    ```

    Args:
        value: 
            Fractional progress in the range ``0.0`` – ``1.0``.  Ignored when ``indeterminate`` is ``True``.
        indeterminate: 
            If ``True``, the indicator plays a continuous looping animation regardless of ``value``.
        label: 
            Optional text label rendered alongside the indicator.
        variant: 
            Indicator layout variant — ``"linear"`` for a horizontal bar or ``"circular"`` for a spinning arc.
        circular: 
            Shortcut flag: when ``True`` equivalent to ``variant="circular"``.
        stroke_width: 
            Thickness of the progress arc or bar in logical pixels.
    """

    control_type = "progress_indicator"

    def __init__(
        self,
        *,
        value: float | None = None,
        indeterminate: bool | None = None,
        label: str | None = None,
        variant: str | None = None,
        circular: bool | None = None,
        stroke_width: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            indeterminate=indeterminate,
            label=label,
            variant=variant,
            circular=circular,
            stroke_width=stroke_width,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
