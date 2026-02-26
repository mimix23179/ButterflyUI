import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

import 'submodules/skins_submodule_registry.dart';

const Set<String> skinsRegistryModules = {
  ...skinsCoreModules,
  ...skinsTokenModules,
  ...skinsEditorModules,
  ...skinsCommandModules,
};

String? skinsModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'skins_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!skinsRegistryModules.contains(module)) return null;
  return module;
}
