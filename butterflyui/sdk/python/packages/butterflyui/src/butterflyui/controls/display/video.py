from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["Video"]

@butterfly_control('video', field_aliases={'content': 'child', 'source': 'src'})
class Video(LayoutControl, SingleChildControl):
    """
    Video player control with playback management.

    Embeds a video player backed by the platform media stack.  Supports
    ``autoplay``, ``loop``, ``muted``, and optional native ``controls``.
    A ``poster`` image can be displayed before playback starts, and
    ``fit`` controls how the video is scaled inside its container.

    Use ``play``, ``pause``, ``set_position``, and ``get_state`` to
    manage playback programmatically.

    Example:

    ```python
    import butterflyui as bui

    vid = bui.Video(
        src="/media/intro.mp4",
        poster="/media/thumb.jpg",
        autoplay=False,
        controls=True,
    )
    ```
    """

    src: str | None = None
    """
    URI or file path of the video source.
    """

    title: str | None = None
    """
    Primary title shown by the player chrome.
    """

    poster: str | None = None
    """
    Image URL shown as a thumbnail before playback.
    """

    autoplay: bool | None = None
    """
    Controls whether playback starts automatically as soon as the media is ready. Leave it disabled when playback should begin only after an explicit user action.
    """

    loop: bool | None = None
    """
    Controls whether playback restarts automatically after the media reaches the end of the stream.
    """

    muted: bool | None = None
    """
    Controls whether audio starts muted. The media can still render visually while sound remains off until changed by the runtime or user.
    """

    controls: bool | None = None
    """
    Controls whether the platform's native playback controls are shown, such as play/pause, seek, volume, or fullscreen actions when available.
    """

    fit: str | None = None
    """
    Box-fit mode (e.g. ``"contain"``, ``"cover"``).
    """

    volume: float | None = None
    """
    Initial volume level from ``0.0`` to ``1.0``.
    """

    position: float | None = None
    """
    Initial playback position, in seconds.
    """

    aspect_ratio: float | None = None
    """
    Preferred display aspect ratio when the runtime cannot derive it from the media stream yet.
    """

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})

    def set_position(self, session: Any, seconds: float) -> dict[str, Any]:
        return self.invoke(session, "set_position", {"seconds": float(seconds)})

    def set_volume(self, session: Any, volume: float) -> dict[str, Any]:
        return self.invoke(session, "set_volume", {"volume": float(volume)})

    def set_muted(self, session: Any, muted: bool) -> dict[str, Any]:
        return self.invoke(session, "set_muted", {"muted": bool(muted)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
