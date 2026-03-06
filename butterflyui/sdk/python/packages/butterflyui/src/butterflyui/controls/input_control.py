from __future__ import annotations

from typing import Any

from .layout_control import LayoutControl

__all__ = ["InputControl"]


class InputControl(LayoutControl):
    """
    Shared input behavior for controls that carry a user-editable value.
    """

    value: Any = None
    """
    Current value held by the input control.
    """

    label: str | None = None
    """
    Human-readable label shown with the input.
    """

    placeholder: str | None = None
    """
    Hint text shown when the input value is empty.
    """
