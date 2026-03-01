from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .toast import Toast

__all__ = ["Snackbar"]

class Snackbar(Toast):
    """Material-style snackbar notification built on Toast.

    Extends Toast to render a brief bottom-anchored message within the Flutter
    widget tree following Material Design conventions.

    Example:
        ```python
        bar = Snackbar(message="Saved!", open=True, duration_ms=3000, action_label="Undo")
        ```

    Args:
        message: Text content of the snackbar.
        open: Whether the snackbar is currently visible.
        duration_ms: Time in milliseconds before auto-dismissal.
        action_label: Label for the optional action button.
        variant: Visual style variant (e.g., info, success, error).
    """

    control_type = "snackbar"

    def __init__(
        self,
        message: str | None = None,
        *,
        open: bool | None = None,
        duration_ms: int | None = None,
        action_label: str | None = None,
        variant: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            message=message,
            open=open,
            duration_ms=duration_ms,
            action_label=action_label,
            variant=variant,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
