import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

const Set<String> skinsRegistryModules = {
  'selector',
  'preset',
  'editor',
  'preview',
  'apply',
  'clear',
  'token_mapper',
  'create_skin',
  'edit_skin',
  'delete_skin',
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

String? skinsModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'skins_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!skinsRegistryModules.contains(module)) return null;
  return module;
}
