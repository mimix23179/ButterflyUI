from __future__ import annotations

from collections.abc import Mapping
from typing import Any

__all__ = ["invoke_control_method", "invoke_control_method_async"]


def invoke_control_method(
    session: Any,
    control_id: str,
    method: str,
    args: Mapping[str, Any] | None = None,
    *,
    timeout: float | None = 10.0,
    **kwargs: Any,
) -> dict[str, Any]:
    return session.invoke(control_id, method, dict(args or {}), timeout=timeout, **kwargs)


async def invoke_control_method_async(
    session: Any,
    control_id: str,
    method: str,
    args: Mapping[str, Any] | None = None,
    *,
    timeout: float | None = 10.0,
    **kwargs: Any,
) -> dict[str, Any]:
    return await session.invoke_async(control_id, method, dict(args or {}), timeout=timeout, **kwargs)
