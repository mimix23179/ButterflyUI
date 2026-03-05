from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ...core.icon_data import normalize_icon_value
from .._shared import Component, merge_props

__all__ = ["Icon"]

class Icon(Component):
    """
    Renderable icon-value control for consistent icon payload handling.

    ``Icon`` wraps runtime icon resolution and exposes a stable Python API for
    icon name/codepoint payloads plus optional visual surface fields. It is
    designed to pair with ``Color`` and button/layout/overlay controls where
    icon rendering needs consistent serialization.

    ```python
    import butterflyui as bui

    bui.Icon(
        icon="settings",
        size=20,
        color="#60A5FA",
        background="#0B1220",
        radius=8,
        padding=6,
        tooltip="Settings",
    )
    ```

    Args:
        icon:
            Icon payload, typically a name string or codepoint integer.
        props:
            Optional prebuilt property map merged before ``**kwargs``.
        style:
            Optional style map for the control host.
        strict:
            Enables strict schema validation when supported.
        **kwargs:
            Extra runtime props forwarded to the renderer, including values such
            as ``value``, ``name``, ``size``, ``color``, ``foreground``,
            ``background``, ``bgcolor``, ``tooltip``, ``semantic_label``,
            ``padding``, ``radius``, ``border_color``, ``border_width``,
            ``auto_contrast``, and ``min_contrast``.
    """
    control_type = "icon"

    def __init__(
        self,
        icon: str | int | None = None,
        *,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, icon=icon, **kwargs)
        for key in ("icon", "value", "name", "leading_icon", "trailing_icon"):
            if key in merged:
                merged[key] = normalize_icon_value(merged[key], strict=strict)
        super().__init__(props=merged, style=style, strict=strict)

