from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["QueueList"]

class QueueList(Component):
    """
    Queue/job list showing task items with optional per-row progress
    indicators.

    The runtime renders a ``ListView.separated`` of ``ListTile`` rows
    capped at ``max_items``.  Each item mapping is displayed with
    ``title`` (or ``label``/``name``), optional ``subtitle`` (or
    ``description``), and when ``show_progress`` is ``True`` a
    ``LinearProgressIndicator`` driven by the item’s ``progress``
    (or ``value``) field.  Tapping an enabled row emits a
    ``"select"`` event carrying the item ``id``, ``index``, and full
    ``item`` payload.

    ```python
    import butterflyui as bui

    bui.QueueList(
        items=[
            {"id": "job-1", "title": "Compile", "progress": 0.8},
            {"id": "job-2", "title": "Test", "progress": 0.3},
            {"id": "job-3", "title": "Deploy", "progress": 0.0},
        ],
        show_progress=True,
        max_items=10,
        dense=True,
    )
    ```

    Args:
        items: 
            Queue item payload list — each mapping should contain at least ``"id"`` and ``"title"`` (or ``"label"``/``"name"``).  Optional ``"progress"`` (0–1), ``"subtitle"``, and ``"enabled"`` keys are recognised.
        max_items: 
            Maximum number of visible rows.  When the ``items`` list is longer, only the first ``max_items`` are rendered.
        dense: 
            If ``True``, list tiles use compact vertical density.
        show_progress: 
            If ``True``, a ``LinearProgressIndicator`` is rendered beneath the subtitle for items that carry a ``progress`` value.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "queue_list"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        max_items: int | None = None,
        dense: bool | None = None,
        show_progress: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            max_items=max_items,
            dense=dense,
            show_progress=show_progress,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
