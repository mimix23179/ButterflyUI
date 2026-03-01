from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Layer"]

class Layer(Component):
    """Visibility, opacity, clipping, and pointer-control decorator for
    a single child widget.

    The Flutter runtime conditionally hides the child when ``visible``
    is ``False``, applies ``Opacity``, clips to a rectangle or circle
    via ``ClipRRect`` / ``ClipOval``, and wraps with
    ``AbsorbPointer`` or ``IgnorePointer`` as configured.

    Example::

        import butterflyui as bui

        layer = bui.Layer(
            bui.Image(src="bg.png"),
            opacity=0.6,
            clip=True,
            clip_shape="circle",
            ignore_pointer=True,
        )

    Args:
        clip: 
            When ``True`` the child is clipped to the shape
            specified by *clip_shape*.
        clip_shape: 
            Clipping shape — ``"circle"`` for ``ClipOval``,
            anything else for ``ClipRRect``.
        shape: 
            Alias for *clip_shape*.
        clip_radius: 
            Corner radius of the ``ClipRRect`` when clipping
            a rectangle.
        border_radius: 
            Alias for *clip_radius*.
        radius: 
            Alias for *clip_radius*.
        opacity: 
            Layer opacity (``0.0`` – ``1.0``).
        ignore_pointer: 
            When ``True`` the child does not receive
            pointer events (``IgnorePointer``).
        absorb_pointer: 
            When ``True`` the child absorbs pointer
            events without propagating (``AbsorbPointer``).
        visible: 
            When ``False`` the child is replaced with an empty
            ``SizedBox``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "layer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        clip: bool | None = None,
        clip_shape: str | None = None,
        shape: str | None = None,
        clip_radius: float | None = None,
        border_radius: float | None = None,
        radius: float | None = None,
        opacity: float | None = None,
        ignore_pointer: bool | None = None,
        absorb_pointer: bool | None = None,
        visible: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            clip=clip,
            clip_shape=clip_shape,
            shape=shape,
            clip_radius=clip_radius,
            border_radius=border_radius,
            radius=radius,
            opacity=opacity,
            ignore_pointer=ignore_pointer,
            absorb_pointer=absorb_pointer,
            visible=visible,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
