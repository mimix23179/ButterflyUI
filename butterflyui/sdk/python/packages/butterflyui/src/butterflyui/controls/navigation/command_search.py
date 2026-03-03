from __future__ import annotations

from .command_palette import CommandPalette

__all__ = ["CommandSearch"]


class CommandSearch(CommandPalette):
    """Alias for :class:`CommandPalette` using ``control_type='command_search'``."""

    control_type = "command_search"

