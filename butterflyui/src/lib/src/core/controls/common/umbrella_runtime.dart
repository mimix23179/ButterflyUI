import 'package:butterflyui_runtime/src/core/control_utils.dart';

String umbrellaRuntimeNorm(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

Map<String, Object?> umbrellaRuntimeMap(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

List<String> umbrellaRuntimeStringList(
  Object? value, {
  Set<String>? allowed,
}) {
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

  final manifest = <String, Object?>{
    ...umbrellaRuntimeMap(props['manifest']),
  };

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
    manifest[key] = readList(
      key,
      fallback,
      allowed: key == 'enabled_modules' ? modules : null,
    );
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
  out['registries'] = normalizeUmbrellaRegistries(out['registries'], roleAliases);
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

  final registries = normalizeUmbrellaRegistries(props['registries'], roleAliases);
  final roleRegistry = umbrellaRuntimeMap(registries[normalizedRole]);
  roleRegistry[normalizedModule] = definition;
  registries[normalizedRole] = roleRegistry;
  props['registries'] = registries;

  final manifest = buildUmbrellaManifest(
    props: props,
    modules: modules,
    defaults: manifestDefaults,
  );

  final enabledModules = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: modules,
  ).toList();
  if (modules.contains(normalizedModule) && !enabledModules.contains(normalizedModule)) {
    enabledModules.add(normalizedModule);
  }
  manifest['enabled_modules'] = enabledModules;

  final listKey = roleManifestLists[normalizedRole];
  if (listKey != null) {
    final values = umbrellaRuntimeStringList(manifest[listKey]).toList();
    if (!values.contains(normalizedModule)) {
      values.add(normalizedModule);
    }
    manifest[listKey] = values;
  }

  props['manifest'] = manifest;
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
