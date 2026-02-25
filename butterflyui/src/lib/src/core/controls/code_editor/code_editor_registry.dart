import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

const Set<String> codeEditorRegistryModules = {
  'ide',
  'editor_surface',
  'editor_view',
  'editor_tabs',
  'document_tab_strip',
  'file_tabs',
  'file_tree',
  'workspace_explorer',
  'explorer_tree',
  'tree',
  'code_document',
  'code_buffer',
  'code_category_layer',
  'smart_search_bar',
  'search_box',
  'search_field',
  'search_history',
  'search_intent',
  'search_item',
  'search_results_view',
  'search_scope_selector',
  'search_source',
  'search_provider',
  'search_everything_panel',
  'semantic_search',
  'query_token',
  'scoped_search_replace',
  'inline_search_overlay',
  'inline_widget',
  'ghost_editor',
  'gutter',
  'hint',
  'mini_map',
  'editor_minimap',
  'dock_graph',
  'dock',
  'dock_pane',
  'workbench_editor',
  'empty_state_view',
  'empty_view',
  'command_search',
  'diff',
  'diff_narrator',
  'diagnostic_stream',
  'diagnostics_panel',
  'inline_error_view',
  'editor_intent_router',
  'intent_router',
  'intent_panel',
  'intent_search',
  'command_bar',
  'export_panel',
  'scope_picker',
  'inspector',
};

String? codeEditorModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'code_editor_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!codeEditorRegistryModules.contains(module)) return null;
  return module;
}
