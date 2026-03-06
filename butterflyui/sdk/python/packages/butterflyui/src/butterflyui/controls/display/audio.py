from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Audio"]

@butterfly_control('audio')
class Audio(LayoutControl):
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

    title: str | None = None
    """
    Display title shown in the player chrome.
    """

    artist: str | None = None
    """
    Artist name shown alongside the title.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `audio` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `audio` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `audio` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `audio` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `audio` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `audio` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `audio` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `audio` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `audio` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `audio` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `audio` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `audio` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `audio` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `audio` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `audio` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `audio` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `audio` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `audio` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `audio` runtime control.
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
