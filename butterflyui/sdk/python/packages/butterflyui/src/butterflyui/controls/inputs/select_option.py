from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .option import Option

__all__ = ["SelectOption"]

class SelectOption(Option):
    """
    Option item specialised for use inside a :class:`Select` control.

    Subclass of :class:`Option` that maps to the ``select_option``
    control type.  The Flutter side may apply select-specific visual
    treatment (e.g. a checkmark beside the active item).  All
    :class:`Option` parameters are available.

    ```python
    import butterflyui as bui

    bui.Select(
        bui.SelectOption("Python", value="py"),
        bui.SelectOption("Dart", value="dart"),
        bui.SelectOption("Rust", value="rs"),
    )
    ```

    Args:
        label:
            Display text for the option.
        value:
            Machine-readable value emitted with selection events.
        description:
            Secondary subtitle text rendered below the label.
        icon:
            Leading icon name or codepoint.
        selected:
            If ``True``, this option is pre-selected.
        enabled:
            If ``False``, the option is non-interactive.
        dense:
            If ``True``, the item uses compact height.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "select_option"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        description: str | None = None,
        icon: str | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=label,
            value=value,
            description=description,
            icon=icon,
            selected=selected,
            enabled=enabled,
            dense=dense,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
