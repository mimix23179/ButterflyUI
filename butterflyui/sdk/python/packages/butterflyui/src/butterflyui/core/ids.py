from __future__ import annotations

import uuid

__all__ = ["new_control_id"]


def new_control_id() -> str:
    return uuid.uuid4().hex
