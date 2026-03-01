from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Sidebar"]

class Sidebar(Component):
    """
    Flat navigation sidebar listing items or sections in a vertical panel.

    The runtime renders a scrollable vertical navigation list. ``sections``
    groups items under labelled headings; ``items`` provides a flat
    ungrouped list. ``selected_id`` highlights the active item. For event
    emission and sectioned navigation, use ``Navigator``.

    ```python
    import butterflyui as bui

    bui.Sidebar(
        items=[
            {"id": "home", "label": "Home"},
            {"id": "settings", "label": "Settings"},
        ],
        selected_id="home",
    )
    ```

    Args:
        sections:
            List of section specs, each with a ``label`` and nested
            ``items`` list.
        items:
            Flat list of navigation item specs.
        selected_id:
            The ``id`` of the currently selected item.
    """

    control_type = "sidebar"

    def __init__(
        self,
        *,
        sections: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        selected_id: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            sections=sections,
            items=items,
            selected_id=selected_id,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
