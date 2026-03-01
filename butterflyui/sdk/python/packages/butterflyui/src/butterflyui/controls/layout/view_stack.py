from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ViewStack"]

class ViewStack(Component):
    """
    Stacked-page navigator that displays one child at a time by index.

    The runtime renders multiple children but shows only the child at the
    current ``index``. ``animate`` enables transition animations between
    pages, with ``duration_ms`` controlling animation length. ``keep_alive``
    keeps off-screen children alive in the widget tree to preserve their
    state.

    ```python
    import butterflyui as bui

    stack = bui.ViewStack(
        bui.Text("Page 0"),
        bui.Text("Page 1"),
        bui.Text("Page 2"),
        index=0,
        animate=True,
        events=["change"],
    )
    ```

    Args:
        index:
            Zero-based index of the currently visible child.
        animate:
            When ``True`` transitions between pages are animated.
        duration_ms:
            Duration of the page transition animation in milliseconds.
        keep_alive:
            When ``True`` off-screen children remain mounted in the tree.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "view_stack"

    def __init__(
        self,
        *children: Any,
        index: int | None = None,
        animate: bool | None = None,
        duration_ms: int | None = None,
        keep_alive: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            index=index,
            animate=animate,
            duration_ms=duration_ms,
            keep_alive=keep_alive,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_index(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "set_index", {"index": int(index)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
