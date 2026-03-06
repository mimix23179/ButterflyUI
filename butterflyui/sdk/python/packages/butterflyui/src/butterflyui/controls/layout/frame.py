from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["Frame"]

@butterfly_control('frame', field_aliases={'content': 'child'})
class Frame(LayoutControl, SingleChildControl):
    """
    Sized and decorated frame with constraints, spacing, and visual styling.

    The runtime renders a container that applies combined width/height
    constraints (including min/max bounds), padding/margin spacing, background
    color, border, corner radius, and clip behaviour. ``alignment`` positions
    the child within the frame.

    ``Frame`` forwards additional style pipeline props through ``**kwargs``,
    including classes/modifiers/motion/effects plus optional ``icon``,
    ``color``, and ``transparency`` hints.

    Example:

    ```python
    import butterflyui as bui

    bui.Frame(
        bui.Text("Content"),
        width=400,
        min_height=100,
        padding=16,
        bgcolor="#FAFAFA",
        radius=8,
        events=["resize"],
    )
    ```
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
