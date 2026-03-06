from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Container"]

@butterfly_control('container', field_aliases={'content': 'child'})
class Container(LayoutControl):
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

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control's content area.
    """

    border_color: Any | None = None
    """
    Border color applied to the outer edge of the rendered control or decorative surface.
    """

    border_width: float | None = None
    """
    Border stroke width in logical pixels.
    """

    radius: float | None = None
    """
    Corner radius in logical pixels.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `container` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `container` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `container` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `container` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `container` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `container` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `container` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `container` runtime control.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `container` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `container` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `container` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `container` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `container` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `container` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `container` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `container` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `container` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `container` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `container` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
