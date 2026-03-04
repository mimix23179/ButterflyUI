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

    Args:
        role:
            Role/variant selector. Recommended values:
            ``"identity"``, ``"status"``, ``"rating"``, ``"reactions"``,
            ``"check"``, ``"ownership"``.
        variant:
            Legacy alias for ``role``.
        title:
            Primary line.
        subtitle:
            Secondary line.
        caption:
            Tertiary/supporting caption line.
        description:
            Body text alias.
        name:
            Identity name alias.
        tone:
            Semantic tone (``neutral/info/success/warn/danger``).
        size:
            Size token (for example ``sm``, ``md``, ``lg``).
        interactive:
            Enables hover/focus affordances and tap emission.
        icon:
            Icon descriptor for role surfaces.
        leading:
            Leading slot descriptor (control map/string/icon).
        trailing:
            Trailing slot descriptor.
        avatar:
            Avatar descriptor.
        initials:
            Avatar fallback initials.
        tags:
            Identity tags/chips.
        status:
            Status text or key for status role.
        badge:
            Badge label.
        color:
            Optional role accent override.
        value:
            Numeric/text value for rating/status/metric roles.
        max:
            Maximum bound used in rating role.
        allow_half:
            Enables half values in rating role.
        count:
            Count label for rating/reaction roles.
        items:
            Item descriptors for reactions/check roles.
        selected:
            Selected reaction/item identifiers.
        checked:
            Checked ids for check role.
        checked_value:
            Boolean check state for a single-check role usage.
        dot_count:
            Dot count for typing-like status visuals.
        document_id:
            Ownership document identifier.
        ranges:
            Ownership ranges.
        owners:
            Ownership descriptors.
        owner:
            Single-owner alias.
        show_avatars:
            Shows avatars in identity/ownership variants.
        compact:
            Compact density alias.
        dense:
            Dense density alias.
        aria_label:
            Accessibility label alias.
        events:
            Runtime event subscriptions (for example ``tap``, ``rate``,
            ``react``, ``check_change``).
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Local style map merged by the style resolver.
        strict:
            Enables strict schema validation when supported.
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
        super().__init__(
            *children_args,
            child=child,
            children=children,
            props=merge_props(
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
            ),
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
