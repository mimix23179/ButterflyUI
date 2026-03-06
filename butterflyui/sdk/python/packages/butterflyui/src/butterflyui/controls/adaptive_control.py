from __future__ import annotations

from .control import Control

__all__ = ["AdaptiveControl"]


class AdaptiveControl(Control):
    """
    Shared flag for controls that may adapt their presentation by platform.
    """

    adaptive: bool | None = None
    """
    Enables platform-adaptive rendering when supported by the runtime.
    """
