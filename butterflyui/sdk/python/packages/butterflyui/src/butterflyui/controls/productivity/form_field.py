from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["FormField"]

@butterfly_control('form_field')
class FormField(FormFieldControl):
    """
    Labeled wrapper that adds decoration and validation state to a form input.

    The runtime wraps any input widget with a label row, optional helper
    text, and error text. ``label`` names the field. ``description`` adds
    a secondary hint. ``required`` appends a required indicator to the label.
    ``helper_text`` shows a hint below the input. ``error_text`` displays a
    validation error message.

    Example:

    ```python
    import butterflyui as bui

    bui.FormField(
        bui.TextInput(placeholder="Enter your name"),
        label="Full Name",
        required=True,
        helper_text="As shown on your ID",
    )
    ```
    """

    description: str | None = None
    """
    Secondary hint text displayed below the label.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `form_field` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `form_field` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `form_field` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `form_field` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `form_field` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `form_field` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `form_field` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `form_field` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `form_field` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `form_field` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `form_field` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `form_field` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `form_field` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `form_field` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `form_field` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `form_field` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `form_field` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `form_field` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `form_field` runtime control.
    """
