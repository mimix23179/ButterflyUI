from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .align import Align

__all__ = ["Center"]

class Center(Align):
    """
    Centers its child within the available space.

    A convenience specialization of ``Align`` that defaults ``alignment`` to
    ``"center"``. Inherits the ``width_factor`` and ``height_factor``
    shrink-wrap behaviour from ``Align``.

    ```python
    import butterflyui as bui

    bui.Center(
        bui.Text("Centered"),
        events=["layout"],
    )
    ```

    Args:
        width_factor:
            If set, the widget's width is this multiple of the child's width.
        height_factor:
            If set, the widget's height is this multiple of the child's height.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "center"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        width_factor: float | None = None,
        height_factor: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            *children,
            alignment="center",
            width_factor=width_factor,
            height_factor=height_factor,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
