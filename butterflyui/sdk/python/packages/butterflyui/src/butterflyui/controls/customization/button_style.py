from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ButtonStyle"]

@butterfly_control('button_style', positional_fields=('value',))
class ButtonStyle(LayoutControl):
    """
    Style-preset picker rendered as a row of ``ChoiceChip`` widgets.

    The default presets are ``"solid"``, ``"outline"``, and ``"ghost"``.
    Selecting a chip emits a ``"change"`` event with the chosen preset's
    ``id``. The control also supports per-state style overrides (base,
    hover, pressed) and a full action/event dispatch system.

    ```python
    import butterflyui as bui

    bui.ButtonStyle(
        value="solid",
        options=[
            {"id": "solid", "label": "Solid"},
            {"id": "outline", "label": "Outline"},
            {"id": "ghost", "label": "Ghost"},
        ],
    )
    ```
    """

    value: str | None = None
    """
    Currently selected style preset ``id``.
    """

    options: list[Any] | None = None
    """
    Ordered list of option descriptors rendered by the control. Each item can be a primitive shortcut or a mapping with the keys the Flutter side expects for this control.
    """

    items: list[Any] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    base: Mapping[str, Any] | None = None
    """
    Base style map applied in the idle state before any interactive or disabled overrides are merged.
    """

    hover: Mapping[str, Any] | None = None
    """
    State-specific style map applied while the pointer hovers the control. Use it to override hover-time visual properties such as background, border, elevation, or text color.
    """

    pressed: Mapping[str, Any] | None = None
    """
    State-specific style map applied while the control is actively pressed. Use it for press-time feedback such as scale, elevation, tint, or shadow changes.
    """

    focus_ring: Mapping[str, Any] | None = None
    """
    Focus-ring configuration applied when the control receives keyboard or accessibility focus. Typical values control ring color, width, inset, or animation depending on the renderer.
    """

    motion_behavior: Mapping[str, Any] | None = None
    """
    Motion configuration used when transitioning between interaction states. Use it to tune duration, easing, and animation behavior for hover, press, focus, or selection changes.
    """

    action: Any | None = None
    """
    Action identifier dispatched when the selected preset changes.
    """

    actions: list[Any] | None = None
    """
    Ordered list of action descriptors executed or rendered by this control. Each item should match the action shape expected by the runtime for this control type.
    """

    action_id: str | None = None
    """
    Specific action id to emit on change.
    """

    action_event: str | None = None
    """
    Event name used when dispatching the action.
    """

    action_payload: Mapping[str, Any] | None = None
    """
    Additional payload merged into the action dispatch.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `button_style` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `button_style` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `button_style` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `button_style` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `button_style` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `button_style` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `button_style` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `button_style` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `button_style` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `button_style` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `button_style` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `button_style` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `button_style` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `button_style` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `button_style` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `button_style` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `button_style` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `button_style` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `button_style` runtime control.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def set_state_style(self, session: Any, state: str, style_props: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_state_style", {"state": state, "style": dict(style_props)})
