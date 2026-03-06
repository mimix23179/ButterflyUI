from __future__ import annotations

from typing import Any

__all__ = ["SurfaceProps"]


class SurfaceProps:
    """Shared surface, decoration, and shell-paint props."""

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    border: Any | None = None
    """
    Border descriptor used when rendering the control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    border_width: float | None = None
    """
    Border width in logical pixels.
    """

    radius: float | None = None
    """
    Corner radius used when painting the control.
    """

    shadow: Any | None = None
    """
    Shadow descriptor rendered beneath the control.
    """

    shadow_color: Any | None = None
    """
    Shadow color used by the runtime.
    """

    elevation: Any | None = None
    """
    Elevation token or explicit value used by the runtime.
    """

    gradient: Any | None = None
    """
    Gradient descriptor used to paint the control background.
    """

    shape: Any | None = None
    """
    Shape descriptor used by the runtime when painting the surface.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior applied when painting or clipping the control contents.
    """
