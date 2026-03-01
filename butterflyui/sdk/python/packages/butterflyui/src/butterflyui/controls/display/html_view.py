from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["HtmlView"]

class HtmlView(Component):
    """Embedded HTML renderer backed by a platform WebView.

    Displays arbitrary HTML inside a ``WebView`` widget.  Content can
    be supplied inline via ``value`` / ``html`` / ``text``, or loaded
    from a local file using ``html_file``.  When ``html_file`` is set
    the runtime converts the path to a ``file://`` URL and derives a
    ``base_url`` from its parent directory so relative assets resolve
    correctly.

    Use ``get_value`` to retrieve the current HTML string,
    ``set_value`` to replace it, and ``load_file`` to swap in a new
    file path at runtime.

    Example::

        import butterflyui as bui

        view = bui.HtmlView(
            value="<h2>Report</h2><p>Details here...</p>",
        )

    Args:
        value: 
            Inline HTML content string.
        html: 
            Alias for ``value``.
        text: 
            Alias for ``value``.
        html_file: 
            Local file path to an ``.html`` file.  Converted to a ``file://`` URL at runtime.
        base_url: 
            Explicit base URL for resolving relative paths inside the HTML.  Defaults to the directory of ``html_file``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "html_view"

    def __init__(
        self,
        value: str | None = None,
        *,
        html: str | None = None,
        text: str | None = None,
        html_file: str | None = None,
        base_url: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = html if html is not None else (text if text is not None else value)
        merged = merge_props(
            props,
            html=resolved,
            value=resolved,
            text=resolved,
            html_file=html_file,
            base_url=base_url,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def load_file(self, session: Any, path: str) -> dict[str, Any]:
        return self.invoke(session, "load_file", {"path": path})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
