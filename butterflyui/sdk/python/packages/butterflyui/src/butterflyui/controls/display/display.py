from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Display"]

@butterfly_control('display')
class Display(LayoutControl):
    """
    Unified presentational control for identity, status, ratings, reactions, checks, and ownership.

    ``Display`` replaces several narrow widgets with a role-driven API:
    ``identity``, ``status``, ``rating``, ``reactions``, ``check``, and
    ``ownership``. Legacy variants are still accepted and mapped by the
    runtime for backward compatibility.

    Display now uses the shared universal renderer pipeline too, so the same
    ``classes``/``style_slots``/``modifiers``/``motion``/``effects`` props
    can style identity/status/rating/reaction/check/ownership roles
    consistently with Candy/Skins/Gallery.

    Example:
    ```python
    import butterflyui as bui

    profile = bui.Display(
        role="identity",
        title="Nina Hart",
        subtitle="Design Systems",
        avatar="https://example.com/avatar.png",
        tags=["Owner", "Core Team"],
        trailing={"type": "icon", "props": {"name": "chevron_right"}},
        interactive=True,
        events=["tap"],
    )
    ```
    """

    role: str | None = None
    """
    Role/variant selector. Recommended values:
    ``"identity"``, ``"status"``, ``"rating"``, ``"reactions"``,
    ``"check"``, ``"ownership"``.
    """

    caption: str | None = None
    """
    Tertiary/supporting caption line.
    """

    description: str | None = None
    """
    Longer descriptive text rendered beneath or alongside the control's primary label.
    """

    name: str | None = None
    """
    Human-readable name used to identify this item, style pack, or preset.
    """

    avatar: Any | None = None
    """
    Avatar source or descriptor rendered alongside the control's primary content.
    """

    initials: str | None = None
    """
    Fallback initials rendered when an avatar or image source is not available.
    """

    tags: list[Any] | None = None
    """
    List of tag labels associated with the rendered item or record.
    """

    status: str | None = None
    """
    Status text or key for status role.
    """

    badge: str | None = None
    """
    Badge value or descriptor rendered as a compact status marker near the control's main content.
    """

    value: Any | None = None
    """
    Numeric/text value for rating/status/metric roles.
    """

    max: int | None = None
    """
    Maximum bound used in rating role.
    """

    allow_half: bool | None = None
    """
    Enables half values in rating role.
    """

    count: int | None = None
    """
    Count label for rating/reaction roles.
    """

    selected: list[Any] | None = None
    """
    Selected reaction/item identifiers.
    """

    checked: list[Any] | None = None
    """
    List of checked item identifiers or payloads used by the display role when it renders multi-check or selection state.
    """

    checked_value: bool | None = None
    """
    Boolean check state for a single-check role usage.
    """

    dot_count: int | None = None
    """
    Dot count for typing-like status visuals.
    """

    document_id: str | None = None
    """
    Identifier of the backing document, record, or content item shown by the control.
    """

    ranges: list[Mapping[str, Any]] | None = None
    """
    List of value ranges, highlight segments, or annotated spans rendered by the control.
    """

    owners: list[Mapping[str, Any]] | None = None
    """
    Ordered collection of owner entries associated with the rendered record or item.
    """

    owner: Mapping[str, Any] | None = None
    """
    Single owner descriptor associated with the rendered record or item.
    """

    show_avatars: bool | None = None
    """
    Shows avatars in identity/ownership variants.
    """

    compact: bool | None = None
    """
    Enables a more compact visual density with reduced padding, gaps, or surface size.
    """

    dense: bool | None = None
    """
    Enables a denser layout with reduced gaps, padding, or row height.
    """

    label: Any | None = None
    """
    Primary label rendered by the control.
    """

    src: Any | None = None
    """
    Source value consumed by the runtime, such as a file path or URL.
    """

    rating: Any | None = None
    """
    Rating value forwarded to the `display` runtime control.
    """

    max_rating: Any | None = None
    """
    Max rating value forwarded to the `display` runtime control.
    """

    show_count: Any | None = None
    """
    Show count value forwarded to the `display` runtime control.
    """

    inactive_color: Any | None = None
    """
    Inactive color value forwarded to the `display` runtime control.
    """

    dot_size: Any | None = None
    """
    Dot size value forwarded to the `display` runtime control.
    """

    text: Any | None = None
    """
    Text value rendered by the control.
    """

    indices: Any | None = None
    """
    Indices value forwarded to the `display` runtime control.
    """

    options: Any | None = None
    """
    Option descriptors rendered by the control.
    """

    spacing: Any | None = None
    """
    Spacing between repeated child elements.
    """

    values: Any | None = None
    """
    Values value forwarded to the `display` runtime control.
    """

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_checked(self, session: Any, checked: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_checked", {"checked": checked})

    def emit(
        self,
        session: Any,
        event: str = "change",
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
