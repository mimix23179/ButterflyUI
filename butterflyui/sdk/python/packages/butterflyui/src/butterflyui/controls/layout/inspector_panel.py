from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["InspectorPanel"]

class InspectorPanel(Component):
    """
    Read-only inspector panel that displays structured property sections.

    The runtime renders a scrollable panel of labelled sections, each
    containing key-value rows. Useful for surfacing metadata, debug
    information, or object properties to the user. ``sections`` is a list
    of section specs that each may carry a ``title`` and a list of row items.

    ```python
    import butterflyui as bui

    bui.InspectorPanel(
        title="Object Properties",
        sections=[
            {"title": "Geometry", "rows": [{"label": "Width", "value": "320"}]},
        ],
    )
    ```

    Args:
        title:
            Optional heading displayed at the top of the panel.
        sections:
            List of section specs. Each section may have a ``title`` and a
            list of ``rows`` with ``label``/``value`` entries.
    """

    control_type = "inspector_panel"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        sections: list[Mapping[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, title=title, sections=sections, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)
