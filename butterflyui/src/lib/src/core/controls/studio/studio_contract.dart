import 'package:butterflyui_runtime/src/core/control_utils.dart';

const int studioSchemaVersion = 2;

const List<String> studioModuleOrder = [
  'builder',
  'canvas',
  'timeline_surface',
  'node_surface',
  'preview_surface',
  'block_palette',
  'component_palette',
  'inspector',
  'outline_tree',
  'project_panel',
  'properties_panel',
  'responsive_toolbar',
  'tokens_editor',
  'actions_editor',
  'bindings_editor',
  'asset_browser',
  'selection_tools',
  'transform_box',
  'transform_toolbar',
];

const Set<String> studioModules = {
  'actions_editor',
  'asset_browser',
  'bindings_editor',
  'block_palette',
  'builder',
  'canvas',
  'timeline_surface',
  'node_surface',
  'preview_surface',
  'component_palette',
  'inspector',
  'outline_tree',
  'project_panel',
  'properties_panel',
  'responsive_toolbar',
  'tokens_editor',
  'selection_tools',
  'transform_box',
  'transform_toolbar',
};

const Set<String> studioSurfaceModules = {
  'canvas',
  'timeline_surface',
  'node_surface',
  'preview_surface',
};

const Set<String> studioPanelModules = {
  'project_panel',
  'outline_tree',
  'asset_browser',
  'inspector',
  'properties_panel',
  'actions_editor',
  'bindings_editor',
  'tokens_editor',
  'responsive_toolbar',
  'selection_tools',
  'transform_toolbar',
  'transform_box',
};

const Set<String> studioStates = {
  'idle',
  'loading',
  'ready',
  'editing',
  'preview',
  'disabled',
};

const Set<String> studioEvents = {
  'ready',
  'change',
  'submit',
  'select',
  'state_change',
  'module_change',
};

const Set<String> defaultStudioEvents = {
  'ready',
  'change',
  'submit',
  'select',
  'state_change',
  'module_change',
};

const Map<String, String> studioModuleAliases = {
  'assets': 'asset_browser',
  'assets_panel': 'asset_browser',
  'builder_surface': 'builder',
  'canvas_surface': 'canvas',
  'layers': 'outline_tree',
  'layers_panel': 'outline_tree',
  'node': 'node_surface',
  'node_graph': 'node_surface',
  'preview': 'preview_surface',
  'properties': 'properties_panel',
  'responsive': 'responsive_toolbar',
  'timeline': 'timeline_surface',
  'timeline_editor': 'timeline_surface',
  'token_editor': 'tokens_editor',
  'tokens': 'tokens_editor',
  'toolbox': 'selection_tools',
  'transform': 'transform_box',
  'transform_tools': 'transform_toolbar',
};

const Map<String, String> studioRegistryRoleAliases = {
  'surface': 'surface_registry',
  'surfaces': 'surface_registry',
  'surface_registry': 'surface_registry',
  'module': 'module_registry',
  'modules': 'module_registry',
  'module_registry': 'module_registry',
  'tool': 'tool_registry',
  'tools': 'tool_registry',
  'tool_registry': 'tool_registry',
  'panel': 'panel_registry',
  'panels': 'panel_registry',
  'panel_registry': 'panel_registry',
  'importer': 'importer_registry',
  'importers': 'importer_registry',
  'importer_registry': 'importer_registry',
  'exporter': 'exporter_registry',
  'exporters': 'exporter_registry',
  'exporter_registry': 'exporter_registry',
  'command': 'command_registry',
  'commands': 'command_registry',
  'command_registry': 'command_registry',
  'schema': 'schema_registry',
  'schemas': 'schema_registry',
  'schema_registry': 'schema_registry',
  'compute': 'command_registry',
};

const Map<String, String> studioRegistryManifestLists = {
  'module_registry': 'enabled_modules',
  'surface_registry': 'enabled_surfaces',
  'panel_registry': 'enabled_panels',
  'tool_registry': 'enabled_tools',
  'importer_registry': 'importers',
  'exporter_registry': 'exporters',
};

