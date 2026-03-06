from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TopBar"]


class TopBar(Component):
    """
    Application top bar with optional inline search and trailing actions.
    
    The runtime renders a top navigation surface composed of ``title`` and
    optional ``subtitle`` plus a search field and trailing ``actions``.
    ``center_title`` controls title alignment.
    
    ``TopBar`` uses the same runtime renderer as ``AppBar`` and supports
    shared layout hints through ``props`` (alignment/position, margin,
    constraints, radius, and clip behavior).
    
    Example:
    
    ```python
    import butterflyui as bui
    
    bui.TopBar(
        title="Explorer",
        show_search=True,
        search_placeholder="Search files...",
        actions=[{"id": "filter", "icon": "filter_list"}],
        events=["search", "action"],
    )
    ```
    """


    title: str | None = None
    """
    Primary heading text rendered by the control.
    """

    subtitle: str | None = None
    """
    Optional secondary text shown below the title.
    """

    center_title: bool | None = None
    """
    Centers the title when ``True``.
    """

    show_search: bool | None = None
    """
    Shows an inline search field when ``True``.
    """

    search_value: str | None = None
    """
    Current text value shown in the control's search input.
    """

    search_placeholder: str | None = None
    """
    Placeholder text for the search field.
    """

    actions: list[Any] | None = None
    """
    Ordered list of action descriptors rendered or triggered by this control. Each entry should match the runtime payload shape expected for the control type.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "top_bar"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        subtitle: str | None = None,
        center_title: bool | None = None,
        show_search: bool | None = None,
        search_value: str | None = None,
        search_placeholder: str | None = None,
        actions: list[Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            subtitle=subtitle,
            center_title=center_title,
            show_search=show_search,
            search_value=search_value,
            search_placeholder=search_placeholder,
            actions=actions,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_title(self, session: Any, title: str) -> dict[str, Any]:
        return self.invoke(session, "set_title", {"title": title})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )

    def trigger(
        self,
        session: Any,
        event: str = "change",
        **payload: Any,
    ) -> dict[str, Any]:
        return self.emit(session, event, payload)
