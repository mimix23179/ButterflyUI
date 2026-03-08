from __future__ import annotations

from ..base_control import butterfly_control
from .grid import Grid

__all__ = ["GridView"]


@butterfly_control('grid_view', field_aliases={'controls': 'children'})
class GridView(Grid):
    """
    Grid alias that maps directly to the ``grid_view`` runtime control.

    Shares the same Python API as :class:`Grid` but targets the dedicated
    runtime control name used by the Dart renderer and schema hints.
    """
