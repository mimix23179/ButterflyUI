from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["SceneView"]

@butterfly_control('scene_view')
class SceneView(LayoutControl):
    """
    Scene surface that can display a background, grid, axes, and camera
    viewport.

    Acts as a container for editor content with configurable visual
    helpers. Emits events for camera changes and user interactions.

    ```python
    import butterflyui as bui

    bui.SceneView(
        my_content,
        background="#0f172a",
        show_grid=True,
        show_axes=True,
        camera={"zoom": 1.0, "x": 0, "y": 0},
    )
    ```
    """

    show_grid: bool | None = None
    """
    If ``True``, a reference grid is drawn on the scene.
    """

    show_axes: bool | None = None
    """
    If ``True``, X/Y coordinate axes are drawn.
    """

    camera: Mapping[str, Any] | None = None
    """
    Camera/viewport configuration dict with keys such as ``"zoom"``, ``"x"``, and ``"y"``.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
