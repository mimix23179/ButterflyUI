from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ProgressBar"]

@butterfly_control('progress_bar')
class ProgressBar(LayoutControl):
    """
    Linear progress indicator for determinate or indeterminate tasks.

    ``ProgressBar`` sends the canonical ``progress_bar`` control type and pins
    ``variant="linear"`` / ``circular=False`` so the Flutter side always builds
    a horizontal bar. Use ``value`` for determinate progress (typically ``0`` to
    ``1``), or set ``indeterminate=True`` to show an animated loading state.

    ```python
    import butterflyui as bui

    bar = bui.ProgressBar(value=0.35, label="Uploading", stroke_width=8)
    ```
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

    circular: bool | None = None
    """
    Circular value forwarded to the `progress_bar` runtime control.
    """

    def set_value(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
