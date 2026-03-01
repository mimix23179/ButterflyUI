from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ReactionBar"]

class ReactionBar(Component):
    """Horizontal bar of toggleable emoji-reaction chips.

    Renders a ``Wrap`` of ``ChoiceChip`` widgets, each representing
    one reaction ``item`` dict (with ``id``, ``label``/``emoji``, and
    optional ``count``).  Chips whose ``id`` appears in ``selected``
    start in the selected state.  Toggling a chip emits ``"react"``
    with the item id and new selection state.

    Example::

        import butterflyui as bui

        bar = bui.ReactionBar(
            items=[
                {"id": "thumbs_up", "emoji": "\U0001f44d", "count": 3},
                {"id": "heart", "emoji": "\u2764\ufe0f", "count": 1},
            ],
            selected=["thumbs_up"],
        )

    Args:
        items: 
            List of reaction dicts.  Each should include ``id``, ``label`` or ``emoji``, and optionally ``count``.
        selected: 
            List of ``id`` strings for pre-selected reactions.
        max_visible: 
            Maximum number of chips shown (remaining are hidden).
        dense: 
            If ``True`` chips use compact visual density.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "reaction_bar"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        selected: list[str] | None = None,
        max_visible: int | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            selected=selected,
            max_visible=max_visible,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
