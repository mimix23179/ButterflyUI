import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildLayerListControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final merged = <Map<String, Object?>>[];

  final rawLayers = props['layers'];
  if (rawLayers is List) {
    for (final entry in rawLayers) {
      if (entry is Map) {
        merged.add(coerceObjectMap(entry));
      }
    }
  }

  for (final raw in rawChildren) {
    if (raw is Map) {
      merged.add(coerceObjectMap(raw));
    }
  }

  final active = (props['active_layer'] ?? props['active_id'])?.toString();
  final mode = (props['mode'] ?? '').toString().toLowerCase();

  final visible = <Widget>[];
  for (final layer in merged) {
    final layerProps = layer['props'] is Map
        ? coerceObjectMap(layer['props'] as Map)
        : const <String, Object?>{};
    if (layer['visible'] == false || layerProps['visible'] == false) {
      continue;
    }
    final id = (layer['id'] ?? layerProps['id'])?.toString();
    if (mode == 'active' && active != null && active.isNotEmpty && id != active) {
      continue;
    }
    visible.add(Positioned.fill(child: buildChild(layer)));
  }

  if (visible.isEmpty) return const SizedBox.shrink();
  return Stack(fit: StackFit.expand, children: visible);
}
