from __future__ import annotations

from dataclasses import dataclass
from typing import Any

__all__ = ["OverlayOpenEvent", "OverlayDismissEvent"]


@dataclass(slots=True)
class OverlayOpenEvent:
    control_id: str | None = None
    data: Any = None


@dataclass(slots=True)
class OverlayDismissEvent:
    control_id: str | None = None
    reason: str | None = None
    data: Any = None
