from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["BorderSide"]

@butterfly_control('border_side')
class BorderSide(LayoutControl):
    """
    Renders a single border line on one or more sides of the parent.

    Unlike :class:`Border`, which wraps a child, ``BorderSide`` draws a
    standalone line (a thin ``SizedBox`` with a side decoration). It is
    useful for separator-style borders. It also accepts per-side maps via
    `top`, `right`, `bottom`, and `left` for individual configuration.

    ```python
    import butterflyui as bui

    bui.BorderSide(side="bottom", color="#64748b", width=1)
    ```
    """

    side: str | None = None
    """
    Which side to draw: ``"top"``, ``"right"``, ``"bottom"`` (default), or ``"left"``.
    """

    length: float | None = None
    """
    Line length in logical pixels. Defaults to ``double.infinity`` (stretches to fill).
    """

    animated: bool | None = None
    """
    If ``True``, transitions are animated via ``AnimatedContainer``.
    """

    duration_ms: int | None = None
    """
    Animation duration in milliseconds. Defaults to ``180``.
    """

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
