from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TextArea"]

class TextArea(Component):
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

    Args:
        value:
            Initial text content of the field.
        placeholder:
            Hint text shown when the field is empty.
        label:
            Floating label text shown above the field.
        min_lines:
            Minimum number of visible text lines.
        max_lines:
            Maximum number of visible lines before scrolling.
        enabled:
            If ``False``, the field is non-interactive.
        read_only:
            If ``True``, the content is visible but not editable.
        emit_on_change:
            If ``True``, ``change`` events are fired on every
            keystroke.
        debounce_ms:
            Milliseconds to debounce ``change`` events when
            ``emit_on_change`` is ``True``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "text_area"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        label: str | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        enabled: bool | None = None,
        read_only: bool | None = None,
        emit_on_change: bool | None = None,
        debounce_ms: int | None = None,
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
            label=label,
            multiline=True,
            min_lines=min_lines,
            max_lines=max_lines,
            enabled=enabled,
            read_only=read_only,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
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
