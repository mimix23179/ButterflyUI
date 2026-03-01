from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TaskList"]

class TaskList(Component):
    """
    Checklist / to-do list with checkbox toggles, strikethrough on
    completion, and aggregate change events.

    The runtime renders a ``ListView`` of ``CheckboxListTile`` rows
    parsed from the ``items`` list.  Each item mapping is displayed with
    ``label`` (or ``title``/``text``), optional ``description`` (or
    ``subtitle``), and a checkbox driven by ``done``/``completed``/
    ``checked``.  Toggling a checkbox emits a ``"toggle"`` event with
    the item ``id``, new ``value``, and running ``completed_count`` /
    ``total_count``, followed by a ``"change"`` event carrying the full
    checked-state map.  Completed items render with a
    ``lineThrough`` text decoration.

    ```python
    import butterflyui as bui

    bui.TaskList(
        items=[
            {"id": "t1", "label": "Write docs", "done": True},
            {"id": "t2", "label": "Run tests", "done": False},
            {"id": "t3", "label": "Deploy"},
        ],
        dense=True,
        separator=True,
    )
    ```

    Args:
        items: 
            Task item payloads — list of mappings with ``"id"`` (or ``"key"``), ``"label"`` (or ``"title"``/``"text"``), optional ``"description"``/``"subtitle"``, and ``"done"``/``"completed"``/``"checked"`` boolean.
        dense: 
            If ``True``, checkbox tiles use compact vertical density.
        separator: 
            If ``True``, a ``Divider`` is inserted between each task row.
    """

    control_type = "task_list"

    def __init__(
        self,
        *,
        items: list[Any] | None = None,
        dense: bool | None = None,
        separator: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            dense=dense,
            separator=separator,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
