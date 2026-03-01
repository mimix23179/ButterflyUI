from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["CodeView"]

class CodeView(Component):
    """Read-only monospace code viewer with optional line numbers.

    Renders source code in a dark-background ``Container`` using a
    monospace ``TextStyle``.  The text is selectable by default and
    supports horizontal scrolling when ``wrap`` is ``False``.  Enabling
    ``show_line_numbers`` prepends numbered gutter lines.

    Use ``get_value`` to retrieve the current text content and
    ``set_value`` to replace it at runtime.

    Example::

        import butterflyui as bui

        viewer = bui.CodeView(
            value="def greet():\n    return 'Hi'",
            language="python",
            show_line_numbers=True,
            selectable=True,
        )

    Args:
        value: 
            Source-code string to display.
        text: 
            Alias for ``value``.
        language: 
            Syntax-highlighting language hint (e.g. ``"python"``, ``"dart"``, ``"javascript"``).
        selectable: 
            If ``True`` (default) the code text is selectable.
        wrap: 
            If ``True`` long lines soft-wrap; otherwise horizontal scrolling is enabled.
        show_line_numbers: 
            If ``True`` a numbered gutter is prepended to each line.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "code_view"

    def __init__(
        self,
        value: str | None = None,
        *,
        text: str | None = None,
        language: str | None = None,
        selectable: bool | None = None,
        wrap: bool | None = None,
        show_line_numbers: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = text if text is not None else value
        merged = merge_props(
            props,
            value=resolved,
            text=resolved,
            language=language,
            selectable=selectable,
            wrap=wrap,
            show_line_numbers=show_line_numbers,
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
