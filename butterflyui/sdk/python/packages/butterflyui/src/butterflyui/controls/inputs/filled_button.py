from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .button import Button
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["FilledButton"]

@butterfly_control('filled_button', positional_fields=('label',))
class FilledButton(ButtonControl):
    """
    Filled emphasis button preset.

    ``FilledButton`` forwards all interaction, action dispatch, style, and
    customization behavior from :class:`Button` while forcing
    ``variant="filled"``. Use it for primary call-to-action surfaces where
    stronger visual emphasis is needed.

    In addition to typed parameters, runtime keys passed through ``**kwargs``
    are preserved. This includes optional icon/color/transparency props and
    style pipeline fields such as classes, modifiers, motion, and effects.

    Example:

    ```python
    import butterflyui as bui

    bui.FilledButton(
        "Deploy",
        action_id="deploy_release",
        icon="rocket_launch",
        transparency=0.04,
    )
    ```
    """
