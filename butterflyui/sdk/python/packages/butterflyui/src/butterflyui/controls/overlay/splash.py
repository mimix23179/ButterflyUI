from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

__all__ = ["Splash"]

@butterfly_control('splash')
class Splash(OverlayControl):
    """
    Full-screen splash or loading overlay shown during app startup or transitions.

    The runtime renders a full-screen overlay with optional branding,
    loading indicator, and progress tracking. ``active`` shows or hides the
    splash. ``color`` sets the background fill. ``title``/``subtitle``/
    ``message`` add text content. ``loading`` shows a spinner;
    ``show_progress`` adds a determinate progress bar driven by ``progress``.
    ``skip_enabled`` adds a skip button. ``auto_start`` starts the splash
    immediately; ``hide_on_complete`` dismisses it when progress reaches 1.0.
    ``effect`` selects a visual transition effect.

    Example:

    ```python
    import butterflyui as bui

    bui.Splash(
        active=True,
        title="My App",
        loading=True,
        auto_start=True,
        hide_on_complete=True,
        events=["skip", "complete"],
    )
    ```
    """

    active: bool | None = None
    """
    When ``True`` the splash screen is visible.
    """

    color: Any | None = None
    """
    Background fill color of the splash screen.
    """

    duration_ms: int | None = None
    """
    Minimum display duration in milliseconds before auto-hide.
    """

    radius: float | None = None
    """
    Corner radius applied to the splash surface.
    """

    centered: bool | None = None
    """
    When ``True`` content is centered within the splash area.
    """

    title: str | None = None
    """
    Primary heading text rendered by the control.
    """

    subtitle: str | None = None
    """
    Secondary text shown below the title.
    """

    message: str | None = None
    """
    Main message text rendered inside the control.
    """

    loading: bool | None = None
    """
    When ``True`` a loading spinner is shown.
    """

    progress: float | None = None
    """
    Determinate progress value (0.0--1.0) for the progress bar.
    """

    show_progress: bool | None = None
    """
    When ``True`` a determinate progress bar is rendered.
    """

    skip_enabled: bool | None = None
    """
    When ``True`` a skip button is shown to dismiss early.
    """

    auto_start: bool | None = None
    """
    When ``True`` the splash starts automatically on mount.
    """

    hide_on_complete: bool | None = None
    """
    When ``True`` the splash dismisses automatically when
    ``progress`` reaches 1.0.
    """

    min_duration_ms: int | None = None
    """
    Minimum time in milliseconds the splash stays visible.
    """

    background: Any | None = None
    """
    Background widget or image shown behind the splash content.
    """

    effect: str | None = None
    """
    Named visual transition effect applied to the splash.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `splash` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `splash` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `splash` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `splash` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `splash` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `splash` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `splash` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `splash` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `splash` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `splash` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `splash` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `splash` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `splash` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `splash` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `splash` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `splash` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `splash` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `splash` runtime control.
    """

    def trigger(self, session: Any, x: float | None = None, y: float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if x is not None:
            payload["x"] = x
        if y is not None:
            payload["y"] = y
        return self.invoke(session, "trigger", payload)

    def start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "start", {})

    def stop(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "stop", {})

    def set_progress(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"value": float(value)})

    def skip(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "skip", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
