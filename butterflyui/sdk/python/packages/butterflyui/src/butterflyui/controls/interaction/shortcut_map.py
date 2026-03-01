from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ShortcutMap"]

class ShortcutMap(Component):
    """
    Registers keyboard shortcuts and dispatches them to Python handlers.

    Wraps the child in a Flutter ``Shortcuts`` + ``Actions`` (or a
    global hotkey listener when ``use_global_hotkeys`` is ``True``).
    Each entry in ``shortcuts`` is a mapping with at least a ``key``
    descriptor (e.g. ``{"key": "Ctrl+S"}``) and an optional
    ``event`` name (defaults to the key string).  When the shortcut
    is triggered the corresponding event is emitted with the shortcut
    descriptor as payload.

    ```python
    import butterflyui as bui

    bui.ShortcutMap(
        bui.Column(bui.TextField()),
        shortcuts=[
            {"key": "Ctrl+S", "event": "save"},
            {"key": "Ctrl+Z", "event": "undo"},
        ],
    )
    ```

    Args:
        shortcuts:
            List of shortcut descriptor mappings.  Each entry must
            have a ``"key"`` field (e.g. ``"Ctrl+S"``) and may
            include an ``"event"`` name emitted when triggered.
        enabled:
            If ``False``, no shortcuts are active.
        use_global_hotkeys:
            If ``True``, shortcuts are registered as system-wide
            global hotkeys (desktop only) that fire even when the
            window does not have focus.
    """
    control_type = "shortcut_map"

    def __init__(
        self,
        child: Any | None = None,
        *,
        shortcuts: list[Mapping[str, Any]] | None = None,
        enabled: bool | None = None,
        use_global_hotkeys: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            shortcuts=shortcuts,
            enabled=enabled,
            use_global_hotkeys=use_global_hotkeys,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
