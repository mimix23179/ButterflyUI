from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Outline"]

@butterfly_control('outline')
class Outline(LayoutControl):
    """
    Expandable tree outline panel for hierarchical navigation.

    The runtime renders a collapsible tree of nodes. ``nodes`` supplies the
    hierarchy, where each node may have a ``children`` list. ``expanded`` is
    a list of node IDs that are currently open. ``selected_id`` highlights
    the active node. ``dense`` reduces row height; ``show_icons`` controls
    icon visibility.

    Example:

    ```python
    import butterflyui as bui

    bui.Outline(
        nodes=[
            {"id": "src", "label": "src", "children": [
                {"id": "main", "label": "main.py"},
            ]},
        ],
        expanded=["src"],
        events=["select", "expand"],
    )
    ```
    """

    nodes: list[Mapping[str, Any]] | None = None
    """
    List of tree node spec mappings. Nodes may include ``id``,
    ``label``, ``icon``, and ``children``.
    """

    expanded: list[str] | None = None
    """
    List of node IDs whose subtrees are currently expanded.
    """

    selected_id: str | None = None
    """
    The ``id`` of the currently selected node.
    """

    dense: bool | None = None
    """
    Reduces row height and indent padding.
    """

    show_icons: bool | None = None
    """
    When ``True`` icon decorations are shown beside node labels.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `outline` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `outline` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `outline` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `outline` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `outline` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `outline` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `outline` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `outline` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `outline` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `outline` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `outline` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `outline` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `outline` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `outline` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `outline` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `outline` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `outline` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `outline` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `outline` runtime control.
    """

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
