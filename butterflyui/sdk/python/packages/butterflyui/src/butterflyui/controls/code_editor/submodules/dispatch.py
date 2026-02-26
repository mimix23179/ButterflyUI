"""
Dispatch layer for the CodeEditor umbrella control.

Maps every code-editor submodule string to its Python class and provides
category-based lookup helpers that mirror the Dart submodule registry.
"""
from __future__ import annotations

from typing import Optional, Type

# ---------------------------------------------------------------------------
# Individual module imports
# ---------------------------------------------------------------------------

from .code_buffer import CodeBuffer
from .code_category_layer import CodeCategoryLayer
from .code_document import CodeDocument
from .command_bar import CommandBar
from .command_search import CommandSearch
from .diagnostic_stream import DiagnosticStream
from .diagnostics_panel import DiagnosticsPanel
from .diff import Diff
from .diff_narrator import DiffNarrator
from .dock import Dock
from .dock_graph import DockGraph
from .dock_pane import DockPane
from .document_tab_strip import DocumentTabStrip
from .editor_intent_router import EditorIntentRouter
from .editor_minimap import EditorMinimap
from .editor_surface import EditorSurface
from .editor_tabs import EditorTabs
from .editor_view import EditorView
from .empty_state_view import EmptyStateView
from .empty_view import EmptyView
from .explorer_tree import ExplorerTree
from .export_panel import ExportPanel
from .file_tabs import FileTabs
from .file_tree import FileTree
from .ghost_editor import GhostEditor
from .gutter import Gutter
from .hint import Hint
from .ide import Ide
from .inline_error_view import InlineErrorView
from .inline_search_overlay import InlineSearchOverlay
from .inline_widget import InlineWidget
from .inspector import Inspector
from .intent_panel import IntentPanel
from .intent_router import IntentRouter
from .intent_search import IntentSearch
from .mini_map import MiniMap
from .query_token import QueryToken
from .scope_picker import ScopePicker
from .scoped_search_replace import ScopedSearchReplace
from .search_box import SearchBox
from .search_everything_panel import SearchEverythingPanel
from .search_field import SearchField
from .search_history import SearchHistory
from .search_intent import SearchIntent
from .search_item import SearchItem
from .search_provider import SearchProvider
from .search_results_view import SearchResultsView
from .search_scope_selector import SearchScopeSelector
from .search_source import SearchSource
from .semantic_search import SemanticSearch
from .smart_search_bar import SmartSearchBar
from .tree import Tree
from .workbench_editor import WorkbenchEditor
from .workspace_explorer import WorkspaceExplorer

# ---------------------------------------------------------------------------
# Category dictionaries
# ---------------------------------------------------------------------------

EDITOR_COMPONENTS: dict[str, type] = {
    "ide": Ide,
    "editor_surface": EditorSurface,
    "editor_view": EditorView,
    "workbench_editor": WorkbenchEditor,
    "ghost_editor": GhostEditor,
    "editor_minimap": EditorMinimap,
    "mini_map": MiniMap,
    "gutter": Gutter,
    "hint": Hint,
    "inline_widget": InlineWidget,
}

DOCUMENT_COMPONENTS: dict[str, type] = {
    "code_buffer": CodeBuffer,
    "code_category_layer": CodeCategoryLayer,
    "code_document": CodeDocument,
}

TABS_COMPONENTS: dict[str, type] = {
    "editor_tabs": EditorTabs,
    "document_tab_strip": DocumentTabStrip,
    "file_tabs": FileTabs,
}

EXPLORER_COMPONENTS: dict[str, type] = {
    "file_tree": FileTree,
    "explorer_tree": ExplorerTree,
    "workspace_explorer": WorkspaceExplorer,
    "tree": Tree,
}

SEARCH_COMPONENTS: dict[str, type] = {
    "smart_search_bar": SmartSearchBar,
    "search_box": SearchBox,
    "search_field": SearchField,
    "search_scope_selector": SearchScopeSelector,
    "search_source": SearchSource,
    "search_provider": SearchProvider,
    "search_history": SearchHistory,
    "search_intent": SearchIntent,
    "search_item": SearchItem,
    "search_results_view": SearchResultsView,
    "search_everything_panel": SearchEverythingPanel,
    "semantic_search": SemanticSearch,
    "scoped_search_replace": ScopedSearchReplace,
    "inline_search_overlay": InlineSearchOverlay,
    "intent_search": IntentSearch,
    "query_token": QueryToken,
}

DIAGNOSTICS_COMPONENTS: dict[str, type] = {
    "diagnostics_panel": DiagnosticsPanel,
    "diagnostic_stream": DiagnosticStream,
    "inline_error_view": InlineErrorView,
}

DIFF_COMPONENTS: dict[str, type] = {
    "diff": Diff,
    "diff_narrator": DiffNarrator,
}

COMMANDS_COMPONENTS: dict[str, type] = {
    "command_bar": CommandBar,
    "command_search": CommandSearch,
    "editor_intent_router": EditorIntentRouter,
    "intent_router": IntentRouter,
    "intent_panel": IntentPanel,
    "scope_picker": ScopePicker,
    "export_panel": ExportPanel,
}

