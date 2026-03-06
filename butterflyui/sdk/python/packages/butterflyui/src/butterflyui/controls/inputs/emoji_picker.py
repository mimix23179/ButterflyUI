from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["EmojiPicker"]

@butterfly_control('emoji_picker', positional_fields=('value',))
class EmojiPicker(FormFieldControl):
    """
    Scrollable emoji grid with category tabs and optional search.

    The Flutter runtime renders a paginated emoji panel grouped by
    category (smileys, animals, food, etc.).  A ``show_search`` bar
    lets users filter by keyword.  ``show_recent`` enables a *Recently
    Used* tab.  Selecting an emoji emits a ``pick`` event with the
    Unicode character (and optional metadata when
    ``include_metadata`` is ``True``).

    Use :meth:`set_category`, :meth:`search`, and :meth:`set_value` to
    control the panel imperatively.

    Example:

    ```python
    import butterflyui as bui

    bui.EmojiPicker(
        show_search=True,
        show_recent=True,
        columns=8,
    )
    ```
    """

    categories: list[str] | None = None
    """
    List of category names to display.  Defaults to all
    standard emoji categories.
    """

    recent: list[str] | None = None
    """
    List of recently used emoji characters to pre-populate
    the *Recent* tab.
    """

    skin_tone: str | None = None
    """
    Default skin tone modifier applied to applicable emoji
    (e.g. ``"light"``, ``"medium"``, ``"dark"``).
    """

    show_search: bool | None = None
    """
    If ``True``, a search text field is rendered above the
    grid.
    """

    show_recent: bool | None = None
    """
    If ``True``, a *Recently Used* category tab is shown.
    """

    category: str | None = None
    """
    Category name or identifier used to group, filter, or preselect the control's current content.
    """

    query: str | None = None
    """
    Initial search query pre-filled in the search field.
    """

    include_metadata: bool | None = None
    """
    If ``True``, the ``pick`` event payload includes extra
    metadata (name, group, annotations).
    """

    recent_limit: int | None = None
    """
    Maximum number of entries stored in the recent tab.
    """

    columns: int | None = None
    """
    Number of emoji columns per row in the grid.
    """

    items: list[str] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `emoji_picker` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `emoji_picker` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `emoji_picker` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `emoji_picker` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `emoji_picker` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `emoji_picker` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `emoji_picker` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `emoji_picker` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `emoji_picker` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `emoji_picker` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `emoji_picker` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `emoji_picker` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `emoji_picker` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `emoji_picker` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `emoji_picker` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `emoji_picker` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `emoji_picker` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `emoji_picker` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `emoji_picker` runtime control.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_category(self, session: Any, category: str) -> dict[str, Any]:
        return self.invoke(session, "set_category", {"category": category})

    def search(self, session: Any, query: str) -> dict[str, Any]:
        return self.invoke(session, "search", {"query": query})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
