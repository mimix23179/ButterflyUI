from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DropZone"]

class DropZone(Component):
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

    ```python
    import butterflyui as bui

    bui.DropZone(
        title="Drop tasks here",
        accepts=["task"],
    )
    ```

    Args:
        enabled:
            If ``False``, the zone does not accept any drops.
        accepts:
            List of ``drag_type`` strings this zone will accept.
            Alias ``accept_types`` is kept in sync.
        accept_types:
            Alias for ``accepts``.
        accept_mimes:
            List of MIME type strings accepted for desktop file drops.
        title:
            Heading text shown in the default empty-state card.
        subtitle:
            Subheading text shown below ``title`` in the empty-state
            card.
        use_desktop_drop:
            If ``True``, the zone also listens for system-level
            file-drop events (desktop only).
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "drop_zone"

    def __init__(
        self,
        child: Any | None = None,
        *,
        enabled: bool | None = None,
        accepts: list[str] | None = None,
        accept_types: list[str] | None = None,
        accept_mimes: list[str] | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        use_desktop_drop: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            accepts=accepts,
            accept_types=accept_types if accept_types is not None else accepts,
            accept_mimes=accept_mimes,
            title=title,
            subtitle=subtitle,
            use_desktop_drop=use_desktop_drop,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
