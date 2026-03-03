from __future__ import annotations

from .search_bar import SearchBar

__all__ = ["SmartSearchBar"]


class SmartSearchBar(SearchBar):
    """Alias for :class:`SearchBar` using ``control_type='smart_search_bar'``."""

    control_type = "smart_search_bar"

