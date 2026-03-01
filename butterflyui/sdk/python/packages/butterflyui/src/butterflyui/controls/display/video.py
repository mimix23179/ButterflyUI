from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Video"]

class Video(Component):
    """Video player control with playback management.

    Embeds a video player backed by the platform media stack.  Supports
    ``autoplay``, ``loop``, ``muted``, and optional native ``controls``.
    A ``poster`` image can be displayed before playback starts, and
    ``fit`` controls how the video is scaled inside its container.

    Use ``play``, ``pause``, ``set_position``, and ``get_state`` to
    manage playback programmatically.

    Example::

        import butterflyui as bui

        vid = bui.Video(
            src="/media/intro.mp4",
            poster="/media/thumb.jpg",
            autoplay=False,
            controls=True,
        )

    Args:
        src: 
            URI or file path of the video source.
        poster: 
            Image URL shown as a thumbnail before playback.
        autoplay: 
            If ``True`` playback starts automatically.
        loop: 
            If ``True`` the video restarts when it finishes.
        muted: 
            If ``True`` audio is muted.
        controls: 
            If ``True`` native player controls are shown.
        fit: 
            Box-fit mode (e.g. ``"contain"``, ``"cover"``).
        volume: 
            Initial volume level from ``0.0`` to ``1.0``.
        events: 
            Event names to subscribe to (e.g. ``["play", "pause"]``).
        props: 
            Extra properties forwarded to the Flutter runtime.
        style: 
            Inline style overrides applied to the player.
        strict: 
            If ``True`` unknown property keys raise an error.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "video"

    def __init__(
        self,
        *,
        src: str | None = None,
        poster: str | None = None,
        autoplay: bool | None = None,
        loop: bool | None = None,
        muted: bool | None = None,
        controls: bool | None = None,
        fit: str | None = None,
        volume: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            poster=poster,
            autoplay=autoplay,
            loop=loop,
            muted=muted,
            controls=controls,
            fit=fit,
            volume=volume,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})

    def set_position(self, session: Any, seconds: float) -> dict[str, Any]:
        return self.invoke(session, "set_position", {"seconds": float(seconds)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
