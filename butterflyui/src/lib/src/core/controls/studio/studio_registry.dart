import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

const Set<String> studioRegistryModules = {
  'builder',
  'canvas',
  'canvas_surface',
  'timeline_surface',
  'node_surface',
  'preview_surface',
  'block_palette',
  'component_palette',
  'inspector',
  'outline_tree',
  'project_panel',
  'properties_panel',
  'responsive_toolbar',
  'tokens_editor',
  'actions_editor',
  'bindings_editor',
  'asset_browser',
  'selection_tools',
  'transform_box',
  'transform_toolbar',
  'assets',
  'assets_panel',
  'layers',
  'layers_panel',
  'node',
  'node_graph',
  'preview',
  'properties',
  'responsive',
  'timeline',
  'timeline_editor',
  'token_editor',
  'tokens',
  'toolbox',
  'transform',
  'transform_tools',
};

String? studioModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'studio_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!studioRegistryModules.contains(module)) return null;
  return module;
}
