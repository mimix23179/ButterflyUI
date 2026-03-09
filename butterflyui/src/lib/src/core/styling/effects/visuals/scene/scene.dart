import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/layer.dart';

class EffectScene {
  final List<EffectLayer> backgroundLayers;
  final List<EffectLayer> overlayLayers;

  const EffectScene({
    this.backgroundLayers = const <EffectLayer>[],
    this.overlayLayers = const <EffectLayer>[],
  });

  factory EffectScene.fromLayers(Iterable<EffectLayer> layers) {
    final backgrounds = <EffectLayer>[];
    final overlays = <EffectLayer>[];
    for (final layer in layers) {
      if (layer.position == EffectLayerPosition.overlay) {
        overlays.add(layer);
      } else {
        backgrounds.add(layer);
      }
    }
    return EffectScene(backgroundLayers: backgrounds, overlayLayers: overlays);
  }

  static const EffectScene empty = EffectScene();

  bool get isEmpty => backgroundLayers.isEmpty && overlayLayers.isEmpty;
}
