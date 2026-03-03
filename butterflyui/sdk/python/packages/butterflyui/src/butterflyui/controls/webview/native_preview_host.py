from __future__ import annotations

from .webview import WebView

__all__ = ["NativePreviewHost"]


class NativePreviewHost(WebView):
    """Alias for :class:`WebView` using ``control_type='native_preview_host'``."""

    control_type = "native_preview_host"

