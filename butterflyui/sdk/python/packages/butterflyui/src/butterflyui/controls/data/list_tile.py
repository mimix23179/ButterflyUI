from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ListTile"]

@butterfly_control('list_tile')
class ListTile(LayoutControl):
    """
    Data-oriented list tile with selectable and disabled states, leading/
    trailing icons, and tap-to-select behaviour.

    The runtime renders a Material ``ListTile`` whose ``title`` falls
    back through ``label`` and ``text`` props.  ``leading_icon`` (also
    matched from ``icon`` or ``leading_text``) is resolved via
    ``buildIconValue`` into a 18 px icon widget; ``trailing_icon``
    likewise.  ``meta`` (or ``trailing_text``) is shown as a trailing
    ``Text`` when no trailing icon is set.  Tapping the tile emits a
    ``"select"`` event with the item's ``id``, ``title``, ``value``,
    and ``meta`` fields.

    ```python
    import butterflyui as bui

    bui.ListTile(
        title="Settings",
        subtitle="Manage preferences",
        leading_icon="settings",
        trailing_icon="chevron_right",
    )
    ```
    """

    title: str | None = None
    """
    Primary title text.  Falls back to ``label`` or ``text`` props in the runtime.
    """

    subtitle: str | None = None
    """
    Secondary supporting text rendered beneath the title.
    """

    leading_icon: str | None = None
    """
    Icon name/data rendered at the leading edge (18 px).  The runtime also accepts ``icon`` or ``leading_text``.
    """

    trailing_icon: str | None = None
    """
    Icon name/data rendered at the trailing edge (18 px).
    """

    meta: str | None = None
    """
    Metadata string shown as trailing text when no ``trailing_icon`` is supplied.  Also accepted via ``trailing_text``.
    """

    selected: bool | None = None
    """
    If ``True``, the tile renders in its selected visual state.
    """

    dense: Any | None = None
    """
    Whether the runtime should use a more compact visual density.
    """

    leading_text: Any | None = None
    """
    Leading text value forwarded to the `list_tile` runtime control.
    """

    leading_image: Any | None = None
    """
    Leading image value forwarded to the `list_tile` runtime control.
    """

    badges: Any | None = None
    """
    Badges value forwarded to the `list_tile` runtime control.
    """

    actions: Any | None = None
    """
    Action descriptors rendered or dispatched by this control.
    """

    trailing_text: Any | None = None
    """
    Trailing text value forwarded to the `list_tile` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `list_tile` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `list_tile` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `list_tile` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `list_tile` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `list_tile` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `list_tile` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `list_tile` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `list_tile` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `list_tile` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `list_tile` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `list_tile` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `list_tile` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `list_tile` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `list_tile` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `list_tile` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `list_tile` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `list_tile` runtime control.
    """
