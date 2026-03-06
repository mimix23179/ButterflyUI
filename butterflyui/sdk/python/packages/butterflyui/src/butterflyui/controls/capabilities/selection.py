from __future__ import annotations

from typing import Any

__all__ = ["SelectionProps", "ToggleProps"]


class SelectionProps:
    """Shared selection-list and selection-state props."""

    options: list[Any] | None = None
    """
    Option descriptors rendered by the control.
    """

    items: list[Any] | None = None
    """
    Structured item descriptors consumed by the control.
    """

    multiple: bool | None = None
    """
    Whether multiple values may be selected.
    """

    selected_index: int | None = None
    """
    Currently selected item index.
    """

    selected_value: Any = None
    """
    Currently selected value when the control exposes a value-oriented API.
    """


class ToggleProps:
    """Shared toggle-state props."""

    tristate: bool | None = None
    """
    Whether the control supports a third indeterminate state.
    """
