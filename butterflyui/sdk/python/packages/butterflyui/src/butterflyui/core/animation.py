from __future__ import annotations

from dataclasses import dataclass
from typing import Any

__all__ = ["AnimationSpec"]


@dataclass(slots=True)
class AnimationSpec:
    preset: str | None = None
    duration_ms: int | None = None
    curve: str | None = None
    offset: tuple[float, float] | None = None
    instant: bool | None = None
    animate_on_mount: bool | None = None
    extra: dict[str, Any] | None = None

    def to_json(self) -> dict[str, Any]:
        out: dict[str, Any] = {}
        if self.preset is not None:
            out["preset"] = self.preset
        if self.duration_ms is not None:
            out["duration_ms"] = int(self.duration_ms)
        if self.curve is not None:
            out["curve"] = str(self.curve)
        if self.offset is not None:
            out["offset"] = [float(self.offset[0]), float(self.offset[1])]
        if self.instant is not None:
            out["instant"] = bool(self.instant)
        if self.animate_on_mount is not None:
            out["animate_on_mount"] = bool(self.animate_on_mount)
        if self.extra:
            out.update(self.extra)
        return out

    def __butterflyui_json__(self) -> dict[str, Any]:
        return self.to_json()

    @staticmethod
    def from_json(data: dict | None) -> "AnimationSpec | None":
        if not data:
            return None
        preset = data.get("preset")
        duration_ms = data.get("duration_ms")
        curve = data.get("curve")
        offset = None
        if isinstance(data.get("offset"), (list, tuple)) and len(data.get("offset")) >= 2:
            try:
                offset = (float(data["offset"][0]), float(data["offset"][1]))
            except Exception:
                offset = None
        instant = data.get("instant")
        animate_on_mount = data.get("animate_on_mount")
        return AnimationSpec(preset=preset, duration_ms=int(duration_ms) if duration_ms is not None else None, curve=curve, offset=offset, instant=bool(instant) if instant is not None else None, animate_on_mount=bool(animate_on_mount) if animate_on_mount is not None else None)
