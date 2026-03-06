from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Video"]

@butterfly_control('video', field_aliases={'content': 'child'})
class Video(LayoutControl):
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

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    src: str | None = None
    """
    URI or file path of the video source.
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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `video` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `video` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `video` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `video` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `video` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `video` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `video` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `video` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `video` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `video` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `video` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `video` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `video` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `video` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `video` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `video` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `video` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `video` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `video` runtime control.
    """

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
