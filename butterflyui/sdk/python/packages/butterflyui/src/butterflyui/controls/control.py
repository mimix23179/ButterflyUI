from __future__ import annotations

from .base_control import BaseControl
from .capabilities.core import CoreProps

__all__ = ["Control", "Component"]


class Control(BaseControl, CoreProps):
    """
    Strict core base for renderable ButterflyUI controls.
    """


Component = Control
