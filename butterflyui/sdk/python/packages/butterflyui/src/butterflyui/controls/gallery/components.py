from __future__ import annotations

from .submodules import (
    CATEGORY_COMPONENTS,
    MODULE_CATEGORY,
    MODULE_COMPONENTS,
    get_gallery_category_components,
    get_gallery_commands_component,
    get_gallery_component,
    get_gallery_customization_component,
    get_gallery_items_component,
    get_gallery_layout_component,
    get_gallery_media_component,
    get_gallery_module_category,
)

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    "MODULE_COMPONENTS",
    "CATEGORY_COMPONENTS",
    "MODULE_CATEGORY",
    "get_gallery_component",
    "get_gallery_layout_component",
    "get_gallery_items_component",
    "get_gallery_media_component",
    "get_gallery_commands_component",
    "get_gallery_customization_component",
    "get_gallery_category_components",
    "get_gallery_module_category",
    *sorted(component.__name__ for component in MODULE_COMPONENTS.values()),
]
