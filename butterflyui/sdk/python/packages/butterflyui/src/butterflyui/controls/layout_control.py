from __future__ import annotations

from typing import Any

from .capabilities.layout import LayoutProps
from .control import Control
from .effects_control import EffectsControl
from .modifier_control import ModifierControl
from .motion_control import MotionControl
from .style_control import StyleControl
from .surface_control import SurfaceControl

__all__ = ["LayoutControl"]


class LayoutControl(
    Control,
    LayoutProps,
    SurfaceControl,
    StyleControl,
    MotionControl,
    ModifierControl,
    EffectsControl,
):
    """
    Shared layout behavior for visual ButterflyUI controls.
    """

    def frame(self, **kwargs: Any) -> "LayoutControl":
        self.patch(**kwargs)
        return self
