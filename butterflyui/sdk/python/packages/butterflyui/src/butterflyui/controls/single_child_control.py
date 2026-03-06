from __future__ import annotations

from .capabilities.content import SingleChildProps

__all__ = ["SingleChildControl"]


class SingleChildControl(SingleChildProps):
    """Shared `content` slot capability for controls."""
