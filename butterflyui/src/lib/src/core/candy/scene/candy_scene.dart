import 'package:butterflyui_runtime/src/core/candy/scene/candy_layer.dart';

class CandyScene {
  final List<CandySceneLayer> backgroundLayers;
  final List<CandySceneLayer> overlayLayers;

  const CandyScene({
    this.backgroundLayers = const <CandySceneLayer>[],
    this.overlayLayers = const <CandySceneLayer>[],
  });

  factory CandyScene.fromLayers(Iterable<CandySceneLayer> layers) {
    final backgrounds = <CandySceneLayer>[];
    final overlays = <CandySceneLayer>[];
    for (final layer in layers) {
      if (layer.position == CandySceneLayerPosition.overlay) {
        overlays.add(layer);
      } else {
        backgrounds.add(layer);
      }
    }
    return CandyScene(backgroundLayers: backgrounds, overlayLayers: overlays);
  }

  static const CandyScene empty = CandyScene();

  bool get isEmpty => backgroundLayers.isEmpty && overlayLayers.isEmpty;
}
