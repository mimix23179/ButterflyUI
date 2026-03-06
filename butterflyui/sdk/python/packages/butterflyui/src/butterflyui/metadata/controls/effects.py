from __future__ import annotations

from ..registry import iter_control_specs

CONTROL_SPECS = tuple(spec for spec in iter_control_specs() if "effect" in spec.tags)

__all__ = ["CONTROL_SPECS"]
