from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["Container"]

@butterfly_control('container', field_aliases={'content': 'child'})
class Container(LayoutControl, SingleChildControl):
    """
    Decorated layout container combining sizing, spacing, and visual decoration.

    Maps to Flutter's ``Container`` widget. Combines ``width``/``height``
    constraints, ``padding`` and ``margin`` spacing, background and border
    decoration (``bgcolor``, ``border_color``, ``border_width``, ``radius``),
    and child ``alignment`` in one component.

    Additional visual props such as motion, effects, color, and transparency
    can still be passed through ``**kwargs`` when the runtime supports them.

    Example:

    ```python
    import butterflyui as bui

    bui.Container(
        bui.Text("Hello"),
        width=300,
        padding=16,
        bgcolor="#FFFFFF",
        radius=8,
        events=["tap"],
    )
    ```
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
