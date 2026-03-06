from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["DropZone"]

@butterfly_control('drop_zone')
class DropZone(LayoutControl):
    """
    Rectangular drop target that accepts drags from :class:`DragPayload`.

    Renders a ``DragTarget`` container with a visual highlight that
    changes colour depending on hover / accept / reject state (green
    border when hovering an accepted type, red border for a rejected
    type).  When no child is provided a default *Drop Here* card with
    ``title`` and optional ``subtitle`` is shown.  ``accepts`` /
    ``accept_types`` filters which ``drag_type`` values this zone will
    receive; an empty list accepts anything.  Setting
    ``use_desktop_drop`` enables system-level file-drop support on
    desktop platforms.

    Emitted events:
    - ``enter`` — a compatible drag entered the zone.
    - ``leave`` — the drag left without dropping.
    - ``drop``  — a drag was released inside the zone.
    - ``reject`` — an incompatible drag type hovered the zone.

    Example:

    ```python
    import butterflyui as bui

    bui.DropZone(
        title="Drop tasks here",
        accepts=["task"],
    )
    ```
    """

    accepts: list[str] | None = None
    """
    List of ``drag_type`` strings this zone will accept.
    Alias ``accept_types`` is kept in sync.
    """

    accept_types: list[str] | None = None
    """
    Backward-compatible alias for ``accepts``. When both fields are provided, ``accepts`` takes precedence and this alias is kept only for compatibility.
    """

    accept_mimes: list[str] | None = None
    """
    List of MIME type strings accepted for desktop file drops.
    """

    use_desktop_drop: bool | None = None
    """
    If ``True``, the zone also listens for system-level
    file-drop events (desktop only).
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
