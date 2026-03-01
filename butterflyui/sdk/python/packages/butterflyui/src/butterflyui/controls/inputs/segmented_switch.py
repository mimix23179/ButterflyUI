from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .switch import Switch

__all__ = ["SegmentedSwitch"]

class SegmentedSwitch(Switch):
    """
    Toggle switch styled as a segmented control.

    Extends :class:`Switch` but maps to the ``segmented_switch``
    control type, which the Flutter side may render as a two-segment
    pill (e.g. *On* / *Off*) instead of a standard thumb-track switch.
    All :class:`Switch` parameters apply unchanged.

    ```python
    import butterflyui as bui

    bui.SegmentedSwitch(value=True, label="Dark mode", inline=True)
    ```

    Args:
        value:
            Current boolean state of the switch.
        label:
            Text label rendered beside the control.
        inline:
            If ``True``, label and switch are arranged in a single row.
    """
    control_type = "segmented_switch"

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
        super().__init__(
            value=value,
            label=label,
            inline=inline,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
