from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Badge"]

class Badge(Component):
    """
    Displays a compact label, count, or status indicator.

    The runtime colours the badge according to `severity` (``"success"``,
    ``"warning"``, ``"error"``) or uses explicit `bgcolor` / `color`
    overrides. When `dot` is ``True`` an empty dot indicator is shown
    instead of text. The optional `pulse` flag adds a scale animation.

    If `clickable` is ``True``, a ``"click"`` event is emitted with the
    current display value.

    ```python
    import butterflyui as bui

    bui.Badge("New", severity="success", pulse=True)
    ```

    Args:
        label: 
            Display text. Resolved from `text` when ``None``.
        text: 
            Alias for `label`.
        value: 
            Arbitrary value exposed to event payloads and the ``get_value`` / ``set_value`` invoke methods.
        color: 
            Foreground (text) colour. Overrides the severity-derived colour.
        bgcolor: 
            Background colour. Overrides the severity-derived background.
        text_color: 
            Alias for `color`.
        severity: 
            Semantic severity controlling the theme colour scheme. One of ``"success"``, ``"warning"`` / ``"warn"``, ``"error"`` / ``"danger"``. Defaults to the primary colour.
        variant: 
            Visual variant hint forwarded to the runtime.
        dot: 
            If ``True``, renders a small coloured dot instead of text.
        pulse: 
            If ``True``, the badge animates with a subtle pulse (scale tween).
        count: 
            When set, overrides the display text with this integer count.
        radius: 
            Corner radius of the badge container. Defaults to a large pill shape (``999``) or fully round for dots.
        padding: 
            Inner padding of the badge. Accepts a number, list, or dict. Defaults to ``horizontal: 8, vertical: 3``.
        clickable: 
            If ``True``, the badge becomes tappable and emits a ``"click"`` event with the current display value.
    """
    control_type = "badge"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        color: Any | None = None,
        bgcolor: Any | None = None,
        text_color: Any | None = None,
        severity: str | None = None,
        variant: str | None = None,
        dot: bool | None = None,
        pulse: bool | None = None,
        count: int | None = None,
        radius: float | None = None,
        padding: Any | None = None,
        clickable: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = text if text is not None else label
        merged = merge_props(
            props,
            label=resolved,
            text=resolved,
            value=value,
            color=color,
            bgcolor=bgcolor,
            text_color=text_color,
            severity=severity,
            variant=variant,
            dot=dot,
            pulse=pulse,
            count=count,
            radius=radius,
            padding=padding,
            clickable=clickable,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})
