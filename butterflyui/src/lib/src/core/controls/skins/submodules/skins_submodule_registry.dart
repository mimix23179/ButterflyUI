/// Module-category registry for the Skins umbrella control.
///
/// Mirrors the Dart submodule categorisation so that host code and
/// external callers can route module names to the appropriate builder
/// without hard-coding string comparisons everywhere.
library skins_submodule_registry;

// ---------------------------------------------------------------------------
// Per-category module sets
// ---------------------------------------------------------------------------

/// Core interactive modules: skin selection, preset browsing, live editing,
/// preview surface, and token mapping.
const Set<String> skinsCoreModules = {
  'selector',
  'preset',
  'editor',
  'preview',
  'token_mapper',
};

/// Token / asset collection modules: visual-property libraries rendered as
/// chip grids or item lists.
const Set<String> skinsTokenModules = {
  'effects',
  'particles',
  'shaders',
  'materials',
  'icons',
  'fonts',
  'colors',
  'background',
  'border',
  'shadow',
  'outline',
  'animation',
  'transition',
  'interaction',
  'layout',
  'responsive',
};

/// Named-editor modules: specialised text/JSON editors for each token type.
const Set<String> skinsEditorModules = {
  'effect_editor',
  'particle_editor',
  'shader_editor',
  'material_editor',
  'icon_editor',
  'font_editor',
  'color_editor',
  'background_editor',
  'border_editor',
  'shadow_editor',
  'outline_editor',
};

/// Command / action modules: apply, clear, and skin CRUD operations.
const Set<String> skinsCommandModules = {
  'apply',
  'clear',
  'create_skin',
  'edit_skin',
  'delete_skin',
};

// ---------------------------------------------------------------------------
// Combined lookup map
// ---------------------------------------------------------------------------

/// Maps every module name to its category string.
const Map<String, String> skinsModuleCategories = {
  // core
  'selector': 'core',
  'preset': 'core',
  'editor': 'core',
  'preview': 'core',
  'token_mapper': 'core',
  // tokens
  'effects': 'tokens',
  'particles': 'tokens',
  'shaders': 'tokens',
  'materials': 'tokens',
  'icons': 'tokens',
  'fonts': 'tokens',
  'colors': 'tokens',
  'background': 'tokens',
  'border': 'tokens',
  'shadow': 'tokens',
  'outline': 'tokens',
  'animation': 'tokens',
  'transition': 'tokens',
  'interaction': 'tokens',
  'layout': 'tokens',
  'responsive': 'tokens',
  // editors
  'effect_editor': 'editors',
  'particle_editor': 'editors',
  'shader_editor': 'editors',
  'material_editor': 'editors',
  'icon_editor': 'editors',
  'font_editor': 'editors',
  'color_editor': 'editors',
  'background_editor': 'editors',
  'border_editor': 'editors',
  'shadow_editor': 'editors',
  'outline_editor': 'editors',
  // commands
  'apply': 'commands',
  'clear': 'commands',
  'create_skin': 'commands',
  'edit_skin': 'commands',
  'delete_skin': 'commands',
};

// ---------------------------------------------------------------------------
// Helper functions
// ---------------------------------------------------------------------------

/// Returns the category name for [module], or `null` if unknown.
String? skinsModuleCategory(String module) => skinsModuleCategories[module];

/// Returns `true` if [module] belongs to the `core` category.
bool skinsIsCoreModule(String module) => skinsCoreModules.contains(module);

/// Returns `true` if [module] belongs to the `tokens` category.
bool skinsIsTokenModule(String module) => skinsTokenModules.contains(module);

/// Returns `true` if [module] belongs to the `editors` category.
bool skinsIsEditorModule(String module) => skinsEditorModules.contains(module);

/// Returns `true` if [module] belongs to the `commands` category.
bool skinsIsCommandModule(String module) =>
    skinsCommandModules.contains(module);
