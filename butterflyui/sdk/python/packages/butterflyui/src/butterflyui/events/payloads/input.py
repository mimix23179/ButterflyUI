from __future__ import annotations

from dataclasses import dataclass
from typing import Any

__all__ = ["ChangeEvent", "SubmitEvent"]


@dataclass(slots=True)
class ChangeEvent:
    value: Any = None
    data: Any = None


@dataclass(slots=True)
class SubmitEvent:
    value: Any = None
    data: Any = None
