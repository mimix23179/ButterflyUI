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

    background: Any | None = None
    """
    Background colour of the scene surface.
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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `scene_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `scene_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `scene_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `scene_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `scene_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `scene_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `scene_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `scene_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `scene_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `scene_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `scene_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `scene_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `scene_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `scene_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `scene_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `scene_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `scene_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `scene_view` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
