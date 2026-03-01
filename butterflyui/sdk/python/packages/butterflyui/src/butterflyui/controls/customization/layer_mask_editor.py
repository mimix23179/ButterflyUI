from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["LayerMaskEditor"]

class LayerMaskEditor(Component):
    """
    Controls for editing a layer mask: brush size, opacity, feather, and
    invert.

    The runtime renders a column of ``Slider`` rows for brush size
    (``1``–``256``), opacity (``0``–``1``), and feather (``0``–``1``), plus a
    ``SwitchListTile`` for invert. Each change emits a ``"change"`` event
    with the full mask state.

    ```python
    import butterflyui as bui

    bui.LayerMaskEditor(
        brush_size=24,
        opacity=1.0,
        feather=0.0,
        invert=False,
    )
    ```

    Args:
        value: 
            Current mask value exposed to ``get_state`` / ``set_value``.
        mask: 
            Alias for `value`.
        brush_size: 
            Mask brush diameter. Slider range ``1``–``256``. Defaults to ``24``.
        hardness: 
            Mask brush hardness, ``0``–``100``.
        opacity: 
            Mask opacity, ``0.0``–``1.0``. Defaults to ``1.0``.
        feather: 
            Mask edge feather amount, ``0.0``–``1.0``. Defaults to ``0.0``.
        invert: 
            If ``True``, the mask is inverted. Defaults to ``False``.
        show_alpha: 
            If ``True``, an alpha preview overlay is shown.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "layer_mask_editor"

    def __init__(
        self,
        child: Any | None = None,
        *,
        value: Any | None = None,
        mask: Any | None = None,
        brush_size: float | None = None,
        hardness: float | None = None,
        opacity: float | None = None,
        feather: float | None = None,
        invert: bool | None = None,
        show_alpha: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            mask=mask,
            brush_size=brush_size,
            hardness=hardness,
            opacity=opacity,
            feather=feather,
            invert=invert,
            show_alpha=show_alpha,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
