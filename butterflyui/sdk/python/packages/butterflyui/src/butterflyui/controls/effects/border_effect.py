from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["BorderEffect", "Border"]


class BorderEffect(Component):
    """Wrap a child control in a configurable border decoration."""

    control_type = "border"

    def __init__(
        self,
        *children: Any,
        color: Any | None = None,
        width: float | None = None,
        radius: float | None = None,
        side: str | None = None,
        sides: Mapping[str, Any] | None = None,
        animated: bool | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            width=width,
            radius=radius,
            side=side,
            sides=dict(sides) if sides is not None else None,
            animated=animated,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)


Border = BorderEffect
