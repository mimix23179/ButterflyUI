from __future__ import annotations

from .submodules import (
    CATEGORY_COMPONENTS,
    MODULE_CATEGORY,
    MODULE_COMPONENTS,
    get_code_editor_category_components,
    get_code_editor_commands_component,
    get_code_editor_component,
    get_code_editor_diagnostics_component,
    get_code_editor_diff_component,
    get_code_editor_document_component,
    get_code_editor_editor_component,
    get_code_editor_explorer_component,
    get_code_editor_layout_component,
    get_code_editor_module_category,
    get_code_editor_search_component,
    get_code_editor_tabs_component,
)

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    "MODULE_COMPONENTS",
    "CATEGORY_COMPONENTS",
    "MODULE_CATEGORY",
    "get_code_editor_component",
    "get_code_editor_editor_component",
    "get_code_editor_document_component",
    "get_code_editor_tabs_component",
    "get_code_editor_explorer_component",
    "get_code_editor_search_component",
    "get_code_editor_diagnostics_component",
    "get_code_editor_diff_component",
    "get_code_editor_commands_component",
    "get_code_editor_layout_component",
    "get_code_editor_category_components",
    "get_code_editor_module_category",
    *sorted(component.__name__ for component in MODULE_COMPONENTS.values()),
]
