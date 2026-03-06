from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["KeyListener"]

@butterfly_control('key_listener')
class KeyListener(LayoutControl):
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

    Example:

    ```python
    import butterflyui as bui

    bui.KeyListener(
        bui.TextField(),
        autofocus=True,
    )
    ```
    """

    autofocus: bool | None = None
    """
    If ``True``, the focus node requests focus when first
    mounted.
    """
