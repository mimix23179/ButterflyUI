import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';

import 'submodules/code_editor_submodule_registry.dart';

const Set<String> codeEditorRegistryModules = {
  ...codeEditorEditorModules,
  ...codeEditorDocumentModules,
  ...codeEditorTabsModules,
  ...codeEditorExplorerModules,
  ...codeEditorSearchModules,
  ...codeEditorDiagnosticsModules,
  ...codeEditorDiffModules,
  ...codeEditorCommandsModules,
  ...codeEditorLayoutModules,
};

String? codeEditorModuleFromControlType(String type) {
  final normalized = umbrellaRuntimeNorm(type.replaceAll('.', '_'));
  final expectedPrefix = 'code_editor_';
  if (!normalized.startsWith(expectedPrefix)) return null;
  final module = normalized.substring(expectedPrefix.length);
  if (!codeEditorRegistryModules.contains(module)) return null;
  return module;
}
