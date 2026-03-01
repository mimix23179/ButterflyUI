from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Switch"]

class Switch(Component):
    """
    Boolean toggle switch.

    Renders a Flutter ``Switch`` (or ``SwitchListTile`` when ``label``
    is provided).  Toggling the switch emits a ``change`` event with
    the new boolean value.  When ``inline`` is ``True`` the label and
    switch are arranged in a single row; otherwise the label appears
    above the control.

    ```python
    import butterflyui as bui

    bui.Switch(value=False, label="Notifications", inline=True)
    ```

    Args:
        value:
            Current boolean state of the switch.
        label:
            Text label rendered beside or above the switch.
        inline:
            If ``True``, label and switch share a single row
            (``SwitchListTile`` layout).
    """
    control_type = "switch"

    def __init__(
        self,
        value: bool | None = None,
        *,
        label: str | None = None,
        inline: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            label=label,
            inline=inline,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
