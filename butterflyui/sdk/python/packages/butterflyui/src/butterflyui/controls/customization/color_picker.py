from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ColorPicker"]

@butterfly_control('color_picker', positional_fields=('value',))
class ColorPicker(LayoutControl):
    """
    Interactive colour selector with hex text input, optional alpha slider,
    and a preset-swatches grid.

    The runtime renders a colour swatch preview, a hex ``TextField``, an
    optional ``Slider`` for the alpha channel, and an optional ``GridView``
    of preset colour circles. On change the control emits ``"change"``
    events carrying the hex string plus decomposed ``r``, ``g``, ``b``,
    and ``alpha`` components.

    ```python
    import butterflyui as bui

    bui.ColorPicker(
        value="#7c3aed",
        show_alpha=True,
        presets=["#ef4444", "#22c55e", "#3b82f6", "#f59e0b"],
    )
    ```
    """

    value: Any | None = None
    """
    Initial colour value (hex string). Also used for ``get_value`` / ``set_value``.
    """

    mode: str | None = None
    """
    Picker layout mode hint forwarded to the runtime.
    """

    picker_mode: str | None = None
    """
    Backward-compatible alias for ``mode``. When both fields are provided, ``mode`` takes precedence and this alias is kept only for compatibility.
    """

    show_alpha: bool | None = None
    """
    If ``True``, displays an alpha-channel slider below the colour swatch.
    """

    presets: list[Any] | None = None
    """
    List of preset colour strings displayed as selectable circles below the picker.
    """

    emit_on_change: bool | None = None
    """
    If ``True``, a ``"change"`` event is emitted on every interaction (not just on commit).
    """

    show_actions: bool | None = None
    """
    If ``True``, shows commit/cancel action buttons.
    """

    show_input: bool | None = None
    """
    Controls whether (default), the hex ``TextField`` is visible. Set it to ``False`` to disable this behavior.
    """

    show_hex: bool | None = None
    """
    Backward-compatible alias for ``show_input``. When both fields are provided, ``show_input`` takes precedence and this alias is kept only for compatibility.
    """

    show_presets: bool | None = None
    """
    Controls whether (default when presets are supplied), the preset- swatches grid is visible. Set it to ``False`` to disable this behavior.
    """

    preset_size: float | None = None
    """
    Diameter of each preset swatch circle. Defaults to ``20``.
    """

    preset_spacing: float | None = None
    """
    Spacing between preset swatch circles. Defaults to ``6``.
    """

    preview_height: float | None = None
    """
    Height of the colour-preview swatch area.
    """

    input_label: str | None = None
    """
    Label text displayed above the hex input ``TextField``.
    """

    input_placeholder: str | None = None
    """
    Placeholder text shown inside the hex input when empty.
    """

    commit_text: str | None = None
    """
    Label for the commit/OK action button.
    """

    cancel_text: str | None = None
    """
    Label for the cancel action button.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})
