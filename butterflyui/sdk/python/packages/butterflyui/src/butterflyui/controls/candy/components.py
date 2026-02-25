from __future__ import annotations

from .submodules import MODULE_COMPONENTS

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    "MODULE_COMPONENTS",
    *sorted(component.__name__ for component in MODULE_COMPONENTS.values()),
]
