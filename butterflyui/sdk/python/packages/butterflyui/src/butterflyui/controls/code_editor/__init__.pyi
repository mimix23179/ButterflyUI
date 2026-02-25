from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import CodeEditor as _CodeEditor
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

class CodeEditor(_CodeEditor):
    code_buffer: type[CodeBuffer]
    CodeBuffer: type[CodeBuffer]
    code_category_layer: type[CodeCategoryLayer]
    CodeCategoryLayer: type[CodeCategoryLayer]
    code_document: type[CodeDocument]
    CodeDocument: type[CodeDocument]
    command_bar: type[CommandBar]
    CommandBar: type[CommandBar]
    command_search: type[CommandSearch]
    CommandSearch: type[CommandSearch]
    diagnostic_stream: type[DiagnosticStream]
    DiagnosticStream: type[DiagnosticStream]
    diagnostics_panel: type[DiagnosticsPanel]
    DiagnosticsPanel: type[DiagnosticsPanel]
    diff: type[Diff]
    Diff: type[Diff]
    diff_narrator: type[DiffNarrator]
    DiffNarrator: type[DiffNarrator]
    dock: type[Dock]
    Dock: type[Dock]
    dock_graph: type[DockGraph]
    DockGraph: type[DockGraph]
    dock_pane: type[DockPane]
    DockPane: type[DockPane]
    document_tab_strip: type[DocumentTabStrip]
    DocumentTabStrip: type[DocumentTabStrip]
    editor_intent_router: type[EditorIntentRouter]
    EditorIntentRouter: type[EditorIntentRouter]
    editor_minimap: type[EditorMinimap]
    EditorMinimap: type[EditorMinimap]
    editor_surface: type[EditorSurface]
    EditorSurface: type[EditorSurface]
    editor_tabs: type[EditorTabs]
    EditorTabs: type[EditorTabs]
    editor_view: type[EditorView]
    EditorView: type[EditorView]
    empty_state_view: type[EmptyStateView]
    EmptyStateView: type[EmptyStateView]
    empty_view: type[EmptyView]
    EmptyView: type[EmptyView]
    explorer_tree: type[ExplorerTree]
    ExplorerTree: type[ExplorerTree]
    export_panel: type[ExportPanel]
    ExportPanel: type[ExportPanel]
    file_tabs: type[FileTabs]
    FileTabs: type[FileTabs]
    file_tree: type[FileTree]
    FileTree: type[FileTree]
    ghost_editor: type[GhostEditor]
    GhostEditor: type[GhostEditor]
    gutter: type[Gutter]
    Gutter: type[Gutter]
    hint: type[Hint]
    Hint: type[Hint]
    ide: type[Ide]
    Ide: type[Ide]
    inline_error_view: type[InlineErrorView]
    InlineErrorView: type[InlineErrorView]
    inline_search_overlay: type[InlineSearchOverlay]
    InlineSearchOverlay: type[InlineSearchOverlay]
    inline_widget: type[InlineWidget]
    InlineWidget: type[InlineWidget]
    inspector: type[Inspector]
    Inspector: type[Inspector]
    intent_panel: type[IntentPanel]
    IntentPanel: type[IntentPanel]
    intent_router: type[IntentRouter]
    IntentRouter: type[IntentRouter]
    intent_search: type[IntentSearch]
    IntentSearch: type[IntentSearch]
    mini_map: type[MiniMap]
    MiniMap: type[MiniMap]
    query_token: type[QueryToken]
    QueryToken: type[QueryToken]
    scope_picker: type[ScopePicker]
    ScopePicker: type[ScopePicker]
    scoped_search_replace: type[ScopedSearchReplace]
    ScopedSearchReplace: type[ScopedSearchReplace]
    search_box: type[SearchBox]
    SearchBox: type[SearchBox]
    search_everything_panel: type[SearchEverythingPanel]
    SearchEverythingPanel: type[SearchEverythingPanel]
    search_field: type[SearchField]
    SearchField: type[SearchField]
    search_history: type[SearchHistory]
    SearchHistory: type[SearchHistory]
    search_intent: type[SearchIntent]
    SearchIntent: type[SearchIntent]
    search_item: type[SearchItem]
    SearchItem: type[SearchItem]
    search_provider: type[SearchProvider]
    SearchProvider: type[SearchProvider]
    search_results_view: type[SearchResultsView]
    SearchResultsView: type[SearchResultsView]
    search_scope_selector: type[SearchScopeSelector]
    SearchScopeSelector: type[SearchScopeSelector]
    search_source: type[SearchSource]
    SearchSource: type[SearchSource]
    semantic_search: type[SemanticSearch]
    SemanticSearch: type[SemanticSearch]
    smart_search_bar: type[SmartSearchBar]
    SmartSearchBar: type[SmartSearchBar]
    tree: type[Tree]
    Tree: type[Tree]
    workbench_editor: type[WorkbenchEditor]
    WorkbenchEditor: type[WorkbenchEditor]
    workspace_explorer: type[WorkspaceExplorer]
    WorkspaceExplorer: type[WorkspaceExplorer]

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
