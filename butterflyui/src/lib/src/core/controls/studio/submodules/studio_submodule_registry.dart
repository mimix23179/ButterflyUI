/// Module-category registry for the Studio umbrella control.
///
/// Mirrors the Dart submodule categorisation so that the workbench and
/// external callers can route module names to the appropriate builder
/// without hard-coding string comparisons everywhere.
library studio_submodule_registry;

// ---------------------------------------------------------------------------
// Per-category module sets
// ---------------------------------------------------------------------------

/// Surface rendering modules: the main canvas types plus the overall builder
/// orchestrator, and their canonical aliases.
const Set<String> studioSurfaceModules_ = {
  'builder',
  'canvas',
  'canvas_surface',
  'timeline_surface',
  'timeline',
  'timeline_editor',
  'node_surface',
  'node',
  'node_graph',
  'preview_surface',
  'preview',
};

/// Panel and palette modules: project/asset tree panels, inspector panels,
/// editor panels, and content palette sidebars.
const Set<String> studioPanelModules_ = {
  'project_panel',
  'outline_tree',
  'asset_browser',
  'assets',
  'assets_panel',
  'layers',
  'layers_panel',
  'component_palette',
  'block_palette',
  'inspector',
  'properties_panel',
  'properties',
  'actions_editor',
  'bindings_editor',
  'tokens_editor',
  'token_editor',
  'tokens',
};

/// Tool and responsive-toolbar modules: selection, transform, and viewport
/// adjustment tools.
const Set<String> studioToolModules_ = {
  'selection_tools',
  'toolbox',
  'transform_toolbar',
  'transform_tools',
  'transform_box',
  'transform',
  'responsive_toolbar',
  'responsive',
};

// ---------------------------------------------------------------------------
// Combined lookup map  (explicit key/value pairs — Dart const cannot use for)
// ---------------------------------------------------------------------------

/// Maps every module name to its category string.
const Map<String, String> studioModuleCategories = {
  // surfaces
  'builder': 'surfaces',
  'canvas': 'surfaces',
  'canvas_surface': 'surfaces',
  'timeline_surface': 'surfaces',
  'timeline': 'surfaces',
  'timeline_editor': 'surfaces',
  'node_surface': 'surfaces',
  'node': 'surfaces',
  'node_graph': 'surfaces',
  'preview_surface': 'surfaces',
  'preview': 'surfaces',
  // panels
  'project_panel': 'panels',
  'outline_tree': 'panels',
  'asset_browser': 'panels',
  'assets': 'panels',
  'assets_panel': 'panels',
  'layers': 'panels',
  'layers_panel': 'panels',
  'component_palette': 'panels',
  'block_palette': 'panels',
  'inspector': 'panels',
  'properties_panel': 'panels',
  'properties': 'panels',
  'actions_editor': 'panels',
  'bindings_editor': 'panels',
  'tokens_editor': 'panels',
  'token_editor': 'panels',
  'tokens': 'panels',
  // tools
  'selection_tools': 'tools',
  'toolbox': 'tools',
  'transform_toolbar': 'tools',
  'transform_tools': 'tools',
  'transform_box': 'tools',
  'transform': 'tools',
  'responsive_toolbar': 'tools',
  'responsive': 'tools',
};

// ---------------------------------------------------------------------------
// Helper functions
// ---------------------------------------------------------------------------

/// Returns the category name for [module], or `null` if unrecognised.
String? studioModuleCategory(String module) => studioModuleCategories[module];

/// Returns `true` if [module] belongs to the surfaces category.
bool studioIsSurfaceModule(String module) =>
    studioSurfaceModules_.contains(module);

/// Returns `true` if [module] belongs to the panels category.
bool studioIsPanelModule(String module) =>
    studioPanelModules_.contains(module);

/// Returns `true` if [module] belongs to the tools category.
bool studioIsToolModule(String module) =>
    studioToolModules_.contains(module);
