/// Canonical module-to-category mapping for the Gallery umbrella control.
///
/// Used by [gallery_registry.dart] to build the full module set and by
/// the host to delegate per-category submodule builders.

// ---------------------------------------------------------------------------
// Category sets
// ---------------------------------------------------------------------------

const Set<String> galleryLayoutModules = {
  'toolbar',
  'filter_bar',
  'sort_bar',
  'section_header',
  'grid_layout',
  'pagination',
  'search_bar',
  'loading_skeleton',
  'empty_state',
};

const Set<String> galleryItemModules = {
  'item_tile',
  'item_badge',
  'item_meta_row',
  'item_preview',
  'item_actions',
  'item_selectable',
  'item_drag_handle',
  'item_drop_target',
  'item_reorder_handle',
  'item_selection_checkbox',
  'item_selection_radio',
  'item_selection_switch',
};

const Set<String> galleryMediaModules = {
  'fonts',
  'font_picker',
  'font_renderer',
  'audio',
  'audio_picker',
  'audio_renderer',
  'video',
  'video_picker',
  'video_renderer',
  'image',
  'image_picker',
  'image_renderer',
  'document',
  'document_picker',
  'document_renderer',
};

const Set<String> galleryCommandModules = {
  'apply',
  'clear',
  'select_all',
  'deselect_all',
  'apply_font',
  'apply_image',
  'set_as_wallpaper',
};

const Set<String> galleryCustomizationModules = {'presets', 'skins'};

// ---------------------------------------------------------------------------
// Category map + helper
// ---------------------------------------------------------------------------

const Map<String, String> galleryModuleCategories = {
  // layout
  'toolbar': 'layout',
  'filter_bar': 'layout',
  'sort_bar': 'layout',
  'section_header': 'layout',
  'grid_layout': 'layout',
  'pagination': 'layout',
  'search_bar': 'layout',
  'loading_skeleton': 'layout',
  'empty_state': 'layout',
  // items
  'item_tile': 'items',
  'item_badge': 'items',
  'item_meta_row': 'items',
  'item_preview': 'items',
  'item_actions': 'items',
  'item_selectable': 'items',
  'item_drag_handle': 'items',
  'item_drop_target': 'items',
  'item_reorder_handle': 'items',
  'item_selection_checkbox': 'items',
  'item_selection_radio': 'items',
  'item_selection_switch': 'items',
  // media
  'fonts': 'media',
  'font_picker': 'media',
  'font_renderer': 'media',
  'audio': 'media',
  'audio_picker': 'media',
  'audio_renderer': 'media',
  'video': 'media',
  'video_picker': 'media',
  'video_renderer': 'media',
  'image': 'media',
  'image_picker': 'media',
  'image_renderer': 'media',
  'document': 'media',
  'document_picker': 'media',
  'document_renderer': 'media',
  // commands
  'apply': 'commands',
  'clear': 'commands',
  'select_all': 'commands',
  'deselect_all': 'commands',
  'apply_font': 'commands',
  'apply_image': 'commands',
  'set_as_wallpaper': 'commands',
  // customization
  'presets': 'customization',
  'skins': 'customization',
};

/// Returns the category name for [module], or null if unknown.
String? galleryModuleCategory(String module) =>
    galleryModuleCategories[module];

// ---------------------------------------------------------------------------
// Per-category helpers
// ---------------------------------------------------------------------------

bool galleryIsLayoutModule(String module) =>
    galleryLayoutModules.contains(module);

bool galleryIsItemModule(String module) =>
    galleryItemModules.contains(module);

bool galleryIsMediaModule(String module) =>
    galleryMediaModules.contains(module);

bool galleryIsCommandModule(String module) =>
    galleryCommandModules.contains(module);

bool galleryIsCustomizationModule(String module) =>
    galleryCustomizationModules.contains(module);
