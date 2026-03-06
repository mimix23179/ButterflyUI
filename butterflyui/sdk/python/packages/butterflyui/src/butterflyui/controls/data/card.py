from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Card"]

@butterfly_control('card', field_aliases={'content': 'child'})
class Card(LayoutControl):
    """
    Material-style surface container that wraps a single child control
    inside a rounded, optionally elevated panel.

    The runtime renders a Flutter ``Card`` whose background colour falls
    back to the active Candy ``surface`` token, border colour to the
    ``border`` token, and corner radius to the theme's ``card.radius``
    or ``radii.md`` token.  An optional ``content_padding`` is applied as
    inner ``Padding``, and ``content_alignment`` positions the child
    inside the card via ``Align``.

    ```python
    import butterflyui as bui

    bui.Card(
        bui.Text("Hello from a card!"),
        radius=12,
        elevated=True,
        content_padding=16,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    title: str | None = None
    """
    Optional primary title text forwarded as metadata in the control props.
    """

    subtitle: str | None = None
    """
    Optional secondary title text forwarded as metadata in the control props.
    """

    elevated: bool | None = None
    """
    If ``True``, applies elevated card styling with a non-zero ``elevation`` value.
    """

    radius: float | None = None
    """
    Corner radius in logical pixels.  Overrides the Candy ``card.radius`` / ``radii.md`` tokens.
    """

    content_padding: Any | None = None
    """
    Inner padding applied around the card's child content (single number or per-edge spec).
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    elevation: Any | None = None
    """
    Elevation value forwarded to the `card` runtime control.
    """

    shape: Any | None = None
    """
    Shape value forwarded to the `card` runtime control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `card` runtime control.
    """

    surface_tint_color: Any | None = None
    """
    Surface tint color value forwarded to the `card` runtime control.
    """

    shadow_color: Any | None = None
    """
    Shadow color value forwarded to the `card` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `card` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `card` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `card` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `card` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `card` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `card` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `card` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `card` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `card` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `card` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `card` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `card` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `card` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `card` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `card` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `card` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `card` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `card` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `card` runtime control.
    """
