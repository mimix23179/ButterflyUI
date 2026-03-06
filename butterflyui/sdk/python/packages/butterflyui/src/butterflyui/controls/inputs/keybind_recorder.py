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

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
