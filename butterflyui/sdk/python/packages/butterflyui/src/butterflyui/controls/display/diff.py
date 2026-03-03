from __future__ import annotations

from .diff_view import DiffView

__all__ = ["Diff"]


class Diff(DiffView):
    """Alias for :class:`DiffView` using ``control_type='diff'``."""

    control_type = "diff"

