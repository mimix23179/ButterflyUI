from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ProgressRing"]

@butterfly_control('progress_ring')
class ProgressRing(LayoutControl):
    """
    Circular progress indicator for determinate or indeterminate tasks.

    ``ProgressRing`` sends the canonical ``progress_ring`` control type and pins
    ``variant="circular"`` / ``circular=True`` so the Flutter side always
    renders a ring. Use ``value`` for determinate progress, or set
    ``indeterminate=True`` for an animated spinner-style state.

    ```python
    import butterflyui as bui

    ring = bui.ProgressRing(value=0.72, label="Syncing", stroke_width=6)
    ```
    """

    value: float | None = None
    """
    Progress value for determinate mode.
    """

    indeterminate: bool | None = None
    """
    If ``True``, renders an animated indeterminate ring.
    """

    label: str | None = None
    """
    Optional text label shown with the indicator.
    """

    stroke_width: float | None = None
    """
    Thickness of the rendered stroke in logical pixels.
    """

    circular: bool | None = None
    """
    Circular value forwarded to the `progress_ring` runtime control.
    """

    def set_value(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
