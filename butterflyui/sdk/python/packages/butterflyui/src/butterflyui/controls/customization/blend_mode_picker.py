from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["BlendModePicker"]

@butterfly_control('blend_mode_picker', positional_fields=('value',))
class BlendModePicker(LayoutControl):
    """
    Dropdown selector for choosing a compositing blend mode.

    Renders a ``DropdownButtonFormField`` in the runtime with an optional
    live preview that demonstrates the selected mode by blending a pair of
    sample colours.

    The default options list is ``srcOver``, ``multiply``, ``screen``,
    ``overlay``, and ``plus``. Override with `options`.

    ```python
    import butterflyui as bui

    bui.BlendModePicker(
        value="multiply",
        preview=True,
        sample={"base": "#ff0000", "overlay": "#0000ff"},
    )
    ```
    """

    value: str | None = None
    """
    Currently selected blend mode string, e.g. ``"multiply"`` or ``"screen"``. Emitted in ``"change"`` events.
    """

    options: list[Any] | None = None
    """
    List of blend-mode strings offered in the dropdown. Defaults to ``["srcOver", "multiply", "screen", "overlay", "plus"]``.
    """

    items: list[Any] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    label: str | None = None
    """
    Label text displayed above the dropdown field. Defaults to ``"Blend Mode"``.
    """

    preview: bool | None = None
    """
    If ``True``, a small colour swatch preview of the selected blend mode is rendered below the dropdown.
    """

    sample: Mapping[str, Any] | None = None
    """
    Dict with ``"base"`` and ``"overlay"`` colour strings used by the blend-mode preview swatch.
    """

    dense: bool | None = None
    """
    If ``True``, renders the dropdown in a compact, dense layout.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `blend_mode_picker` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `blend_mode_picker` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `blend_mode_picker` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `blend_mode_picker` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `blend_mode_picker` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `blend_mode_picker` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `blend_mode_picker` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `blend_mode_picker` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `blend_mode_picker` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `blend_mode_picker` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `blend_mode_picker` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `blend_mode_picker` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `blend_mode_picker` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `blend_mode_picker` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `blend_mode_picker` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `blend_mode_picker` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `blend_mode_picker` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `blend_mode_picker` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `blend_mode_picker` runtime control.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})
