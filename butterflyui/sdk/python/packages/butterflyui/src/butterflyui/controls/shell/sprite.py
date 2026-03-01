from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Sprite"]

class Sprite(Component):
    """
    Sprite-sheet animation player that steps through frames at a given FPS.

    The runtime loads an image sprite sheet from ``src`` and plays it as an
    animation. ``frame_width``/``frame_height`` define the size of each frame
    cell. ``frames`` sets the total number of frames. ``fps`` controls the
    playback rate. ``loop`` repeats continuously. ``autoplay`` starts on
    mount. ``play`` is a live toggle for play/pause. ``columns``/``rows``
    describe the sprite-sheet grid. ``fit`` sets the Flutter box-fit mode.
    ``opacity`` controls transparency. ``progress`` seeks to a fractional
    position (0.0--1.0).

    ```python
    import butterflyui as bui

    bui.Sprite(
        src="assets/explosion.png",
        frame_width=64,
        frame_height=64,
        frames=16,
        fps=24.0,
        loop=True,
        autoplay=True,
        events=["complete"],
    )
    ```

    Args:
        src:
            Asset path or URL of the sprite-sheet image.
        frame_width:
            Width of a single frame cell in logical pixels.
        frame_height:
            Height of a single frame cell in logical pixels.
        frames:
            Total number of frames in the sprite sheet.
        fps:
            Playback speed in frames per second.
        loop:
            When ``True`` the animation repeats after the last frame.
        autoplay:
            When ``True`` playback begins immediately on mount.
        play:
            Live play/pause toggle. ``True`` plays; ``False`` pauses.
        columns:
            Number of frame columns in the sprite-sheet grid.
        rows:
            Number of frame rows in the sprite-sheet grid.
        fit:
            Flutter ``BoxFit`` mode for rendering the sprite.
        opacity:
            Opacity value in the range 0.0--1.0.
        progress:
            Normalised seek position (0.0 = first frame, 1.0 = last frame).
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "sprite"

    def __init__(
        self,
        *,
        src: str | None = None,
        frame_width: float | None = None,
        frame_height: float | None = None,
        frames: int | None = None,
        fps: float | None = None,
        loop: bool | None = None,
        autoplay: bool | None = None,
        play: bool | None = None,
        columns: int | None = None,
        rows: int | None = None,
        fit: str | None = None,
        opacity: float | None = None,
        progress: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            kind="sprite",
            frame_width=frame_width,
            frame_height=frame_height,
            frames=frames,
            fps=fps,
            loop=loop,
            autoplay=autoplay,
            play=play,
            columns=columns,
            rows=rows,
            fit=fit,
            opacity=opacity,
            progress=progress,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
