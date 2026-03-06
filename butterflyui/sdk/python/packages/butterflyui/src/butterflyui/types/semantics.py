from __future__ import annotations

from dataclasses import dataclass

__all__ = ["SemanticsProps"]


@dataclass(slots=True)
class SemanticsProps:
    label: str | None = None
    hint: str | None = None
    role: str | None = None

    def to_json(self) -> dict[str, str]:
        out: dict[str, str] = {}
        if self.label is not None:
            out["label"] = self.label
        if self.hint is not None:
            out["hint"] = self.hint
        if self.role is not None:
            out["role"] = self.role
        return out
