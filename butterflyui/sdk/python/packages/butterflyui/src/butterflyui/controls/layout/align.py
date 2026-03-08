from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ..base_control import butterfly_control
from ..layout_control import LayoutControl
from ..single_child_control import SingleChildControl

__all__ = ["Align"]


@butterfly_control('align', field_aliases={'content': 'child'})
class Align(LayoutControl, SingleChildControl):
    """
    Positions its child at a specified alignment within the available space.

    The runtime wraps Flutter's ``Align`` widget. ``alignment`` accepts a
    string such as ``"center"``, ``"top_left"``, or ``"bottom_right"``, or a
    mapping with ``x`` and ``y`` values in the range -1.0 to 1.0. Setting
    ``width_factor`` or ``height_factor`` shrinks the widget to a fraction of
    the child's corresponding dimension.

    Example:

    ```python
    import butterflyui as bui

    bui.Align(
        bui.Text("Hello"),
        alignment="bottom_right",
        events=["layout"],
    )
    ```
    """

    width_factor: float | None = None
    """
    If set, the widget's width is this multiple of the child's width.
    """

    height_factor: float | None = None
    """
    If set, the widget's height is this multiple of the child's height.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def set_alignment(self, session: Any, alignment: Any) -> dict[str, Any]:
        return self.invoke(session, "set_alignment", {"alignment": alignment})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )
