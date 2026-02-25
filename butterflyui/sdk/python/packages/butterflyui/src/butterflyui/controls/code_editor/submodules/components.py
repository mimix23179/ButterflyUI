from __future__ import annotations

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

MODULE_COMPONENTS = {
    "code_buffer": CodeBuffer,
    "code_category_layer": CodeCategoryLayer,
    "code_document": CodeDocument,
    "command_bar": CommandBar,
    "command_search": CommandSearch,
    "diagnostic_stream": DiagnosticStream,
    "diagnostics_panel": DiagnosticsPanel,
    "diff": Diff,
    "diff_narrator": DiffNarrator,
    "dock": Dock,
    "dock_graph": DockGraph,
    "dock_pane": DockPane,
    "document_tab_strip": DocumentTabStrip,
    "editor_intent_router": EditorIntentRouter,
    "editor_minimap": EditorMinimap,
    "editor_surface": EditorSurface,
    "editor_tabs": EditorTabs,
    "editor_view": EditorView,
    "empty_state_view": EmptyStateView,
    "empty_view": EmptyView,
    "explorer_tree": ExplorerTree,
    "export_panel": ExportPanel,
    "file_tabs": FileTabs,
    "file_tree": FileTree,
    "ghost_editor": GhostEditor,
    "gutter": Gutter,
    "hint": Hint,
    "ide": Ide,
    "inline_error_view": InlineErrorView,
    "inline_search_overlay": InlineSearchOverlay,
    "inline_widget": InlineWidget,
    "inspector": Inspector,
    "intent_panel": IntentPanel,
    "intent_router": IntentRouter,
    "intent_search": IntentSearch,
    "mini_map": MiniMap,
    "query_token": QueryToken,
    "scope_picker": ScopePicker,
    "scoped_search_replace": ScopedSearchReplace,
    "search_box": SearchBox,
    "search_everything_panel": SearchEverythingPanel,
    "search_field": SearchField,
    "search_history": SearchHistory,
    "search_intent": SearchIntent,
    "search_item": SearchItem,
    "search_provider": SearchProvider,
    "search_results_view": SearchResultsView,
    "search_scope_selector": SearchScopeSelector,
    "search_source": SearchSource,
    "semantic_search": SemanticSearch,
    "smart_search_bar": SmartSearchBar,
    "tree": Tree,
    "workbench_editor": WorkbenchEditor,
    "workspace_explorer": WorkspaceExplorer,
}

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    "MODULE_COMPONENTS",
    "CodeBuffer",
    "CodeCategoryLayer",
    "CodeDocument",
    "CommandBar",
    "CommandSearch",
    "DiagnosticStream",
    "DiagnosticsPanel",
    "Diff",
    "DiffNarrator",
    "Dock",
    "DockGraph",
    "DockPane",
    "DocumentTabStrip",
    "EditorIntentRouter",
    "EditorMinimap",
    "EditorSurface",
    "EditorTabs",
    "EditorView",
    "EmptyStateView",
    "EmptyView",
    "ExplorerTree",
    "ExportPanel",
    "FileTabs",
    "FileTree",
    "GhostEditor",
    "Gutter",
    "Hint",
    "Ide",
    "InlineErrorView",
    "InlineSearchOverlay",
    "InlineWidget",
    "Inspector",
    "IntentPanel",
    "IntentRouter",
    "IntentSearch",
    "MiniMap",
    "QueryToken",
    "ScopePicker",
    "ScopedSearchReplace",
    "SearchBox",
    "SearchEverythingPanel",
    "SearchField",
    "SearchHistory",
    "SearchIntent",
    "SearchItem",
    "SearchProvider",
    "SearchResultsView",
    "SearchScopeSelector",
    "SearchSource",
    "SemanticSearch",
    "SmartSearchBar",
    "Tree",
    "WorkbenchEditor",
    "WorkspaceExplorer",
]
