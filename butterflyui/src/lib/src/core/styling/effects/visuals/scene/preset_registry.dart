import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/layer.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/scene.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';

List<String> _coerceEffectStringList(Object? value) {
  if (value == null) return const <String>[];
  if (value is String) {
    return value.trim().isEmpty ? const <String>[] : <String>[value];
  }
  if (value is List) {
    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .toList();
  }
  return <String>[value.toString()];
}

void _addEffectPresetLayers(
  List<EffectLayer> layers,
  Set<String> signatures,
  String token,
) {
  void add(Object? value, {EffectLayerPosition? position}) {
    final layer = EffectLayer.fromValue(value, defaultPosition: position);
    if (layer == null) return;
    if (signatures.add(layer.signature)) {
      layers.add(layer);
    }
  }

  switch (normalizeEffectLayerToken(token)) {
    case 'galaxy':
      add(<String, Object?>{
        'type': 'nebula',
        'renderer': 'shader',
        'shader_asset': 'shaders/galaxy.frag',
        'density': 0.82,
        'speed': 0.22,
        'intensity': 0.95,
        'color': '#221047',
        'accent_color': '#5F8CFF',
        'opacity': 0.88,
      });
      add(<String, Object?>{
        'type': 'starfield',
        'density': 0.72,
        'speed': 0.18,
        'intensity': 0.85,
        'color': '#FFFFFF',
        'accent_color': '#8BE6FF',
        'opacity': 0.92,
      });
      break;
    case 'matrix':
    case 'matrix_rain':
    case 'cyber':
    case 'retro_terminal':
      add(<String, Object?>{
        'type': 'matrix_rain',
        'renderer': 'shader',
        'shader_asset': 'shaders/matrix_rain.frag',
        'density': 0.95,
        'speed': 0.85,
        'intensity': 0.9,
        'color': '#3DFFB0',
        'accent_color': '#D4FFE8',
        'opacity': 0.9,
      });
      break;
    case 'stars':
    case 'starfield':
      add(<String, Object?>{
        'type': 'starfield',
        'density': 0.78,
        'speed': 0.16,
        'intensity': 0.82,
        'color': '#FFFFFF',
        'accent_color': '#8BE6FF',
        'opacity': 0.9,
      });
      break;
    case 'nebula':
      add(<String, Object?>{
        'type': 'nebula',
        'density': 0.76,
        'speed': 0.2,
        'intensity': 0.88,
        'color': '#341867',
        'accent_color': '#4AC2FF',
        'opacity': 0.82,
      });
      break;
    case 'rain':
    case 'rainstorm':
      add(<String, Object?>{
        'type': 'rain',
        'renderer': 'shader',
        'shader_asset': 'shaders/rainstorm.frag',
        'density': 0.9,
        'speed': 1.05,
        'intensity': 0.7,
        'color': '#A7DBFF',
        'accent_color': '#D7F2FF',
        'opacity': 0.55,
      }, position: EffectLayerPosition.overlay);
      break;
    case 'water':
    case 'water_flow':
    case 'flowing_water':
    case 'liquid_dream':
      add(<String, Object?>{
        'type': 'liquid_glow',
        'renderer': 'shader',
        'shader_asset': 'shaders/liquid_glow.frag',
        'density': 0.7,
        'speed': 0.16,
        'intensity': 0.82,
        'color': '#0F4475',
        'accent_color': '#35D0FF',
        'opacity': 0.8,
      });
      break;
    default:
      break;
  }
}

EffectScene resolveEffectSceneFromProps(Map<String, Object?> props) {
  final layers = <EffectLayer>[];
  final signatures = <String>{};

  void addValue(Object? value, {EffectLayerPosition? position}) {
    if (value == null) return;
    if (value is List) {
      for (final item in value) {
        addValue(item, position: position);
      }
      return;
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      final nestedSceneLayers = map['scene_layers'];
      final nestedBackgroundLayers = map['background_layers'];
      final nestedOverlayLayers = map['overlay_layers'];
      if (nestedSceneLayers != null ||
          nestedBackgroundLayers != null ||
          nestedOverlayLayers != null) {
        addValue(nestedSceneLayers, position: position);
        addValue(
          nestedBackgroundLayers,
          position: EffectLayerPosition.background,
        );
        addValue(nestedOverlayLayers, position: EffectLayerPosition.overlay);
        return;
      }
    }
    final layer = EffectLayer.fromValue(value, defaultPosition: position);
    if (layer == null) return;
    if (signatures.add(layer.signature)) {
      layers.add(layer);
    }
  }

  addValue(props['scene']);
  addValue(props['scene_layers']);
  addValue(
    props['background_layers'],
    position: EffectLayerPosition.background,
  );
  addValue(props['overlay_layers'], position: EffectLayerPosition.overlay);

  final hasExplicitSceneLayers = layers.isNotEmpty;

  final assetLayer = <String, Object?>{};
  for (final key in const <String>[
    'lottie_asset',
    'lottie_url',
    'lottie_data',
    'lottie_json',
    'rive_asset',
    'rive_url',
    'rive_artboard',
    'rive_state_machine',
    'fit',
    'alignment',
    'opacity',
    'width',
    'height',
    'size',
    'position',
    'padding',
  ]) {
    final value = props[key];
    if (value != null) {
      assetLayer[key] = value;
    }
  }
  if (assetLayer.isNotEmpty) {
    addValue(assetLayer);
  }

  final mergePresetScene =
      props['merge_preset_scene'] == true || props['mergePresetScene'] == true;
  if (!hasExplicitSceneLayers || mergePresetScene) {
    final semanticTokens = <String>[
      if (props['preset'] != null) props['preset'].toString(),
      ..._coerceEffectStringList(props['ambient']),
      ..._coerceEffectStringList(props['reactive']),
      ..._coerceEffectStringList(props['decor']),
    ];
    for (final token in semanticTokens) {
      _addEffectPresetLayers(layers, signatures, token);
    }
  }

  return EffectScene.fromLayers(layers);
}
