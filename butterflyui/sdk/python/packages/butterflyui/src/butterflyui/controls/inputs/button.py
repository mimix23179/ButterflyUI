from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["Button"]

@butterfly_control('button', positional_fields=('label',))
class Button(ButtonControl):
    """
    Base interactive button control.

    ``Button`` is the shared click surface used by specialized button
    controls. It serializes caption, variant, events, and declarative actions
    into one runtime payload.

    In addition to typed parameters, extra keys passed via ``**kwargs`` are
    forwarded to runtime. This allows advanced visual and pipeline fields like
    ``icon``, ``color``, ``transparency``, ``classes``, ``modifiers``,
    ``motion``, and ``effects``.
    "

    Example:

    ```python
    import butterflyui as bui

    bui.Button(
        "Submit",
        variant="filled",
        action_id="submit_form",
        icon="send",
        transparency=0.08,
    )
    ```
    """
