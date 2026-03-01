from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["OwnershipMarker"]

class OwnershipMarker(Component):
    """
    Inline ownership or authorship marker for collaborative document editing.

    The runtime renders a set of user-attribution markers overlaid on a
    document. ``document_id`` targets the associated document. ``items``
    provides a list of ownership range specs (author, range, color, etc.).
    ``enabled`` activates the feature. ``dense`` reduces marker size.

    ```python
    import butterflyui as bui

    bui.OwnershipMarker(
        document_id="doc-1",
        items=[{"author": "alice", "start": 0, "end": 50}],
        enabled=True,
        events=["select"],
    )
    ```

    Args:
        document_id:
            ID of the document these ownership markers are associated with.
        items:
            List of ownership range spec mappings.
        enabled:
            When ``True`` ownership markers are rendered.
        dense:
            When ``True`` markers are rendered in a compact size.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "ownership_marker"

    def __init__(
        self,
        *,
        document_id: str | None = None,
        items: list[Mapping[str, Any]] | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            document_id=document_id,
            items=[dict(item) for item in (items or [])],
            enabled=enabled,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
