from __future__ import annotations

import asyncio
from typing import Any, Callable, Optional

from ..app import ButterflyUISession
from .control import Component

__all__ = ["TaskQueue", "Progress"]


class TaskQueue:
    def __init__(self, max_concurrency: int = 1) -> None:
        self._sem = asyncio.Semaphore(max(1, int(max_concurrency)))

    async def run(self, coro: Callable[[], Any] | Any) -> Any:
        async with self._sem:
            if callable(coro):
                return await coro()
            return await coro


class Progress:
    def __init__(self, session: ButterflyUISession, target: Component) -> None:
        self._session = session
        self._target = target

    def update(self, *, value: Optional[float] = None, label: Optional[str] = None) -> None:
        props: dict[str, Any] = {}
        if value is not None:
            props["value"] = value
        if label is not None:
            props["label"] = label
        if props:
            self._target.patch(session=self._session, **props)

    def __call__(self, value: Optional[float] = None, label: Optional[str] = None) -> None:
        self.update(value=value, label=label)
