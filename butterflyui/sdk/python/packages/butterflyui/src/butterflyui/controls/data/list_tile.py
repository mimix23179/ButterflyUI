from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..title_control import TitleControl
from ..subtitle_control import SubtitleControl
__all__ = ["ListTile"]

@butterfly_control('list_tile')
class ListTile(LayoutControl, TitleControl, SubtitleControl):
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
