from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["WebView"]


def _normalize_webview_engine(value: str | None) -> str:
    normalized = (value or "").strip().lower()
    if normalized in {"windows", "webview_windows", "win", "win32"}:
        return "windows"
    return "windows"

@butterfly_control('webview', field_aliases={'content': 'child'})
class WebView(LayoutControl):
    """
    Embedded browser window powered by a platform WebView engine.

    The runtime embeds a native webview (WebView2 on Windows, etc.) that
    loads ``url`` or inline ``html``. ``engine`` / ``webview_engine`` selects
    the rendering backend — currently normalised to ``"windows"`` on desktop.
    ``base_url`` sets the origin for local HTML content. ``prevent_links``
    intercepts navigation to matching URL patterns before they load.

    Full browser-capability flags control JavaScript, DOM storage, cookies,
    caching, incognito mode, media playback, file access, and popup
    behaviour. ``init_timeout_ms`` caps the engine startup wait.

    Programmatic methods (``reload``, ``go_back``, ``load_url``,
    ``run_javascript``, *etc.*) are invoked via a session handle.

    Example:

    ```python
    import butterflyui as bui

    view = bui.WebView(
        url="https://example.com",
        javascript_enabled=True,
        allow_popups=False,
        init_timeout_ms=10000,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    url: str | None = None
    """
    Initial URL to load in the webview.
    """

    html: str | None = None
    """
    Inline HTML string to render, used instead of ``url``.
    """

    base_url: str | None = None
    """
    Origin URL used when loading ``html`` from a string.
    """

    engine: str | None = None
    """
    Webview rendering engine. Normalised to ``"windows"`` on desktop.
    """

    webview_engine: str | None = None
    """
    Backward-compatible alias for ``engine``. When both fields are provided, ``engine`` takes precedence and this alias is kept only for compatibility.
    """

    fallback_engine: str | None = None
    """
    Fallback engine identifier if the primary engine fails.
    """

    prevent_links: list[str] | None = None
    """
    List of URL patterns whose navigation is intercepted and blocked.
    """

    request_headers: Mapping[str, Any] | None = None
    """
    Custom HTTP headers sent with every request.
    """

    user_agent: str | None = None
    """
    Custom User-Agent string override.
    """

    javascript_enabled: bool | None = None
    """
    When ``True`` (default) JavaScript execution is enabled.
    """

    dom_storage_enabled: bool | None = None
    """
    When ``True`` DOM/localStorage storage is enabled.
    """

    third_party_cookies_enabled: bool | None = None
    """
    When ``True`` third-party cookies are allowed.
    """

    cache_enabled: bool | None = None
    """
    When ``True`` the browser cache is active.
    """

    clear_cache_on_start: bool | None = None
    """
    When ``True`` the cache is cleared when the view initialises.
    """

    incognito: bool | None = None
    """
    When ``True`` no browsing data is persisted between sessions.
    """

    media_playback_requires_user_gesture: bool | None = None
    """
    When ``True`` media autoplay requires a user interaction first.
    """

    allows_inline_media_playback: bool | None = None
    """
    When ``True`` media can play inline without entering fullscreen.
    """

    allow_file_access: bool | None = None
    """
    When ``True`` ``file://`` URLs can be loaded.
    """

    allow_universal_access_from_file_urls: bool | None = None
    """
    When ``True`` file-origin pages can access cross-origin content.
    """

    allow_popups: bool | None = None
    """
    When ``True`` ``window.open()`` calls are permitted.
    """

    open_external_links: bool | None = None
    """
    When ``True`` external links open in the system browser.
    """

    init_timeout_ms: int | None = None
    """
    Maximum milliseconds to wait for the WebView engine to
    initialise. Defaults to ``15000``.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    use_inapp: Any | None = None
    """
    Use inapp value forwarded to the `webview` runtime control.
    """

    headers: Any | None = None
    """
    Headers value forwarded to the `webview` runtime control.
    """

    js_enabled: Any | None = None
    """
    Js enabled value forwarded to the `webview` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `webview` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `webview` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `webview` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `webview` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `webview` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `webview` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `webview` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `webview` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `webview` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `webview` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `webview` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `webview` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `webview` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `webview` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `webview` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `webview` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `webview` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `webview` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `webview` runtime control.
    """

    def reload(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "reload", {})

    def can_go_back(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "can_go_back", {})

    def can_go_forward(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "can_go_forward", {})

    def go_back(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "go_back", {})

    def go_forward(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "go_forward", {})

    def load_url(self, session: Any, url: str) -> dict[str, Any]:
        return self.invoke(session, "load_request", {"url": url})

    def load_request(
        self,
        session: Any,
        url: str,
        *,
        headers: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        args: dict[str, Any] = {"url": url}
        if headers is not None:
            args["headers"] = dict(headers)
        return self.invoke(session, "load_request", args)

    def load_html(
        self,
        session: Any,
        html: str,
        *,
        base_url: str | None = None,
    ) -> dict[str, Any]:
        args: dict[str, Any] = {"value": html}
        if base_url is not None:
            args["base_url"] = base_url
        return self.invoke(session, "load_html", args)

    def run_javascript(self, session: Any, script: str) -> dict[str, Any]:
        return self.invoke(session, "run_javascript", {"value": script})

    def clear_cache(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_cache", {})

    def clear_local_storage(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_local_storage", {})

    def get_current_url(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_current_url", {})

    def get_title(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_title", {})

    def get_user_agent(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_user_agent", {})

    def set_user_agent(self, session: Any, user_agent: str) -> dict[str, Any]:
        return self.invoke(session, "set_user_agent", {"value": user_agent})

    def set_javascript_mode(self, session: Any, *, enabled: bool) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_javascript_mode",
            {"mode": "unrestricted" if enabled else "disabled"},
        )

    def set_popup_policy(self, session: Any, policy: str) -> dict[str, Any]:
        return self.invoke(session, "set_popup_policy", {"value": policy})

    def open_devtools(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "open_devtools", {})
