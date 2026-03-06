from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..title_control import TitleControl
__all__ = ["Audio"]

@butterfly_control('audio')
class Audio(LayoutControl, TitleControl):
    """
    Audio player control with playback and volume management.

    Embeds an audio player backed by the platform media stack.  Supports
    ``autoplay``, ``loop``, and initial ``volume`` / ``muted`` state.
    Display metadata (``title`` and ``artist``) can be shown in the
    player chrome when the runtime supports it.

    Use the ``play``, ``pause``, ``set_position``, and ``set_volume``
    methods to control playback programmatically, and ``get_state`` to
    retrieve the current position, duration, and playing status.

    Example:

    ```python
    import butterflyui as bui

    player = bui.Audio(
        src="/media/track.mp3",
        title="Lo-fi Beats",
        autoplay=True,
        volume=0.8,
    )
    ```
    """

    src: str | None = None
    """
    URI or file path of the audio source.
    """

    autoplay: bool | None = None
    """
    Controls whether playback starts automatically as soon as the media is ready. Leave it disabled when playback should begin only after an explicit user action.
    """

    loop: bool | None = None
    """
    Controls whether playback restarts automatically after the media reaches the end of the stream.
    """

    volume: float | None = None
    """
    Initial volume level from ``0.0`` (silent) to ``1.0``.
    """

    muted: bool | None = None
    """
    Controls whether audio starts muted. The media can still render visually while sound remains off until changed by the runtime or user.
    """

    artist: str | None = None
    """
    Artist name shown alongside the title.
    """

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
