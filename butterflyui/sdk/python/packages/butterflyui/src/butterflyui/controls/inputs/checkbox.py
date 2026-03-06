from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..toggle_control import ToggleControl

__all__ = ["Checkbox"]

@butterfly_control('checkbox', positional_fields=('value',))
class Checkbox(ToggleControl):
    """
    Single boolean check-box with an optional text label.

    Renders a Flutter ``Checkbox`` (or ``CheckboxListTile`` when
    ``label`` is provided).  When ``tristate`` is ``True`` the control
    cycles through ``True``, ``False``, and ``None`` (indeterminate).
    Toggling the checkbox emits a ``change`` event with the new value.

    Example:

    ```python
    import butterflyui as bui

    bui.Checkbox(value=True, label="Accept terms")
    ```
    """
