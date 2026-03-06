from __future__ import annotations

from ..registry import iter_control_specs

_TOOL_CATEGORIES = {"customization", "productivity", "gallery"}
CONTROL_SPECS = tuple(spec for spec in iter_control_specs() if spec.category in _TOOL_CATEGORIES)

__all__ = ["CONTROL_SPECS"]
