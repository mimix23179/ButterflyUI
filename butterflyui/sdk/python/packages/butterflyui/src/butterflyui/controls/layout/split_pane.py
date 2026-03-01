from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .split_view import SplitView

__all__ = ["SplitPane"]

class SplitPane(SplitView):
    """
    Draggable two-panel split with bounded resize constraints.

    Extends ``SplitView`` by adding ``min_ratio`` and ``max_ratio`` to
    constrain where the divider can be dragged. Prefer ``SplitPane`` over
    ``SplitView`` when the split position must stay within bounds during
    user interaction.

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

    Args:
        axis:
            Split direction. Values: ``"horizontal"``, ``"vertical"``.
        ratio:
            Initial fractional position of the divider (0.0-1.0).
        min_ratio:
            Minimum allowed divider ratio during drag.
        max_ratio:
            Maximum allowed divider ratio during drag.
        draggable:
            When ``True`` the user can drag the divider to resize panels.
        divider_size:
            Width or height of the divider affordance in logical pixels.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "split_pane"

    def __init__(
        self,
        *children: Any,
        axis: str | None = None,
        ratio: float | None = None,
        min_ratio: float | None = None,
        max_ratio: float | None = None,
        draggable: bool | None = None,
        divider_size: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            axis=axis,
            ratio=ratio,
            min_ratio=min_ratio,
            max_ratio=max_ratio,
            draggable=draggable,
            divider_size=divider_size,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_ratio(self, session: Any, ratio: float) -> dict[str, Any]:
        return self.invoke(session, "set_ratio", {"ratio": float(ratio)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
