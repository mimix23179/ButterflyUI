from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .toast import Toast

__all__ = ["Snackbar"]

class Snackbar(Toast):
    """
    Material-style snackbar notification that appears at the bottom of the screen.

    A specialization of ``Toast`` with snackbar semantics and positioning.
    Inherits ``message``, ``open``, ``duration_ms``, ``action_label``, and
    ``variant`` from ``Toast``.

    ```python
    import butterflyui as bui

    bui.Snackbar(
        message="File saved.",
        open=True,
        duration_ms=3000,
        action_label="Undo",
    )
    ```

    Args:
        message:
            The notification message text.
        open:
            When ``True`` the snackbar is visible.
        duration_ms:
            Time in milliseconds before the snackbar auto-dismisses.
        action_label:
            Label for an optional inline action button.
        variant:
            Semantic color variant. Values: ``"info"``, ``"success"``,
            ``"warning"``, ``"error"``.
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
