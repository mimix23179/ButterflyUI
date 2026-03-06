from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Container"]

class Container(Component):
    """
    Decorated layout container combining sizing, spacing, and visual decoration.

    Maps to Flutter's ``Container`` widget. Combines ``width``/``height``
    constraints, ``padding`` and ``margin`` spacing, background and border
    decoration (``bgcolor``, ``border_color``, ``border_width``, ``radius``),
    and child ``alignment`` in one component.

    ``Container`` also supports the universal ButterflyUI styling pipeline via
    forwarded ``**kwargs``:
    - style layer: ``variant``, ``tone``, ``size``, ``density``, ``classes``,
      ``style``, ``style_slots``.
    - modifier layer: ``modifiers``, ``on_hover_modifiers``,
      ``on_pressed_modifiers``, ``on_focus_modifiers``.
    - motion layer: ``motion``, ``enter_motion``, ``exit_motion``,
      ``hover_motion``, ``press_motion``.
    - effects layer: ``effects``, ``effect_order``, ``effect_clip``,
      ``effect_target``.
    - visual tokens: ``icon``, ``color``, and ``transparency``.

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

    Args:
        width:
            Fixed width in logical pixels.
        height:
            Fixed height in logical pixels.
        padding:
            Inner spacing between the container edge and its children.
        margin:
            Outer spacing around the container.
        alignment:
            How children are aligned within the container.
        bgcolor:
            Background fill color.
        border_color:
            Border stroke color.
        border_width:
            Border stroke width in logical pixels.
        radius:
            Corner radius in logical pixels.
        events:
            List of event names the Flutter runtime should emit to Python.
        **kwargs:
            Additional runtime props, including universal style/modifier/motion/
            effects props handled by the shared renderer, plus optional
            ``icon``, ``color``, and ``transparency`` hints.
    """


    bgcolor: Any | None = None
    """
    Background fill color.
    """

    border_color: Any | None = None
    """
    Border stroke color.
    """

    border_width: float | None = None
    """
    Border stroke width in logical pixels.
    """

    radius: float | None = None
    """
    Corner radius in logical pixels.
    """

    events: list[str] | None = None
    """
    List of event names the Flutter runtime should emit to Python.
    """

    control_type = "container"

    def __init__(
        self,
        *children: Any,
        width: Any | None = None,
        height: Any | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        alignment: Any | None = None,
        bgcolor: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            width=width,
            height=height,
            padding=padding,
            margin=margin,
            alignment=alignment,
            bgcolor=bgcolor,
            border_color=border_color,
            border_width=border_width,
            radius=radius,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
