from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ColorPicker"]

class ColorPicker(Component):
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

    Args:
        value: 
            Initial colour value (hex string). Also used for ``get_value`` / ``set_value``.
        color: 
            Alias for `value`.
        mode: 
            Picker layout mode hint forwarded to the runtime.
        picker_mode: 
            Alias for `mode`.
        show_alpha: 
            If ``True``, displays an alpha-channel slider below the colour swatch.
        alpha: 
            Alias for `show_alpha`.
        presets: 
            List of preset colour strings displayed as selectable circles below the picker.
        emit_on_change: 
            If ``True``, a ``"change"`` event is emitted on every interaction (not just on commit).
        show_actions: 
            If ``True``, shows commit/cancel action buttons.
        show_input: 
            If ``True`` (default), the hex ``TextField`` is visible.
        show_hex: 
            Alias for `show_input`.
        show_presets: 
            If ``True`` (default when presets are supplied), the preset- swatches grid is visible.
        preset_size: 
            Diameter of each preset swatch circle. Defaults to ``20``.
        preset_spacing: 
            Spacing between preset swatch circles. Defaults to ``6``.
        preview_height: 
            Height of the colour-preview swatch area.
        input_label: 
            Label text displayed above the hex input ``TextField``.
        input_placeholder: 
            Placeholder text shown inside the hex input when empty.
        commit_text: 
            Label for the commit/OK action button.
        cancel_text: 
            Label for the cancel action button.
        enabled: 
            If ``False``, the entire picker is disabled and non-interactive.
    """
    control_type = "color_picker"

    def __init__(
        self,
        value: Any | None = None,
        *,
        color: Any | None = None,
        mode: str | None = None,
        picker_mode: str | None = None,
        show_alpha: bool | None = None,
        alpha: bool | None = None,
        presets: list[Any] | None = None,
        emit_on_change: bool | None = None,
        show_actions: bool | None = None,
        show_input: bool | None = None,
        show_hex: bool | None = None,
        show_presets: bool | None = None,
        preset_size: float | None = None,
        preset_spacing: float | None = None,
        preview_height: float | None = None,
        input_label: str | None = None,
        input_placeholder: str | None = None,
        commit_text: str | None = None,
        cancel_text: str | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            color=color,
            mode=mode,
            picker_mode=picker_mode,
            show_alpha=show_alpha,
            alpha=alpha,
            presets=presets,
            emit_on_change=emit_on_change,
            show_actions=show_actions,
            show_input=show_input,
            show_hex=show_hex,
            show_presets=show_presets,
            preset_size=preset_size,
            preset_spacing=preset_spacing,
            preview_height=preview_height,
            input_label=input_label,
            input_placeholder=input_placeholder,
            commit_text=commit_text,
            cancel_text=cancel_text,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})
