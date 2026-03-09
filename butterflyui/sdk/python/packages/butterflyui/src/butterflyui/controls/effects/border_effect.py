from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["BorderEffect", "Border"]

@butterfly_control('border')
class BorderEffect(LayoutControl):
    """
    Wrap a child control in a configurable border decoration.
    """

    side: str | None = None
    """
    Single-side shortcut, such as ``"top"`` or ``"bottom"``.
    """

    sides: Mapping[str, Any] | None = None
    """
    Per-side border payload for advanced border configuration.
    """

    animated: bool | None = None
    """
    Whether border changes should animate.
    """

    duration_ms: int | None = None
    """
    Duration of the border animation in milliseconds.
    """

Border = BorderEffect
