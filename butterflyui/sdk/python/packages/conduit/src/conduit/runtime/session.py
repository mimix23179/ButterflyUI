from __future__ import annotations

from contextvars import ContextVar
from typing import Optional, TYPE_CHECKING

if TYPE_CHECKING:
    from ..app import ConduitSession

_current_session: ContextVar[Optional["ConduitSession"]] = ContextVar(
    "conduit_current_session", default=None
)


def set_current_session(session: "ConduitSession" | None) -> None:
    _current_session.set(session)


def get_current_session() -> "ConduitSession" | None:
    return _current_session.get()