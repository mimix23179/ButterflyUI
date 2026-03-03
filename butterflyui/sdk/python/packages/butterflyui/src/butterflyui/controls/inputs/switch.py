from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Switch"]


class Switch(Component):
    """Boolean switch with optional segmented presentation."""

    control_type = "switch"

    def __init__(
        self,
        value: bool | None = None,
        *,
        label: str | None = None,
        inline: bool | None = None,
        mode: str | None = None,
        on_label: str | None = None,
        off_label: str | None = None,
        segments: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                value=value,
                label=label,
                inline=inline,
                mode=mode,
                on_label=on_label,
                off_label=off_label,
                segments=segments,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def set_value(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})
