from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SymbolTree"]

class SymbolTree(Component):
    """
    Hierarchical symbol outline tree for code or document structure navigation.

    Similar to ``Outline`` but styled for symbol navigation use-cases such
    as a document structure panel or a code outline. ``nodes`` supplies the
    tree hierarchy. ``expanded`` holds IDs of open nodes. ``selected_id``
    marks the active node. ``dense`` reduces row height; ``show_icons``
    toggles symbol-type icon glyphs.

    ```python
    import butterflyui as bui

    bui.SymbolTree(
        nodes=[
            {"id": "class_foo", "label": "Foo", "icon": "symbol_class", "children": [
                {"id": "method_bar", "label": "bar()", "icon": "symbol_method"},
            ]},
        ],
        expanded=["class_foo"],
        events=["select"],
    )
    ```

    Args:
        nodes:
            List of tree node spec mappings with ``id``, ``label``, optional
            ``icon``, and optional ``children``.
        expanded:
            List of node IDs whose subtrees are currently expanded.
        selected_id:
            The ``id`` of the currently selected symbol node.
        dense:
            Reduces row height and indent padding.
        show_icons:
            When ``True`` symbol-type icon glyphs are shown beside labels.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "symbol_tree"

    def __init__(
        self,
        *,
        nodes: list[Mapping[str, Any]] | None = None,
        expanded: list[str] | None = None,
        selected_id: str | None = None,
        dense: bool | None = None,
        show_icons: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            nodes=[dict(node) for node in (nodes or [])],
            expanded=expanded,
            selected_id=selected_id,
            dense=dense,
            show_icons=show_icons,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
