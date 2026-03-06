from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["KeybindRecorder"]

@butterfly_control('keybind_recorder', positional_fields=('value',))
class KeybindRecorder(FormFieldControl):
    """
    Keyboard shortcut recorder field.

    Renders a focusable ``TextField``-style widget that captures raw
    key events while focused and converts them to a human-readable
    shortcut string (e.g. ``"Ctrl+Shift+S"``).  The recorded binding
    is stored as ``value`` and emitted via a ``change`` event when the
    user releases the last key.  An optional clear button resuls the
    value to empty when ``show_clear`` is ``True``.

    Use :meth:`set_value` to inject a shortcut string from Python and
    :meth:`get_value` to read the current binding.

    Example:

    ```python
    import butterflyui as bui

    bui.KeybindRecorder(
        placeholder="Press a shortcut…",
        show_clear=True,
    )
    ```
    """

    show_clear: bool | None = None
    """
    If ``True``, a trailing ``×`` button clears the current
    binding.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `keybind_recorder` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `keybind_recorder` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `keybind_recorder` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `keybind_recorder` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `keybind_recorder` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `keybind_recorder` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `keybind_recorder` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `keybind_recorder` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `keybind_recorder` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `keybind_recorder` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `keybind_recorder` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `keybind_recorder` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `keybind_recorder` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `keybind_recorder` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `keybind_recorder` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `keybind_recorder` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `keybind_recorder` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `keybind_recorder` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `keybind_recorder` runtime control.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
