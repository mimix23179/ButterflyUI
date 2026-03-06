from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["BorderSide"]

@butterfly_control('border_side')
class BorderSide(LayoutControl):
    """
    Renders a single border line on one or more sides of the parent.

    Unlike :class:`Border`, which wraps a child, ``BorderSide`` draws a
    standalone line (a thin ``SizedBox`` with a side decoration). It is
    useful for separator-style borders. It also accepts per-side maps via
    `top`, `right`, `bottom`, and `left` for individual configuration.

    ```python
    import butterflyui as bui

    bui.BorderSide(side="bottom", color="#64748b", width=1)
    ```
    """

    side: str | None = None
    """
    Which side to draw: ``"top"``, ``"right"``, ``"bottom"`` (default), or ``"left"``.
    """

    color: Any | None = None
    """
    Line colour. Defaults to ``"#64748b"`` (slate-500).
    """

    length: float | None = None
    """
    Line length in logical pixels. Defaults to ``double.infinity`` (stretches to fill).
    """

    animated: bool | None = None
    """
    If ``True``, transitions are animated via ``AnimatedContainer``.
    """

    duration_ms: int | None = None
    """
    Animation duration in milliseconds. Defaults to ``180``.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `border_side` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `border_side` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `border_side` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `border_side` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `border_side` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `border_side` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `border_side` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `border_side` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `border_side` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `border_side` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `border_side` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `border_side` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `border_side` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `border_side` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `border_side` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `border_side` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `border_side` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `border_side` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `border_side` runtime control.
    """

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
