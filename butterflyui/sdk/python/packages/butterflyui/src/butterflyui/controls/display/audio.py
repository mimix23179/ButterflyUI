from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Audio"]

class Audio(Component):
    """Audio player control with playback and volume management.

    Embeds an audio player backed by the platform media stack.  Supports
    ``autoplay``, ``loop``, and initial ``volume`` / ``muted`` state.
    Display metadata (``title`` and ``artist``) can be shown in the
    player chrome when the runtime supports it.

    Use the ``play``, ``pause``, ``set_position``, and ``set_volume``
    methods to control playback programmatically, and ``get_state`` to
    retrieve the current position, duration, and playing status.

    Example::

        import butterflyui as bui

        player = bui.Audio(
            src="/media/track.mp3",
            title="Lo-fi Beats",
            autoplay=True,
            volume=0.8,
        )

    Args:
        src: 
            URI or file path of the audio source.
        autoplay: 
            If ``True`` playback begins automatically on mount.
        loop: 
            If ``True`` the track restarts when it finishes.
        volume: 
            Initial volume level from ``0.0`` (silent) to ``1.0``.
        muted: 
            If ``True`` audio output is muted regardless of volume.
        title: 
            Display title shown in the player chrome.
        artist: 
            Artist name shown alongside the title.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "audio"

    def __init__(
        self,
        *,
        src: str | None = None,
        autoplay: bool | None = None,
        loop: bool | None = None,
        volume: float | None = None,
        muted: bool | None = None,
        title: str | None = None,
        artist: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            autoplay=autoplay,
            loop=loop,
            volume=volume,
            muted=muted,
            title=title,
            artist=artist,
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

    def set_volume(self, session: Any, volume: float) -> dict[str, Any]:
        return self.invoke(session, "set_volume", {"volume": float(volume)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
