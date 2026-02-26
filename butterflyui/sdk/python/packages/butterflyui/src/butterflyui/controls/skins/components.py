from __future__ import annotations

from .submodules import (
    CATEGORY_COMPONENTS,
    MODULE_CATEGORY,
    MODULE_COMPONENTS,
    get_skins_category_components,
    get_skins_commands_component,
    get_skins_component,
    get_skins_core_component,
    get_skins_editors_component,
    get_skins_module_category,
    get_skins_tokens_component,
)

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    "MODULE_COMPONENTS",
    "CATEGORY_COMPONENTS",
    "MODULE_CATEGORY",
    "get_skins_component",
    "get_skins_core_component",
    "get_skins_tokens_component",
    "get_skins_editors_component",
    "get_skins_commands_component",
    "get_skins_category_components",
    "get_skins_module_category",
    *sorted(component.__name__ for component in MODULE_COMPONENTS.values()),
]
