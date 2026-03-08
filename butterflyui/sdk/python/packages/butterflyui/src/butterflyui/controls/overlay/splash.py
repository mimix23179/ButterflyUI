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

    duration_ms: int | None = None
    """
    Minimum display duration in milliseconds before auto-hide.
    """

    centered: bool | None = None
    """
    When ``True`` content is centered within the splash area.
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

    effect: str | None = None
    """
    Named visual transition effect applied to the splash.
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

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
