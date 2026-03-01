from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BreadcrumbBar"]

class BreadcrumbBar(Component):
    """
    Interactive breadcrumb navigation bar with click-to-navigate support.

    The runtime renders a row of clickable path segments. ``path`` provides
    a forward-slash-delimited string path; ``items`` offers explicit segment
    specs. ``current_index`` highlights the active segment. ``dropdown_levels``
    shows parent levels as a dropdown when segments overflow. ``compact``
    collapses middle segments.

    ```python
    import butterflyui as bui

    bui.BreadcrumbBar(
        path="/home/projects/my-project",
        separator="/",
        dropdown_levels=True,
        events=["navigate"],
    )
    ```

    Args:
        items:
            Explicit list of segment spec mappings. Overrides ``path``.
        path:
            Forward-slash-delimited path string auto-split into segments.
        current_index:
            Zero-based index of the currently active segment.
        separator:
            String or icon name rendered between segments.
        max_items:
            Maximum number of segments to display before truncating.
        dense:
            Reduces segment height and padding.
        dropdown_levels:
            When ``True`` parent levels are shown in a dropdown on overflow.
        show_root:
            When ``True`` the root segment is always visible.
        compact:
            When ``True`` middle segments are collapsed to an ellipsis.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "breadcrumb_bar"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        path: str | None = None,
        current_index: int | None = None,
        separator: str | None = None,
        max_items: int | None = None,
        dense: bool | None = None,
        dropdown_levels: bool | None = None,
        show_root: bool | None = None,
        compact: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            path=path,
            current_index=current_index,
            separator=separator,
            max_items=max_items,
            dense=dense,
            dropdown_levels=dropdown_levels,
            show_root=show_root,
            compact=compact,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": items})

    def set_index(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "set_index", {"index": int(index)})

    def navigate_path(self, session: Any, path: str) -> dict[str, Any]:
        return self.invoke(session, "navigate_path", {"path": path})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
