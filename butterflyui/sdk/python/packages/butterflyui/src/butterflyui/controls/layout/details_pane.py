from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DetailsPane"]

class DetailsPane(Component):
    """
    Adaptive master-detail layout that stacks or splits based on available width.

    When the viewport is narrower than ``stack_breakpoint`` the master and
    detail panels are stacked and toggled via ``show_details``; above the
    breakpoint the layout renders a side-by-side split at ``split_ratio``.
    ``mode`` can override automatic behaviour with ``"stack"`` or ``"split"``.
    ``show_back`` adds a back button in stacked mode.

    ```python
    import butterflyui as bui

    bui.DetailsPane(
        bui.Text("Master panel"),
        bui.Text("Detail panel"),
        split_ratio=0.35,
        stack_breakpoint=700,
        events=["navigate"],
    )
    ```

    Args:
        mode:
            Override the automatic layout mode. Values: ``"stack"``,
            ``"split"``.
        split_ratio:
            Fractional width of the master panel (0.0-1.0) in split mode.
        stack_breakpoint:
            Viewport width in logical pixels below which stacking activates.
        show_details:
            When ``True`` the detail panel is visible in stacked mode.
        show_back:
            When ``True`` a back navigation button is shown in stacked mode.
        back_label:
            Label text for the back button.
        divider:
            When ``True`` a divider line is drawn between the panels.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "details_pane"

    def __init__(
        self,
        *children: Any,
        mode: str | None = None,
        split_ratio: float | None = None,
        stack_breakpoint: float | None = None,
        show_details: bool | None = None,
        show_back: bool | None = None,
        back_label: str | None = None,
        divider: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            mode=mode,
            split_ratio=split_ratio,
            stack_breakpoint=stack_breakpoint,
            show_details=show_details,
            show_back=show_back,
            back_label=back_label,
            divider=divider,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_show_details(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_show_details", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
