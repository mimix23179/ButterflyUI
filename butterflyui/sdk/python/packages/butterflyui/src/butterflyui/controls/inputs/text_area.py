from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["TextArea"]

@butterfly_control('text_area', positional_fields=('value',))
class TextArea(FormFieldControl):
    """
    Multi-line text input with auto-grow and debounced change events.

    Renders a Flutter ``TextField`` with ``maxLines: null`` so the
    widget grows vertically as the user types.  The minimum visible
    height can be set via ``min_lines``.  When ``emit_on_change`` is
    ``True`` a ``change`` event is dispatched on every keystroke
    (subject to ``debounce_ms``); otherwise only the final submitted
    value is emitted.  ``read_only`` makes the field non-editable
    while still showing the content.  Use :meth:`set_value` and
    :meth:`get_value` to drive the field from Python.

    Example:

    ```python
    import butterflyui as bui

    bui.TextArea(
        placeholder="Write a description…",
        min_lines=4,
        max_lines=12,
        emit_on_change=True,
        debounce_ms=300,
    )
    ```
    """

    min_lines: int | None = None
    """
    Minimum number of visible text lines.
    """

    max_lines: int | None = None
    """
    Maximum number of visible lines before scrolling.
    """

    emit_on_change: bool | None = None
    """
    If ``True``, ``change`` events are fired on every
    keystroke.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
