from __future__ import annotations

from .child_control import ChildControl
from .scope_control import ScopeControl

__all__ = ["EffectControl"]


class EffectControl(ScopeControl, ChildControl):
    """
    Shared child-wrapping behavior for effect and decorator controls.
    """
