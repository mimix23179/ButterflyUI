from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TagChip"]

class TagChip(Component):
    """
    Selectable tag chip with an optional leading icon and dismiss button.

    Renders a Flutter ``InputChip`` styled for tagging use cases.  The
    chip can be toggled (``selected``) and optionally dismissed by the
    user.  Tapping the chip emits a ``select`` event; tapping the close
    icon emits a ``dismiss`` event.  Call :meth:`set_selected` to
    update the selection state imperatively.

    ```python
    import butterflyui as bui

    bui.TagChip(
        "Python",
        value="python",
        selected=True,
        dismissible=True,
        icon="code",
    )
    ```

    Args:
        label:
            Text displayed inside the chip.
        value:
            Arbitrary identifier emitted with events.
        selected:
            If ``True``, the chip renders in its selected/highlighted
            state.
        enabled:
            If ``False``, the chip is non-interactive.
        dismissible:
            If ``True``, a trailing close button is shown; tapping
            it emits a ``dismiss`` event.
        color:
            Background colour override applied when selected.
        icon:
            Leading icon name or codepoint rendered before the label.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "tag_chip"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dismissible: bool | None = None,
        color: Any | None = None,
        icon: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            value=value,
            selected=selected,
            enabled=enabled,
            dismissible=dismissible,
            color=color,
            icon=icon,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
