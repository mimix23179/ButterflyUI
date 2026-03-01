from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GradientEditor"]

class GradientEditor(Component):
    """
    Interactive gradient editor with an angle slider and colour-stop
    controls.

    The runtime renders a ``Slider`` for the angle (``0``–``360``°) and a
    ``Wrap`` of circular colour-stop chips. Each stop has a position and
    colour. An add button appends stops; individual stops can be removed.
    Emits ``"angle_change"`` and ``"stops_change"`` events.

    ```python
    import butterflyui as bui

    bui.GradientEditor(
        stops=[
            {"position": 0.0, "color": "#7c3aed"},
            {"position": 1.0, "color": "#06b6d4"},
        ],
        angle=135,
    )
    ```

    Args:
        stops: 
            List of colour-stop dicts, each with ``"position"`` (``0.0``–``1.0``) and ``"color"`` (hex string).
        angle: 
            Initial gradient angle in degrees (``0``–``360``). Defaults to ``0``.
        show_angle: 
            If ``True`` (default), the angle slider is visible.
        show_add: 
            If ``True`` (default), the "add stop" button is visible.
        show_remove: 
            If ``True`` (default), each stop shows a remove affordance.
        live_preview: 
            If ``True``, a live gradient preview is rendered alongside the controls.
        export_format: 
            Hint for the desired export format of gradient data (e.g. ``"css"``, ``"json"``).
    """
    control_type = "gradient_editor"

    def __init__(
        self,
        *children: Any,
        stops: list[Any] | None = None,
        angle: float | None = None,
        show_angle: bool | None = None,
        show_add: bool | None = None,
        show_remove: bool | None = None,
        live_preview: bool | None = None,
        export_format: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            stops=stops,
            angle=angle,
            show_angle=show_angle,
            show_add=show_add,
            show_remove=show_remove,
            live_preview=live_preview,
            export_format=export_format,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_stops(self, session: Any, stops: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_stops", {"stops": stops})

    def set_angle(self, session: Any, angle: float) -> dict[str, Any]:
        return self.invoke(session, "set_angle", {"angle": float(angle)})

    def add_stop(self, session: Any, position: float, color: Any) -> dict[str, Any]:
        return self.invoke(session, "add_stop", {"position": float(position), "color": color})

    def remove_stop(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "remove_stop", {"index": int(index)})
