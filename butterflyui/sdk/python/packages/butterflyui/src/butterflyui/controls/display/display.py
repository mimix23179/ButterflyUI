from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Display"]


class Display(Component):
    """Unified display surface for identity, status, rating, reactions, and checks.

    Replaces ``persona``, ``rating_display``, ``reaction_bar``, ``result_card``,
    ``status_mark``, ``typing_indicator``, and ``check_list`` with one configurable
    control. Use ``variant`` to select primary behavior.
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
