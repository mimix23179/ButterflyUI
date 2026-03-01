from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["KeybindRecorder"]

class KeybindRecorder(Component):
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

    ```python
    import butterflyui as bui

    bui.KeybindRecorder(
        placeholder="Press a shortcut…",
        show_clear=True,
    )
    ```

    Args:
        value:
            Currently recorded keyboard shortcut string.
        placeholder:
            Hint text shown when no shortcut has been recorded.
        enabled:
            If ``False``, the recorder is non-interactive.
        show_clear:
            If ``True``, a trailing ``×`` button clears the current
            binding.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "keybind_recorder"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        enabled: bool | None = None,
        show_clear: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            enabled=enabled,
            show_clear=show_clear,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
