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
    
    Supports icon payloads directly and forwards style pipeline fields via
    ``**kwargs`` for color/transparency and motion/effect customization.

    Example:
    
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
    """


    _butterflyui_field_aliases = {"style_name": "style"}

    open: bool | None = None
    """
    If ``True``, snackbar is visible.
    """


    message: str | None = None
    """
    Main message text rendered inside the control.
    """

    label: str | None = None
    """
    Primary label text rendered by the control or its active action.
    """

    duration_ms: int | None = None
    """
    Auto-dismiss timeout in milliseconds.
    """

    action_label: str | None = None
    """
    Label text rendered for the control's inline action when that action is available.
    """

    variant: str | None = None
    """
    Semantic style hint (for example ``"info"``, ``"success"``,
    ``"warning"``, ``"error"``).
    """

    style_name: str | None = None
    """
    Renderer style mode, defaults to ``"snackbar"``.
    """

    icon: Any | None = None
    """
    Icon value or icon descriptor rendered by the control.
    """

    instant: bool | None = None
    """
    If ``True``, bypasses queued animation behavior when supported.
    """

    priority: int | None = None
    """
    Queue priority hint for host-level scheduling.
    """

    use_flushbar: bool | None = None
    """
    Runtime integration hint for Flushbar-style presentation.
    """

    use_fluttertoast: bool | None = None
    """
    Runtime integration hint for FlutterToast-style presentation.
    """

    toast_position: str | None = None
    """
    Preferred toast/snackbar placement hint.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    style: Mapping[str, Any] | None = None
    """
    Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
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
        merged = merge_props(
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
                    )
        super().__init__(
            props=merged,
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

