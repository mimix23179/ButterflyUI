from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Splash"]

class Splash(Component):
    """Full-screen splash screen rendered during app startup or transitions.

    Covers the Flutter widget tree with a branded loading screen that can
    display progress, animated effects, and optional skip controls.

    Example:
        ```python
        splash = Splash(active=True, auto_start=True, title="Welcome", show_progress=True)
        ```

    Args:
        active: Whether the splash screen is currently displayed.
        color: Primary accent colour of the splash screen.
        duration_ms: Total display duration in milliseconds.
        radius: Corner radius of the splash surface.
        centered: Whether content is centred on the splash screen.
        title: Heading text displayed on the splash screen.
        subtitle: Subheading text displayed below the title.
        message: Body message shown during loading.
        loading: Whether an indeterminate loading indicator is shown.
        progress: Current progress value between 0.0 and 1.0.
        show_progress: Whether the progress indicator is visible.
        skip_enabled: Whether a skip button is shown to the user.
        auto_start: Whether the splash sequence begins automatically.
        hide_on_complete: Whether the screen hides when progress reaches 1.0.
        min_duration_ms: Minimum display time regardless of progress.
        background: Background widget or colour descriptor.
        effect: Named visual effect applied to the splash surface.
        events: Flutter client events to subscribe to.
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
