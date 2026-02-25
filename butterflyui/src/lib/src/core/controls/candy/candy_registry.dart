import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

const Set<String> candyRegistryModules = {
  'button',
  'card',
  'column',
  'container',
  'row',
  'stack',
  'surface',
  'wrap',
  'align',
  'center',
  'spacer',
  'aspect_ratio',
  'overflow_box',
  'fitted_box',
  'effects',
  'particles',
  'border',
  'shadow',
  'outline',
  'gradient',
  'animation',
  'transition',
  'canvas',
  'clip',
  'decorated_box',
  'badge',
  'avatar',
  'icon',
  'text',
  'motion',
};

String? candyModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'candy_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!candyRegistryModules.contains(module)) return null;
  return module;
}
