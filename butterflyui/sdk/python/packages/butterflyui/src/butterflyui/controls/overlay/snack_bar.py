from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl


__all__ = ["SnackBar"]

@butterfly_control('snack_bar', field_aliases={'style_name': 'style'}, positional_fields=('message',))
class SnackBar(OverlayControl):
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

    style_name: str | None = None
    """
    Style name value forwarded to the `snack_bar` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `snack_bar` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `snack_bar` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `snack_bar` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `snack_bar` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `snack_bar` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `snack_bar` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `snack_bar` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `snack_bar` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `snack_bar` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `snack_bar` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `snack_bar` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `snack_bar` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `snack_bar` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `snack_bar` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `snack_bar` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `snack_bar` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `snack_bar` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `snack_bar` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `snack_bar` runtime control.
    """

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
