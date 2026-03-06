from __future__ import annotations

import json
from dataclasses import dataclass
from importlib import resources
from collections.abc import Mapping
from typing import Any

__all__ = [
    "IconData",
    "ICON_NAMES",
    "ICON_SET",
    "icon_names",
    "is_icon_name",
    "normalize_icon_name",
    "normalize_icon_value",
    "suggest_icon_names",
]


@dataclass(frozen=True, slots=True)
class IconData:
    """Typed icon descriptor used by Python-side icon registry helpers."""

    name: str
    codepoint: int | None = None


def _load_icon_names() -> tuple[str, ...]:
    resource = resources.files(__package__).joinpath("icons.json")
    try:
        payload = json.loads(resource.read_text(encoding="utf-8"))
    except FileNotFoundError:
        return tuple()

    raw_icons: Any
    if isinstance(payload, Mapping):
        raw_icons = payload.get("icons", [])
    else:
        raw_icons = payload

    if not isinstance(raw_icons, list):
        return tuple()

    names: list[str] = []
    seen: set[str] = set()
    for entry in raw_icons:
        if not isinstance(entry, str):
            continue
        normalized = normalize_icon_name(entry)
        if not normalized or normalized in seen:
            continue
        seen.add(normalized)
        names.append(normalized)
    return tuple(names)


def normalize_icon_name(value: str | None) -> str | None:
    if value is None:
        return None
    normalized = value.strip().lower().replace("-", "_").replace(" ", "_")
    return normalized or None


ICON_NAMES: tuple[str, ...] = _load_icon_names()
ICON_SET: frozenset[str] = frozenset(ICON_NAMES)


def icon_names() -> tuple[str, ...]:
    return ICON_NAMES


def is_icon_name(value: str | None) -> bool:
    normalized = normalize_icon_name(value)
    return normalized in ICON_SET if normalized is not None else False


def suggest_icon_names(value: str | None, *, limit: int = 8) -> list[str]:
    normalized = normalize_icon_name(value)
    if not normalized:
        return []

    starts_with = [name for name in ICON_NAMES if name.startswith(normalized)]
    if len(starts_with) >= limit:
        return starts_with[:limit]

    contains = [
        name
        for name in ICON_NAMES
        if normalized in name and name not in starts_with
    ]
    return (starts_with + contains)[:limit]


def normalize_icon_value(value: Any, *, strict: bool = False) -> Any:
    if value is None:
        return None

    if isinstance(value, bool):
        return value

    if isinstance(value, int):
        return value

    if isinstance(value, str):
        normalized = normalize_icon_name(value)
        if normalized is None:
            return value
        if strict and normalized not in ICON_SET:
            suggestions = suggest_icon_names(normalized)
            if suggestions:
                suggestion_text = ", ".join(suggestions)
                raise ValueError(
                    f"Unknown icon name '{value}'. Did you mean: {suggestion_text}?"
                )
            raise ValueError(f"Unknown icon name '{value}'.")
        return normalized

    if isinstance(value, Mapping):
        out = dict(value)
        for key in ("icon", "name", "value", "glyph"):
            if key in out:
                out[key] = normalize_icon_value(out[key], strict=strict)
        return out

    return value