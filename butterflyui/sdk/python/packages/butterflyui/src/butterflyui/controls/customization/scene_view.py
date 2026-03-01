from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SceneView"]

class SceneView(Component):
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

    Args:
        background: 
            Background colour of the scene surface.
        show_grid: 
            If ``True``, a reference grid is drawn on the scene.
        show_axes: 
            If ``True``, X/Y coordinate axes are drawn.
        camera: 
            Camera/viewport configuration dict with keys such as ``"zoom"``, ``"x"``, and ``"y"``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "scene_view"

    def __init__(
        self,
        *children: Any,
        background: Any | None = None,
        show_grid: bool | None = None,
        show_axes: bool | None = None,
        camera: Mapping[str, Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            background=background,
            show_grid=show_grid,
            show_axes=show_axes,
            camera=dict(camera) if camera is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
