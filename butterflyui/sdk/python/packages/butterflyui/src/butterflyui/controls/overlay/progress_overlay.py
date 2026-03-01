from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ProgressOverlay"]

class ProgressOverlay(Component):
    """
    Semi-transparent progress overlay blocking interaction during an operation.

    The runtime renders a blocking overlay on top of its child. ``open``
    shows or hides the overlay. ``progress`` drives a determinate progress
    bar (0.0--1.0); setting ``indeterminate`` shows a spinner instead.
    ``label`` displays a status message. ``cancellable`` adds a cancel
    button that emits a cancellation event.

    ```python
    import butterflyui as bui

    bui.ProgressOverlay(
        bui.Text("Main content"),
        open=True,
        indeterminate=True,
        label="Loading…",
        cancellable=False,
        events=["cancel"],
    )
    ```

    Args:
        open:
            When ``True`` the progress overlay is visible and blocks input.
        progress:
            Determinate progress value in the range 0.0--1.0.
        indeterminate:
            When ``True`` an indeterminate spinner is shown instead of a
            progress bar.
        label:
            Status message displayed below the spinner or progress bar.
        cancellable:
            When ``True`` a cancel button is shown that emits a cancel event.
        events:
            List of event names the Flutter runtime should emit to Python.
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
