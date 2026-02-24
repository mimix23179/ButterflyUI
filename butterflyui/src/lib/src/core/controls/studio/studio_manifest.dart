import 'studio_contract.dart';

class StudioManifest {
  StudioManifest({
    required this.enabledSurfaces,
    required this.enabledPanels,
    required this.enabledTools,
    required this.importers,
    required this.exporters,
    required this.compute,
    this.starterKit,
  });

  final List<String> enabledSurfaces;
  final List<String> enabledPanels;
  final List<String> enabledTools;
  final List<String> importers;
  final List<String> exporters;
  final List<String> compute;
  final String? starterKit;

  factory StudioManifest.fromProps(Map<String, Object?> props) {
    final manifest = studioBuildManifest(props);
    String? starter = manifest['starter_kit']?.toString().trim();
    if (starter != null && starter.isEmpty) {
      starter = null;
    }
    return StudioManifest(
      enabledSurfaces: studioCoerceStringList(manifest['enabled_surfaces']),
      enabledPanels: studioCoerceStringList(manifest['enabled_panels']),
      enabledTools: studioCoerceStringList(manifest['enabled_tools']),
      importers: studioCoerceStringList(manifest['importers']),
      exporters: studioCoerceStringList(manifest['exporters']),
      compute: studioCoerceStringList(manifest['compute']),
      starterKit: starter,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'enabled_surfaces': enabledSurfaces,
      'enabled_panels': enabledPanels,
      'enabled_tools': enabledTools,
      'importers': importers,
      'exporters': exporters,
      'compute': compute,
      if (starterKit != null && starterKit!.isNotEmpty)
        'starter_kit': starterKit,
    };
  }

  StudioManifest copyWith({
    List<String>? enabledSurfaces,
    List<String>? enabledPanels,
    List<String>? enabledTools,
    List<String>? importers,
    List<String>? exporters,
    List<String>? compute,
    String? starterKit,
  }) {
    return StudioManifest(
      enabledSurfaces: enabledSurfaces ?? this.enabledSurfaces,
      enabledPanels: enabledPanels ?? this.enabledPanels,
      enabledTools: enabledTools ?? this.enabledTools,
      importers: importers ?? this.importers,
      exporters: exporters ?? this.exporters,
      compute: compute ?? this.compute,
      starterKit: starterKit ?? this.starterKit,
    );
  }
}
