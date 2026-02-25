import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

const Set<String> terminalRegistryModules = {
  'capabilities',
  'command_builder',
  'flow_gate',
  'output_mapper',
  'presets',
  'progress',
  'progress_view',
  'prompt',
  'raw_view',
  'replay',
  'session',
  'stdin',
  'stdin_injector',
  'stream',
  'stream_view',
  'tabs',
  'timeline',
  'view',
  'workbench',
  'process_bridge',
  'execution_lane',
  'log_viewer',
  'log_panel',
};

String? terminalModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'terminal_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!terminalRegistryModules.contains(module)) return null;
  return module;
}
