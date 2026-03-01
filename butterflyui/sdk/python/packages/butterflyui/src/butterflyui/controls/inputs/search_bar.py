from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SearchBar"]

class SearchBar(Component):
    """
    Search input with suggestion overlay, optional filters, and debounce.

    Renders a full-width search ``TextField`` with a magnify icon.  As
    the user types, the ``value`` / ``query`` prop is updated and an
    ``input`` event is emitted after ``debounce_ms`` milliseconds,
    allowing the Python side to populate ``suggestions`` asynchronously.
    Setting ``show_suggestions`` to ``True`` renders a dropdown overlay
    with the current ``suggestions`` list.  The ``filters`` list renders
    a row of chip filters below the search bar.  A trailing ``×`` button
    is shown when ``show_clear`` is ``True``.

    ```python
    import butterflyui as bui

    bui.SearchBar(
        placeholder="Search files…",
        debounce_ms=300,
        show_clear=True,
        show_suggestions=True,
    )
    ```

    Args:
        value:
            Current search query string.  Alias ``query`` is kept in
            sync.
        query:
            Alias for ``value``.
        placeholder:
            Hint text shown when the field is empty.
        hint:
            Alias for ``placeholder``.
        suggestions:
            List of suggestion items (strings or mappings) to display
            in the overlay.
        filters:
            List of filter chip items rendered below the input.
        debounce_ms:
            Milliseconds to debounce ``input`` events while the user
            is typing.
        show_clear:
            If ``True``, a clear ``×`` button is shown when the field
            is non-empty.
        show_suggestions:
            If ``True``, the suggestions dropdown overlay is rendered.
        max_suggestions:
            Maximum number of suggestion items shown in the overlay.
        loading:
            If ``True``, a progress indicator is shown inside the
            overlay while results are being fetched.
    """
    control_type = "search_bar"

    def __init__(
        self,
        value: str | None = None,
        *,
        query: str | None = None,
        placeholder: str | None = None,
        hint: str | None = None,
        suggestions: list[Any] | None = None,
        filters: list[Any] | None = None,
        debounce_ms: int | None = None,
        show_clear: bool | None = None,
        show_suggestions: bool | None = None,
        max_suggestions: int | None = None,
        loading: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = query if query is not None else value
        merged = merge_props(
            props,
            value=resolved,
            query=resolved,
            placeholder=placeholder,
            hint=hint,
            suggestions=suggestions,
            filters=filters,
            debounce_ms=debounce_ms,
            show_clear=show_clear,
            show_suggestions=show_suggestions,
            max_suggestions=max_suggestions,
            loading=loading,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
