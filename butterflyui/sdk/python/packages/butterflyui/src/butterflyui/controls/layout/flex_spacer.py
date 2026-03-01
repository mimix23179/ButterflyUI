from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FlexSpacer"]

class FlexSpacer(Component):
    """
    Invisible spacer that consumes flex space inside a ``Row`` or ``Column``.

    The runtime maps to Flutter's ``Spacer`` (a zero-sized ``Expanded``).
    ``flex`` is the flex factor; larger values claim more of the available
    space relative to sibling flex children.

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.FlexSpacer(flex=1),
        bui.Text("Right"),
    )
    ```

    Args:
        flex:
            Flex factor shared among sibling ``Expanded`` children. Defaults
            to ``1``.
    """

    control_type = "flex_spacer"

    def __init__(
        self,
        *,
        flex: int = 1,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, flex=int(flex), **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
