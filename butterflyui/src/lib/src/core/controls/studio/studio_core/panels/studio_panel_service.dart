import '../../studio_contract.dart';

class StudioPanelService {
  final Map<String, Map<String, Object?>> _registry =
      <String, Map<String, Object?>>{};
  Map<String, Object?> _layout = <String, Object?>{
    'left': <String>[
      'project_panel',
      'outline_tree',
      'component_palette',
      'block_palette',
      'asset_browser',
    ],
    'right': <String>[
      'inspector',
      'properties_panel',
      'actions_editor',
      'bindings_editor',
      'tokens_editor',
      'selection_tools',
      'transform_toolbar',
      'transform_box',
    ],
    'bottom': <String>['history', 'manifest', 'registries'],
  };
  String focusedPanel = 'inspector';

  Map<String, Map<String, Object?>> get registry =>
      Map<String, Map<String, Object?>>.unmodifiable(_registry);

  Map<String, Object?> get layout => deepCopyStudioMap(_layout);

  void loadFrom(Map<String, Object?> source) {
    _registry.clear();
    final panelRegistry = studioCoerceObjectMap(source['registry']);
    for (final panel in panelRegistry.entries) {
      final panelId = normalizeStudioModuleToken(panel.key);
      if (panelId.isEmpty || panel.value is! Map) continue;
      _registry[panelId] = studioCoerceObjectMap(panel.value);
    }
    final rawLayout = studioCoerceObjectMap(source['layout']);
    if (rawLayout.isNotEmpty) {
      _layout = deepCopyStudioMap(rawLayout);
    }
    final focused = normalizeStudioModuleToken(
      (source['focused_panel'] ?? source['focus']).toString(),
    );
    if (focused.isNotEmpty) {
      focusedPanel = focused;
    }
    _ensureDefaultPanels();
  }

  Map<String, Object?> registerPanel(
    String panelId,
    Map<String, Object?> definition,
  ) {
    final normalized = normalizeStudioModuleToken(panelId);
    if (normalized.isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'panel_id is required'};
    }
    _registry[normalized] = <String, Object?>{
      'id': normalized,
      'label': definition['label'] ?? _labelize(normalized),
      ...definition,
    };
    _ensurePanelInLayout(normalized);
    return <String, Object?>{
      'ok': true,
      'panel_id': normalized,
      'definition': _registry[normalized],
    };
  }

  void ensurePanels(Iterable<String> panels) {
    for (final panel in panels) {
      final normalized = normalizeStudioModuleToken(panel);
      if (normalized.isEmpty || _registry.containsKey(normalized)) continue;
      registerPanel(normalized, const <String, Object?>{});
    }
    _ensureDefaultPanels();
  }

  void setLayout(Map<String, Object?> layout) {
    _layout = deepCopyStudioMap(layout);
    _ensureDefaultPanels();
  }

  void focus(String panelId) {
    final normalized = normalizeStudioModuleToken(panelId);
    if (normalized.isNotEmpty) {
      focusedPanel = normalized;
      _ensurePanelInLayout(normalized);
    }
  }

  void _ensureDefaultPanels() {
    ensurePanels(studioPanelModules);
    if (!_registry.containsKey(focusedPanel)) {
      focusedPanel = _registry.keys.first;
    }
  }

  void _ensurePanelInLayout(String panelId) {
    final right = studioCoerceStringList(_layout['right']).toList();
    if (!right.contains(panelId)) {
      right.add(panelId);
      _layout['right'] = right;
    }
  }

  String _labelize(String id) {
    if (id.isEmpty) return 'Panel';
    return id
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'focused_panel': focusedPanel,
      'registry': _registry,
      'layout': _layout,
    };
  }
}
