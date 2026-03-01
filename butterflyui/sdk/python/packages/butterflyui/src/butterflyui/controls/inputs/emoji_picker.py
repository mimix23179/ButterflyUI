from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["EmojiPicker"]

class EmojiPicker(Component):
    """
    Scrollable emoji grid with category tabs and optional search.

    The Flutter runtime renders a paginated emoji panel grouped by
    category (smileys, animals, food, etc.).  A ``show_search`` bar
    lets users filter by keyword.  ``show_recent`` enables a *Recently
    Used* tab.  Selecting an emoji emits a ``pick`` event with the
    Unicode character (and optional metadata when
    ``include_metadata`` is ``True``).

    Use :meth:`set_category`, :meth:`search`, and :meth:`set_value` to
    control the panel imperatively.

    ```python
    import butterflyui as bui

    bui.EmojiPicker(
        show_search=True,
        show_recent=True,
        columns=8,
    )
    ```

    Args:
        value:
            Pre-selected emoji character.
        categories:
            List of category names to display.  Defaults to all
            standard emoji categories.
        recent:
            List of recently used emoji characters to pre-populate
            the *Recent* tab.
        skin_tone:
            Default skin tone modifier applied to applicable emoji
            (e.g. ``"light"``, ``"medium"``, ``"dark"``).
        show_search:
            If ``True``, a search text field is rendered above the
            grid.
        show_recent:
            If ``True``, a *Recently Used* category tab is shown.
        category:
            Initially active category name.
        query:
            Initial search query pre-filled in the search field.
        include_metadata:
            If ``True``, the ``pick`` event payload includes extra
            metadata (name, group, annotations).
        recent_limit:
            Maximum number of entries stored in the recent tab.
        columns:
            Number of emoji columns per row in the grid.
        items:
            Explicit list of emoji characters to display, overriding
            the default full set.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "emoji_picker"

    def __init__(
        self,
        value: str | None = None,
        *,
        categories: list[str] | None = None,
        recent: list[str] | None = None,
        skin_tone: str | None = None,
        show_search: bool | None = None,
        show_recent: bool | None = None,
        category: str | None = None,
        query: str | None = None,
        include_metadata: bool | None = None,
        recent_limit: int | None = None,
        columns: int | None = None,
        items: list[str] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            categories=categories,
            recent=recent,
            skin_tone=skin_tone,
            show_search=show_search,
            show_recent=show_recent,
            category=category,
            query=query,
            include_metadata=include_metadata,
            recent_limit=recent_limit,
            columns=columns,
            items=items,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_category(self, session: Any, category: str) -> dict[str, Any]:
        return self.invoke(session, "set_category", {"category": category})

    def search(self, session: Any, query: str) -> dict[str, Any]:
        return self.invoke(session, "search", {"query": query})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
