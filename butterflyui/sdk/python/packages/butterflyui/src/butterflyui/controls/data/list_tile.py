from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ListTile"]

class ListTile(Component):
    """
    Data-oriented list tile with selectable and disabled states, leading/
    trailing icons, and tap-to-select behaviour.

    The runtime renders a Material ``ListTile`` whose ``title`` falls
    back through ``label`` and ``text`` props.  ``leading_icon`` (also
    matched from ``icon`` or ``leading_text``) is resolved via
    ``buildIconValue`` into a 18 px icon widget; ``trailing_icon``
    likewise.  ``meta`` (or ``trailing_text``) is shown as a trailing
    ``Text`` when no trailing icon is set.  Tapping the tile emits a
    ``"select"`` event with the item's ``id``, ``title``, ``value``,
    and ``meta`` fields.

    ```python
    import butterflyui as bui

    bui.ListTile(
        title="Settings",
        subtitle="Manage preferences",
        leading_icon="settings",
        trailing_icon="chevron_right",
    )
    ```

    Args:
        title: 
            Primary title text.  Falls back to ``label`` or ``text`` props in the runtime.
        subtitle: 
            Secondary supporting text rendered beneath the title.
        leading_icon: 
            Icon name/data rendered at the leading edge (18 px).  The runtime also accepts ``icon`` or ``leading_text``.
        trailing_icon: 
            Icon name/data rendered at the trailing edge (18 px).
        meta: 
            Metadata string shown as trailing text when no ``trailing_icon`` is supplied.  Also accepted via ``trailing_text``.
        selected: 
            If ``True``, the tile renders in its selected visual state.
        enabled: 
            If ``False``, the tile is visually dimmed and non-interactive.  Defaults to ``True``.
    """

    control_type = "list_tile"

    def __init__(
        self,
        *,
        title: str | None = None,
        subtitle: str | None = None,
        leading_icon: str | None = None,
        trailing_icon: str | None = None,
        meta: str | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            subtitle=subtitle,
            leading_icon=leading_icon,
            trailing_icon=trailing_icon,
            meta=meta,
            selected=selected,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
