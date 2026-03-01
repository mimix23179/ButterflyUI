from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .breadcrumb_bar import BreadcrumbBar

__all__ = ["CrumbTrail"]

class CrumbTrail(BreadcrumbBar):
    """
    Compact step-through breadcrumb trail with a current step indicator.

    A simplified form of ``BreadcrumbBar`` focused on sequential navigation.
    ``current_index`` highlights the active step; ``enabled`` disables all
    segment interactions when ``False``.

    ```python
    import butterflyui as bui

    bui.CrumbTrail(
        items=[
            {"label": "Step 1"},
            {"label": "Step 2"},
            {"label": "Step 3"},
        ],
        current_index=1,
        events=["navigate"],
    )
    ```

    Args:
        items:
            List of step/segment spec mappings.
        current_index:
            Zero-based index of the currently active step.
        separator:
            String or icon name rendered between segments.
        enabled:
            When ``False`` all segment navigation interactions are disabled.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "crumb_trail"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        current_index: int | None = None,
        separator: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            items=items,
            separator=separator,
            max_items=None,
            events=events,
            props=merge_props(props, current_index=current_index, enabled=enabled),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_index(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "set_index", {"index": int(index)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
