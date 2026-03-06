from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["Option"]

@butterfly_control('option', positional_fields=('label',))
class Option(FormFieldControl):
    """
    Single selectable option item for use inside list or select controls.

    Renders a ``ListTile``-style item with an optional leading icon,
    description subtitle, and checkbox/radio indicator depending on
    the parent context.  Tapping the item emits a ``select`` event
    carrying ``label`` and ``value``.  Setting ``selected`` pre-checks
    the item; setting ``enabled`` to ``False`` makes it non-interactive.

    Example:

    ```python
    import butterflyui as bui

    bui.Option(
        "Python",
        value="python",
        description="General-purpose scripting language",
        icon="code",
    )
    ```
    """

    description: str | None = None
    """
    Secondary subtitle text rendered below the label.
    """

    icon: str | None = None
    """
    Icon value or icon descriptor rendered by the control.
    """

    selected: bool | None = None
    """
    If ``True``, the option is pre-selected.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `option` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `option` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `option` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `option` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `option` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `option` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `option` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `option` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `option` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `option` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `option` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `option` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `option` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `option` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `option` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `option` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `option` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `option` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `option` runtime control.
    """

    def emit(self, session: Any, event: str = "select", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
