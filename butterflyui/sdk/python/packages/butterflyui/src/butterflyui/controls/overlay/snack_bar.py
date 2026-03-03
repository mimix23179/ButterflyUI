from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["SnackBar"]


class SnackBar(Component):
    """
    Transient snackbar feedback control with optional action affordance.

    ``SnackBar`` is the canonical control name replacing legacy ``snackbar``.
    It is designed for short-lived status feedback such as save confirmations,
    warnings, and undo prompts.

    ```python
    import butterflyui as bui

    sb = bui.SnackBar(
        message="Project saved",
        action_label="Undo",
        variant="success",
        open=True,
        duration_ms=2600,
    )
    ```

    Args:
        message:
            Primary snackbar message text.
        label:
            Optional secondary label text.
        open:
            If ``True``, snackbar is visible.
        duration_ms:
            Auto-dismiss timeout in milliseconds.
        action_label:
            Optional action button label.
        variant:
            Semantic style hint (for example ``"info"``, ``"success"``,
            ``"warning"``, ``"error"``).
        style_name:
            Renderer style mode, defaults to ``"snackbar"``.
        icon:
            Optional icon descriptor.
        instant:
            If ``True``, bypasses queued animation behavior when supported.
        priority:
            Queue priority hint for host-level scheduling.
        use_flushbar:
            Runtime integration hint for Flushbar-style presentation.
        use_fluttertoast:
            Runtime integration hint for FlutterToast-style presentation.
        toast_position:
            Preferred toast/snackbar placement hint.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """

    control_type = "snack_bar"

    def __init__(
        self,
        message: str | None = None,
        *,
        label: str | None = None,
        open: bool | None = None,
        duration_ms: int | None = None,
        action_label: str | None = None,
        variant: str | None = None,
        style_name: str | None = None,
        icon: Any | None = None,
        instant: bool | None = None,
        priority: int | None = None,
        use_flushbar: bool | None = None,
        use_fluttertoast: bool | None = None,
        toast_position: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                message=message,
                label=label,
                open=open,
                duration_ms=duration_ms,
                action_label=action_label,
                variant=variant,
                style=style_name,
                icon=icon,
                instant=instant,
                priority=priority,
                use_flushbar=use_flushbar,
                use_fluttertoast=use_fluttertoast,
                toast_position=toast_position,
                events=events,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def show(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "show", {})

    def hide(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "hide", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )

