from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import merge_props
from .button import Button

__all__ = ["FilledButton"]


class FilledButton(Button):
    """Convenience ``Button`` preset with ``variant='filled'``."""

    control_type = "filled_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        events: list[str] | None = None,
        action: Any | None = None,
        action_id: str | None = None,
        action_event: str | None = None,
        action_payload: Mapping[str, Any] | None = None,
        actions: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=label,
            text=text,
            value=value,
            variant="filled",
            events=events,
            action=action,
            action_id=action_id,
            action_event=action_event,
            action_payload=action_payload,
            actions=actions,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )
