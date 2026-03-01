from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DecoratedBox"]

class DecoratedBox(Component):
    """
    Paints a decoration (color, gradient, border, shadow) behind its child.

    The runtime wraps Flutter's ``DecoratedBox``. ``color``/``bgcolor`` set a
    solid background. ``gradient`` accepts a mapping describing a
    ``LinearGradient`` or ``RadialGradient``. ``image`` sets a
    ``DecorationImage``. ``shadow`` accepts a list of box-shadow specs.
    ``shape`` can be ``"rectangle"`` (default) or ``"circle"``.

    ```python
    import butterflyui as bui

    bui.DecoratedBox(
        bui.Text("Styled"),
        bgcolor="#2196F3",
        radius=12,
        padding=16,
    )
    ```

    Args:
        color:
            Background fill color. Alias for ``bgcolor``.
        bgcolor:
            Background fill color. Alias for ``color``.
        gradient:
            Gradient spec mapping (e.g. ``LinearGradient`` or
            ``RadialGradient``).
        image:
            ``DecorationImage`` spec mapping shown as a background image.
        border_color:
            Border stroke color.
        border_width:
            Border stroke width in logical pixels.
        radius:
            Corner radius in logical pixels.
        shape:
            Box shape. Values: ``"rectangle"`` (default), ``"circle"``.
        shadow:
            List of box-shadow spec mappings.
        padding:
            Inner spacing applied before the decoration is painted.
        margin:
            Outer spacing around the decorated box.
        clip_behavior:
            Anti-aliasing clip mode applied to the decoration boundary.
    """

    control_type = "decorated_box"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        color: Any | None = None,
        bgcolor: Any | None = None,
        gradient: Mapping[str, Any] | None = None,
        image: Mapping[str, Any] | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: float | None = None,
        shape: str | None = None,
        shadow: Any | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        clip_behavior: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            bgcolor=bgcolor if bgcolor is not None else color,
            gradient=dict(gradient) if gradient is not None else None,
            image=dict(image) if image is not None else None,
            border_color=border_color,
            border_width=border_width,
            radius=radius,
            shape=shape,
            shadow=shadow,
            padding=padding,
            margin=margin,
            clip_behavior=clip_behavior,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
