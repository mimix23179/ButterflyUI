from __future__ import annotations

from .capabilities.content import MultiChildProps

__all__ = ["MultiChildControl"]


class MultiChildControl(MultiChildProps):
    """Shared `controls` slot capability for controls."""