String studioNorm(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

String normalizeStudioModuleToken(String value) {
  final normalized = studioNorm(value);
  if (normalized.isEmpty) return '';
  return studioModuleAliases[normalized] ?? normalized;
}

String normalizeStudioSurfaceToken(String value) {
  final normalized = normalizeStudioModuleToken(value);
  if (normalized.isEmpty) return '';
  if (normalized == 'canvas_surface') return 'canvas';
  return normalized;
}

String normalizeStudioRegistryRole(String role) {
  final normalized = studioNorm(role);
  if (normalized.isEmpty) return '';
  return studioRegistryRoleAliases[normalized] ?? '${normalized}_registry';
}

String? studioManifestListForRole(String role) {
  final normalized = normalizeStudioRegistryRole(role);
  return studioRegistryManifestLists[normalized];
}

Map<String, Object?> studioCoerceObjectMap(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

List<Map<String, Object?>> studioCoerceMapList(Object? value) {
  if (value is! List) return const <Map<String, Object?>>[];
  final out = <Map<String, Object?>>[];
  for (final entry in value) {
    if (entry is Map) {
      out.add(coerceObjectMap(entry));
    }
  }
  return out;
}

List<String> studioCoerceStringList(Object? value) {
  if (value is! List) return const <String>[];
  final out = <String>[];
  for (final entry in value) {
    final normalized = studioNorm(entry?.toString() ?? '');
    if (normalized.isNotEmpty) out.add(normalized);
  }
  return out;
}

Object? deepCopyStudioValue(Object? value) {
  if (value is Map) {
    final out = <String, Object?>{};
    for (final entry in value.entries) {
      out[entry.key.toString()] = deepCopyStudioValue(entry.value);
    }
    return out;
  }
  if (value is List) {
    return value.map(deepCopyStudioValue).toList(growable: false);
  }
  return value;
}

Map<String, Object?> deepCopyStudioMap(Map<String, Object?> value) {
  final out = <String, Object?>{};
  for (final entry in value.entries) {
    out[entry.key] = deepCopyStudioValue(entry.value);
  }
  return out;
}

List<String> _normalizedUniqueStrings(
  Object? raw, {
  required String Function(String value) normalize,
  Set<String>? allowed,
}) {
  final out = <String>[];
  for (final value in studioCoerceStringList(raw)) {
    final normalized = normalize(value);
    if (normalized.isEmpty) continue;
    if (allowed != null && !allowed.contains(normalized)) continue;
    if (!out.contains(normalized)) out.add(normalized);
  }
  return out;
}

Map<String, Object?> studioBuildManifest(Map<String, Object?> props) {
  final rawManifest = studioCoerceObjectMap(props['manifest']);
  final manifest = <String, Object?>{...rawManifest};

  List<String> readList(
    String key,
    List<String> fallback, {
    String Function(String value)? normalize,
    Set<String>? allowed,
  }) {
    final normalizer = normalize ?? studioNorm;
    final fromManifest = _normalizedUniqueStrings(
      manifest[key],
      normalize: normalizer,
      allowed: allowed,
    );
    if (fromManifest.isNotEmpty) return fromManifest;
    final fromProps = _normalizedUniqueStrings(
      props[key],
      normalize: normalizer,
      allowed: allowed,
    );
    if (fromProps.isNotEmpty) return fromProps;
    return fallback;
  }

  manifest['enabled_surfaces'] = readList(
    'enabled_surfaces',
    const ['canvas'],
    normalize: normalizeStudioSurfaceToken,
    allowed: studioSurfaceModules,
  );
  manifest['enabled_modules'] = readList(
    'enabled_modules',
    const [
      'builder',
      'canvas',
      'timeline_surface',
      'node_surface',
      'preview_surface',
      'responsive_toolbar',
      'project_panel',
      'outline_tree',
      'component_palette',
      'block_palette',
      'asset_browser',
      'selection_tools',
      'transform_toolbar',
      'inspector',
      'properties_panel',
      'actions_editor',
      'bindings_editor',
      'tokens_editor',
      'transform_box',
    ],
    normalize: normalizeStudioModuleToken,
    allowed: studioModules,
  );
  manifest['enabled_panels'] = readList(
    'enabled_panels',
    const [
      'project_panel',
      'outline_tree',
      'asset_browser',
      'inspector',
      'properties_panel',
      'actions_editor',
      'bindings_editor',
      'tokens_editor',
      'responsive_toolbar',
    ],
    normalize: normalizeStudioModuleToken,
    allowed: studioPanelModules,
  );
  manifest['enabled_tools'] = readList('enabled_tools', const [
    'select',
    'move',
    'resize',
    'text',
  ]);
  manifest['importers'] = readList('importers', const [
    'image',
    'svg',
    'audio',
    'video',
    'font',
  ]);
  manifest['exporters'] = readList('exporters', const ['png', 'json']);
  manifest['compute'] = readList('compute', const <String>[]);

  final starterKit = (manifest['starter_kit'] ?? props['starter_kit'] ?? '')
      .toString()
      .trim();
  if (starterKit.isNotEmpty) {
    manifest['starter_kit'] = starterKit;
  }

  return manifest;
}

Map<String, Object?> normalizeStudioProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] =
      (coerceOptionalInt(out['schema_version']) ?? studioSchemaVersion).clamp(
        1,
        9999,
      );

  final module = normalizeStudioModuleToken(out['module']?.toString() ?? '');
  if (module.isNotEmpty && studioModules.contains(module)) {
    out['module'] = module;
  } else {
    out['module'] = 'builder';
  }

  final state = studioNorm(out['state']?.toString() ?? '');
  if (state.isNotEmpty && studioStates.contains(state)) {
    out['state'] = state;
  } else if (state.isNotEmpty) {
    out.remove('state');
  } else {
    out['state'] = 'ready';
  }

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((e) => studioNorm(e?.toString() ?? ''))
        .where((e) => e.isNotEmpty && studioEvents.contains(e))
        .toSet()
        .toList(growable: false);
  }

  final showChrome = out['show_chrome'];
  final showModules = out['show_modules'];
  if (showChrome == null && showModules == null) {
    out['show_chrome'] = true;
  }

  out['left_pane_ratio'] = (coerceDouble(out['left_pane_ratio']) ?? 0.22).clamp(
    0.12,
    0.4,
  );
  out['right_pane_ratio'] = (coerceDouble(out['right_pane_ratio']) ?? 0.26)
      .clamp(0.16, 0.42);
  out['bottom_panel_height'] = (coerceDouble(out['bottom_panel_height']) ?? 196)
      .clamp(120, 420);

  final modules = studioCoerceObjectMap(out['modules']);
  final normalizedModules = <String, Object?>{};

  void mergeModule(String key, Object? value) {
    final normalized = normalizeStudioModuleToken(key);
    if (!studioModules.contains(normalized)) return;
    if (value == true) {
      normalizedModules[normalized] = <String, Object?>{};
      out[normalized] = <String, Object?>{};
      return;
    }
    final mapValue = studioCoerceObjectMap(value);
    if (mapValue.isEmpty && value is! Map) return;
    normalizedModules[normalized] = mapValue;
    out[normalized] = mapValue;
  }

  for (final key in studioModules) {
    final topLevel = out[key];
    if (topLevel != null) {
      mergeModule(key, topLevel);
    }
  }
  for (final entry in out.entries.toList(growable: false)) {
    if (entry.key == 'modules') continue;
    mergeModule(entry.key, entry.value);
  }
  for (final entry in modules.entries) {
    mergeModule(entry.key, entry.value);
  }
  out['modules'] = normalizedModules;

  out['manifest'] = studioBuildManifest(out);

  return out;
}

