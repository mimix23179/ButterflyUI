from __future__ import annotations

from typing import Any, Iterator

from .icon_data import IconData

ICON_NAMES: tuple[str, ...]
ICON_SET: frozenset[str]


def icon(name: str, *, strict: bool = True) -> str: ...

def icon_names() -> tuple[str, ...]: ...

def is_icon_name(value: str | None) -> bool: ...

def normalize_icon_name(value: str | None) -> str | None: ...

def normalize_icon_value(value: Any, *, strict: bool = False) -> Any: ...


class _IconsNamespace:
    def __iter__(self) -> Iterator[str]: ...
    def __contains__(self, value: object) -> bool: ...
    def __getattr__(self, name: str) -> str: ...


Icons: _IconsNamespace