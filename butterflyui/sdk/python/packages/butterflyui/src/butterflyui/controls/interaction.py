from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "KeyListener",
    "ShortcutMap",
]


class KeyListener(Component):
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


class ShortcutMap(Component):
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



