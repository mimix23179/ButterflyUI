from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DockLayout"]

class DockLayout(Component):
    """
    Dock-style layout that pins pane children to edges and fills remaining space.

    The runtime renders a layout analogous to WinForms ``DockPanel``. Each
    item in ``panes`` specifies a ``slot`` (``"top"``, ``"bottom"``,
    ``"left"``, ``"right"``, or ``"fill"``). Panes are placed sequentially;
    the first ``"fill"`` slot consumes remaining space. ``gap`` adds uniform
    spacing between docked regions.

    ```python
    import butterflyui as bui

    bui.DockLayout(
        panes=[
            {"slot": "top", "size": 48, "content": bui.Text("Header")},
            {"slot": "fill", "content": bui.Text("Main content")},
        ],
        gap=4,
    )
    ```

    Args:
        panes:
            List of pane spec mappings. Each spec should include a ``slot``
            key and an optional ``size`` in logical pixels.
        gap:
            Spacing in logical pixels between docked regions.
    """

    control_type = "dock_layout"

    def __init__(
        self,
        *children: Any,
        panes: list[Mapping[str, Any]] | None = None,
        gap: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, panes=panes, gap=gap, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)
