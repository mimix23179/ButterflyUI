import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

const Set<String> galleryRegistryModules = {
  'toolbar',
  'filter_bar',
  'grid_layout',
  'item_actions',
  'item_badge',
  'item_meta_row',
  'item_preview',
  'item_selectable',
  'item_tile',
  'pagination',
  'section_header',
  'sort_bar',
  'empty_state',
  'loading_skeleton',
  'search_bar',
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
  'item_drag_handle',
  'item_drop_target',
  'item_reorder_handle',
  'item_selection_checkbox',
  'item_selection_radio',
  'item_selection_switch',
  'apply',
  'clear',
  'select_all',
  'deselect_all',
  'apply_font',
  'apply_image',
  'set_as_wallpaper',
  'presets',
  'skins',
};

String? galleryModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'gallery_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!galleryRegistryModules.contains(module)) return null;
  return module;
}
