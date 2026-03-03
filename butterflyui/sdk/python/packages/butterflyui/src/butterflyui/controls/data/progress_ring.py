from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ProgressRing"]


class ProgressRing(Component):
    """Circular progress ring."""

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
