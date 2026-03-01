from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Visibility"]

class Visibility(Component):
    """
    Controls the visibility of its child without removing it from the tree.

    The runtime wraps Flutter's ``Visibility`` widget. When ``visible`` is
    ``False`` the child is hidden. ``maintain_state`` keeps the child's state
    alive; ``maintain_size`` preserves its occupied space;
    ``maintain_animation`` keeps animations running. ``replacement`` renders
    in place of the hidden child when ``maintain_size`` is ``False``.

    ```python
    import butterflyui as bui

    bui.Visibility(
        bui.Text("Secret content"),
        visible=False,
        maintain_size=True,
        events=["change"],
    )
    ```

    Args:
        visible:
            When ``True`` the child is visible. Defaults to ``True``.
        maintain_state:
            When ``True`` the child's widget state is preserved while hidden.
        maintain_size:
            When ``True`` the child continues to occupy its layout space
            while hidden.
        maintain_animation:
            When ``True`` animations continue to play while the child is
            hidden.
        replacement:
            Widget rendered in place of the child when ``maintain_size`` is
            ``False``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "visibility"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        visible: bool | None = None,
        maintain_state: bool | None = None,
        maintain_size: bool | None = None,
        maintain_animation: bool | None = None,
        replacement: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            visible=visible,
            maintain_state=maintain_state,
            maintain_size=maintain_size,
            maintain_animation=maintain_animation,
            replacement=replacement,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_visible(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_visible", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
