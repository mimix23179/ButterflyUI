import 'studio_contract.dart';

class StudioManifest {
  StudioManifest({
    required this.enabledModules,
    required this.enabledSurfaces,
    required this.enabledPanels,
    required this.enabledTools,
    required this.importers,
    required this.exporters,
    required this.compute,
    required this.layout,
    required this.keybinds,
    required this.providers,
    required this.requiredModules,
    this.starterKit,
  });

  final List<String> enabledModules;
  final List<String> enabledSurfaces;
  final List<String> enabledPanels;
  final List<String> enabledTools;
  final List<String> importers;
  final List<String> exporters;
  final List<String> compute;
  final Map<String, Object?> layout;
  final Map<String, Object?> keybinds;
  final Map<String, Object?> providers;
  final List<String> requiredModules;
  final String? starterKit;

  factory StudioManifest.fromProps(Map<String, Object?> props) {
    final manifest = studioBuildManifest(props);
    String? starter = manifest['starter_kit']?.toString().trim();
    if (starter != null && starter.isEmpty) {
      starter = null;
    }
    return StudioManifest(
      enabledModules: studioCoerceStringList(manifest['enabled_modules']),
      enabledSurfaces: studioCoerceStringList(manifest['enabled_surfaces']),
      enabledPanels: studioCoerceStringList(manifest['enabled_panels']),
      enabledTools: studioCoerceStringList(manifest['enabled_tools']),
      importers: studioCoerceStringList(manifest['importers']),
      exporters: studioCoerceStringList(manifest['exporters']),
      compute: studioCoerceStringList(manifest['compute']),
      layout: studioCoerceObjectMap(manifest['layout']),
      keybinds: studioCoerceObjectMap(manifest['keybinds']),
      providers: studioCoerceObjectMap(manifest['providers']),
      requiredModules: studioCoerceStringList(manifest['required_modules']),
      starterKit: starter,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'enabled_modules': enabledModules,
      'enabled_surfaces': enabledSurfaces,
      'enabled_panels': enabledPanels,
      'enabled_tools': enabledTools,
      'importers': importers,
      'exporters': exporters,
      'compute': compute,
      if (layout.isNotEmpty) 'layout': layout,
      if (keybinds.isNotEmpty) 'keybinds': keybinds,
      if (providers.isNotEmpty) 'providers': providers,
      if (requiredModules.isNotEmpty) 'required_modules': requiredModules,
      if (starterKit != null && starterKit!.isNotEmpty)
        'starter_kit': starterKit,
    };
  }

  StudioManifest copyWith({
    List<String>? enabledModules,
    List<String>? enabledSurfaces,
    List<String>? enabledPanels,
    List<String>? enabledTools,
    List<String>? importers,
    List<String>? exporters,
    List<String>? compute,
    Map<String, Object?>? layout,
    Map<String, Object?>? keybinds,
    Map<String, Object?>? providers,
    List<String>? requiredModules,
    String? starterKit,
  }) {
    return StudioManifest(
      enabledModules: enabledModules ?? this.enabledModules,
      enabledSurfaces: enabledSurfaces ?? this.enabledSurfaces,
      enabledPanels: enabledPanels ?? this.enabledPanels,
      enabledTools: enabledTools ?? this.enabledTools,
      importers: importers ?? this.importers,
      exporters: exporters ?? this.exporters,
      compute: compute ?? this.compute,
      layout: layout ?? this.layout,
      keybinds: keybinds ?? this.keybinds,
      providers: providers ?? this.providers,
      requiredModules: requiredModules ?? this.requiredModules,
      starterKit: starterKit ?? this.starterKit,
    );
  }
}
