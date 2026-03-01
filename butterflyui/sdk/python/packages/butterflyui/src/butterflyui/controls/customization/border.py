from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Border"]

class Border(Component):
    """
    Wraps a child control in a configurable border with optional animation.

    The runtime renders the child inside a ``Container`` (or
    ``AnimatedContainer`` when `animated` is ``True``). Borders can be
    applied to individual sides or all sides at once. Per-side overrides
    are available via the `sides` mapping.

    ```python
    import butterflyui as bui

    bui.Border(
        my_content,
        color="#64748b",
        width=2,
        radius=8,
        animated=True,
    )
    ```

    Args:
        color: 
            Border colour. Defaults to ``"#64748b"`` (slate-500).
        width: 
            Border width in logical pixels. Defaults to ``1``.
        radius: 
            Corner radius of the surrounding box. Defaults to ``0``.
        side: 
            Apply the border to a single side: ``"top"``, ``"right"``, ``"bottom"``, ``"left"``, or ``"all"`` (default).
        sides: 
            Per-side border config. A dict whose keys are side names (``"top"``, ``"right"``, etc.) and whose values are dicts with ``"color"`` and/or ``"width"``.
        animated: 
            If ``True``, property changes are smoothly animated via ``AnimatedContainer``.
        duration_ms: 
            Animation duration in milliseconds when `animated` is ``True``. Defaults to ``180``.
    """
    control_type = "border"

    def __init__(
        self,
        *children: Any,
        color: Any | None = None,
        width: float | None = None,
        radius: float | None = None,
        side: str | None = None,
        sides: Mapping[str, Any] | None = None,
        animated: bool | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            width=width,
            radius=radius,
            side=side,
            sides=dict(sides) if sides is not None else None,
            animated=animated,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
