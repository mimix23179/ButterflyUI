from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import CodeEditor
from .submodules import (
    CodeBuffer,
    CodeCategoryLayer,
    CodeDocument,
    CommandBar,
    CommandSearch,
    DiagnosticStream,
    DiagnosticsPanel,
    Diff,
    DiffNarrator,
    Dock,
    DockGraph,
    DockPane,
    DocumentTabStrip,
    EditorIntentRouter,
    EditorMinimap,
    EditorSurface,
    EditorTabs,
    EditorView,
    EmptyStateView,
    EmptyView,
    ExplorerTree,
    ExportPanel,
    FileTabs,
    FileTree,
    GhostEditor,
    Gutter,
    Hint,
    Ide,
    InlineErrorView,
    InlineSearchOverlay,
    InlineWidget,
    Inspector,
    IntentPanel,
    IntentRouter,
    IntentSearch,
    MiniMap,
    QueryToken,
    ScopePicker,
    ScopedSearchReplace,
    SearchBox,
    SearchEverythingPanel,
    SearchField,
    SearchHistory,
    SearchIntent,
    SearchItem,
    SearchProvider,
    SearchResultsView,
    SearchScopeSelector,
    SearchSource,
    SemanticSearch,
    SmartSearchBar,
    Tree,
    WorkbenchEditor,
    WorkspaceExplorer,
)
from .schema import (
    DEFAULT_ENGINE,
    DEFAULT_WEBVIEW_ENGINE,
    EVENTS,
    MODULES,
    REGISTRY_MANIFEST_LISTS,
    REGISTRY_ROLE_ALIASES,
    SCHEMA_VERSION,
    STATES,
)

CodeEditor.code_buffer = CodeBuffer
CodeEditor.CodeBuffer = CodeBuffer
CodeEditor.code_category_layer = CodeCategoryLayer
CodeEditor.CodeCategoryLayer = CodeCategoryLayer
CodeEditor.code_document = CodeDocument
CodeEditor.CodeDocument = CodeDocument
CodeEditor.command_bar = CommandBar
CodeEditor.CommandBar = CommandBar
CodeEditor.command_search = CommandSearch
CodeEditor.CommandSearch = CommandSearch
CodeEditor.diagnostic_stream = DiagnosticStream
CodeEditor.DiagnosticStream = DiagnosticStream
CodeEditor.diagnostics_panel = DiagnosticsPanel
CodeEditor.DiagnosticsPanel = DiagnosticsPanel
CodeEditor.diff = Diff
CodeEditor.Diff = Diff
CodeEditor.diff_narrator = DiffNarrator
CodeEditor.DiffNarrator = DiffNarrator
CodeEditor.dock = Dock
CodeEditor.Dock = Dock
CodeEditor.dock_graph = DockGraph
CodeEditor.DockGraph = DockGraph
CodeEditor.dock_pane = DockPane
CodeEditor.DockPane = DockPane
CodeEditor.document_tab_strip = DocumentTabStrip
CodeEditor.DocumentTabStrip = DocumentTabStrip
CodeEditor.editor_intent_router = EditorIntentRouter
CodeEditor.EditorIntentRouter = EditorIntentRouter
CodeEditor.editor_minimap = EditorMinimap
CodeEditor.EditorMinimap = EditorMinimap
CodeEditor.editor_surface = EditorSurface
CodeEditor.EditorSurface = EditorSurface
CodeEditor.editor_tabs = EditorTabs
CodeEditor.EditorTabs = EditorTabs
CodeEditor.editor_view = EditorView
CodeEditor.EditorView = EditorView
CodeEditor.empty_state_view = EmptyStateView
CodeEditor.EmptyStateView = EmptyStateView
CodeEditor.empty_view = EmptyView
CodeEditor.EmptyView = EmptyView
CodeEditor.explorer_tree = ExplorerTree
CodeEditor.ExplorerTree = ExplorerTree
CodeEditor.export_panel = ExportPanel
CodeEditor.ExportPanel = ExportPanel
CodeEditor.file_tabs = FileTabs
CodeEditor.FileTabs = FileTabs
CodeEditor.file_tree = FileTree
CodeEditor.FileTree = FileTree
CodeEditor.ghost_editor = GhostEditor
CodeEditor.GhostEditor = GhostEditor
CodeEditor.gutter = Gutter
CodeEditor.Gutter = Gutter
CodeEditor.hint = Hint
CodeEditor.Hint = Hint
CodeEditor.ide = Ide
CodeEditor.Ide = Ide
CodeEditor.inline_error_view = InlineErrorView
CodeEditor.InlineErrorView = InlineErrorView
CodeEditor.inline_search_overlay = InlineSearchOverlay
CodeEditor.InlineSearchOverlay = InlineSearchOverlay
CodeEditor.inline_widget = InlineWidget
CodeEditor.InlineWidget = InlineWidget
CodeEditor.inspector = Inspector
CodeEditor.Inspector = Inspector
CodeEditor.intent_panel = IntentPanel
CodeEditor.IntentPanel = IntentPanel
CodeEditor.intent_router = IntentRouter
CodeEditor.IntentRouter = IntentRouter
CodeEditor.intent_search = IntentSearch
CodeEditor.IntentSearch = IntentSearch
CodeEditor.mini_map = MiniMap
CodeEditor.MiniMap = MiniMap
CodeEditor.query_token = QueryToken
CodeEditor.QueryToken = QueryToken
CodeEditor.scope_picker = ScopePicker
CodeEditor.ScopePicker = ScopePicker
CodeEditor.scoped_search_replace = ScopedSearchReplace
CodeEditor.ScopedSearchReplace = ScopedSearchReplace
CodeEditor.search_box = SearchBox
CodeEditor.SearchBox = SearchBox
CodeEditor.search_everything_panel = SearchEverythingPanel
CodeEditor.SearchEverythingPanel = SearchEverythingPanel
CodeEditor.search_field = SearchField
CodeEditor.SearchField = SearchField
CodeEditor.search_history = SearchHistory
CodeEditor.SearchHistory = SearchHistory
CodeEditor.search_intent = SearchIntent
CodeEditor.SearchIntent = SearchIntent
CodeEditor.search_item = SearchItem
CodeEditor.SearchItem = SearchItem
CodeEditor.search_provider = SearchProvider
CodeEditor.SearchProvider = SearchProvider
CodeEditor.search_results_view = SearchResultsView
CodeEditor.SearchResultsView = SearchResultsView
CodeEditor.search_scope_selector = SearchScopeSelector
CodeEditor.SearchScopeSelector = SearchScopeSelector
CodeEditor.search_source = SearchSource
CodeEditor.SearchSource = SearchSource
CodeEditor.semantic_search = SemanticSearch
CodeEditor.SemanticSearch = SemanticSearch
CodeEditor.smart_search_bar = SmartSearchBar
CodeEditor.SmartSearchBar = SmartSearchBar
CodeEditor.tree = Tree
CodeEditor.Tree = Tree
CodeEditor.workbench_editor = WorkbenchEditor
CodeEditor.WorkbenchEditor = WorkbenchEditor
CodeEditor.workspace_explorer = WorkspaceExplorer
CodeEditor.WorkspaceExplorer = WorkspaceExplorer

__all__ = [
    "CodeEditor",
    "SCHEMA_VERSION",
    "DEFAULT_ENGINE",
    "DEFAULT_WEBVIEW_ENGINE",
    "MODULES",
    "STATES",
    "EVENTS",
    "REGISTRY_ROLE_ALIASES",
    "REGISTRY_MANIFEST_LISTS",
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
