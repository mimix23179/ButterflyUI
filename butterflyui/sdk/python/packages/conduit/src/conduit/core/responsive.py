from __future__ import annotations

from dataclasses import dataclass
from typing import Mapping, Optional, TypeVar

T = TypeVar("T")

__all__ = ["Breakpoints"]


@dataclass(slots=True)
class Breakpoints:
    xs: float = 0.0
    sm: float = 480.0
    md: float = 768.0
    lg: float = 1024.0
    xl: float = 1280.0

    def match(self, width: float) -> str:
        if width >= self.xl:
            return "xl"
        if width >= self.lg:
            return "lg"
        if width >= self.md:
            return "md"
        if width >= self.sm:
            return "sm"
        return "xs"

    def resolve(self, width: float, values: Mapping[str, T], default: Optional[T] = None) -> Optional[T]:
        order = ["xs", "sm", "md", "lg", "xl"]
        thresholds = {
            "xs": self.xs,
            "sm": self.sm,
            "md": self.md,
            "lg": self.lg,
            "xl": self.xl,
        }

        candidates = [name for name in order if width >= thresholds[name]]
        for name in reversed(candidates):
            if name in values:
                return values[name]

        for name in order:
            if name in values:
                return values[name]

        return default
