from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Wrap"]

class Wrap(Component):
    """
    Flow layout that wraps children onto additional lines when space runs out.

    The runtime wraps Flutter's ``Wrap`` widget. ``spacing`` adds inline gaps
    between children; ``run_spacing`` adds gaps between lines (or columns
    when ``direction`` is ``"vertical"``). ``alignment`` controls positioning
    within each run; ``run_alignment`` places the runs along the cross axis.
    ``cross_axis`` sets alignment of children within a single run.
    ``direction`` switches the main axis to horizontal (default) or vertical.

    ```python
    import butterflyui as bui

    bui.Wrap(
        *[bui.Chip(label=f"Tag {i}") for i in range(10)],
        spacing=8,
        run_spacing=8,
        alignment="start",
    )
    ```

    Args:
        spacing:
            Gap between consecutive children along the main axis.
        run_spacing:
            Gap between consecutive runs along the cross axis.
        alignment:
            Alignment of children within each run along the main axis.
        run_alignment:
            Alignment of runs along the cross axis.
        cross_axis:
            Alignment of children within a run along the cross axis.
        direction:
            Main-axis direction. Values: ``"horizontal"`` (default),
            ``"vertical"``.
    """

    control_type = "wrap"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        run_spacing: float | None = None,
        alignment: str | None = None,
        run_alignment: str | None = None,
        cross_axis: str | None = None,
        direction: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing,
            run_spacing=run_spacing,
            alignment=alignment,
            run_alignment=run_alignment,
            cross_axis=cross_axis,
            direction=direction,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
