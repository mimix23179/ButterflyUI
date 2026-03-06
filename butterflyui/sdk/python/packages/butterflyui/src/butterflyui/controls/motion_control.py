from __future__ import annotations

from .capabilities.motion import MotionProps

__all__ = ["MotionControl"]


class MotionControl(MotionProps):
    """Shared motion capability for controls."""
