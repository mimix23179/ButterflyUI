from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ProgressTimeline"]

class ProgressTimeline(Component):
    """
    Step-by-step timeline showing sequential milestones with selectable
    step indicators and optional connector lines.

    The runtime renders a vertical sequence of labelled step indicators.
    Each item in ``items`` can carry a ``label`` / ``title``, an
    optional ``status`` (e.g. ``"completed"``, ``"active"``,
    ``"pending"``), and an ``icon``.  The visual status of steps
    before ``current_index`` defaults to *completed*, the step at
    ``current_index`` to *active*, and subsequent steps to *pending*.
    When ``show_connector`` is ``True`` (default) vertical connector
    lines join adjacent steps.  Tapping a step emits a
    ``"step_select"`` event.

    ```python
    import butterflyui as bui

    bui.ProgressTimeline(
        items=[
            {"label": "Configure"},
            {"label": "Install"},
            {"label": "Verify"},
        ],
        current_index=1,
        show_connector=True,
    )
    ```

    Args:
        items: 
            Timeline step definitions — list of mappings with ``"label"`` (or ``"title"``), optional ``"status"``, and optional ``"icon"``.
        current_index: 
            Zero-based index of the currently active step.  Steps before this index default to *completed*.
        dense: 
            If ``True``, steps use compact spacing for tighter layouts.
        show_connector: 
            If ``True`` (default), vertical connector lines are drawn between adjacent steps.
    """

    control_type = "progress_timeline"

    def __init__(
        self,
        *,
        items: list[Any] | None = None,
        current_index: int | None = None,
        dense: bool | None = None,
        show_connector: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            current_index=current_index,
            dense=dense,
            show_connector=show_connector,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
