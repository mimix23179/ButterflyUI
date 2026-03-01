from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .drawer import Drawer

__all__ = ["SideDrawer"]

class SideDrawer(Drawer):
    """
    Persistent or modal side panel that slides in from a screen edge.

    A specialized form of ``Drawer`` with side-panel styling. Inherits
    ``open``, ``side``, ``size``, and ``dismissible`` from ``Drawer``.
    Typically used for navigation menus or inspector panels.

    ```python
    import butterflyui as bui

    bui.SideDrawer(
        bui.Text("Menu content"),
        side="left",
        size=280,
        open=False,
    )
    ```

    Args:
        open:
            When ``True`` the panel is visible.
        side:
            Edge from which the panel slides. Values: ``"left"``,
            ``"right"``, ``"top"``, ``"bottom"``.
        size:
            Panel width (for left/right) or height (for top/bottom) in
            logical pixels.
        dismissible:
            When ``True`` tapping outside closes the panel.
    """

    control_type = "side_drawer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        open: bool | None = None,
        side: str | None = None,
        size: float | None = None,
        dismissible: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            open=open,
            side=side,
            size=size,
            dismissible=dismissible,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
