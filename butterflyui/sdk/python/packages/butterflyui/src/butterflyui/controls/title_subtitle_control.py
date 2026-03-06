from __future__ import annotations

from .capabilities.content import TitleSubtitleProps
from .subtitle_control import SubtitleControl
from .title_control import TitleControl

__all__ = ["TitleSubtitleControl"]


class TitleSubtitleControl(TitleControl, SubtitleControl, TitleSubtitleProps):
    """Shared title/subtitle capability for controls."""
