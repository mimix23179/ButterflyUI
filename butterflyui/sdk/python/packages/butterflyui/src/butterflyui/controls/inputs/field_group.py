from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["FieldGroup"]

@butterfly_control('field_group')
class FieldGroup(FormFieldControl):
    """
    Labeled vertical container for grouping related form fields.

    Renders a Flutter ``Column`` with an optional bold ``label``
    header, uniform ``spacing`` between child widgets, an optional
    ``helper_text`` shown below the group in a subdued style, and an
    optional ``error_text`` shown in red.  When ``required`` is
    ``True`` a red asterisk is appended to the label.

    Example:

    ```python
    import butterflyui as bui

    bui.FieldGroup(
        bui.TextField(label="First name"),
        bui.TextField(label="Last name"),
        label="Full name",
        required=True,
    )
    ```
    """

    spacing: float | None = None
    """
    Vertical gap in logical pixels between children.
    Defaults to ``8``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `field_group` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `field_group` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `field_group` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `field_group` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `field_group` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `field_group` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `field_group` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `field_group` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `field_group` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `field_group` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `field_group` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `field_group` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `field_group` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `field_group` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `field_group` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `field_group` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `field_group` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `field_group` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `field_group` runtime control.
    """