Map<String, Object?>? studioSectionProps(
  Map<String, Object?> props,
  String key,
) {
  final normalized = normalizeStudioModuleToken(key);
  final manifest = studioCoerceObjectMap(props['manifest']);
  final enabledModules = _normalizedUniqueStrings(
    manifest['enabled_modules'],
    normalize: normalizeStudioModuleToken,
    allowed: studioModules,
  );
  if (enabledModules.isNotEmpty && !enabledModules.contains(normalized)) {
    return null;
  }
  final section = props[normalized];
  if (section is Map) {
    return <String, Object?>{
      ...coerceObjectMap(section),
      'events': props['events'],
    };
  }
  if (section == true) {
    return <String, Object?>{'events': props['events']};
  }
  final modules = studioCoerceObjectMap(props['modules']);
  final fromModules = modules[normalized];
  if (fromModules is Map) {
    return <String, Object?>{
      ...coerceObjectMap(fromModules),
      'events': props['events'],
    };
  }
  if (fromModules == true) {
    return <String, Object?>{'events': props['events']};
  }
  return null;
}

List<String> availableStudioModules(Map<String, Object?> props) {
  final manifest = studioCoerceObjectMap(props['manifest']);
  final fromManifest = _normalizedUniqueStrings(
    manifest['enabled_modules'],
    normalize: normalizeStudioModuleToken,
    allowed: studioModules,
  );
  if (fromManifest.isNotEmpty) {
    return fromManifest;
  }

  final modules = <String>[];
  final moduleMap = studioCoerceObjectMap(props['modules']);
  for (final key in studioModuleOrder) {
    if (props[key] is Map ||
        props[key] == true ||
        moduleMap[key] is Map ||
        moduleMap[key] == true) {
      modules.add(key);
    }
  }
  if (modules.isEmpty) {
    modules.addAll(const [
      'builder',
      'canvas',
      'timeline_surface',
      'node_surface',
      'responsive_toolbar',
      'project_panel',
      'outline_tree',
      'component_palette',
      'block_palette',
      'asset_browser',
      'selection_tools',
      'transform_toolbar',
      'inspector',
      'properties_panel',
      'actions_editor',
      'bindings_editor',
      'tokens_editor',
      'transform_box',
    ]);
  }
  return modules;
}
