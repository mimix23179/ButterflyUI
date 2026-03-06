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

    title: str | None = None
    """
    Heading text shown in the default empty-state card.
    """

    subtitle: str | None = None
    """
    Subheading text shown below ``title`` in the empty-state
    card.
    """

    use_desktop_drop: bool | None = None
    """
    If ``True``, the zone also listens for system-level
    file-drop events (desktop only).
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `drop_zone` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `drop_zone` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `drop_zone` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `drop_zone` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `drop_zone` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `drop_zone` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `drop_zone` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `drop_zone` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `drop_zone` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `drop_zone` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `drop_zone` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `drop_zone` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `drop_zone` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `drop_zone` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `drop_zone` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `drop_zone` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `drop_zone` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `drop_zone` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `drop_zone` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
