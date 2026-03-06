from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..selection_control import SelectionControl

__all__ = ["Dropdown"]

@butterfly_control('dropdown', positional_fields=('value',))
class Dropdown(SelectionControl):
    """
    Non-editable drop-down select rendered as a ``Combobox``.

    Extends :class:`Combobox` but maps to the ``dropdown`` control type
    on the Flutter side, which may render as a pure select-only
    dropdown rather than an editable text field.  Supports the same
    option, grouping, async-source, and imperative methods as
    :class:`Combobox`.

    Example:

    ```python
    import butterflyui as bui

    bui.Dropdown(
        options=["Small", "Medium", "Large"],
        label="Size",
        value="Medium",
    )
    ```
    """

    groups: list[Mapping[str, Any]] | None = None
    """
    List of grouped option sections, each with
    ``"label"`` and ``"options"`` keys.
    """

    hint: str | None = None
    """
    Hint/placeholder text shown when nothing is selected.
    """

    loading: bool | None = None
    """
    If ``True``, a progress indicator is shown.
    """

    async_source: str | None = None
    """
    Async data source identifier or configuration used to fetch items for this control on demand.
    """
