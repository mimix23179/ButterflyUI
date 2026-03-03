from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import merge_props
from .progress_indicator import ProgressIndicator

__all__ = ["ProgressBar"]


class ProgressBar(ProgressIndicator):
    """
    Linear progress indicator with optional label and determinate/indeterminate modes.

    ``ProgressBar`` is a dedicated wrapper around ``ProgressIndicator`` that
    always renders as the linear bar variant (``variant="linear"`` and
    ``circular=False``).  Use determinate mode by passing ``value`` or switch
    to indeterminate mode by setting ``indeterminate=True``.

    The runtime also supports the inherited invoke API from
    ``ProgressIndicator`` (for example ``set_value`` and ``get_state``).

    ```python
    import butterflyui as bui

    bui.ProgressBar(
        value=0.42,
        label="Uploading 42%",
        stroke_width=6,
    )
    ```

    Args:
        value:
            Progress value in the ``0.0`` â€“ ``1.0`` range (runtime also accepts percentage-like values).
        indeterminate:
            When ``True``, the bar animates continuously and ignores ``value``.
        label:
            Optional text rendered with the indicator.
        stroke_width:
            Thickness of the progress bar in logical pixels.
    """

    control_type = "progress_bar"

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
            variant="linear",
            circular=False,
            stroke_width=stroke_width,
            props=merge_props(props),
            style=style,
            strict=strict,
            **kwargs,
        )
