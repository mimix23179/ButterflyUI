import '../../studio_contract.dart';

class StudioToolService {
  final Map<String, Map<String, Object?>> _registry =
      <String, Map<String, Object?>>{};

  String _activeTool = 'select';

  String get activeTool => _activeTool;

  Map<String, Map<String, Object?>> get registry =>
      Map<String, Map<String, Object?>>.unmodifiable(_registry);

  void loadFrom(Map<String, Object?> source) {
    _registry.clear();
    final rawRegistry = studioCoerceObjectMap(source['registry']);
    for (final entry in rawRegistry.entries) {
      final id = studioNorm(entry.key);
      if (id.isEmpty || entry.value is! Map) continue;
      _registry[id] = studioCoerceObjectMap(entry.value);
    }
    final tool = studioNorm(
      (source['active_tool'] ?? source['active']).toString(),
    );
    if (tool.isNotEmpty) {
      _activeTool = tool;
    }
    _ensureFallbackTools();
  }

  Map<String, Object?> registerTool(
    String toolId,
    Map<String, Object?> definition,
  ) {
    final normalized = studioNorm(toolId);
    if (normalized.isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'tool_id is required'};
    }
    _registry[normalized] = <String, Object?>{
      'id': normalized,
      'label': definition['label'] ?? _labelize(normalized),
      'cursor': definition['cursor'] ?? 'basic',
      ...definition,
    };
    if (!_registry.containsKey(_activeTool)) {
      _activeTool = normalized;
    }
    return <String, Object?>{
      'ok': true,
      'tool_id': normalized,
      'definition': _registry[normalized],
    };
  }

  void ensureTools(Iterable<String> tools) {
    for (final tool in tools) {
      final normalized = studioNorm(tool);
      if (normalized.isEmpty || _registry.containsKey(normalized)) continue;
      registerTool(normalized, const <String, Object?>{});
    }
    _ensureFallbackTools();
  }

  bool activate(String toolId) {
    final normalized = studioNorm(toolId);
    if (normalized.isEmpty) return false;
    if (!_registry.containsKey(normalized)) {
      registerTool(normalized, const <String, Object?>{});
    }
    _activeTool = normalized;
    return true;
  }

  String _labelize(String id) {
    if (id.isEmpty) return 'Tool';
    final words = id.split('_').where((part) => part.isNotEmpty).toList();
    if (words.isEmpty) return 'Tool';
    return words
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  void _ensureFallbackTools() {
    ensureTools(const <String>['select', 'move', 'resize', 'text']);
    if (!_registry.containsKey(_activeTool)) {
      _activeTool = _registry.keys.first;
    }
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'active_tool': _activeTool,
      'registry': _registry,
      'tools': _registry.values.toList(growable: false),
    };
  }
}
