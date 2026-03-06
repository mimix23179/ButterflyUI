from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .split_view import SplitView
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..multi_child_control import MultiChildControl
__all__ = ["SplitPane"]

@butterfly_control('split_pane', field_aliases={'controls': 'children'})
class SplitPane(LayoutControl, MultiChildControl):
    """
    Draggable two-panel split with bounded resize constraints.

    Extends ``SplitView`` by adding ``min_ratio`` and ``max_ratio`` to
    constrain where the divider can be dragged. Prefer ``SplitPane`` over
    ``SplitView`` when the split position must stay within bounds during
    user interaction.

    Example:

    ```python
    import butterflyui as bui

    bui.SplitPane(
        bui.Text("Left panel"),
        bui.Text("Right panel"),
        axis="horizontal",
        ratio=0.3,
        min_ratio=0.2,
        max_ratio=0.6,
        events=["resize"],
    )
    ```
    """

    axis: str | None = None
    """
    Split direction. Values: ``"horizontal"``, ``"vertical"``.
    """

    ratio: float | None = None
    """
    Initial fractional position of the divider (0.0-1.0).
    """

    min_ratio: float | None = None
    """
    Minimum allowed divider ratio during drag.
    """

    max_ratio: float | None = None
    """
    Maximum allowed divider ratio during drag.
    """

    draggable: bool | None = None
    """
    When ``True`` the user can drag the divider to resize panels.
    """

    divider_size: float | None = None
    """
    Width or height of the divider affordance in logical pixels.
    """

    use_split_view: Any | None = None
    """
    Use split view value forwarded to the `split_pane` runtime control.
    """

    def set_ratio(self, session: Any, ratio: float) -> dict[str, Any]:
        return self.invoke(session, "set_ratio", {"ratio": float(ratio)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
