from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Switch"]


class Switch(Component):
    """
    Boolean switch input with optional segmented presentation.
    
    ``Switch`` now also covers segmented-switch use cases through ``mode`` and
    ``segments``. In default mode it behaves like a standard on/off toggle;
    segmented mode allows richer labels and grouped state presentation.

    Example:
    
    ```python
    import butterflyui as bui
    
    toggle = bui.Switch(
        value=True,
        label="Notifications",
        on_label="On",
        off_label="Off",
    )
    ```
    """


    value: bool | None = None
    """
    Current value rendered or edited by the control. The exact payload shape depends on the control type.
    """

    label: str | None = None
    """
    Primary label text rendered by the control or its active action.
    """

    inline: bool | None = None
    """
    If ``True``, aligns label and switch inline.
    """

    mode: str | None = None
    """
    Rendering mode (for example ``"toggle"`` or ``"segmented"``
    depending on renderer support).
    """

    on_label: str | None = None
    """
    Label text shown when the control is in its on or enabled state.
    """

    off_label: str | None = None
    """
    Label text shown when the control is in its off or disabled state.
    """

    segments: list[Any] | None = None
    """
    Segment descriptors for segmented presentation mode.
    """

    control_type = "switch"

    def __init__(
        self,
        value: bool | None = None,
        *,
        label: str | None = None,
        inline: bool | None = None,
        mode: str | None = None,
        on_label: str | None = None,
        off_label: str | None = None,
        segments: list[Any] | None = None,
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
                        mode=mode,
                        on_label=on_label,
                        off_label=off_label,
                        segments=segments,
                        **kwargs,
                    )
        super().__init__(
            props=merged,
            style=style,
            strict=strict,
        )

    def set_value(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})
