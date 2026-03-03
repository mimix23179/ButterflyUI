from __future__ import annotations

from .webview import WebView

__all__ = ["WebViewAdapter"]


class WebViewAdapter(WebView):
    """Alias for :class:`WebView` using ``control_type='webview_adapter'``."""

    control_type = "webview_adapter"

