from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Sprite"]

class Sprite(Component):
    control_type = "sprite"

    def __init__(
        self,
        *,
        src: str | None = None,
        frame_width: float | None = None,
        frame_height: float | None = None,
        frames: int | None = None,
        fps: float | None = None,
        loop: bool | None = None,
        autoplay: bool | None = None,
        play: bool | None = None,
        columns: int | None = None,
        rows: int | None = None,
        fit: str | None = None,
        opacity: float | None = None,
        progress: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            kind="sprite",
            frame_width=frame_width,
            frame_height=frame_height,
            frames=frames,
            fps=fps,
            loop=loop,
            autoplay=autoplay,
            play=play,
            columns=columns,
            rows=rows,
            fit=fit,
            opacity=opacity,
            progress=progress,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
