from __future__ import annotations

from contextvars import ContextVar
from typing import Optional, TYPE_CHECKING

if TYPE_CHECKING:
    from ..app import ButterflyUISession

_current_session: ContextVar[Optional["ButterflyUISession"]] = ContextVar(
    "butterflyui_current_session", default=None
)


def set_current_session(session: "ButterflyUISession" | None) -> None:
    _current_session.set(session)


def get_current_session() -> "ButterflyUISession" | None:
    return _current_session.get()