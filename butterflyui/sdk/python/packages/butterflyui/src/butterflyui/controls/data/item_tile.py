from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .list_tile import ListTile
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ItemTile"]

@butterfly_control('item_tile')
class ItemTile(LayoutControl):
    """
    Selectable list tile tailored for data-oriented item rows, extending
    ``ListTile`` with an ``events`` convenience parameter and invoke
    helpers for runtime state management.

    Renders the same ``ListTile`` widget as its parent class —
    ``title``, optional ``subtitle``, ``leading_icon``, and
    ``trailing_icon`` — but also surfaces ``set_selected()``,
    ``get_state()``, and ``emit()`` helpers for driving the tile from
    Python.  Tapping the tile emits a ``"select"`` event whose payload
    includes the ``id``, ``title``, ``value``, and ``meta`` fields when
    present.

    ```python
    import butterflyui as bui

    bui.ItemTile(
        title="Build artefact",
        subtitle="245 KB",
        leading_icon="package",
        trailing_icon="chevron_right",
        selected=False,
    )
    ```
    """

    meta: str | None = None
    """
    Additional metadata string displayed as trailing text or forwarded in event payloads.
    """

    selected: bool | None = None
    """
    If ``True``, the tile renders in its selected visual state.
    """

    dense: Any | None = None
    """
    Whether the runtime should use a more compact visual density.
    """

    leading_text: Any | None = None
    """
    Leading text value forwarded to the `item_tile` runtime control.
    """

    leading_image: Any | None = None
    """
    Leading image value forwarded to the `item_tile` runtime control.
    """

    badges: Any | None = None
    """
    Badges value forwarded to the `item_tile` runtime control.
    """

    actions: Any | None = None
    """
    Action descriptors rendered or dispatched by this control.
    """

    trailing_text: Any | None = None
    """
    Trailing text value forwarded to the `item_tile` runtime control.
    """

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
