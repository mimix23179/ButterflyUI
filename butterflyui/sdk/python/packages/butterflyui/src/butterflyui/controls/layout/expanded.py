from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Expanded"]

class Expanded(Component):
    """
    Expands a child to fill remaining space inside a ``Row``, ``Column``, or ``Flex``.

    The runtime wraps Flutter's ``Expanded`` widget. ``flex`` determines the
    proportion of available space allocated to this child relative to sibling
    flex children. ``fit`` controls how the child is sized into the allocated
    space: ``"tight"`` forces the child to fill, ``"loose"`` allows it to be
    smaller.

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Fixed"),
        bui.Expanded(bui.Text("Fill remaining"), flex=1),
    )
    ```

    Args:
        flex:
            Flex factor. Higher values claim a larger share of available space
            relative to sibling flex children. Defaults to ``1``.
        fit:
            How the child fills the allocated space. Values: ``"tight"``
            (fill exactly), ``"loose"`` (at most the allocated size).
    """

    control_type = "expanded"

    def __init__(
        self,
        child: Any | None = None,
        *,
        flex: int = 1,
        fit: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, flex=int(flex), fit=fit, **kwargs)
        super().__init__(
            child=child,
            props=merged,
            style=style,
            strict=strict,
        )
