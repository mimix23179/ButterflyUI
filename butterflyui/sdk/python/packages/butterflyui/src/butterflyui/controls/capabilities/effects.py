from __future__ import annotations

from typing import Any

__all__ = ["EffectsProps"]


class EffectsProps:
    """Shared visual-effects pipeline props."""

    effects: Any = None
    """
    Effect descriptors applied to the control.
    """

    effect_order: Any = None
    """
    Ordering or composition mode used by the effects pipeline.
    """

    effect_clip: Any = None
    """
    Clip descriptor used while applying effects.
    """

    effect_target: Any = None
    """
    Named effect target or layer identifier consumed by the runtime.
    """
