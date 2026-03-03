from __future__ import annotations

from .outline import Outline

__all__ = ["OutlineView"]


class OutlineView(Outline):
    """Alias for :class:`Outline` using ``control_type='outline_view'``."""

    control_type = "outline_view"

