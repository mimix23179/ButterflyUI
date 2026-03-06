from __future__ import annotations

from typing import Any

__all__ = ["MotionProps"]


class MotionProps:
    """Shared motion and animation-pipeline props."""

    motion: Any = None
    """
    Primary motion descriptor applied by the runtime.
    """

    enter_motion: Any = None
    """
    Motion descriptor used when the control enters.
    """

    exit_motion: Any = None
    """
    Motion descriptor used when the control exits.
    """

    hover_motion: Any = None
    """
    Motion descriptor used while the control is hovered.
    """

    press_motion: Any = None
    """
    Motion descriptor used while the control is pressed.
    """

    animate: Any = None
    """
    Implicit animation descriptor used by the runtime.
    """

    autoplay: bool | None = None
    """
    Whether playback or animation should start automatically.
    """

    loop: bool | None = None
    """
    Whether motion playback should loop.
    """
