from __future__ import annotations

from typing import Any

from .scope_control import ScopeControl

__all__ = ["EffectControl"]


class EffectControl(ScopeControl):
    """
    Shared child-wrapping behavior for effect and decorator controls.
    """

    child: Any = None
    """
    Primary child control wrapped by the effect.
    """
