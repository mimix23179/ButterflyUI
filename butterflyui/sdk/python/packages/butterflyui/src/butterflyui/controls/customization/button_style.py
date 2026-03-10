from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ButtonStyle"]

@butterfly_control('button_style', positional_fields=('value',))
class ButtonStyle(LayoutControl):
    """
    Thin Styling helper for previewing and selecting button-surface
    variants.

    The runtime keeps the option-picker behavior, but the preview
    surfaces are now resolved through ButterflyUI's Styling engine so
    local ``style`` maps, inline ``css`` declarations, stylesheet
    payloads, and optional Lottie / Rive overlay layers all participate
    in the same render path.

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

    css: str | None = None
    """
    Inline CSS-like declaration block merged through the Styling engine.
    """

    stylesheet: str | Mapping[str, Any] | list[Any] | None = None
    """
    Stylesheet payload or CSS source resolved against this helper.
    """

    background_layers: list[Any] | None = None
    """
    Background scene-layer definitions rendered behind the preview surfaces.
    """

    foreground_layers: list[Any] | None = None
    """
    Foreground scene-layer definitions rendered above the preview surfaces.
    """

    lottie: Any = None
    """
    Lottie shorthand forwarded into the helper's overlay scene layers.
    """

    rive: Any = None
    """
    Rive shorthand forwarded into the helper's overlay scene layers.
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

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def set_state_style(self, session: Any, state: str, style_props: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_state_style", {"state": state, "style": dict(style_props)})
