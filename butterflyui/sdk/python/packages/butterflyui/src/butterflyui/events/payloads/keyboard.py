from __future__ import annotations

from dataclasses import dataclass

__all__ = ["KeyEvent"]


@dataclass(slots=True)
class KeyEvent:
    key: str | None = None
    code: str | None = None
    alt: bool = False
    ctrl: bool = False
    meta: bool = False
    shift: bool = False
