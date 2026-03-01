from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Spacer"]

class Spacer(Component):
    """
    Flexible spacer that consumes available space inside a flex layout.

    Similar to ``FlexSpacer`` but exposes runtime control methods
    (``set_flex``, ``get_state``, ``emit``). ``flex`` controls the proportion
    of available space consumed relative to other flexible siblings.

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.Spacer(flex=1),
        bui.Text("Right"),
        events=["resize"],
    )
    ```

    Args:
        flex:
            Flex factor. Higher values claim more space relative to sibling
            flex children. Defaults to ``1``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "spacer"

    def __init__(
        self,
        *,
        flex: int = 1,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            flex=int(flex),
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_flex(self, session: Any, flex: int) -> dict[str, Any]:
        return self.invoke(session, "set_flex", {"flex": int(flex)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
