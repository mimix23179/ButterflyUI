from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["FlexSpacer"]

@butterfly_control('flex_spacer')
class FlexSpacer(LayoutControl):
    """
    Invisible spacer that consumes flex space inside a ``Row`` or ``Column``.

    The runtime maps to Flutter's ``Spacer`` (a zero-sized ``Expanded``).
    ``flex`` is the flex factor; larger values claim more of the available
    space relative to sibling flex children.

    Example:

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.FlexSpacer(flex=1),
        bui.Text("Right"),
    )
    ```
    """
