from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Timeline"]

class Timeline(Component):
    """
    Sequenced animation timeline that orchestrates child widgets
    along configurable tracks.
    
    *Timeline* is a container-level orchestrator: it holds one or more
    children together with ``tracks`` definitions that describe
    per-child animation keyframes, delays, and ordering.  Playback
    can be auto-started on mount or toggled via ``set_play()``.
    
    Example:
    
    ```python
    import butterflyui as bui

    tl = bui.Timeline(
        bui.Text("Step 1"),
        bui.Text("Step 2"),
        duration_ms=1000,
        delay_ms=200,
        direction="vertical",
        autoplay=True,
    )
    ```
    """


    tracks: list[Mapping[str, Any]] | None = None
    """
    List of track definition mappings describing
    per-child animation configuration.
    """

    direction: str | None = None
    """
    Layout direction — ``"vertical"`` or
    ``"horizontal"``.
    """

    spacing: float | None = None
    """
    Gap between children in logical pixels.
    """

    autoplay: bool | None = None
    """
    When ``True`` the timeline starts on mount.
    """

    play: bool | None = None
    """
    Explicit play toggle.  ``True`` starts, ``False``
    pauses.
    """

    duration_ms: int | None = None
    """
    Total timeline duration in milliseconds.
    """

    delay_ms: int | None = None
    """
    Initial delay before the timeline begins playing.
    """

    repeat: bool | None = None
    """
    When ``True`` the timeline loops after completion.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """
    control_type = "timeline"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        tracks: list[Mapping[str, Any]] | None = None,
        direction: str | None = None,
        spacing: float | None = None,
        autoplay: bool | None = None,
        play: bool | None = None,
        duration_ms: int | None = None,
        delay_ms: int | None = None,
        repeat: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            tracks=[dict(track) for track in (tracks or [])],
            direction=direction,
            spacing=spacing,
            autoplay=autoplay,
            play=play,
            duration_ms=duration_ms,
            delay_ms=delay_ms,
            repeat=repeat,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
