from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ColorSwatchGrid"]

class ColorSwatchGrid(Component):
    """
    Grid of selectable colour swatches rendered via ``GridView.builder``.

    Each swatch is a coloured square that can be tapped to select it.
    Selection is tracked by ``selected_index`` or ``selected_id``. A
    ``"select"`` event is emitted with the swatch's ``index``, ``id``, and
    ``value``.

    ```python
    import butterflyui as bui

    bui.ColorSwatchGrid(
        swatches=[
            {"color": "#ef4444", "label": "Red"},
            {"color": "#22c55e", "label": "Green"},
            {"color": "#3b82f6", "label": "Blue"},
        ],
        columns=6,
        size=24,
    )
    ```

    Args:
        swatches: 
            List of swatch descriptors. Each item is a dict with keys ``"color"`` / ``"value"``, optional ``"label"`` and ``"id"``.
        selected_id: 
            ``id`` of the currently selected swatch.
        selected_index: 
            Zero-based index of the currently selected swatch.
        columns: 
            Number of columns in the grid. Defaults to ``6``.
        size: 
            Width and height of each swatch square in logical pixels. Defaults to ``24``.
        spacing: 
            Spacing between swatches. Defaults to ``6``.
        show_labels: 
            If ``True``, swatch labels are displayed below each colour square.
        show_add: 
            If ``True``, an "add" button is shown to let users append new swatches.
        show_remove: 
            If ``True``, a remove/delete affordance is shown on each swatch.
        groups: 
            Optional grouping descriptors for organising swatches into labelled sections.
        group_by: 
            Key name used to group swatches (e.g. ``"category"``).
        responsive: 
            If ``True``, the grid adapts its column count to the available width.
    """
    control_type = "color_swatch_grid"

    def __init__(
        self,
        *children: Any,
        swatches: list[Any] | None = None,
        selected_id: str | None = None,
        selected_index: int | None = None,
        columns: int | None = None,
        size: float | None = None,
        spacing: float | None = None,
        show_labels: bool | None = None,
        show_add: bool | None = None,
        show_remove: bool | None = None,
        groups: list[Any] | None = None,
        group_by: str | None = None,
        responsive: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            swatches=swatches,
            selected_id=selected_id,
            selected_index=selected_index,
            columns=columns,
            size=size,
            spacing=spacing,
            show_labels=show_labels,
            show_add=show_add,
            show_remove=show_remove,
            groups=groups,
            group_by=group_by,
            responsive=responsive,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_selected(self, session: Any, selected_id: str | None = None, selected_index: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if selected_id is not None:
            payload["selected_id"] = selected_id
        if selected_index is not None:
            payload["selected_index"] = int(selected_index)
        return self.invoke(session, "set_selected", payload)
