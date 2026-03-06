from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["KeyListener"]

@butterfly_control('key_listener')
class KeyListener(LayoutControl):
    """
    Captures raw keyboard events for the subtree below it.

    Wraps the child in a Flutter ``Focus`` widget and a
    ``KeyEventListener`` (or equivalent) that intercepts
    ``KeyDownEvent``, ``KeyUpEvent``, and ``KeyRepeatEvent``.
    Each intercepted event emits a ``key_down``, ``key_up``, or
    ``key_repeat`` event with a payload containing ``key`` (logical
    key name), ``physical_key`` (physical key code), and
    ``modifiers`` (active modifier flags).

    Setting ``autofocus`` causes the node to grab keyboard focus
    immediately when mounted so events are captured without a
    preceding tap.

    Example:

    ```python
    import butterflyui as bui

    bui.KeyListener(
        bui.TextField(),
        autofocus=True,
    )
    ```
    """

    autofocus: bool | None = None
    """
    If ``True``, the focus node requests focus when first
    mounted.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `key_listener` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `key_listener` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `key_listener` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `key_listener` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `key_listener` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `key_listener` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `key_listener` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `key_listener` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `key_listener` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `key_listener` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `key_listener` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `key_listener` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `key_listener` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `key_listener` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `key_listener` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `key_listener` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `key_listener` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `key_listener` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `key_listener` runtime control.
    """
