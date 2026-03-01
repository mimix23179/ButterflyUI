from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BrushPanel"]

class BrushPanel(Component):
    """
    Card with sliders for brush size, hardness, opacity, and flow.

    The runtime renders four ``Slider`` widgets inside a ``Card``. Each
    slider change emits a ``"change"`` event containing the changed key,
    its new value, and the entire brush state snapshot (size, hardness,
    opacity, flow, colour, blend mode).

    ```python
    import butterflyui as bui

    bui.BrushPanel(
        size=24,
        hardness=50,
        opacity=100,
        flow=80,
    )
    ```

    Args:
        size: 
            Brush diameter. Slider range ``1``–``256``. Defaults to ``16``.
        hardness: 
            Brush hardness percentage. Slider range ``0``–``100``. Defaults to ``50``.
        opacity: 
            Brush opacity percentage. Slider range ``0``–``100``. Defaults to ``100``.
        flow: 
            Brush paint-flow percentage. Slider range ``0``–``100``. Defaults to ``100``.
        spacing: 
            Spacing between brush dabs as a fraction of brush size.
        color: 
            Current brush colour. Included in ``get_state`` and ``"change"`` event payloads.
        blend_mode: 
            Current blend mode string (e.g. ``"multiply"``). Included in ``get_state`` and ``"change"`` event payloads.
        pressure_enabled: 
            If ``True``, enables pressure-sensitive brush dynamics.
        smoothing: 
            Stroke smoothing amount.
    """
    control_type = "brush_panel"

    def __init__(
        self,
        *,
        size: float | None = None,
        hardness: float | None = None,
        opacity: float | None = None,
        flow: float | None = None,
        spacing: float | None = None,
        color: Any | None = None,
        blend_mode: str | None = None,
        pressure_enabled: bool | None = None,
        smoothing: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            size=size,
            hardness=hardness,
            opacity=opacity,
            flow=flow,
            spacing=spacing,
            color=color,
            blend_mode=blend_mode,
            pressure_enabled=pressure_enabled,
            smoothing=smoothing,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_value(self, session: Any, key: str, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"key": key, "value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
