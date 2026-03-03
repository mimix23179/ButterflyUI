from __future__ import annotations

from .empty_state import EmptyState

__all__ = ["EmptyStateView"]


class EmptyStateView(EmptyState):
    """Alias for :class:`EmptyState` using ``control_type='empty_state_view'``."""

    control_type = "empty_state_view"

