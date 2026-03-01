from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Breadcrumbs"]

class Breadcrumbs(Component):
    """
    Simple read-only breadcrumb trail showing a navigation path.

    The runtime renders a horizontal row of path segments separated by
    ``separator``. ``max_items`` truncates a long path to the most recent
    segments. For an interactive breadcrumb with click-to-navigate support,
    use ``BreadcrumbBar``.

    ```python
    import butterflyui as bui

    bui.Breadcrumbs(
        items=[
            {"label": "Home"},
            {"label": "Projects"},
            {"label": "My Project"},
        ],
        separator="/",
    )
    ```

    Args:
        items:
            List of breadcrumb segment specs. Each entry typically has a
            ``label`` key.
        separator:
            String or icon name rendered between segments.
        max_items:
            Maximum number of segments to display before truncating.
    """

    control_type = "breadcrumbs"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        separator: str | None = None,
        max_items: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            separator=separator,
            max_items=max_items,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
