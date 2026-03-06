from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Sprite"]

@butterfly_control('sprite')
class Sprite(LayoutControl):
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

    Example:

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
    """

    src: str | None = None
    """
    Asset path or URL of the sprite-sheet image.
    """

    frame_width: float | None = None
    """
    Width of a single frame cell in logical pixels.
    """

    frame_height: float | None = None
    """
    Height of a single frame cell in logical pixels.
    """

    frames: int | None = None
    """
    Total number of frames in the sprite sheet.
    """

    fps: float | None = None
    """
    Playback speed in frames per second.
    """

    loop: bool | None = None
    """
    When ``True`` the animation repeats after the last frame.
    """

    autoplay: bool | None = None
    """
    When ``True`` playback begins immediately on mount.
    """

    play: bool | None = None
    """
    Live play/pause toggle. ``True`` plays; ``False`` pauses.
    """

    columns: int | None = None
    """
    Number of frame columns in the sprite-sheet grid.
    """

    rows: int | None = None
    """
    Number of frame rows in the sprite-sheet grid.
    """

    fit: str | None = None
    """
    Flutter ``BoxFit`` mode for rendering the sprite.
    """

    progress: float | None = None
    """
    Normalised seek position (0.0 = first frame, 1.0 = last frame).
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `sprite` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `sprite` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `sprite` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `sprite` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `sprite` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `sprite` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `sprite` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `sprite` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `sprite` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `sprite` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `sprite` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `sprite` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `sprite` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `sprite` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `sprite` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `sprite` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `sprite` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `sprite` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `sprite` runtime control.
    """

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
