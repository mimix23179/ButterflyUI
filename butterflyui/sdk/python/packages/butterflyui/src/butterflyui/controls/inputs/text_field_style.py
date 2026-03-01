from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TextFieldStyle"]

class TextFieldStyle(Component):
    """
    Style configuration object that customises the appearance of text fields.

    Sends a style descriptor to the Flutter runtime which is applied to
    all ``TextField``-based controls in the subtree or to the specific
    control it is attached to, depending on the host layout.  Supports
    filled, outlined, and custom-radius variants as well as per-slot
    colour overrides.  Use :meth:`set_variant` to change the visual
    variant imperatively and :meth:`get_state` to read the current
    style state.

    ```python
    import butterflyui as bui

    bui.TextFieldStyle(
        variant="outlined",
        radius=8.0,
        border_color="#555",
        label_color="#aaa",
    )
    ```

    Args:
        variant:
            Named style variant — e.g. ``"filled"``, ``"outlined"``,
            ``"underline"``.
        dense:
            If ``True``, the field uses compact height.
        filled:
            If ``True``, the fill decoration is applied.
        outlined:
            If ``True``, an outline border decoration is applied.
        radius:
            Corner radius of the border in logical pixels.
        border_width:
            Width of the border stroke in logical pixels.
        color:
            Fill background colour.
        border_color:
            Colour of the border stroke.
        hint_color:
            Colour of the hint/placeholder text.
        label_color:
            Colour of the floating label text.
        text_color:
            Colour of the typed input text.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "text_field_style"

    def __init__(
        self,
        *,
        variant: str | None = None,
        dense: bool | None = None,
        filled: bool | None = None,
        outlined: bool | None = None,
        radius: float | None = None,
        border_width: float | None = None,
        color: Any | None = None,
        border_color: Any | None = None,
        hint_color: Any | None = None,
        label_color: Any | None = None,
        text_color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            dense=dense,
            filled=filled,
            outlined=outlined,
            radius=radius,
            border_width=border_width,
            color=color,
            border_color=border_color,
            hint_color=hint_color,
            label_color=label_color,
            text_color=text_color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_variant(self, session: Any, variant: str) -> dict[str, Any]:
        return self.invoke(session, "set_variant", {"variant": variant})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
