import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';
import 'package:butterflyui_runtime/src/core/controls/candy/submodules/candy_submodule_registry.dart';

final Set<String> candyRegistryModules = {
  ...candyLayoutModules,
  ...candyInteractiveModules,
  ...candyDecorationModules,
  ...candyEffectsModules,
  ...candyMotionModules,
};

String? candyModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'candy_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!candyRegistryModules.contains(module)) return null;
  return module;
}
