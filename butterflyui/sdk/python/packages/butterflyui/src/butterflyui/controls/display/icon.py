from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Icon"]

class Icon(Component):
    """
    Render a resolved icon glyph with optional surface styling and contrast hints.

    ``Icon`` is a thin Python wrapper over the runtime icon renderer. The runtime
    accepts flexible icon payloads (name aliases, integer code points, and map
    payloads) and can apply background/border/padding tokens so the icon remains
    legible inside layout and overlay surfaces.

    Supported icon payload forms:
    - icon name: ``"settings"`` or ``"chevron_right"``
    - integer code point: ``0xe8b8``
    - structured map:
      ``{"codepoint": 0xe8b8, "font_family": "MaterialIcons", "color": "#60A5FA"}``

    Example::

        import butterflyui as bui

        ic = bui.Icon(
            icon="settings",
            size=20,
            color={"token": "primary", "auto_contrast": True},
            background="#0B1220",
            border_color="#334155",
            border_width=1,
            radius=8,
            padding=6,
            tooltip="Settings",
        )

    Args:
        icon:
            Icon payload resolved by the runtime. Usually a name string or integer
            code point.
        props:
            Optional prebuilt property map merged before ``kwargs``.
        style:
            Optional style-slot map consumed by universal decorators.
        strict:
            Enables strict schema validation in supported runtimes.
        **kwargs:
            Additional runtime props such as ``value``, ``name``, ``size``,
            ``color``, ``foreground``, ``background``, ``bgcolor``, ``tooltip``,
            ``semantic_label``, ``padding``, ``radius``, ``border_color``,
            ``border_width``, ``auto_contrast``, and ``min_contrast``.
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
        super().__init__(props=merged, style=style, strict=strict)
