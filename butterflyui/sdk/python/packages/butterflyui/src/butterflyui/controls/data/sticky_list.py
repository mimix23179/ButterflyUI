from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

__all__ = ["StickyList"]

@butterfly_control('sticky_list', field_aliases={'controls': 'children'})
class StickyList(ScrollableControl):
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

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `sticky_list` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `sticky_list` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `sticky_list` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `sticky_list` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `sticky_list` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `sticky_list` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `sticky_list` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `sticky_list` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `sticky_list` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `sticky_list` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `sticky_list` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `sticky_list` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `sticky_list` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `sticky_list` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `sticky_list` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `sticky_list` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `sticky_list` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `sticky_list` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `sticky_list` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
