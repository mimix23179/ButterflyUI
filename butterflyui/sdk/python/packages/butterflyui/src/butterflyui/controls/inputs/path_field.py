from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PathField"]

class PathField(Component):
    """
    Text field with an inline *Browse…* button for file/directory paths.

    Renders an editable ``TextField`` followed (or prepended) by a
    browse icon button.  Tapping the button opens the native file or
    directory picker according to ``mode`` and ``file_type``; the
    selected path is then written back into the field.  The user may
    also type a path directly.  Path changes emit a ``change`` event.

    ```python
    import butterflyui as bui

    bui.PathField(
        label="Output directory",
        mode="directory",
        show_clear=True,
    )
    ```

    Args:
        value:
            Current path string shown in the text field.
        label:
            Floating label text above the field.
        placeholder:
            Hint text shown when the field is empty.
        mode:
            Picker mode — ``"open"``, ``"save"``, or ``"directory"``.
        file_type:
            MIME category hint forwarded to the file picker
            (e.g. ``"image"``, ``"any"``).
        extensions:
            List of allowed file extensions without the leading dot.
        suggested_name:
            Default file name pre-filled when ``mode="save"``.
        show_browse:
            If ``True`` (default), the browse icon button is displayed.
        show_clear:
            If ``True``, a trailing ``×`` button clears the current
            path.
        enabled:
            If ``False``, the field is non-interactive.
        dense:
            If ``True``, the field uses compact height.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "path_field"

    def __init__(
        self,
        value: str | None = None,
        *,
        label: str | None = None,
        placeholder: str | None = None,
        mode: str | None = None,
        file_type: str | None = None,
        extensions: list[str] | None = None,
        suggested_name: str | None = None,
        show_browse: bool | None = None,
        show_clear: bool | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            label=label,
            placeholder=placeholder,
            mode=mode,
            file_type=file_type,
            extensions=extensions,
            suggested_name=suggested_name,
            show_browse=show_browse,
            show_clear=show_clear,
            enabled=enabled,
            dense=dense,
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
