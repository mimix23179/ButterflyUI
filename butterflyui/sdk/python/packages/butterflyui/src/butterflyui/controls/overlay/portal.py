from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

from ..single_child_control import SingleChildControl
__all__ = ["Portal"]

@butterfly_control('portal', field_aliases={'content': 'child'}, positional_fields=('portal',))
class Portal(OverlayControl, SingleChildControl):
    """
    Renders portal content into a separate overlay layer above the widget tree.

    The runtime keeps the ``child`` widget in the normal layout tree but
    projects the ``portal`` content to a top-level overlay layer. ``open``
    controls whether the portal overlay is visible. ``dismissible`` closes
    it on outside tap. ``passthrough`` allows pointer events to reach
    widgets behind the portal. ``alignment`` and ``offset`` position the
    portal content.

    Example:

    ```python
    import butterflyui as bui

    bui.Portal(
        child=bui.Button(label="Open"),
        portal=bui.Text("Portal content"),
        open=True,
        alignment="center",
    )
    ```
    """

    portal: Any | None = None
    """
    The widget projected into the top-level overlay layer.
    """

    passthrough: bool | None = None
    """
    When ``True`` pointer events pass through to widgets below.
    """
