from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["DatePicker"]

@butterfly_control('date_picker', positional_fields=('value',))
class DatePicker(FormFieldControl):
    """
    Date picker supporting single date, range, and span workflows.

    ``DatePicker`` unifies legacy controls into one API via ``mode``:
    - ``"single"`` replaces ``date_select``
    - ``"range"`` replaces ``date_range_picker`` / ``date_range``
    - ``"span"`` replaces ``date_span``

    Use :meth:`open` to programmatically open the picker and :meth:`set_value`
    to update single or range selections from server-side handlers.

    Example:

    ```python
    import butterflyui as bui

    bui.DatePicker(
        label="Period",
        mode="range",
        min_date="1900-01-01",
        max_date="2099-12-31",
    )
    ```
    """

    start: str | None = None
    """
    Range start date when ``mode`` is ``"range"`` or ``"span"``.
    """

    end: str | None = None
    """
    Range end date when ``mode`` is ``"range"`` or ``"span"``.
    """

    mode: str | None = None
    """
    ``"single"`` (default), ``"range"``, or ``"span"``.
    """

    min_date: str | None = None
    """
    Earliest selectable date as ``"YYYY-MM-DD"``.
    """

    max_date: str | None = None
    """
    Latest selectable date as ``"YYYY-MM-DD"``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `date_picker` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `date_picker` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `date_picker` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `date_picker` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `date_picker` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `date_picker` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `date_picker` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `date_picker` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `date_picker` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `date_picker` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `date_picker` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `date_picker` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `date_picker` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `date_picker` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `date_picker` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `date_picker` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `date_picker` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `date_picker` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `date_picker` runtime control.
    """

    def open(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "open", {})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(
        self,
        session: Any,
        value: str | None = None,
        *,
        start: str | None = None,
        end: str | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if value is not None:
            payload["value"] = value
        if start is not None:
            payload["start"] = start
        if end is not None:
            payload["end"] = end
        return self.invoke(session, "set_value", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
