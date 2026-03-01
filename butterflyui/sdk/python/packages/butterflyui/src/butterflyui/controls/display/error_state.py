from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ErrorState"]

class ErrorState(Component):
    """Error placeholder with retry action and optional detail block.

    Renders a centred column with an error-coloured icon (defaults to
    ``Icons.error_outline``), a bold ``title``, a descriptive
    ``message``, and a ``FilledButton.tonal`` that emits
    ``"retry"`` / ``"action"`` when pressed.  An optional ``detail``
    string is displayed in a monospace container below the message for
    stack traces or error codes.

    Example::

        import butterflyui as bui

        err = bui.ErrorState(
            title="Connection Failed",
            message="Unable to reach the server.",
            detail="ETIMEDOUT 10.0.0.1:443",
            action_label="Retry",
        )

    Args:
        title: 
            Heading text (defaults to ``"Something went wrong"``).
        message: 
            Descriptive body text below the title.
        detail: 
            Optional monospace detail block for stack traces or error codes.
        action_label: 
            Label for the retry button (defaults to ``"Retry"``).  The button emits ``"retry"`` and ``"action"`` events.
        icon: 
            Material icon name rendered above the title (defaults to ``error_outline``).  Tinted with the theme error colour.
    """
    control_type = "error_state"

    def __init__(
        self,
        *,
        title: str | None = None,
        message: str | None = None,
        detail: str | None = None,
        action_label: str | None = None,
        icon: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            message=message,
            detail=detail,
            action_label=action_label,
            icon=icon,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
