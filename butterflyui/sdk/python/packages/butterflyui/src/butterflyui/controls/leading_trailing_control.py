from __future__ import annotations

from .capabilities.content import LeadingTrailingProps
from .leading_control import LeadingControl
from .trailing_control import TrailingControl

__all__ = ["LeadingTrailingControl"]


class LeadingTrailingControl(LeadingControl, TrailingControl, LeadingTrailingProps):
    """Shared leading/trailing slot capability for controls."""
