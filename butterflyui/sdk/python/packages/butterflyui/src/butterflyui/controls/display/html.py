from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .html_view import HtmlView

__all__ = ["Html"]

class Html(HtmlView):
    """Short-hand HTML renderer that delegates to ``HtmlView``.

    Convenience alias for ``HtmlView`` with the same parameter set.
    Renders raw HTML inside a platform ``WebView`` and supports both
    inline ``html`` strings and external ``html_file`` paths.

    Example::

        import butterflyui as bui

        view = bui.Html(value="<h1>Hello</h1><p>World</p>")

    Args:
        value: 
            Inline HTML string to render.
        html: 
            Alias for ``value``.
        text: 
            Alias for ``value``.
        html_file: 
            Local file path to an ``.html`` file.  When set, the file is loaded into the embedded ``WebView``.
        base_url: 
            Base URL used for resolving relative asset paths inside the HTML.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "html"

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
        super().__init__(
            value=value,
            html=html,
            text=text,
            html_file=html_file,
            base_url=base_url,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
