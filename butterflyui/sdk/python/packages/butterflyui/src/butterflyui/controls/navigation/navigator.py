from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .sidebar import Sidebar

__all__ = ["Navigator"]

class Navigator(Sidebar):
    """
    Grouped navigation sidebar with sections and selection tracking.

    A full-featured extension of ``Sidebar`` that groups navigation items
    into labelled sections and emits selection events. ``sections`` supplies
    labelled group specs; ``items`` provides a flat item list. ``selected_id``
    highlights the active item.

    ```python
    import butterflyui as bui

    bui.Navigator(
        sections=[
            {"label": "Main", "items": [{"id": "home", "label": "Home"}, {"id": "files", "label": "Files"}]},
        ],
        selected_id="home",
        events=["select"],
    )
    ```

    Args:
        sections:
            List of section spec mappings, each with a ``label`` and
            ``items`` list.
        items:
            Flat list of navigation item specs (used when sections are not
            needed).
        selected_id:
            The ``id`` of the currently selected navigation item.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "navigator"

    def __init__(
        self,
        *,
        sections: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        selected_id: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            sections=sections,
            items=items,
            selected_id=selected_id,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )
