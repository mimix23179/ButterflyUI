from __future__ import annotations

from .capabilities.surface import SurfaceProps

__all__ = ["SurfaceControl"]


class SurfaceControl(SurfaceProps):
    """Shared surface/decoration capability for controls."""
