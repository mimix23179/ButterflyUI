from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["WebView"]


def _normalize_webview_engine(value: str | None) -> str:
    normalized = (value or "").strip().lower()
    if normalized in {"windows", "webview_windows", "win", "win32"}:
        return "windows"
    return "windows"


class WebView(Component):
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

    ```python
    import butterflyui as bui

    view = bui.WebView(
        url="https://example.com",
        javascript_enabled=True,
        allow_popups=False,
        init_timeout_ms=10000,
    )
    ```

    Args:
        url:
            Initial URL to load in the webview.
        html:
            Inline HTML string to render, used instead of ``url``.
        base_url:
            Origin URL used when loading ``html`` from a string.
        engine:
            Webview rendering engine. Normalised to ``"windows"`` on desktop.
        webview_engine:
            Alias for ``engine``.
        fallback_engine:
            Fallback engine identifier if the primary engine fails.
        prevent_links:
            List of URL patterns whose navigation is intercepted and blocked.
        request_headers:
            Custom HTTP headers sent with every request.
        user_agent:
            Custom User-Agent string override.
        javascript_enabled:
            When ``True`` (default) JavaScript execution is enabled.
        dom_storage_enabled:
            When ``True`` DOM/localStorage storage is enabled.
        third_party_cookies_enabled:
            When ``True`` third-party cookies are allowed.
        cache_enabled:
            When ``True`` the browser cache is active.
        clear_cache_on_start:
            When ``True`` the cache is cleared when the view initialises.
        incognito:
            When ``True`` no browsing data is persisted between sessions.
        media_playback_requires_user_gesture:
            When ``True`` media autoplay requires a user interaction first.
        allows_inline_media_playback:
            When ``True`` media can play inline without entering fullscreen.
        allow_file_access:
            When ``True`` ``file://`` URLs can be loaded.
        allow_universal_access_from_file_urls:
            When ``True`` file-origin pages can access cross-origin content.
        allow_popups:
            When ``True`` ``window.open()`` calls are permitted.
        open_external_links:
            When ``True`` external links open in the system browser.
        init_timeout_ms:
            Maximum milliseconds to wait for the WebView engine to
            initialise. Defaults to ``15000``.
    """

    control_type = "webview"

    def __init__(
        self,
        *,
        url: str | None = None,
        html: str | None = None,
        base_url: str | None = None,
        engine: str | None = None,
        webview_engine: str | None = None,
        fallback_engine: str | None = None,
        prevent_links: list[str] | None = None,
        request_headers: Mapping[str, Any] | None = None,
        user_agent: str | None = None,
        javascript_enabled: bool | None = None,
        dom_storage_enabled: bool | None = None,
        third_party_cookies_enabled: bool | None = None,
        cache_enabled: bool | None = None,
        clear_cache_on_start: bool | None = None,
        incognito: bool | None = None,
        media_playback_requires_user_gesture: bool | None = None,
        allows_inline_media_playback: bool | None = None,
        allow_file_access: bool | None = None,
        allow_universal_access_from_file_urls: bool | None = None,
        allow_popups: bool | None = None,
        open_external_links: bool | None = None,
        init_timeout_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_engine = _normalize_webview_engine(engine or webview_engine)
        merged = merge_props(
            props,
            url=url,
            html=html,
            base_url=base_url,
            engine=resolved_engine,
            webview_engine=resolved_engine,
            fallback_engine="",
            prevent_links=prevent_links,
            request_headers=dict(request_headers) if request_headers is not None else None,
            user_agent=user_agent,
            javascript_enabled=javascript_enabled,
            dom_storage_enabled=dom_storage_enabled,
            third_party_cookies_enabled=third_party_cookies_enabled,
            cache_enabled=cache_enabled,
            clear_cache_on_start=clear_cache_on_start,
            incognito=incognito,
            media_playback_requires_user_gesture=media_playback_requires_user_gesture,
            allows_inline_media_playback=allows_inline_media_playback,
            allow_file_access=allow_file_access,
            allow_universal_access_from_file_urls=allow_universal_access_from_file_urls,
            allow_popups=allow_popups,
            open_external_links=open_external_links,
            init_timeout_ms=init_timeout_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

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


