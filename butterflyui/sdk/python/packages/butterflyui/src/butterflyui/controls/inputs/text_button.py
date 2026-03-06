from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .button import Button
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["TextButton"]

@butterfly_control('text_button', positional_fields=('label',))
class TextButton(ButtonControl):
    """
    Low-emphasis text button preset.

    ``TextButton`` reuses :class:`Button` behavior while forcing
    ``variant="text"``. It is suited for tertiary actions, inline links, and
    toolbar actions where minimal chrome is preferred.

    The control still supports action IDs, action payloads, and runtime event
    emission. Additional visual/runtime props can be supplied through
    ``**kwargs``.

    Example:

    ```python
    import butterflyui as bui

    bui.TextButton(
        "Undo",
        action_id="undo_last",
        icon="undo",
    )
    ```
    """
