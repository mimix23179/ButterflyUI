from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
__all__ = ["StickyList"]

@butterfly_control('sticky_list', field_aliases={'controls': 'children'})
class StickyList(ScrollableControl, MultiChildControl):
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
    """

    sections: list[Mapping[str, Any]] | None = None
    """
    Section payloads — list of mappings each containing ``"header"`` (or ``"title"``) and ``"items"`` (list of item mappings with at least ``"label"``/``"id"``).
    """

    spacing: float | None = None
    """
    Vertical spacing in logical pixels between items or sections.  Defaults to ``8``.
    """

    shrink_wrap: bool | None = None
    """
    If ``True``, the list shrink-wraps its content for embedding inside other scrollable parents.
    """

    reverse: bool | None = None
    """
    If ``True``, the scroll direction is reversed (bottom-to-top).
    """

    cache_extent: float | None = None
    """
    Cache extent in logical pixels for viewport pre-building of off-screen items.
    """

    header_extent: float | None = None
    """
    Fixed extent for section header rows (forwarded to the runtime).
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
