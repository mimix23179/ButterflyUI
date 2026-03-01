from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Clip"]

class Clip(Component):
    """
    Clips its child to a shape such as a rounded rectangle or circle.

    The runtime selects a Flutter clip widget based on ``shape``: ``"rect"``
    maps to ``ClipRect``, ``"oval"`` maps to ``ClipOval``, and the default
    rounded-rect variant uses ``ClipRRect``. ``radius`` sets the corner radius.
    ``clip_behavior`` controls anti-aliasing: ``"hardEdge"``,
    ``"antiAlias"``, or ``"antiAliasWithSaveLayer"``.

    ```python
    import butterflyui as bui

    bui.Clip(
        bui.Image(src="avatar.png"),
        shape="oval",
    )
    ```

    Args:
        shape:
            Clip shape. Values: ``"rect"``, ``"oval"``, ``"rrect"`` (default).
        radius:
            Corner radius in logical pixels for rounded-rect clips.
        clip_behavior:
            Anti-aliasing mode. Values: ``"hardEdge"``, ``"antiAlias"``,
            ``"antiAliasWithSaveLayer"``.
    """

    control_type = "clip"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        shape: str | None = None,
        radius: float | None = None,
        clip_behavior: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            shape=shape,
            radius=radius,
            clip_behavior=clip_behavior,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