LAYOUT_COMPONENTS: dict[str, type] = {
    "dock": Dock,
    "dock_graph": DockGraph,
    "dock_pane": DockPane,
    "inspector": Inspector,
    "empty_state_view": EmptyStateView,
    "empty_view": EmptyView,
}

# ---------------------------------------------------------------------------
# Combined lookup tables
# ---------------------------------------------------------------------------

MODULE_COMPONENTS: dict[str, type] = {
    **EDITOR_COMPONENTS,
    **DOCUMENT_COMPONENTS,
    **TABS_COMPONENTS,
    **EXPLORER_COMPONENTS,
    **SEARCH_COMPONENTS,
    **DIAGNOSTICS_COMPONENTS,
    **DIFF_COMPONENTS,
    **COMMANDS_COMPONENTS,
    **LAYOUT_COMPONENTS,
}

CATEGORY_COMPONENTS: dict[str, dict[str, type]] = {
    "editor": EDITOR_COMPONENTS,
    "document": DOCUMENT_COMPONENTS,
    "tabs": TABS_COMPONENTS,
    "explorer": EXPLORER_COMPONENTS,
    "search": SEARCH_COMPONENTS,
    "diagnostics": DIAGNOSTICS_COMPONENTS,
    "diff": DIFF_COMPONENTS,
    "commands": COMMANDS_COMPONENTS,
    "layout": LAYOUT_COMPONENTS,
}

MODULE_CATEGORY: dict[str, str] = {
    module: category
    for category, modules in CATEGORY_COMPONENTS.items()
    for module in modules
}

# ---------------------------------------------------------------------------
# Dispatch functions
# ---------------------------------------------------------------------------


def get_code_editor_component(module: str) -> Optional[Type]:
    """Return the class for *module*, or ``None`` if unknown."""
    return MODULE_COMPONENTS.get(module)


def get_code_editor_editor_component(module: str) -> Optional[Type]:
    return EDITOR_COMPONENTS.get(module)


def get_code_editor_document_component(module: str) -> Optional[Type]:
    return DOCUMENT_COMPONENTS.get(module)


def get_code_editor_tabs_component(module: str) -> Optional[Type]:
    return TABS_COMPONENTS.get(module)


def get_code_editor_explorer_component(module: str) -> Optional[Type]:
    return EXPLORER_COMPONENTS.get(module)


def get_code_editor_search_component(module: str) -> Optional[Type]:
    return SEARCH_COMPONENTS.get(module)


def get_code_editor_diagnostics_component(module: str) -> Optional[Type]:
    return DIAGNOSTICS_COMPONENTS.get(module)


def get_code_editor_diff_component(module: str) -> Optional[Type]:
    return DIFF_COMPONENTS.get(module)


def get_code_editor_commands_component(module: str) -> Optional[Type]:
    return COMMANDS_COMPONENTS.get(module)


def get_code_editor_layout_component(module: str) -> Optional[Type]:
    return LAYOUT_COMPONENTS.get(module)


def get_code_editor_category_components(category: str) -> Optional[dict[str, type]]:
    """Return the category dict for *category*, or ``None`` if unknown."""
    return CATEGORY_COMPONENTS.get(category)


def get_code_editor_module_category(module: str) -> Optional[str]:
    """Return the category name for *module*, or ``None`` if unknown."""
    return MODULE_CATEGORY.get(module)


__all__ = [
    # Category dicts
    "EDITOR_COMPONENTS",
    "DOCUMENT_COMPONENTS",
    "TABS_COMPONENTS",
    "EXPLORER_COMPONENTS",
    "SEARCH_COMPONENTS",
    "DIAGNOSTICS_COMPONENTS",
    "DIFF_COMPONENTS",
    "COMMANDS_COMPONENTS",
    "LAYOUT_COMPONENTS",
    # Combined
    "MODULE_COMPONENTS",
    "CATEGORY_COMPONENTS",
    "MODULE_CATEGORY",
    # Functions
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
    # Classes (re-exported for convenience)
    "Ide",
    "EditorSurface",
    "EditorView",
    "WorkbenchEditor",
    "GhostEditor",
    "EditorMinimap",
    "MiniMap",
    "Gutter",
    "Hint",
    "InlineWidget",
    "CodeBuffer",
    "CodeCategoryLayer",
    "CodeDocument",
    "EditorTabs",
    "DocumentTabStrip",
    "FileTabs",
    "FileTree",
    "ExplorerTree",
    "WorkspaceExplorer",
    "Tree",
    "SmartSearchBar",
    "SearchBox",
    "SearchField",
    "SearchScopeSelector",
    "SearchSource",
    "SearchProvider",
    "SearchHistory",
    "SearchIntent",
    "SearchItem",
    "SearchResultsView",
    "SearchEverythingPanel",
    "SemanticSearch",
    "ScopedSearchReplace",
    "InlineSearchOverlay",
    "IntentSearch",
    "QueryToken",
    "DiagnosticsPanel",
    "DiagnosticStream",
    "InlineErrorView",
    "Diff",
    "DiffNarrator",
    "CommandBar",
    "CommandSearch",
    "EditorIntentRouter",
    "IntentRouter",
    "IntentPanel",
    "ScopePicker",
    "ExportPanel",
    "Dock",
    "DockGraph",
    "DockPane",
    "Inspector",
    "EmptyStateView",
    "EmptyView",
]
