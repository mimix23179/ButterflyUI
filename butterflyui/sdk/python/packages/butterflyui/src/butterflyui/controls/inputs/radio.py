from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..toggle_control import ToggleControl

__all__ = ["Radio"]

@butterfly_control('radio')
class Radio(ToggleControl):
    """
    Group of radio buttons for mutually exclusive single selection.

    Renders a vertical list of ``RadioListTile`` widgets, one per
    entry in ``options``.  Exactly one option can be active at a
    time.  The active item is identified by ``value`` or ``index``.
    Selecting a different option emits a ``change`` event with the
    new ``value`` and ``index``.

    Example:

    ```python
    import butterflyui as bui

    bui.Radio(
        options=["Option A", "Option B", "Option C"],
        value="Option A",
        label="Choose one",
    )
    ```
    """

    options: list[Any] | None = None
    """
    List of option items.  Each entry may be a plain string
    or a mapping with ``"label"`` and ``"value"`` keys.
    """

    index: int | None = None
    """
    Zero-based index of the initially selected option.
    """
