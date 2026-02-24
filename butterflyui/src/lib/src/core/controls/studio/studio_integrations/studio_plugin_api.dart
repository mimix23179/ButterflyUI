import '../studio_contract.dart';

abstract class StudioPluginHost {
  Map<String, Object?> registerModule({
    required String role,
    required String moduleId,
    Map<String, Object?> definition,
    bool recordHistory,
  });
}

abstract class StudioPluginModule {
  String get id;
  String get version;
  List<String> get dependsOn;
  void register(StudioPluginHost host);
}

Map<String, Object?> buildPluginDescriptor(StudioPluginModule plugin) {
  return <String, Object?>{
    'id': studioNorm(plugin.id),
    'version': plugin.version,
    'depends_on': plugin.dependsOn.map(studioNorm).toList(growable: false),
  };
}
