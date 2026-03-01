from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AttachmentTile"]

class AttachmentTile(Component):
    """File-attachment tile with a type-aware leading icon.

    Renders a ``ListTile`` whose leading icon is resolved from the
    ``type`` value (e.g. ``"image"`` → image icon, ``"audio"`` → audio
    icon, ``"pdf"`` → PDF icon).  The title shows ``label`` and the
    subtitle shows ``subtitle`` or falls back to the filename derived
    from ``src``.  A remove ``IconButton`` appears when
    ``show_remove`` is ``True``.

    Clicking the tile emits ``"open"``, and the remove button emits
    ``"remove"``.  Use ``set_src`` to swap the underlying file source
    at runtime.

    Example::

        import butterflyui as bui

        tile = bui.AttachmentTile(
            label="report.pdf",
            type="pdf",
            src="/files/report.pdf",
            show_remove=True,
        )

    Args:
        label: 
            Display name shown as the tile title.
        subtitle: 
            Secondary text below the label.
        type: 
            Attachment MIME category (``"image"``, ``"audio"``, ``"video"``, ``"pdf"``, etc.) used to pick the leading icon.
        src: 
            URI or file path pointing to the attachment source.
        clickable: 
            If ``True`` the tile emits ``"open"`` on tap.
        show_remove: 
            If ``True`` a trailing remove icon is shown that emits ``"remove"`` when pressed.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "attachment_tile"

    def __init__(
        self,
        *,
        label: str | None = None,
        subtitle: str | None = None,
        type: str | None = None,
        src: str | None = None,
        clickable: bool | None = None,
        show_remove: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            subtitle=subtitle,
            type=type,
            src=src,
            clickable=clickable,
            show_remove=show_remove,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_src(self, session: Any, src: str) -> dict[str, Any]:
        return self.invoke(session, "set_src", {"src": src})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
