from __future__ import annotations

from .tree_view import TreeView

__all__ = ["Tree"]


class Tree(TreeView):
    """Alias for :class:`TreeView` using ``control_type='tree'``."""

    control_type = "tree"

