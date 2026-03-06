from __future__ import annotations

from typing import Any

from .form_field_control import FormFieldControl

__all__ = ["SelectionControl"]


class SelectionControl(FormFieldControl):
    """
    Shared selection-list behavior for choice-based controls.
    """

    options: list[Any] | None = None
    """
    Choice options rendered by the control.
    """

    items: list[Any] | None = None
    """
    Item descriptors rendered by the control.
    """

    multiple: bool | None = None
    """
    Whether multiple values may be selected at the same time.
    """

    selected_index: int | None = None
    """
    Currently selected item index when index-based selection is used.
    """
