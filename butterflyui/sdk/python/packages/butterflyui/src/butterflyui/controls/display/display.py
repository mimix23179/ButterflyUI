from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Display"]


class Display(Component):
    """
    Unified display surface for identity, status, rating, reactions, and checks.

    ``Display`` consolidates multiple presentation-only widgets into one
    control: identity cards, ratings, reactions, status badges, checklists, and
    ownership markers. It is the canonical replacement for legacy
    ``ownership_marker`` wrappers.

    ```python
    import butterflyui as bui

    card = bui.Display(
        variant="result_card",
        title="Build Complete",
        subtitle="All checks passed",
        status="success",
        badge="v1.4.2",
    )
    ```

    Args:
        variant:
            Primary rendering mode (for example ``persona``, ``rating``,
            ``reaction_bar``, ``result_card``, ``status_mark``, ``typing``,
            or ``check_list`` depending on Flutter implementation).
        title:
            Main heading text.
        subtitle:
            Secondary heading text.
        description:
            Body/description text.
        name:
            Display name used by identity variants.
        status:
            Status label or semantic state value.
        badge:
            Badge text displayed with the content.
        avatar:
            Avatar URL/path/string descriptor.
        initials:
            Initials fallback for avatar/identity variants.
        icon:
            Icon descriptor for status/result variants.
        value:
            Numeric or textual value for metric/rating modes.
        max:
            Maximum bound for value/rating modes.
        allow_half:
            Enables half-step values for rating variants.
        items:
            Item descriptors for list/reaction/check variants.
        selected:
            Selected item values for selectable variants.
        checked:
            Checked item values for checklist variants.
        dot_count:
            Dot/count indicator for typing/status variants.
        document_id:
            Document identifier for ownership-marker style variants.
        ranges:
            Ownership range descriptors.
        owners:
            Owner descriptors used by ownership variants.
        show_avatars:
            If ``True``, ownership/identity variants show avatar chips.
        compact:
            Uses compact spacing treatment.
        dense:
            Uses dense spacing treatment.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """

    control_type = "display"

    def __init__(
        self,
        *,
        variant: str | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        description: str | None = None,
        name: str | None = None,
        status: str | None = None,
        badge: str | None = None,
        avatar: str | None = None,
        initials: str | None = None,
        icon: Any | None = None,
        value: Any | None = None,
        max: int | None = None,
        allow_half: bool | None = None,
        items: list[Any] | None = None,
        selected: list[Any] | None = None,
        checked: list[Any] | None = None,
        dot_count: int | None = None,
        document_id: str | None = None,
        ranges: list[Mapping[str, Any]] | None = None,
        owners: list[Mapping[str, Any]] | None = None,
        show_avatars: bool | None = None,
        compact: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                variant=variant,
                title=title,
                subtitle=subtitle,
                description=description,
                name=name,
                status=status,
                badge=badge,
                avatar=avatar,
                initials=initials,
                icon=icon,
                value=value,
                max=max,
                allow_half=allow_half,
                items=items,
                selected=selected,
                checked=checked,
                dot_count=dot_count,
                document_id=document_id,
                ranges=ranges,
                owners=owners,
                show_avatars=show_avatars,
                compact=compact,
                dense=dense,
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

    def emit(self, session: Any, event: str = "change", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
