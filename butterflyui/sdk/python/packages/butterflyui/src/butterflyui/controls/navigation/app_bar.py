from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["AppBar"]

@butterfly_control('app_bar')
class AppBar(LayoutControl):
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

    actions: list[Any] | None = None
    """
    List of trailing action widget specs shown at the end of the bar.
    """

    align: Any | None = None
    """
    Align value forwarded to the `app_bar` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `app_bar` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `app_bar` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `app_bar` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `app_bar` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `app_bar` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `app_bar` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `app_bar` runtime control.
    """

    def set_title(self, session: Any, title: str, subtitle: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {"title": title}
        if subtitle is not None:
            payload["subtitle"] = subtitle
        return self.invoke(session, "set_title", payload)

    def set_search(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_search", {"value": value})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
