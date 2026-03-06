from __future__ import annotations

from collections.abc import Mapping
from typing import Any

__all__ = ["ActionProps", "ButtonProps"]


class ActionProps:
    """Shared declarative action-dispatch props."""

    action: Any = None
    """
    Declarative action descriptor fired by the control.
    """

    action_id: str | None = None
    """
    Registered action identifier dispatched by the control.
    """

    action_event: str | None = None
    """
    Event name emitted to the action dispatcher.
    """

    action_payload: Mapping[str, Any] | None = None
    """
    Extra payload mapping passed to the action dispatcher.
    """

    actions: list[Any] | None = None
    """
    Structured action descriptors rendered or dispatched by the control.
    """

    window_action: str | None = None
    """
    Native window command, such as minimize, maximize, or close.
    """

    window_action_delay_ms: int | None = None
    """
    Delay in milliseconds before a window action is performed.
    """

    url: Any = None
    """
    URL or route-like target opened by the control.
    """

    route: str | None = None
    """
    Application route or navigation target opened by the control.
    """


class ButtonProps:
    """Shared button-label props."""

    label: str | None = None
    """
    Primary label rendered by the control.
    """

    text: str | None = None
    """
    Backward-compatible alias for the rendered label.
    """

    value: Any = None
    """
    Arbitrary value exposed to events or action dispatch.
    """
