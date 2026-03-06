from __future__ import annotations

from typing import Any

__all__ = ["ModifierProps"]


class ModifierProps:
    """Shared stateful modifier-pipeline props."""

    modifiers: Any = None
    """
    Modifier descriptors applied to the control.
    """

    on_hover_modifiers: Any = None
    """
    Modifier descriptors applied while the control is hovered.
    """

    on_pressed_modifiers: Any = None
    """
    Modifier descriptors applied while the control is pressed.
    """

    on_focus_modifiers: Any = None
    """
    Modifier descriptors applied while the control is focused.
    """
