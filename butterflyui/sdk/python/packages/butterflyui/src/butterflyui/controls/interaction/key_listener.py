from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["KeyListener"]

class KeyListener(Component):
    """
    Captures raw keyboard events for the subtree below it.

    Wraps the child in a Flutter ``Focus`` widget and a
    ``KeyEventListener`` (or equivalent) that intercepts
    ``KeyDownEvent``, ``KeyUpEvent``, and ``KeyRepeatEvent``.
    Each intercepted event emits a ``key_down``, ``key_up``, or
    ``key_repeat`` event with a payload containing ``key`` (logical
    key name), ``physical_key`` (physical key code), and
    ``modifiers`` (active modifier flags).

    Setting ``autofocus`` causes the node to grab keyboard focus
    immediately when mounted so events are captured without a
    preceding tap.

    ```python
    import butterflyui as bui

    bui.KeyListener(
        bui.TextField(),
        autofocus=True,
    )
    ```

    Args:
        autofocus:
            If ``True``, the focus node requests focus when first
            mounted.
        enabled:
            If ``False``, key events are not captured or emitted.
    """
    control_type = "key_listener"

    def __init__(
        self,
        child: Any | None = None,
        *,
        autofocus: bool | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            autofocus=autofocus,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
