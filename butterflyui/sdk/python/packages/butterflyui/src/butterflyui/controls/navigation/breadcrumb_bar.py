from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["BreadcrumbBar"]


class BreadcrumbBar(Component):
    """
    Interactive breadcrumb bar with path parsing and overflow behaviors.

    Renders clickable path segments from either a slash-delimited ``path`` or
    explicit ``items`` payloads. ``crumbs`` and ``routes`` remain accepted
    aliases for compatibility with previous payload shapes.

    Supports shared placement props via ``props`` (alignment, margin, size
    constraints, radius/clip) so breadcrumb surfaces can be docked in custom
    headers/toolbars.

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
        crumbs:
            Alias for ``items``.
        routes:
            Alias for ``items`` used by legacy ``breadcrumbs`` payloads.
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
        props:
            Raw prop overrides and extended layout hints.
    """

    control_type = "breadcrumb_bar"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        crumbs: list[Mapping[str, Any]] | None = None,
        routes: list[Mapping[str, Any]] | None = None,
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
            items=items if items is not None else (crumbs if crumbs is not None else routes),
            crumbs=crumbs if crumbs is not None else items,
            routes=routes if routes is not None else items,
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
