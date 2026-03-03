from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .snackbar import Snackbar

__all__ = ["SnackBar"]


class SnackBar(Snackbar):
    """
    Material-style snackbar notification with optional action button.

    ``SnackBar`` mirrors ``Snackbar`` behavior while serializing as
    ``control_type="snack_bar"`` for dedicated renderer dispatch.

    It is intended for short-lived feedback at the edge of the UI
    (for example save confirmations, warnings, and undo prompts).

    ```python
    import butterflyui as bui

    bui.SnackBar(
        message="Project saved",
        action_label="Undo",
        variant="success",
        open=True,
        duration_ms=2600,
    )
    ```

    Args:
        message:
            Snackbar text message to display.
        open:
            If ``True``, the snackbar is shown.
        duration_ms:
            Auto-dismiss timeout in milliseconds.
        action_label:
            Optional action-button label.
        variant:
            Optional semantic style hint (for example ``"info"``,
            ``"success"``, ``"warning"``, ``"error"``).
    """

    control_type = "snack_bar"

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
