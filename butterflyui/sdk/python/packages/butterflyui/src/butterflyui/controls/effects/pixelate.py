from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Pixelate"]

class Pixelate(Component):
    """Pixelation effect achieved by cascading two ``Transform.scale``
    widgets with ``FilterQuality.none``.

    The Flutter runtime first scales the child down by a factor
    derived from ``amount`` (higher amounts = more pixelation), then
    scales it back up to its original size, both with nearest-neighbour
    filtering disabled.  The result is a retro mosaic / pixel-art
    look.

    Example::

        import butterflyui as bui

        px = bui.Pixelate(
            bui.Image(src="photo.png"),
            amount=0.5,
        )

    Args:
        amount: 
            Pixelation intensity (``0.0`` no effect – ``1.0``
            maximum).  Defaults to ``0.35``.  Internally mapped to a
            downscale factor ``1 − amount × 0.9``.
        enabled: 
            When ``False`` the child is rendered unmodified.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "pixelate"

    def __init__(
        self,
        child: Any | None = None,
        *,
        amount: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            amount=amount,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
