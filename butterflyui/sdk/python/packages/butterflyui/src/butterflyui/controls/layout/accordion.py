from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Accordion"]

class Accordion(Component):
    """
    Collapsible accordion that shows or hides sections of content.

    The runtime renders an expandable list where each section can be opened and
    closed independently. ``sections`` supplies inline content specs; children
    may also be passed as positional arguments. ``index`` (alias ``expanded``)
    controls which section(s) are open. ``multiple`` allows several sections to
    be expanded simultaneously.

    ```python
    import butterflyui as bui

    bui.Accordion(
        sections=[{"title": "Section A", "body": "Content A"}],
        multiple=False,
        events=["change"],
    )
    ```

    Args:
        sections:
            List of section spec mappings, each with a ``title`` and content.
        labels:
            Optional list of plain-string section titles.
        index:
            Index or list of indices of the currently expanded section(s).
            Alias for ``expanded``.
        expanded:
            Alias for ``index``.
        multiple:
            When ``True`` more than one section may be open at the same time.
        allow_empty:
            When ``True`` all sections may be collapsed simultaneously.
        dense:
            Reduces section header height and padding.
        show_dividers:
            Adds horizontal dividers between sections.
        spacing:
            Vertical gap between sections in logical pixels.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "accordion"

    def __init__(
        self,
        *children: Any,
        sections: list[Mapping[str, Any]] | None = None,
        labels: list[str] | None = None,
        index: int | list[int] | None = None,
        expanded: int | list[int] | None = None,
        multiple: bool | None = None,
        allow_empty: bool | None = None,
        dense: bool | None = None,
        show_dividers: bool | None = None,
        spacing: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            sections=sections,
            labels=labels,
            index=index if index is not None else expanded,
            expanded=expanded if expanded is not None else index,
            multiple=multiple,
            allow_empty=allow_empty,
            dense=dense,
            show_dividers=show_dividers,
            spacing=spacing,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_expanded(self, session: Any, index: int | list[int]) -> dict[str, Any]:
        return self.invoke(session, "set_expanded", {"index": index, "expanded": index})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
