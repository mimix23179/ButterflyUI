from __future__ import annotations

from .dock_layout import DockLayout

__all__ = ["Dock"]


class Dock(DockLayout):
    """Alias for :class:`DockLayout` using ``control_type='dock'``."""

    control_type = "dock"

