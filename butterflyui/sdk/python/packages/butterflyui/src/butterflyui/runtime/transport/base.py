from __future__ import annotations

from typing import Protocol


class RuntimeTransportServer(Protocol):
    async def start(self) -> None:
        ...

    async def stop(self) -> None:
        ...

    async def wait_for_disconnect(self) -> None:
        ...