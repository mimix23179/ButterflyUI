import '../studio_contract.dart';

class StudioRegistryBus {
  final Map<String, Map<String, Object?>> _registries =
      <String, Map<String, Object?>>{
        'surface_registry': <String, Object?>{},
        'tool_registry': <String, Object?>{},
        'panel_registry': <String, Object?>{},
        'importer_registry': <String, Object?>{},
        'exporter_registry': <String, Object?>{},
        'command_registry': <String, Object?>{},
        'schema_registry': <String, Object?>{},
      };

  void loadFrom(Map<String, Object?> source) {
    for (final key in _registries.keys.toList(growable: false)) {
      _registries[key] = studioCoerceObjectMap(source[key]);
    }
  }

  Map<String, Object?> register(
    String role,
    String moduleId,
    Map<String, Object?> definition,
  ) {
    final normalizedRole = normalizeStudioRegistryRole(role);
    final normalizedId = studioNorm(moduleId);
    if (normalizedRole.isEmpty || normalizedId.isEmpty) {
      return <String, Object?>{
        'ok': false,
        'error': 'role and module_id are required',
      };
    }
    final key = normalizedRole;
    final registry = studioCoerceObjectMap(_registries[key]);
    registry[normalizedId] = definition;
    _registries[key] = registry;
    return <String, Object?>{
      'ok': true,
      'role': key,
      'module_id': normalizedId,
      'definition': definition,
    };
  }

  Map<String, Object?> registerSurface(
    String moduleId,
    Map<String, Object?> definition,
  ) => register('surface', moduleId, definition);

  Map<String, Object?> registerTool(
    String moduleId,
    Map<String, Object?> definition,
  ) => register('tool', moduleId, definition);

  Map<String, Object?> registerPanel(
    String moduleId,
    Map<String, Object?> definition,
  ) => register('panel', moduleId, definition);

  Map<String, Object?> registerImporter(
    String moduleId,
    Map<String, Object?> definition,
  ) => register('importer', moduleId, definition);

  Map<String, Object?> registerExporter(
    String moduleId,
    Map<String, Object?> definition,
  ) => register('exporter', moduleId, definition);

  Map<String, Object?> registerCommand(
    String moduleId,
    Map<String, Object?> definition,
  ) => register('command', moduleId, definition);

  Map<String, Object?> registerSchema(
    String moduleId,
    Map<String, Object?> definition,
  ) => register('schema', moduleId, definition);

  List<String> listIds(String role) {
    final key = normalizeStudioRegistryRole(role);
    return studioCoerceObjectMap(_registries[key]).keys.toList(growable: false);
  }

  Map<String, Object?> getRegistry(String role) {
    return studioCoerceObjectMap(
      _registries[normalizeStudioRegistryRole(role)],
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      for (final entry in _registries.entries) entry.key: entry.value,
    };
  }
}
