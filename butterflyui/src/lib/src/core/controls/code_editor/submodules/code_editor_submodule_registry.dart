/// Canonical module-to-category mapping for the CodeEditor umbrella control.
///
/// Used by [code_editor_registry.dart] to build the full module set and by
/// the host to delegate to per-category submodule builders.

// ---------------------------------------------------------------------------
// Category sets
// ---------------------------------------------------------------------------

const Set<String> codeEditorEditorModules = {
  'ide',
  'editor_surface',
  'editor_view',
  'workbench_editor',
  'ghost_editor',
  'editor_minimap',
  'mini_map',
  'gutter',
  'hint',
  'inline_widget',
};

const Set<String> codeEditorDocumentModules = {
  'code_buffer',
  'code_category_layer',
  'code_document',
};

const Set<String> codeEditorTabsModules = {
  'editor_tabs',
  'document_tab_strip',
  'file_tabs',
};

const Set<String> codeEditorExplorerModules = {
  'file_tree',
  'explorer_tree',
  'workspace_explorer',
  'tree',
};

const Set<String> codeEditorSearchModules = {
  'smart_search_bar',
  'search_box',
  'search_field',
  'search_scope_selector',
  'search_source',
  'search_provider',
  'search_history',
  'search_intent',
  'search_item',
  'search_results_view',
  'search_everything_panel',
  'semantic_search',
  'scoped_search_replace',
  'inline_search_overlay',
  'intent_search',
  'query_token',
};

const Set<String> codeEditorDiagnosticsModules = {
  'diagnostics_panel',
  'diagnostic_stream',
  'inline_error_view',
};

const Set<String> codeEditorDiffModules = {
  'diff',
  'diff_narrator',
};

const Set<String> codeEditorCommandsModules = {
  'command_bar',
  'command_search',
  'editor_intent_router',
  'intent_router',
  'intent_panel',
  'scope_picker',
  'export_panel',
};

const Set<String> codeEditorLayoutModules = {
  'dock',
  'dock_graph',
  'dock_pane',
  'inspector',
  'empty_state_view',
  'empty_view',
};

// ---------------------------------------------------------------------------
// Category map + helper
// ---------------------------------------------------------------------------

const Map<String, String> codeEditorModuleCategories = {
  // editor
  'ide': 'editor',
  'editor_surface': 'editor',
  'editor_view': 'editor',
  'workbench_editor': 'editor',
  'ghost_editor': 'editor',
  'editor_minimap': 'editor',
  'mini_map': 'editor',
  'gutter': 'editor',
  'hint': 'editor',
  'inline_widget': 'editor',
  // document
  'code_buffer': 'document',
  'code_category_layer': 'document',
  'code_document': 'document',
  // tabs
  'editor_tabs': 'tabs',
  'document_tab_strip': 'tabs',
  'file_tabs': 'tabs',
  // explorer
  'file_tree': 'explorer',
  'explorer_tree': 'explorer',
  'workspace_explorer': 'explorer',
  'tree': 'explorer',
  // search
  'smart_search_bar': 'search',
  'search_box': 'search',
  'search_field': 'search',
  'search_scope_selector': 'search',
  'search_source': 'search',
  'search_provider': 'search',
  'search_history': 'search',
  'search_intent': 'search',
  'search_item': 'search',
  'search_results_view': 'search',
  'search_everything_panel': 'search',
  'semantic_search': 'search',
  'scoped_search_replace': 'search',
  'inline_search_overlay': 'search',
  'intent_search': 'search',
  'query_token': 'search',
  // diagnostics
  'diagnostics_panel': 'diagnostics',
  'diagnostic_stream': 'diagnostics',
  'inline_error_view': 'diagnostics',
  // diff
  'diff': 'diff',
  'diff_narrator': 'diff',
  // commands
  'command_bar': 'commands',
  'command_search': 'commands',
  'editor_intent_router': 'commands',
  'intent_router': 'commands',
  'intent_panel': 'commands',
  'scope_picker': 'commands',
  'export_panel': 'commands',
  // layout
  'dock': 'layout',
  'dock_graph': 'layout',
  'dock_pane': 'layout',
  'inspector': 'layout',
  'empty_state_view': 'layout',
  'empty_view': 'layout',
};

/// Returns the category name for [module], or null if unknown.
String? codeEditorModuleCategory(String module) =>
    codeEditorModuleCategories[module];

// ---------------------------------------------------------------------------
// Per-category helpers
// ---------------------------------------------------------------------------

bool codeEditorIsEditorModule(String module) =>
    codeEditorEditorModules.contains(module);

bool codeEditorIsDocumentModule(String module) =>
    codeEditorDocumentModules.contains(module);

bool codeEditorIsTabsModule(String module) =>
    codeEditorTabsModules.contains(module);

bool codeEditorIsExplorerModule(String module) =>
    codeEditorExplorerModules.contains(module);

bool codeEditorIsSearchModule(String module) =>
    codeEditorSearchModules.contains(module);

bool codeEditorIsDiagnosticsModule(String module) =>
    codeEditorDiagnosticsModules.contains(module);

bool codeEditorIsDiffModule(String module) =>
    codeEditorDiffModules.contains(module);

bool codeEditorIsCommandsModule(String module) =>
    codeEditorCommandsModules.contains(module);

bool codeEditorIsLayoutModule(String module) =>
    codeEditorLayoutModules.contains(module);
