from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Pressable"]

class Pressable(Component):
    """
    Adds press, hover, and focus interaction states to its child.

    Wraps the child in a Flutter ``GestureDetector`` + ``MouseRegion``
    + ``Focus`` combination.  The interaction state (``pressed``,
    ``hovered``, ``focused``) is tracked and re-broadcast to the
    child so it can apply visual feedback.  Emitted events:

    - ``press``        — pointer-down inside the bounds.
    - ``release``      — pointer-up after a press.
    - ``tap``          — completed tap (press + release).
    - ``hover_enter``  — pointer entered the bounds.
    - ``hover_exit``   — pointer left the bounds.
    - ``focus_gained`` — focus node received keyboard focus.
    - ``focus_lost``   — focus node lost keyboard focus.

    ```python
    import butterflyui as bui

    bui.Pressable(
        bui.Container(bui.Text("Press me")),
        hover_enabled=True,
        focus_enabled=True,
    )
    ```

    Args:
        enabled:
            Master switch.  If ``False``, no interaction events are
            fired.
        autofocus:
            If ``True``, the focus node requests focus on mount.
        hover_enabled:
            If ``True``, ``hover_enter`` and ``hover_exit`` events are
            fired.
        focus_enabled:
            If ``True``, ``focus_gained`` and ``focus_lost`` events are
            fired.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "pressable"

    def __init__(
        self,
        child: Any | None = None,
        *,
        enabled: bool | None = None,
        autofocus: bool | None = None,
        hover_enabled: bool | None = None,
        focus_enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            autofocus=autofocus,
            hover_enabled=hover_enabled,
            focus_enabled=focus_enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
