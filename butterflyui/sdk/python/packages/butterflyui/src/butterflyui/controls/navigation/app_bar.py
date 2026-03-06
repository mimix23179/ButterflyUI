from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AppBar"]

class AppBar(Component):
    """
    Application top bar with title block, optional search, and trailing actions.
    
    ``AppBar`` and ``TopBar`` share the same runtime renderer. ``leading``
    places a widget at the start edge, ``actions`` supplies trailing widgets,
    and ``title``/``subtitle`` populate the label block.
    
    The control accepts shared frame/layout props through ``props`` (alignment,
    margin, sizing constraints, radius, clip behavior) for consistent placement
    in custom shells.

    Example:
    
    ```python
    import butterflyui as bui
    
    bui.AppBar(
        title="My App",
        subtitle="Dashboard",
        actions=[{"icon": "settings", "id": "settings"}],
        events=["action"],
    )
    ```
    """


    title: str | None = None
    """
    Primary title text displayed in the app bar.
    """

    subtitle: str | None = None
    """
    Optional secondary text shown below the title.
    """

    leading: Any | None = None
    """
    Widget placed at the leading (start) edge of the bar.
    """

    actions: list[Any] | None = None
    """
    List of trailing action widget specs shown at the end of the bar.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "app_bar"

    def __init__(
        self,
        *,
        title: str | None = None,
        subtitle: str | None = None,
        leading: Any | None = None,
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
            leading=leading,
            actions=actions,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_title(self, session: Any, title: str, subtitle: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {"title": title}
        if subtitle is not None:
            payload["subtitle"] = subtitle
        return self.invoke(session, "set_title", payload)

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
