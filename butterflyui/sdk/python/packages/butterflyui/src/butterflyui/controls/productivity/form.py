from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from ..base_control import butterfly_control
from ..input_control import InputControl

from ..multi_child_control import MultiChildControl
from ..title_control import TitleControl
__all__ = ["Form"]

@butterfly_control('form', field_aliases={'controls': 'children'})
class Form(InputControl, MultiChildControl, TitleControl):
    """
    Layout container that groups form fields with an optional title and spacing.

    The runtime renders a vertical form scaffold. ``title`` and
    ``description`` add a header above the fields. ``spacing`` sets the
    gap between child field widgets. Fields are passed as children.

    Example:

    ```python
    import butterflyui as bui

    bui.Form(
        bui.FormField(bui.TextInput(), label="Name"),
        title="User Details",
        spacing=16,
    )
    ```
    """

    description: str | None = None
    """
    Optional description text displayed below the title.
    """

    spacing: float | None = None
    """
    Vertical gap in logical pixels between form field children.
    """
