from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Align"]

class Align(Component):
    """
    Positions its child at a specified alignment within the available space.

    The runtime wraps Flutter's ``Align`` widget. ``alignment`` accepts a
    string such as ``"center"``, ``"top_left"``, or ``"bottom_right"``, or a
    mapping with ``x`` and ``y`` values in the range -1.0 to 1.0. Setting
    ``width_factor`` or ``height_factor`` shrinks the widget to a fraction of
    the child's corresponding dimension.

    ```python
    import butterflyui as bui

    bui.Align(
        bui.Text("Hello"),
        alignment="bottom_right",
        events=["layout"],
    )
    ```

    Args:
        alignment:
            The alignment position. Accepts a named string or an ``{x, y}``
            mapping with values from -1.0 (start) to 1.0 (end).
        width_factor:
            If set, the widget's width is this multiple of the child's width.
        height_factor:
            If set, the widget's height is this multiple of the child's height.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "align"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        alignment: Any | None = None,
        width_factor: float | None = None,
        height_factor: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            alignment=alignment,
            width_factor=width_factor,
            height_factor=height_factor,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_alignment(self, session: Any, alignment: Any) -> dict[str, Any]:
        return self.invoke(session, "set_alignment", {"alignment": alignment})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
