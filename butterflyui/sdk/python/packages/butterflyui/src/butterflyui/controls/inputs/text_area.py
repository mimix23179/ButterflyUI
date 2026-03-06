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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `text_area` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `text_area` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `text_area` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `text_area` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `text_area` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `text_area` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `text_area` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `text_area` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `text_area` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `text_area` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `text_area` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `text_area` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `text_area` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `text_area` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `text_area` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `text_area` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `text_area` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `text_area` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `text_area` runtime control.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
