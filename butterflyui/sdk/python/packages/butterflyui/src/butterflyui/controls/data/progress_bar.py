from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ProgressBar"]


class ProgressBar(Component):
    """Linear progress indicator for determinate or indeterminate tasks.
    
    ``ProgressBar`` sends the canonical ``progress_bar`` control type and pins
    ``variant="linear"`` / ``circular=False`` so the Flutter side always builds
    a horizontal bar. Use ``value`` for determinate progress (typically ``0`` to
    ``1``), or set ``indeterminate=True`` to show an animated loading state.
    
    ```python
    import butterflyui as bui
    
    bar = bui.ProgressBar(value=0.35, label="Uploading", stroke_width=8)
    ```
    
    Args:
        value:
            Progress value for determinate mode.
        indeterminate:
            If ``True``, renders an animated indeterminate bar.
        label:
            Optional text label shown with the indicator.
        stroke_width:
            Thickness of the progress track/indicator.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
    """


    value: float | None = None
    """
    Progress value for determinate mode.
    """

    indeterminate: bool | None = None
    """
    If ``True``, renders an animated indeterminate bar.
    """

    label: str | None = None
    """
    Optional text label shown with the indicator.
    """

    stroke_width: float | None = None
    """
    Thickness of the progress track/indicator.
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
        merged = merge_props(
                        props,
                        value=value,
                        indeterminate=indeterminate,
                        label=label,
                        stroke_width=stroke_width,
                        variant="linear",
                        circular=False,
                        **kwargs,
                    )
        super().__init__(
            props=merged,
            style=style,
            strict=strict,
        )

    def set_value(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
