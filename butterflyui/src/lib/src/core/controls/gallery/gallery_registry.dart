import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

import 'submodules/gallery_submodule_registry.dart';

const Set<String> galleryRegistryModules = {
  ...galleryLayoutModules,
  ...galleryItemModules,
  ...galleryMediaModules,
  ...galleryCommandModules,
  ...galleryCustomizationModules,
};

String? galleryModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'gallery_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!galleryRegistryModules.contains(module)) return null;
  return module;
}
