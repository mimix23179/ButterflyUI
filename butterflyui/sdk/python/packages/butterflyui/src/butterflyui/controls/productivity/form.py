from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from ..base_control import butterfly_control
from ..input_control import InputControl

__all__ = ["Form"]

@butterfly_control('form', field_aliases={'controls': 'children'})
class Form(InputControl):
    """
    Layout container that groups form fields with an optional title and spacing.

    The runtime renders a vertical form scaffold. ``title`` and
    ``description`` add a header above the fields. ``spacing`` sets the
    gap between child field widgets. Fields are passed as children.

    Example:

    ```python
    import butterflyui as bui

    bui.Form(
        bui.FormField(bui.TextInput(), label="Name"),
        title="User Details",
        spacing=16,
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    title: str | None = None
    """
    Optional heading displayed at the top of the form.
    """

    description: str | None = None
    """
    Optional description text displayed below the title.
    """

    spacing: float | None = None
    """
    Vertical gap in logical pixels between form field children.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `form` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `form` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `form` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `form` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `form` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `form` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `form` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `form` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `form` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `form` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `form` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `form` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `form` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `form` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `form` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `form` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `form` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `form` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `form` runtime control.
    """
