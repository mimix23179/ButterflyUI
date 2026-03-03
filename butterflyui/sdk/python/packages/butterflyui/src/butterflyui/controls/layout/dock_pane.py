from __future__ import annotations

from .pane import Pane

__all__ = ["DockPane"]


class DockPane(Pane):
    """Alias for :class:`Pane` using ``control_type='dock_pane'``."""

    control_type = "dock_pane"

