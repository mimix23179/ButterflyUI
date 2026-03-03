from __future__ import annotations

from .error_state import ErrorState

__all__ = ["ProblemScreen"]


class ProblemScreen(ErrorState):
    """Alias for :class:`ErrorState` using ``control_type='problem_screen'``."""

    control_type = "problem_screen"

