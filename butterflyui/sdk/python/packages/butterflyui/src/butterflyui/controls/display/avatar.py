from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Avatar"]

@butterfly_control('avatar', positional_fields=('src',))
class Avatar(LayoutControl):
    """
    Circular avatar with image, initials, or icon fallback.

    Renders a ``CircleAvatar`` that resolves its content in priority
    order: a network/asset image from ``src`` or ``image``, then
    ``initials`` (or auto-derived initials from ``name``), then an
    ``icon`` fallback.  An optional coloured status dot (``"online"``,
    ``"away"``, ``"busy"``, ``"offline"``) is overlaid at the bottom-right
    corner.

    When ``enabled`` is ``True`` (default) the avatar is wrapped in an
    ``InkWell`` that emits ``"click"`` on tap.  Use ``set_src`` to swap
    the image at runtime and ``get_state`` to retrieve the resolved
    display values.

    Example:

    ```python
    import butterflyui as bui

    avatar = bui.Avatar(
        name="Ada Lovelace",
        status="online",
        bgcolor="#334155",
        size=40,
    )
    ```
    """

    src: str | None = None
    """
    Image URL or asset path used as the primary avatar image.
    """

    image: str | None = None
    """
    Alias for ``src`` — the two are interchangeable.
    """

    name: str | None = None
    """
    Full name used to auto-derive initials when ``initials`` is not provided.
    """

    initials: str | None = None
    """
    Explicit one- or two-letter initials shown when no image is available.
    """

    icon: str | None = None
    """
    Fallback Material icon name rendered when neither an image nor initials are present.
    """

    radius: float | None = None
    """
    Explicit corner radius (defaults to half of ``size``).
    """

    color: Any | None = None
    """
    Foreground colour for initials or icon text.
    """

    bgcolor: Any | None = None
    """
    Background fill colour for the circle.
    """

    status: str | None = None
    """
    Presence indicator — ``"online"``, ``"away"``, ``"busy"``, or ``"offline"``.
    """

    badge: Any | None = None
    """
    Arbitrary badge content overlaid on the avatar.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `avatar` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `avatar` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `avatar` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `avatar` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `avatar` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `avatar` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `avatar` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `avatar` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `avatar` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `avatar` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `avatar` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `avatar` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `avatar` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `avatar` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `avatar` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `avatar` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `avatar` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `avatar` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `avatar` runtime control.
    """

    def set_src(self, session: Any, src: str) -> dict[str, Any]:
        return self.invoke(session, "set_src", {"src": src})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
