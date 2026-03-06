from __future__ import annotations

from .dirty import DirtyTrackingMixin

__all__ = ["BaseNode"]


class BaseNode(DirtyTrackingMixin):
    """Minimal internal base for JSON-driven control nodes."""

    control_type: str
    control_id: str
