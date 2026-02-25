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

CodeEditor.code_buffer: type[CodeBuffer] = CodeBuffer
CodeEditor.CodeBuffer: type[CodeBuffer] = CodeBuffer
CodeEditor.code_category_layer: type[CodeCategoryLayer] = CodeCategoryLayer
CodeEditor.CodeCategoryLayer: type[CodeCategoryLayer] = CodeCategoryLayer
CodeEditor.code_document: type[CodeDocument] = CodeDocument
CodeEditor.CodeDocument: type[CodeDocument] = CodeDocument
CodeEditor.command_bar: type[CommandBar] = CommandBar
CodeEditor.CommandBar: type[CommandBar] = CommandBar
CodeEditor.command_search: type[CommandSearch] = CommandSearch
CodeEditor.CommandSearch: type[CommandSearch] = CommandSearch
CodeEditor.diagnostic_stream: type[DiagnosticStream] = DiagnosticStream
CodeEditor.DiagnosticStream: type[DiagnosticStream] = DiagnosticStream
CodeEditor.diagnostics_panel: type[DiagnosticsPanel] = DiagnosticsPanel
CodeEditor.DiagnosticsPanel: type[DiagnosticsPanel] = DiagnosticsPanel
CodeEditor.diff: type[Diff] = Diff
CodeEditor.Diff: type[Diff] = Diff
CodeEditor.diff_narrator: type[DiffNarrator] = DiffNarrator
CodeEditor.DiffNarrator: type[DiffNarrator] = DiffNarrator
CodeEditor.dock: type[Dock] = Dock
CodeEditor.Dock: type[Dock] = Dock
CodeEditor.dock_graph: type[DockGraph] = DockGraph
CodeEditor.DockGraph: type[DockGraph] = DockGraph
CodeEditor.dock_pane: type[DockPane] = DockPane
CodeEditor.DockPane: type[DockPane] = DockPane
CodeEditor.document_tab_strip: type[DocumentTabStrip] = DocumentTabStrip
CodeEditor.DocumentTabStrip: type[DocumentTabStrip] = DocumentTabStrip
CodeEditor.editor_intent_router: type[EditorIntentRouter] = EditorIntentRouter
CodeEditor.EditorIntentRouter: type[EditorIntentRouter] = EditorIntentRouter
CodeEditor.editor_minimap: type[EditorMinimap] = EditorMinimap
CodeEditor.EditorMinimap: type[EditorMinimap] = EditorMinimap
CodeEditor.editor_surface: type[EditorSurface] = EditorSurface
CodeEditor.EditorSurface: type[EditorSurface] = EditorSurface
CodeEditor.editor_tabs: type[EditorTabs] = EditorTabs
CodeEditor.EditorTabs: type[EditorTabs] = EditorTabs
CodeEditor.editor_view: type[EditorView] = EditorView
CodeEditor.EditorView: type[EditorView] = EditorView
CodeEditor.empty_state_view: type[EmptyStateView] = EmptyStateView
CodeEditor.EmptyStateView: type[EmptyStateView] = EmptyStateView
CodeEditor.empty_view: type[EmptyView] = EmptyView
CodeEditor.EmptyView: type[EmptyView] = EmptyView
CodeEditor.explorer_tree: type[ExplorerTree] = ExplorerTree
CodeEditor.ExplorerTree: type[ExplorerTree] = ExplorerTree
CodeEditor.export_panel: type[ExportPanel] = ExportPanel
CodeEditor.ExportPanel: type[ExportPanel] = ExportPanel
CodeEditor.file_tabs: type[FileTabs] = FileTabs
CodeEditor.FileTabs: type[FileTabs] = FileTabs
CodeEditor.file_tree: type[FileTree] = FileTree
CodeEditor.FileTree: type[FileTree] = FileTree
CodeEditor.ghost_editor: type[GhostEditor] = GhostEditor
CodeEditor.GhostEditor: type[GhostEditor] = GhostEditor
CodeEditor.gutter: type[Gutter] = Gutter
CodeEditor.Gutter: type[Gutter] = Gutter
CodeEditor.hint: type[Hint] = Hint
CodeEditor.Hint: type[Hint] = Hint
CodeEditor.ide: type[Ide] = Ide
CodeEditor.Ide: type[Ide] = Ide
CodeEditor.inline_error_view: type[InlineErrorView] = InlineErrorView
CodeEditor.InlineErrorView: type[InlineErrorView] = InlineErrorView
CodeEditor.inline_search_overlay: type[InlineSearchOverlay] = InlineSearchOverlay
CodeEditor.InlineSearchOverlay: type[InlineSearchOverlay] = InlineSearchOverlay
CodeEditor.inline_widget: type[InlineWidget] = InlineWidget
CodeEditor.InlineWidget: type[InlineWidget] = InlineWidget
CodeEditor.inspector: type[Inspector] = Inspector
CodeEditor.Inspector: type[Inspector] = Inspector
CodeEditor.intent_panel: type[IntentPanel] = IntentPanel
CodeEditor.IntentPanel: type[IntentPanel] = IntentPanel
CodeEditor.intent_router: type[IntentRouter] = IntentRouter
CodeEditor.IntentRouter: type[IntentRouter] = IntentRouter
CodeEditor.intent_search: type[IntentSearch] = IntentSearch
CodeEditor.IntentSearch: type[IntentSearch] = IntentSearch
CodeEditor.mini_map: type[MiniMap] = MiniMap
CodeEditor.MiniMap: type[MiniMap] = MiniMap
CodeEditor.query_token: type[QueryToken] = QueryToken
CodeEditor.QueryToken: type[QueryToken] = QueryToken
CodeEditor.scope_picker: type[ScopePicker] = ScopePicker
CodeEditor.ScopePicker: type[ScopePicker] = ScopePicker
CodeEditor.scoped_search_replace: type[ScopedSearchReplace] = ScopedSearchReplace
CodeEditor.ScopedSearchReplace: type[ScopedSearchReplace] = ScopedSearchReplace
CodeEditor.search_box: type[SearchBox] = SearchBox
CodeEditor.SearchBox: type[SearchBox] = SearchBox
CodeEditor.search_everything_panel: type[SearchEverythingPanel] = SearchEverythingPanel
CodeEditor.SearchEverythingPanel: type[SearchEverythingPanel] = SearchEverythingPanel
CodeEditor.search_field: type[SearchField] = SearchField
CodeEditor.SearchField: type[SearchField] = SearchField
CodeEditor.search_history: type[SearchHistory] = SearchHistory
CodeEditor.SearchHistory: type[SearchHistory] = SearchHistory
CodeEditor.search_intent: type[SearchIntent] = SearchIntent
CodeEditor.SearchIntent: type[SearchIntent] = SearchIntent
CodeEditor.search_item: type[SearchItem] = SearchItem
CodeEditor.SearchItem: type[SearchItem] = SearchItem
CodeEditor.search_provider: type[SearchProvider] = SearchProvider
CodeEditor.SearchProvider: type[SearchProvider] = SearchProvider
CodeEditor.search_results_view: type[SearchResultsView] = SearchResultsView
CodeEditor.SearchResultsView: type[SearchResultsView] = SearchResultsView
CodeEditor.search_scope_selector: type[SearchScopeSelector] = SearchScopeSelector
CodeEditor.SearchScopeSelector: type[SearchScopeSelector] = SearchScopeSelector
CodeEditor.search_source: type[SearchSource] = SearchSource
CodeEditor.SearchSource: type[SearchSource] = SearchSource
CodeEditor.semantic_search: type[SemanticSearch] = SemanticSearch
CodeEditor.SemanticSearch: type[SemanticSearch] = SemanticSearch
CodeEditor.smart_search_bar: type[SmartSearchBar] = SmartSearchBar
CodeEditor.SmartSearchBar: type[SmartSearchBar] = SmartSearchBar
CodeEditor.tree: type[Tree] = Tree
CodeEditor.Tree: type[Tree] = Tree
CodeEditor.workbench_editor: type[WorkbenchEditor] = WorkbenchEditor
CodeEditor.WorkbenchEditor: type[WorkbenchEditor] = WorkbenchEditor
CodeEditor.workspace_explorer: type[WorkspaceExplorer] = WorkspaceExplorer
CodeEditor.WorkspaceExplorer: type[WorkspaceExplorer] = WorkspaceExplorer

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
