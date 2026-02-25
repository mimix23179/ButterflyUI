import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:flutter/widgets.dart';

Widget ensureUmbrellaLayoutBounds({
  required Map<String, Object?> props,
  required Widget child,
  double defaultHeight = 640,
  double minHeight = 240,
  double maxHeight = 5000,
}) {
  final configuredHeight = (coerceDouble(props['height']) ?? defaultHeight)
      .clamp(minHeight, maxHeight)
      .toDouble();
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.hasBoundedHeight && constraints.maxHeight.isFinite) {
        return child;
      }
      return SizedBox(height: configuredHeight, child: child);
    },
  );
}

String umbrellaRuntimeNorm(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

Map<String, Object?> umbrellaRuntimeMap(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

List<String> umbrellaRuntimeStringList(Object? value, {Set<String>? allowed}) {
  if (value is! List) return const <String>[];
  final out = <String>[];
  for (final entry in value) {
    final normalized = umbrellaRuntimeNorm(entry?.toString() ?? '');
    if (normalized.isEmpty) continue;
    if (allowed != null && !allowed.contains(normalized)) continue;
    if (!out.contains(normalized)) out.add(normalized);
  }
  return out;
}

String normalizeUmbrellaRegistryRole(
  String role,
  Map<String, String> roleAliases,
) {
  final normalized = umbrellaRuntimeNorm(role);
  if (normalized.isEmpty) return '';
  return roleAliases[normalized] ?? '${normalized}_registry';
}

Map<String, Object?> normalizeUmbrellaRegistries(
  Object? raw,
  Map<String, String> roleAliases,
) {
  final source = umbrellaRuntimeMap(raw);
  final out = <String, Object?>{};
  for (final entry in source.entries) {
    final role = normalizeUmbrellaRegistryRole(entry.key, roleAliases);
    if (role.isEmpty) continue;
    out[role] = umbrellaRuntimeMap(entry.value);
  }
  return out;
}

List<String> _normalizedDependencyList(Object? value, Set<String> modules) {
  final out = <String>[];

  void addToken(String raw) {
    for (final part in raw.split(',')) {
      final normalized = umbrellaRuntimeNorm(part);
      if (normalized.isEmpty) continue;
      if (!modules.contains(normalized)) continue;
      if (!out.contains(normalized)) out.add(normalized);
    }
  }

  if (value is String) {
    addToken(value);
    return out;
  }
  if (value is List) {
    for (final entry in value) {
      addToken(entry?.toString() ?? '');
    }
    return out;
  }
  if (value is Map) {
    for (final entry in value.entries) {
      final enabled = entry.value == null
          ? true
          : (entry.value is bool)
          ? entry.value == true
          : true;
      if (!enabled) continue;
      addToken(entry.key.toString());
    }
  }
  return out;
}

Map<String, Object?> _normalizedModuleMetaEntry({
  required String module,
  required Object? value,
  required Set<String> modules,
}) {
  final payload = umbrellaRuntimeMap(value);
  final id = umbrellaRuntimeNorm((payload['id'] ?? module).toString());
  final version = (payload['version'] ?? payload['module_version'] ?? '1.0.0')
      .toString()
      .trim();
  final dependsOn = _normalizedDependencyList(
    payload['depends_on'] ??
        payload['dependsOn'] ??
        payload['module_dependencies'],
    modules,
  );
  final contributions = umbrellaRuntimeMap(payload['contributions']);
  return <String, Object?>{
    'id': id.isEmpty ? module : id,
    'version': version.isEmpty ? '1.0.0' : version,
    'depends_on': dependsOn,
    'contributions': contributions,
  };
}

Map<String, Object?> normalizeUmbrellaSubmoduleMeta({
  required Map<String, Object?> props,
  required Set<String> modules,
}) {
  final out = <String, Object?>{};

  void upsert(String module, Object? value) {
    final normalizedModule = umbrellaRuntimeNorm(module);
    if (!modules.contains(normalizedModule)) return;
    final next = _normalizedModuleMetaEntry(
      module: normalizedModule,
      value: value,
      modules: modules,
    );
    final current = umbrellaRuntimeMap(out[normalizedModule]);
    out[normalizedModule] = <String, Object?>{...current, ...next};
  }

  final globalMeta = umbrellaRuntimeMap(props['submodule_meta']);
  for (final entry in globalMeta.entries) {
    final token = umbrellaRuntimeNorm(entry.key);
    if (!modules.contains(token)) continue;
    upsert(token, entry.value);
  }
  final activeModule = umbrellaRuntimeNorm((props['module'] ?? '').toString());
  if (modules.contains(activeModule) &&
      (globalMeta.containsKey('id') ||
          globalMeta.containsKey('version') ||
          globalMeta.containsKey('depends_on') ||
          globalMeta.containsKey('dependsOn') ||
          globalMeta.containsKey('contributions'))) {
    upsert(activeModule, globalMeta);
  }

  final moduleMap = umbrellaRuntimeMap(props['modules']);
  for (final module in modules) {
    final sectionFromModules = umbrellaRuntimeMap(moduleMap[module]);
    final sectionFromTopLevel = umbrellaRuntimeMap(props[module]);
    final fromSectionMeta =
        sectionFromModules['submodule_meta'] ??
        sectionFromTopLevel['submodule_meta'];
    if (fromSectionMeta != null) {
      upsert(module, fromSectionMeta);
    }
  }

  return out;
}

List<String> _moduleDependencies({
  required Map<String, Object?> props,
  required String module,
  required Set<String> modules,
}) {
  final dependencies = <String>[];

  void addAll(Object? value) {
    final normalized = _normalizedDependencyList(value, modules);
    for (final dependency in normalized) {
      if (!dependencies.contains(dependency)) {
        dependencies.add(dependency);
      }
    }
  }

  final moduleMap = umbrellaRuntimeMap(props['modules']);
  final modulePayload = umbrellaRuntimeMap(moduleMap[module]);
  addAll(modulePayload['depends_on'] ?? modulePayload['dependsOn']);
  final modulePayloadMeta = umbrellaRuntimeMap(modulePayload['submodule_meta']);
  addAll(modulePayloadMeta['depends_on'] ?? modulePayloadMeta['dependsOn']);

  final topLevelPayload = umbrellaRuntimeMap(props[module]);
  addAll(topLevelPayload['depends_on'] ?? topLevelPayload['dependsOn']);
  final topLevelPayloadMeta = umbrellaRuntimeMap(
    topLevelPayload['submodule_meta'],
  );
  addAll(topLevelPayloadMeta['depends_on'] ?? topLevelPayloadMeta['dependsOn']);

  final manifest = umbrellaRuntimeMap(props['manifest']);
  final manifestDependencies = umbrellaRuntimeMap(
    manifest['module_dependencies'],
  );
  addAll(manifestDependencies[module]);
  final manifestMeta = umbrellaRuntimeMap(manifest['submodule_meta']);
  final manifestMetaForModule = umbrellaRuntimeMap(manifestMeta[module]);
  addAll(
    manifestMetaForModule['depends_on'] ?? manifestMetaForModule['dependsOn'],
  );

  final propDependencies = umbrellaRuntimeMap(props['module_dependencies']);
  addAll(propDependencies[module]);
  final propSubmoduleMeta = umbrellaRuntimeMap(props['submodule_meta']);
  final propMetaForModule = umbrellaRuntimeMap(propSubmoduleMeta[module]);
  addAll(propMetaForModule['depends_on'] ?? propMetaForModule['dependsOn']);
  if (module == umbrellaRuntimeNorm((props['module'] ?? '').toString())) {
    addAll(propSubmoduleMeta['depends_on'] ?? propSubmoduleMeta['dependsOn']);
  }

  final registries = umbrellaRuntimeMap(props['registries']);
  final moduleRegistry = umbrellaRuntimeMap(registries['module_registry']);
  final moduleDefinition = umbrellaRuntimeMap(moduleRegistry[module]);
  addAll(moduleDefinition['depends_on'] ?? moduleDefinition['dependsOn']);

  return dependencies;
}

List<String> resolveUmbrellaEnabledModules({
  required Map<String, Object?> props,
  required Set<String> modules,
  required Iterable<String> seed,
}) {
  final out = <String>[];

  void addModule(String module) {
    final normalized = umbrellaRuntimeNorm(module);
    if (normalized.isEmpty) return;
    if (!modules.contains(normalized)) return;
    if (!out.contains(normalized)) out.add(normalized);
  }

  for (final module in seed) {
    addModule(module);
  }

  final manifest = umbrellaRuntimeMap(props['manifest']);
  for (final module in umbrellaRuntimeStringList(
    manifest['required_modules'],
    allowed: modules,
  )) {
    addModule(module);
  }
  for (final module in umbrellaRuntimeStringList(
    props['required_modules'],
    allowed: modules,
  )) {
    addModule(module);
  }

  final moduleMap = umbrellaRuntimeMap(props['modules']);
  for (final entry in moduleMap.entries) {
    if (entry.value is Map || entry.value == true) {
      addModule(entry.key);
    }
  }
  for (final module in modules) {
    final value = props[module];
    if (value is Map || value == true) {
      addModule(module);
    }
  }

  final queue = <String>[...out];
  var index = 0;
  while (index < queue.length) {
    final module = queue[index];
    index += 1;
    final dependencies = _moduleDependencies(
      props: props,
      module: module,
      modules: modules,
    );
    for (final dependency in dependencies) {
      if (!out.contains(dependency)) {
        out.add(dependency);
        queue.add(dependency);
      }
    }
  }

  return out;
}

Map<String, Object?> buildUmbrellaManifest({
  required Map<String, Object?> props,
  required Set<String> modules,
  required Map<String, List<String>> defaults,
}) {
  final normalizedDefaults = <String, List<String>>{};
  for (final entry in defaults.entries) {
    final key = umbrellaRuntimeNorm(entry.key);
    if (key.isEmpty) continue;
    normalizedDefaults[key] = entry.value;
  }

  final manifest = <String, Object?>{...umbrellaRuntimeMap(props['manifest'])};

  List<String> readList(
    String key,
    List<String> fallback, {
    Set<String>? allowed,
  }) {
    final fromManifest = umbrellaRuntimeStringList(
      manifest[key],
      allowed: allowed,
    );
    if (fromManifest.isNotEmpty) return fromManifest;
    final fromProps = umbrellaRuntimeStringList(props[key], allowed: allowed);
    if (fromProps.isNotEmpty) return fromProps;
    final normalizedFallback = fallback
        .map(umbrellaRuntimeNorm)
        .where((entry) => entry.isNotEmpty)
        .toList(growable: false);
    if (allowed == null) return normalizedFallback;
    return normalizedFallback.where(allowed.contains).toList(growable: false);
  }

  final listKeys = <String>{
    'enabled_modules',
    'enabled_views',
    'enabled_panels',
    'enabled_tools',
    'enabled_providers',
    'enabled_commands',
    ...normalizedDefaults.keys.where((key) => key.startsWith('enabled_')),
    ...manifest.keys.where((key) => key.startsWith('enabled_')),
    ...props.keys.where((key) => key.startsWith('enabled_')),
  };
  for (final key in listKeys) {
    final fallback = normalizedDefaults[key] ?? const <String>[];
    if (key == 'enabled_modules') {
      final seed = readList(key, fallback, allowed: modules);
      manifest[key] = resolveUmbrellaEnabledModules(
        props: props,
        modules: modules,
        seed: seed,
      );
      continue;
    }
    manifest[key] = readList(key, fallback);
  }

  final requiredModules = readList(
    'required_modules',
    const <String>[],
    allowed: modules,
  );
  if (requiredModules.isNotEmpty) {
    manifest['required_modules'] = requiredModules;
  } else {
    manifest.remove('required_modules');
  }

  final layout = umbrellaRuntimeMap(manifest['layout']);
  final propLayout = umbrellaRuntimeMap(props['layout']);
  if (layout.isEmpty && propLayout.isNotEmpty) {
    manifest['layout'] = propLayout;
  } else if (layout.isNotEmpty) {
    manifest['layout'] = layout;
  }

  final keybinds = umbrellaRuntimeMap(manifest['keybinds']);
  final propKeybinds = umbrellaRuntimeMap(props['keybinds']);
  if (keybinds.isEmpty && propKeybinds.isNotEmpty) {
    manifest['keybinds'] = propKeybinds;
  } else if (keybinds.isNotEmpty) {
    manifest['keybinds'] = keybinds;
  }

  final providers = umbrellaRuntimeMap(manifest['providers']);
  final propProviders = umbrellaRuntimeMap(props['providers']);
  if (providers.isEmpty && propProviders.isNotEmpty) {
    manifest['providers'] = propProviders;
  } else if (providers.isNotEmpty) {
    manifest['providers'] = providers;
  }

  final submoduleMeta = normalizeUmbrellaSubmoduleMeta(
    props: props,
    modules: modules,
  );
  if (submoduleMeta.isNotEmpty) {
    manifest['submodule_meta'] = submoduleMeta;
    final moduleVersions = umbrellaRuntimeMap(manifest['module_versions']);
    final moduleDependencies = umbrellaRuntimeMap(
      manifest['module_dependencies'],
    );
    for (final entry in submoduleMeta.entries) {
      final meta = umbrellaRuntimeMap(entry.value);
      final version = (meta['version'] ?? '').toString().trim();
      if (version.isNotEmpty) {
        moduleVersions[entry.key] = version;
      }
      final dependsOn = _normalizedDependencyList(
        meta['depends_on'] ?? meta['dependsOn'],
        modules,
      );
      if (dependsOn.isNotEmpty) {
        moduleDependencies[entry.key] = dependsOn;
      }
    }
    if (moduleVersions.isNotEmpty) {
      manifest['module_versions'] = moduleVersions;
    } else {
      manifest.remove('module_versions');
    }
    if (moduleDependencies.isNotEmpty) {
      manifest['module_dependencies'] = moduleDependencies;
    } else {
      manifest.remove('module_dependencies');
    }
  } else {
    manifest.remove('submodule_meta');
  }

  return manifest;
}

Map<String, Object?> normalizeUmbrellaHostProps({
  required Map<String, Object?> props,
  required Set<String> modules,
  required Map<String, String> roleAliases,
  required Map<String, List<String>> manifestDefaults,
}) {
  final out = <String, Object?>{...props};
  out['manifest'] = buildUmbrellaManifest(
    props: out,
    modules: modules,
    defaults: manifestDefaults,
  );
  out['registries'] = normalizeUmbrellaRegistries(
    out['registries'],
    roleAliases,
  );
  out['submodule_meta'] = normalizeUmbrellaSubmoduleMeta(
    props: out,
    modules: modules,
  );
  return out;
}

Map<String, Object?> registerUmbrellaModule({
  required Map<String, Object?> props,
  required String role,
  required String moduleId,
  required Map<String, Object?> definition,
  required Set<String> modules,
  required Map<String, String> roleAliases,
  required Map<String, String> roleManifestLists,
  required Map<String, List<String>> manifestDefaults,
}) {
  final normalizedRole = normalizeUmbrellaRegistryRole(role, roleAliases);
  final normalizedModule = umbrellaRuntimeNorm(moduleId);
  if (normalizedRole.isEmpty || normalizedModule.isEmpty) {
    return <String, Object?>{
      'ok': false,
      'error': 'role and module_id are required',
    };
  }

  final registries = normalizeUmbrellaRegistries(
    props['registries'],
    roleAliases,
  );
  final roleRegistry = umbrellaRuntimeMap(registries[normalizedRole]);
  roleRegistry[normalizedModule] = definition;
  registries[normalizedRole] = roleRegistry;
  props['registries'] = registries;

  final manifest = buildUmbrellaManifest(
    props: props,
    modules: modules,
    defaults: manifestDefaults,
  );

  final enabledSeed = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: modules,
  ).toList(growable: true);
  if (modules.contains(normalizedModule) &&
      !enabledSeed.contains(normalizedModule)) {
    enabledSeed.add(normalizedModule);
  }
  manifest['enabled_modules'] = resolveUmbrellaEnabledModules(
    props: <String, Object?>{...props, 'manifest': manifest},
    modules: modules,
    seed: enabledSeed,
  );

  final listKey = roleManifestLists[normalizedRole];
  if (listKey != null) {
    final values = umbrellaRuntimeStringList(manifest[listKey]).toList();
    if (!values.contains(normalizedModule)) {
      values.add(normalizedModule);
    }
    manifest[listKey] = values;
  }

  props['manifest'] = manifest;
  final submoduleMeta = normalizeUmbrellaSubmoduleMeta(
    props: props,
    modules: modules,
  );
  if (definition.containsKey('version') ||
      definition.containsKey('depends_on') ||
      definition.containsKey('dependsOn') ||
      definition.containsKey('contributions') ||
      definition.containsKey('id') ||
      definition.containsKey('module_version')) {
    submoduleMeta[normalizedModule] = _normalizedModuleMetaEntry(
      module: normalizedModule,
      value: definition,
      modules: modules,
    );
  }
  props['submodule_meta'] = submoduleMeta;
  if (modules.contains(normalizedModule)) {
    final modulePayload = <String, Object?>{};
    final moduleMap = umbrellaRuntimeMap(props['modules']);
    moduleMap.putIfAbsent(normalizedModule, () => modulePayload);
    props['modules'] = moduleMap;
    props[normalizedModule] = umbrellaRuntimeMap(moduleMap[normalizedModule]);
  }

  return <String, Object?>{
    'ok': true,
    'role': normalizedRole,
    'module_id': normalizedModule,
    'definition': definition,
    'manifest': manifest,
  };
}
