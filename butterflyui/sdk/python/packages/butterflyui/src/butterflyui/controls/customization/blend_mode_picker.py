from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BlendModePicker"]

class BlendModePicker(Component):
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

    Args:
        value: 
            Currently selected blend mode string, e.g. ``"multiply"`` or ``"screen"``. Emitted in ``"change"`` events.
        options: 
            List of blend-mode strings offered in the dropdown. Defaults to ``["srcOver", "multiply", "screen", "overlay", "plus"]``.
        items: 
            Alias for `options`.
        label: 
            Label text displayed above the dropdown field. Defaults to ``"Blend Mode"``.
        preview: 
            If ``True``, a small colour swatch preview of the selected blend mode is rendered below the dropdown.
        sample: 
            Dict with ``"base"`` and ``"overlay"`` colour strings used by the blend-mode preview swatch.
        dense: 
            If ``True``, renders the dropdown in a compact, dense layout.
        enabled: 
            If ``False``, the dropdown is disabled and non-interactive.
    """
    control_type = "blend_mode_picker"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        label: str | None = None,
        preview: bool | None = None,
        sample: Mapping[str, Any] | None = None,
        dense: bool | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            options=options if options is not None else items,
            items=items,
            label=label,
            preview=preview,
            sample=dict(sample) if sample is not None else None,
            dense=dense,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})
