from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .button import Button
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["FilledButton"]

@butterfly_control('filled_button', positional_fields=('label',))
class FilledButton(ButtonControl):
    """
    Filled emphasis button preset.

    ``FilledButton`` forwards all interaction, action dispatch, style, and
    customization behavior from :class:`Button` while forcing
    ``variant="filled"``. Use it for primary call-to-action surfaces where
    stronger visual emphasis is needed.

    In addition to typed parameters, runtime keys passed through ``**kwargs``
    are preserved. This includes optional icon/color/transparency props and
    style pipeline fields such as classes, modifiers, motion, and effects.

    Example:

    ```python
    import butterflyui as bui

    bui.FilledButton(
        "Deploy",
        action_id="deploy_release",
        icon="rocket_launch",
        transparency=0.04,
    )
    ```
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `filled_button` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `filled_button` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `filled_button` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `filled_button` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `filled_button` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `filled_button` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `filled_button` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `filled_button` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `filled_button` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `filled_button` runtime control.
    """

    icon_position: str | None = None
    """
    Icon position value forwarded to the `filled_button` runtime control.
    """

    icon_size: float | None = None
    """
    Icon size value forwarded to the `filled_button` runtime control.
    """

    icon_spacing: float | None = None
    """
    Icon spacing value forwarded to the `filled_button` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `filled_button` runtime control.
    """

    transparency: float | None = None
    """
    Transparency value forwarded to the `filled_button` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `filled_button` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `filled_button` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `filled_button` runtime control.
    """
