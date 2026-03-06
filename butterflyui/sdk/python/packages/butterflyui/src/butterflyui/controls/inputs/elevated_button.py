from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .button import Button
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["ElevatedButton"]

@butterfly_control('elevated_button', positional_fields=('label',))
class ElevatedButton(ButtonControl):
    """
    Raised button preset with ``variant="elevated"``.

    ``ElevatedButton`` forwards the standard :class:`Button` interaction and
    action pipeline while enforcing the elevated visual variant. Use this for
    actions that need stronger depth or separation from surrounding surfaces.

    As with other button wrappers, extra runtime keys passed via ``**kwargs``
    are forwarded unchanged, including icon/color/transparency and style
    pipeline fields.

    Example:

    ```python
    import butterflyui as bui

    bui.ElevatedButton(
        "Confirm",
        value="confirm",
        action_id="confirm_dialog",
        icon="check",
    )
    ```
    """
