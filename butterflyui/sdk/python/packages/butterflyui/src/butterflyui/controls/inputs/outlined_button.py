from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .button import Button
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["OutlinedButton"]

@butterfly_control('outlined_button', positional_fields=('label',))
class OutlinedButton(ButtonControl):
    """
    Outlined emphasis button preset.

    ``OutlinedButton`` uses :class:`Button` behavior and forces
    ``variant="outlined"`` for medium-emphasis actions. It supports the same
    click events, declarative action dispatch, and runtime style/customization
    forwarding as the base button family.

    Example:

    ```python
    import butterflyui as bui

    bui.OutlinedButton(
        "Inspect",
        action_event="open_inspector",
        icon="search",
    )
    ```
    """
