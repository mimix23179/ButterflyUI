from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Display"]


class Display(Component):
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

    variant: str | None = None
    """
    Variant token or preset name used to select a specific visual style.
    """

    title: str | None = None
    """
    Primary heading text rendered by the control.
    """

    subtitle: str | None = None
    """
    Secondary text rendered beneath or beside the primary title.
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

    tone: str | None = None
    """
    Semantic tone (``neutral/info/success/warn/danger``).
    """

    size: str | None = None
    """
    Size token (for example ``sm``, ``md``, ``lg``).
    """

    interactive: bool | None = None
    """
    Enables hover/focus affordances and tap emission.
    """

    icon: Any | None = None
    """
    Icon descriptor for role surfaces.
    """

    leading: Any | None = None
    """
    Leading slot descriptor (control map/string/icon).
    """

    trailing: Any | None = None
    """
    Trailing content or descriptor rendered after the control's primary body.
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

    color: Any | None = None
    """
    Primary color value used by the control for text, icons, strokes, or accent surfaces.
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

    items: list[Any] | None = None
    """
    Item descriptors for reactions/check roles.
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

    aria_label: str | None = None
    """
    Accessibility label announced to assistive technologies when the control does not expose enough visible text on its own.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "display"

    def __init__(
        self,
        *children_args: Any,
        role: str | None = None,
        variant: str | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        caption: str | None = None,
        description: str | None = None,
        name: str | None = None,
        tone: str | None = None,
        size: str | None = None,
        interactive: bool | None = None,
        status: str | None = None,
        badge: str | None = None,
        color: Any | None = None,
        avatar: Any | None = None,
        initials: str | None = None,
        icon: Any | None = None,
        leading: Any | None = None,
        trailing: Any | None = None,
        tags: list[Any] | None = None,
        value: Any | None = None,
        max: int | None = None,
        allow_half: bool | None = None,
        count: int | None = None,
        items: list[Any] | None = None,
        selected: list[Any] | None = None,
        checked: list[Any] | None = None,
        checked_value: bool | None = None,
        dot_count: int | None = None,
        document_id: str | None = None,
        ranges: list[Mapping[str, Any]] | None = None,
        owners: list[Mapping[str, Any]] | None = None,
        owner: Mapping[str, Any] | None = None,
        show_avatars: bool | None = None,
        compact: bool | None = None,
        dense: bool | None = None,
        aria_label: str | None = None,
        events: list[str] | None = None,
        child: Any | None = None,
        children: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
                        props,
                        role=role if role is not None else variant,
                        variant=variant if variant is not None else role,
                        title=title,
                        subtitle=subtitle,
                        caption=caption,
                        description=description,
                        name=name,
                        tone=tone,
                        size=size,
                        interactive=interactive,
                        status=status,
                        badge=badge,
                        color=color,
                        avatar=avatar,
                        initials=initials,
                        icon=icon,
                        leading=leading,
                        trailing=trailing,
                        tags=tags,
                        value=value,
                        max=max,
                        allow_half=allow_half,
                        count=count,
                        items=items,
                        selected=selected,
                        checked=checked,
                        checked_value=checked_value,
                        dot_count=dot_count,
                        document_id=document_id,
                        ranges=ranges,
                        owners=owners if owners is not None else ([dict(owner)] if owner else None),
                        owner=dict(owner) if owner else None,
                        show_avatars=show_avatars,
                        compact=compact,
                        dense=dense,
                        aria_label=aria_label,
                        events=events,
                        **kwargs,
                    )
        super().__init__(
            *children_args,
            child=child,
            children=children,
            props=merged,
            style=style,
            strict=strict,
        )

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
