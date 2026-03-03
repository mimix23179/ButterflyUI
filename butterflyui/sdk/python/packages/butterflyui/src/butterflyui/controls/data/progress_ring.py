from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import merge_props
from .progress_indicator import ProgressIndicator

__all__ = ["ProgressRing"]


class ProgressRing(ProgressIndicator):
    """
    Circular progress indicator with optional label and determinate/indeterminate modes.

    ``ProgressRing`` is the ring-style variant of ``ProgressIndicator`` and
    always serializes as ``control_type="progress_ring"`` while forcing
    ``variant="circular"`` and ``circular=True``.

    The inherited invoke API remains available (for example ``set_value`` and
    ``get_state``).

    ```python
    import butterflyui as bui

    bui.ProgressRing(
        value=0.78,
        label="Rendering preview",
        stroke_width=5,
    )
    ```

    Args:
        value:
            Progress value in the ``0.0`` â€“ ``1.0`` range (runtime also accepts percentage-like values).
        indeterminate:
            When ``True``, renders a continuously spinning ring.
        label:
            Optional text rendered with the indicator.
        stroke_width:
            Stroke thickness of the ring in logical pixels.
    """

    control_type = "progress_ring"

    def __init__(
        self,
        *,
        value: float | None = None,
        indeterminate: bool | None = None,
        label: str | None = None,
        stroke_width: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            indeterminate=indeterminate,
            label=label,
            variant="circular",
            circular=True,
            stroke_width=stroke_width,
            props=merge_props(props),
            style=style,
            strict=strict,
            **kwargs,
        )
