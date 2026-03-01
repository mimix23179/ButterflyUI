from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["EditorTabStrip"]

class EditorTabStrip(Component):
    """
    Horizontal strip of document tabs for a code or content editor.

    The runtime renders a row of closeable, reorderable tab items. Each
    entry in ``tabs`` is a mapping describing a single tab (id, label,
    modified state, icon, etc.).

    ```python
    import butterflyui as bui

    bui.EditorTabStrip(
        tabs=[
            {"id": "file1", "label": "main.py"},
            {"id": "file2", "label": "utils.py", "modified": True},
        ],
    )
    ```

    Args:
        tabs:
            List of tab spec mappings. Each mapping should include at least
            ``id`` and ``label``.
    """

    control_type = "editor_tab_strip"

    def __init__(
        self,
        *,
        tabs: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, tabs=tabs, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
