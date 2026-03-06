from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .button import Button
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["AsyncActionButton"]

@butterfly_control('async_action_button', positional_fields=('label',))
class AsyncActionButton(ButtonControl):
    """
    Button with built-in asynchronous busy/loading behavior.

    ``AsyncActionButton`` extends :class:`Button` by synchronizing ``busy`` and
    ``loading`` state flags and exposing helpers to toggle busy state through
    runtime invocations. This is useful for long-running actions such as remote
    API calls, background jobs, and multi-step workflows.

    While busy, the renderer can show a spinner and optional ``busy_label``;
    when ``disabled_while_busy`` is enabled, presses are ignored until the
    operation completes.

    Example:

    ```python
    import butterflyui as bui

    save_btn = bui.AsyncActionButton(
        "Save",
        action_id="save_document",
        busy_label="Saving...",
        disabled_while_busy=True,
    )
    ```
    """

    busy: bool | None = None
    """
    Controls whether the control should render its busy or in-progress state instead of its idle presentation.
    """

    loading: bool | None = None
    """
    Backward-compatible alias for ``busy``. When both fields are provided, ``busy`` takes precedence and this alias is kept only for compatibility.
    """

    disabled_while_busy: bool | None = None
    """
    If ``True``, disables interaction while busy.
    """

    busy_label: str | None = None
    """
    Replacement label text shown while the control is in its busy state.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `async_action_button` runtime control.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    content_padding: Any | None = None
    """
    Content padding value forwarded to the `async_action_button` runtime control.
    """

    success_label: Any | None = None
    """
    Success label value forwarded to the `async_action_button` runtime control.
    """

    error_label: Any | None = None
    """
    Error label value forwarded to the `async_action_button` runtime control.
    """

    progress: Any | None = None
    """
    Progress value forwarded to the `async_action_button` runtime control.
    """

    show_progress: Any | None = None
    """
    Show progress value forwarded to the `async_action_button` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `async_action_button` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `async_action_button` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `async_action_button` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `async_action_button` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `async_action_button` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `async_action_button` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `async_action_button` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `async_action_button` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `async_action_button` runtime control.
    """

    icon_position: str | None = None
    """
    Icon position value forwarded to the `async_action_button` runtime control.
    """

    icon_size: float | None = None
    """
    Icon size value forwarded to the `async_action_button` runtime control.
    """

    icon_spacing: float | None = None
    """
    Icon spacing value forwarded to the `async_action_button` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `async_action_button` runtime control.
    """

    transparency: float | None = None
    """
    Transparency value forwarded to the `async_action_button` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `async_action_button` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `async_action_button` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `async_action_button` runtime control.
    """

    def set_busy(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_busy", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
