from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..selection_control import SelectionControl

__all__ = ["Select"]

@butterfly_control('select')
class Select(SelectionControl):
    """
    Drop-down select control for choosing one item from a list.

    Renders a Flutter ``DropdownButton`` (or equivalent) that opens an
    option list overlay on tap.  The selected item is identified by
    ``value`` or ``index``.  Selecting a different option emits a
    ``change`` event carrying the new ``value`` and ``index``.

    Example:

    ```python
    import butterflyui as bui

    bui.Select(
        options=["Small", "Medium", "Large"],
        value="Medium",
        label="Size",
    )
    ```
    """

    index: int | None = None
    """
    Zero-based index of the initially selected option.
    """

    hint: str | None = None
    """
    Hint text shown when no option is selected.
    """
