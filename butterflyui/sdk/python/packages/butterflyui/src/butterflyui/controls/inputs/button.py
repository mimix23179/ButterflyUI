from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["Button"]

@butterfly_control('button', positional_fields=('label',))
class Button(ButtonControl):
    """
    Base interactive button control.

    ``Button`` is the shared click surface used by specialized button
    controls. It serializes caption, variant, events, and declarative actions
    into one runtime payload.

    In addition to typed parameters, extra keys passed via ``**kwargs`` are
    forwarded to runtime. This allows advanced visual and pipeline fields like
    ``icon``, ``color``, ``transparency``, ``classes``, ``modifiers``,
    ``motion``, and ``effects``.
    "

    Example:

    ```python
    import butterflyui as bui

    bui.Button(
        "Submit",
        variant="filled",
        action_id="submit_form",
        icon="send",
        transparency=0.08,
    )
    ```
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `button` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `button` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `button` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `button` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `button` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `button` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `button` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `button` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `button` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `button` runtime control.
    """

    icon_position: str | None = None
    """
    Icon position value forwarded to the `button` runtime control.
    """

    icon_size: float | None = None
    """
    Icon size value forwarded to the `button` runtime control.
    """

    icon_spacing: float | None = None
    """
    Icon spacing value forwarded to the `button` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `button` runtime control.
    """

    transparency: float | None = None
    """
    Transparency value forwarded to the `button` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `button` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `button` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `button` runtime control.
    """
