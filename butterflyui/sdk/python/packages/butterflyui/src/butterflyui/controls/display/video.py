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
            Controls whether playback starts automatically as soon as the media is ready. Leave it disabled when playback should begin only after an explicit user action.
        loop:
            Controls whether playback restarts automatically after the media reaches the end of the stream.
        muted:
            Controls whether audio starts muted. The media can still render visually while sound remains off until changed by the runtime or user.
        controls:
            Controls whether the platform's native playback controls are shown, such as play/pause, seek, volume, or fullscreen actions when available.
        fit:
            Box-fit mode (e.g. ``"contain"``, ``"cover"``).
        volume:
            Initial volume level from ``0.0`` to ``1.0``.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
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

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
