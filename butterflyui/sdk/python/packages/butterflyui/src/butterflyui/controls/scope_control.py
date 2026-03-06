from __future__ import annotations

from .layout_control import LayoutControl

__all__ = ["ScopeControl"]


class ScopeControl(LayoutControl):
    """
    Shared subtree scope behavior for style and umbrella controls.
    """
