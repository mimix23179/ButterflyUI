from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ProgressOverlay"]

class ProgressOverlay(Component):
    """Full-screen progress overlay displayed during long-running operations.

    Renders a blocking overlay with an optional progress indicator and cancel
    affordance within the Flutter widget tree.

    Example:
        ```python
        overlay = ProgressOverlay(open=True, indeterminate=True, label="Loading\u2026")
        ```

    Args:
        open: Whether the overlay is currently visible.
        progress: Current progress value between 0.0 and 1.0.
        indeterminate: Whether to show an indeterminate spinner.
        label: Text label displayed beneath the progress indicator.
        cancellable: Whether a cancel button is shown to the user.
        events: Flutter client events to subscribe to.
    """

    control_type = "progress_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *,
        open: bool | None = None,
        progress: float | None = None,
        indeterminate: bool | None = None,
        label: str | None = None,
        cancellable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            open=open,
            progress=progress,
            indeterminate=indeterminate,
            label=label,
            cancellable=cancellable,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_progress(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"value": float(value)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
