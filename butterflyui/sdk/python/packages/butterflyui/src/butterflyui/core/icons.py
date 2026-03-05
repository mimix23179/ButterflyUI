from __future__ import annotations

from typing import Any

from .icon_data import (
    ICON_NAMES,
    ICON_SET,
    IconData,
    icon_names,
    is_icon_name,
    normalize_icon_name,
    normalize_icon_value,
)

__all__ = [
    "IconData",
    "ICON_NAMES",
    "ICON_SET",
    "Icons",
    "icon",
    "icon_names",
    "is_icon_name",
    "normalize_icon_name",
    "normalize_icon_value",
]


class _IconsNamespace:
    """Namespace helper so icons can be referenced as ``Icons.search``."""

    def __iter__(self):
        return iter(ICON_NAMES)

    def __contains__(self, value: object) -> bool:
        if not isinstance(value, str):
            return False
        return is_icon_name(value)

    def __getattr__(self, name: str) -> str:
        normalized = normalize_icon_name(name)
        if normalized and normalized in ICON_SET:
            return normalized
        raise AttributeError(name)


Icons = _IconsNamespace()


def icon(name: str, *, strict: bool = True) -> str:
    normalized = normalize_icon_name(name)
    if normalized is None:
        raise ValueError("icon name cannot be empty")
    if strict and normalized not in ICON_SET:
        raise ValueError(f"Unknown icon name '{name}'.")
    return normalized


# Optional convenience constants: icons.SEARCH, icons.ARROW_LEFT, ...
for _name in ICON_NAMES:
    _const = _name.upper()
    if not _const.isidentifier() or _const in globals():
        continue
    globals()[_const] = _name
    __all__.append(_const)
