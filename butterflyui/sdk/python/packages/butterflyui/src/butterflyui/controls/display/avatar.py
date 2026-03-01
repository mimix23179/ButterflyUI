from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Avatar"]

class Avatar(Component):
    """Circular avatar with image, initials, or icon fallback.

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

    Example::

        import butterflyui as bui

        avatar = bui.Avatar(
            name="Ada Lovelace",
            status="online",
            bgcolor="#334155",
            size=40,
        )

    Args:
        src: 
            Image URL or asset path used as the primary avatar image.
        image: 
            Alias for ``src`` — the two are interchangeable.
        name: 
            Full name used to auto-derive initials when ``initials`` is not provided.
        initials: 
            Explicit one- or two-letter initials shown when no image is available.
        icon: 
            Fallback Material icon name rendered when neither an image nor initials are present.
        size: 
            Diameter of the avatar circle in logical pixels.
        radius: 
            Explicit corner radius (defaults to half of ``size``).
        color: 
            Foreground colour for initials or icon text.
        bgcolor: 
            Background fill colour for the circle.
        status: 
            Presence indicator — ``"online"``, ``"away"``, ``"busy"``, or ``"offline"``.
        badge: 
            Arbitrary badge content overlaid on the avatar.
        enabled: 
            If ``True`` (default) the avatar emits click events.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "avatar"

    def __init__(
        self,
        src: str | None = None,
        *,
        image: str | None = None,
        name: str | None = None,
        initials: str | None = None,
        icon: str | None = None,
        size: float | None = None,
        radius: float | None = None,
        color: Any | None = None,
        bgcolor: Any | None = None,
        status: str | None = None,
        badge: Any | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src if src is not None else image,
            image=image if image is not None else src,
            name=name,
            initials=initials,
            icon=icon,
            size=size,
            radius=radius,
            color=color,
            bgcolor=bgcolor,
            status=status,
            badge=badge,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_src(self, session: Any, src: str) -> dict[str, Any]:
        return self.invoke(session, "set_src", {"src": src})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
