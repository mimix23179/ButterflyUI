import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/layer.dart';

class EffectScene {
  final List<EffectLayer> backgroundLayers;
  final List<EffectLayer> foregroundLayers;
  final List<EffectLayer> overlayLayers;

  const EffectScene({
    this.backgroundLayers = const <EffectLayer>[],
    this.foregroundLayers = const <EffectLayer>[],
    this.overlayLayers = const <EffectLayer>[],
  });

  factory EffectScene.fromLayers(Iterable<EffectLayer> layers) {
    final backgrounds = <EffectLayer>[];
    final foregrounds = <EffectLayer>[];
    final overlays = <EffectLayer>[];
    for (final layer in layers) {
      switch (layer.position) {
        case EffectLayerPosition.foreground:
          foregrounds.add(layer);
          break;
        case EffectLayerPosition.overlay:
          overlays.add(layer);
          break;
        case EffectLayerPosition.background:
          backgrounds.add(layer);
          break;
      }
    }
    return EffectScene(
      backgroundLayers: backgrounds,
      foregroundLayers: foregrounds,
      overlayLayers: overlays,
    );
  }

  static const EffectScene empty = EffectScene();

  bool get isEmpty =>
      backgroundLayers.isEmpty &&
      foregroundLayers.isEmpty &&
      overlayLayers.isEmpty;
}
