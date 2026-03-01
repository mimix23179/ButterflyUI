from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FocusAnchor"]

class FocusAnchor(Component):
    """
    Attaches a Flutter ``FocusNode`` to its child for programmatic focus control.

    Wraps the child in a ``Focus`` widget, exposing precise control
    over the focus system.  Setting ``autofocus`` causes the node to
    acquire focus as soon as the widget is mounted.  The traversal
    flags let you exclude the node or its descendants from the
    keyboard-navigation tab order.  ``focus`` and ``unfocus`` can be
    called from Python to move focus imperatively.

    ``focus_gained`` and ``focus_lost`` events are emitted when the
    node transitions between focused and unfocused states.

    ```python
    import butterflyui as bui

    anchor = bui.FocusAnchor(
        bui.TextField(placeholder="Auto-focused"),
        autofocus=True,
    )
    ```

    Args:
        autofocus:
            If ``True``, the node requests focus when first mounted.
        enabled:
            If ``False``, the focus node is inactive.
        can_request_focus:
            If ``False``, the node will not accept focus requests.
        skip_traversal:
            If ``True``, the node is skipped during tab-order
            traversal.
        descendants_are_focusable:
            If ``False``, descendant widgets cannot receive focus.
        descendants_are_traversable:
            If ``False``, descendants are excluded from tab-order
            traversal.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "focus_anchor"

    def __init__(
        self,
        child: Any | None = None,
        *,
        autofocus: bool | None = None,
        enabled: bool | None = None,
        can_request_focus: bool | None = None,
        skip_traversal: bool | None = None,
        descendants_are_focusable: bool | None = None,
        descendants_are_traversable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            autofocus=autofocus,
            enabled=enabled,
            can_request_focus=can_request_focus,
            skip_traversal=skip_traversal,
            descendants_are_focusable=descendants_are_focusable,
            descendants_are_traversable=descendants_are_traversable,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def unfocus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "unfocus", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
