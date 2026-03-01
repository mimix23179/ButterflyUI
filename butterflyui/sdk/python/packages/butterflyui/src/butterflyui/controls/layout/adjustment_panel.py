from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AdjustmentPanel"]

class AdjustmentPanel(Component):
    """
    Panel of labelled slider-style controls for adjusting numerical values.

    The runtime renders a scrollable list of named adjustable items backed by
    numeric sliders or inputs. ``items``/``adjustments`` declare the controls;
    ``title`` shows a panel header; ``show_reset`` adds a reset-to-default
    button; ``dense`` reduces padding between rows.

    ```python
    import butterflyui as bui

    bui.AdjustmentPanel(
        items=[{"id": "brightness", "label": "Brightness", "value": 50, "min": 0, "max": 100}],
        title="Image Adjustments",
        show_reset=True,
        events=["change"],
    )
    ```

    Args:
        items:
            List of adjustment item specs. Alias for ``adjustments``.
        adjustments:
            Alias for ``items``.
        title:
            Optional header text displayed above the item list.
        show_reset:
            When ``True`` a reset button is shown to restore default values.
        dense:
            Reduces row height and padding.
        enabled:
            Globally enables or disables all adjustment controls.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "adjustment_panel"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        adjustments: list[Mapping[str, Any]] | None = None,
        title: str | None = None,
        show_reset: bool | None = None,
        dense: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items if items is not None else adjustments,
            adjustments=adjustments if adjustments is not None else items,
            title=title,
            show_reset=show_reset,
            dense=dense,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_item(self, session: Any, item_id: str, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_item", {"id": item_id, "value": float(value)})

    def reset(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "reset", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
