from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ProgressRing"]


class ProgressRing(Component):
    """
    Circular progress indicator for determinate or indeterminate tasks.

    ``ProgressRing`` sends the canonical ``progress_ring`` control type and pins
    ``variant="circular"`` / ``circular=True`` so the Flutter side always
    renders a ring. Use ``value`` for determinate progress, or set
    ``indeterminate=True`` for an animated spinner-style state.

    ```python
    import butterflyui as bui

    ring = bui.ProgressRing(value=0.72, label="Syncing", stroke_width=6)
    ```

    Args:
        value:
            Progress value for determinate mode.
        indeterminate:
            If ``True``, renders an animated indeterminate ring.
        label:
            Optional text label shown with the indicator.
        stroke_width:
            Thickness of the ring stroke.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """


    value: float | None = None
    """
    Progress value for determinate mode.
    """

    indeterminate: bool | None = None
    """
    If ``True``, renders an animated indeterminate ring.
    """

    label: str | None = None
    """
    Optional text label shown with the indicator.
    """

    stroke_width: float | None = None
    """
    Thickness of the ring stroke.
    """

    control_type = "progress_ring"

    def __init__(
        self,
        *,
        value: float | None = None,
        indeterminate: bool | None = None,
        label: str | None = None,
        stroke_width: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                value=value,
                indeterminate=indeterminate,
                label=label,
                stroke_width=stroke_width,
                variant="circular",
                circular=True,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def set_value(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
