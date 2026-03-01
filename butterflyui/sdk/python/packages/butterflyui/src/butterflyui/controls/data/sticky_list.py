from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["StickyList"]

class StickyList(Component):
    """
    Sectioned scrollable list with sticky section headers.

    When ``sections`` are provided, each section mapping should carry
    a ``header`` (or ``title``) string and an ``items`` list.  The
    runtime renders bold header text followed by tappable item rows;
    tapping a row emits a ``"select"`` event with ``section_index``,
    ``item_index``, ``item``, ``label``, and ``id``.  When no sections
    are given, explicit ``children`` controls are rendered as a plain
    ``ListView`` separated by ``spacing``.

    ```python
    import butterflyui as bui

    bui.StickyList(
        sections=[
            {"header": "Fruits", "items": [
                {"id": "apple", "label": "Apple"},
                {"id": "banana", "label": "Banana"},
            ]},
            {"header": "Vegetables", "items": [
                {"id": "carrot", "label": "Carrot"},
            ]},
        ],
        spacing=8,
        scrollable=True,
    )
    ```

    Args:
        sections: 
            Section payloads — list of mappings each containing ``"header"`` (or ``"title"``) and ``"items"`` (list of item mappings with at least ``"label"``/``"id"``).
        spacing: 
            Vertical spacing in logical pixels between items or sections.  Defaults to ``8``.
        padding: 
            Outer list padding (single number or per-edge spec).
        scrollable: 
            If ``True`` (default), the list scrolls with ``AlwaysScrollableScrollPhysics``.  Set to ``False`` for ``NeverScrollableScrollPhysics``.
        shrink_wrap: 
            If ``True``, the list shrink-wraps its content for embedding inside other scrollable parents.
        reverse: 
            If ``True``, the scroll direction is reversed (bottom-to-top).
        cache_extent: 
            Cache extent in logical pixels for viewport pre-building of off-screen items.
        header_extent: 
            Fixed extent for section header rows (forwarded to the runtime).
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "sticky_list"

    def __init__(
        self,
        *children: Any,
        sections: list[Mapping[str, Any]] | None = None,
        spacing: float | None = None,
        padding: Any | None = None,
        scrollable: bool | None = None,
        shrink_wrap: bool | None = None,
        reverse: bool | None = None,
        cache_extent: float | None = None,
        header_extent: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            sections=[dict(section) for section in (sections or [])],
            spacing=spacing,
            padding=padding,
            scrollable=scrollable,
            shrink_wrap=shrink_wrap,
            reverse=reverse,
            cache_extent=cache_extent,
            header_extent=header_extent,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
