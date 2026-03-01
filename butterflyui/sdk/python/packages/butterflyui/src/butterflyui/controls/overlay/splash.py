from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Splash"]

class Splash(Component):
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

    Args:
        active:
            When ``True`` the splash screen is visible.
        color:
            Background fill color of the splash screen.
        duration_ms:
            Minimum display duration in milliseconds before auto-hide.
        radius:
            Corner radius applied to the splash surface.
        centered:
            When ``True`` content is centered within the splash area.
        title:
            Primary branding or title text.
        subtitle:
            Secondary text shown below the title.
        message:
            Body or status message text.
        loading:
            When ``True`` a loading spinner is shown.
        progress:
            Determinate progress value (0.0--1.0) for the progress bar.
        show_progress:
            When ``True`` a determinate progress bar is rendered.
        skip_enabled:
            When ``True`` a skip button is shown to dismiss early.
        auto_start:
            When ``True`` the splash starts automatically on mount.
        hide_on_complete:
            When ``True`` the splash dismisses automatically when
            ``progress`` reaches 1.0.
        min_duration_ms:
            Minimum time in milliseconds the splash stays visible.
        background:
            Background widget or image shown behind the splash content.
        effect:
            Named visual transition effect applied to the splash.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "splash"

    def __init__(
        self,
        child: Any | None = None,
        *,
        active: bool | None = None,
        color: Any | None = None,
        duration_ms: int | None = None,
        radius: float | None = None,
        centered: bool | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        message: str | None = None,
        loading: bool | None = None,
        progress: float | None = None,
        show_progress: bool | None = None,
        skip_enabled: bool | None = None,
        auto_start: bool | None = None,
        hide_on_complete: bool | None = None,
        min_duration_ms: int | None = None,
        background: Any | None = None,
        effect: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            active=active,
            color=color,
            duration_ms=duration_ms,
            radius=radius,
            centered=centered,
            title=title,
            subtitle=subtitle,
            message=message,
            loading=loading,
            progress=progress,
            show_progress=show_progress,
            skip_enabled=skip_enabled,
            auto_start=auto_start,
            hide_on_complete=hide_on_complete,
            min_duration_ms=min_duration_ms,
            background=background,
            effect=effect,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

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
