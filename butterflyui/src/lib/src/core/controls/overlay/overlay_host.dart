import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';

Widget buildOverlayHostControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final baseLayer = props['base'] is Map
      ? coerceObjectMap(props['base'] as Map)
      : (rawChildren.isNotEmpty && rawChildren.first is Map
            ? coerceObjectMap(rawChildren.first as Map)
            : null);
  final overlays = <Map<String, Object?>>[];

  final rawOverlays = props['overlays'] ?? props['layers'];
  if (rawOverlays is List) {
    for (final item in rawOverlays) {
      if (item is Map) overlays.add(coerceObjectMap(item));
    }
  }

  for (var i = baseLayer == null ? 0 : 1; i < rawChildren.length; i += 1) {
    final item = rawChildren[i];
    if (item is Map) overlays.add(coerceObjectMap(item));
  }

  if (baseLayer == null && overlays.isEmpty) return const SizedBox.shrink();
  final clipBehavior = props['clip'] == true ? Clip.antiAlias : Clip.none;
  final requestedOverlayIds = _coerceOverlayIds(
    props['active_overlay'] ??
        props['active_id'] ??
        props['overlay_id'] ??
        props['value'],
  );
  final activeOverlayIndex = coerceOptionalInt(
    props['active_index'] ?? props['index'],
  );
  final showAllOverlays = props['show_all_overlays'] == true;
  final showDefaultOverlay = props['show_default_overlay'] == true;
  final maxVisibleOverlays =
      (coerceOptionalInt(props['max_visible_overlays']) ?? 1).clamp(1, 32);
  final transition = props['transition'] is Map
      ? coerceObjectMap(props['transition'] as Map)
      : const <String, Object?>{};
  final transitionType =
      (props['transition_type']?.toString() ??
              transition['type']?.toString() ??
              'fade')
          .toLowerCase()
          .replaceAll('-', '_')
          .trim();
  final transitionDurationMs =
      coerceOptionalInt(transition['duration_ms'] ?? props['transition_ms']) ??
      220;
  final transitionCurve = _curveFromName(
    (transition['curve']?.toString() ?? 'ease_out_cubic').toLowerCase().trim(),
  );

  final widgets = <Widget>[];
  if (baseLayer != null) {
    widgets.add(Positioned.fill(child: buildChild(baseLayer)));
  }

  final visible = <Map<String, Object?>>[];
  for (final overlay in overlays) {
    if (_isVisibleLayer(overlay)) {
      visible.add(overlay);
    }
  }
  final visibleLayers = _dedupeLayers(visible);

  List<Map<String, Object?>> selectedLayers;
  if (showAllOverlays) {
    selectedLayers = _tailLayers(visibleLayers, maxVisibleOverlays);
  } else if (requestedOverlayIds.isNotEmpty) {
    selectedLayers = visibleLayers.where((overlay) {
      final layerIds = _layerIds(overlay);
      if (layerIds.isEmpty) return false;
      for (final id in layerIds) {
        if (requestedOverlayIds.contains(id)) {
          return true;
        }
      }
      return false;
    }).toList();
    if (selectedLayers.length > maxVisibleOverlays) {
      selectedLayers = _tailLayers(selectedLayers, maxVisibleOverlays);
    }
    // Fallback when active id is stale/missing to avoid "no overlay shown".
    if (selectedLayers.isEmpty) {
      selectedLayers = _tailLayers(visibleLayers, maxVisibleOverlays);
    }
  } else if (activeOverlayIndex != null &&
      activeOverlayIndex >= 0 &&
      activeOverlayIndex < visibleLayers.length) {
    selectedLayers = [visibleLayers[activeOverlayIndex]];
  } else if (visibleLayers.isEmpty) {
    selectedLayers = const <Map<String, Object?>>[];
  } else if (showDefaultOverlay) {
    // Default to top-most visible overlay when no active layer was specified.
    selectedLayers = _tailLayers(visibleLayers, maxVisibleOverlays);
  } else {
    selectedLayers = const <Map<String, Object?>>[];
  }

  final overlayLayers = <Widget>[];
  for (final overlay in selectedLayers) {
    Widget layer = buildChild(overlay);
    if (_isPassthroughLayer(overlay)) {
      layer = IgnorePointer(child: layer);
    }
    overlayLayers.add(Positioned.fill(child: layer));
  }
  if (overlayLayers.isNotEmpty) {
    final key = _selectionKey(selectedLayers);
    final overlayStack = Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: overlayLayers,
    );
    final useTransition = transitionType != 'none' && transitionType != 'off';
    if (useTransition) {
      widgets.add(
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: Duration(
              milliseconds: transitionDurationMs.clamp(0, 4000),
            ),
            switchInCurve: transitionCurve,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (animatedChild, animation) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: transitionCurve,
              );
              switch (transitionType) {
                case 'slide':
                case 'glass_sheet':
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(curved),
                    child: FadeTransition(
                      opacity: curved,
                      child: animatedChild,
                    ),
                  );
                case 'scale':
                case 'zoom':
                case 'pop':
                  return ScaleTransition(
                    scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
                    child: FadeTransition(
                      opacity: curved,
                      child: animatedChild,
                    ),
                  );
                case 'fade':
                default:
                  return FadeTransition(opacity: curved, child: animatedChild);
              }
            },
            child: KeyedSubtree(
              key: ValueKey<String>(key),
              child: overlayStack,
            ),
          ),
        ),
      );
    } else {
      widgets.add(Positioned.fill(child: overlayStack));
    }
  }

  return Stack(
    clipBehavior: clipBehavior,
    fit: StackFit.expand,
    children: widgets,
  );
}

String _layerId(Map<String, Object?> layer) {
  final ids = _layerIds(layer);
  if (ids.isEmpty) return '';
  return ids.first;
}

Set<String> _layerIds(Map<String, Object?> layer) {
  final props = layer['props'] is Map
      ? coerceObjectMap(layer['props'] as Map)
      : const <String, Object?>{};
  final ids = <String>{};
  final propOverlay = props['overlay_id']?.toString();
  if (propOverlay != null && propOverlay.isNotEmpty) ids.add(propOverlay);
  final propId = props['id']?.toString();
  if (propId != null && propId.isNotEmpty) ids.add(propId);
  final layerOverlay = layer['overlay_id']?.toString();
  if (layerOverlay != null && layerOverlay.isNotEmpty) ids.add(layerOverlay);
  final layerId = layer['id']?.toString();
  if (layerId != null && layerId.isNotEmpty) ids.add(layerId);
  return ids;
}

bool _isVisibleLayer(Map<String, Object?> layer) {
  final props = layer['props'] is Map
      ? coerceObjectMap(layer['props'] as Map)
      : const <String, Object?>{};
  if (layer['visible'] == false || props['visible'] == false) {
    return false;
  }
  if (layer['open'] == false || props['open'] == false) {
    return false;
  }
  return true;
}

bool _isPassthroughLayer(Map<String, Object?> layer) {
  final props = layer['props'] is Map
      ? coerceObjectMap(layer['props'] as Map)
      : const <String, Object?>{};
  return layer['passthrough'] == true ||
      layer['ignore_pointer'] == true ||
      props['passthrough'] == true ||
      props['ignore_pointer'] == true;
}

Set<String> _coerceOverlayIds(Object? value) {
  final out = <String>{};
  if (value == null) return out;
  if (value is List) {
    for (final item in value) {
      final s = item?.toString().trim() ?? '';
      if (s.isNotEmpty) {
        out.add(s);
      }
    }
    return out;
  }
  final raw = value.toString().trim();
  if (raw.isEmpty) return out;
  if (raw.contains(',')) {
    for (final part in raw.split(',')) {
      final s = part.trim();
      if (s.isNotEmpty) {
        out.add(s);
      }
    }
    return out;
  }
  out.add(raw);
  return out;
}

List<Map<String, Object?>> _tailLayers(
  List<Map<String, Object?>> layers,
  int maxVisibleOverlays,
) {
  if (layers.isEmpty) return const <Map<String, Object?>>[];
  if (layers.length <= maxVisibleOverlays) return layers;
  final from = (layers.length - maxVisibleOverlays).clamp(0, layers.length);
  return layers.sublist(from, layers.length);
}

List<Map<String, Object?>> _dedupeLayers(List<Map<String, Object?>> layers) {
  if (layers.length <= 1) return layers;
  final out = <Map<String, Object?>>[];
  final seen = <String>{};
  for (final layer in layers) {
    final key = _layerId(layer);
    if (key.isNotEmpty) {
      if (seen.contains(key)) {
        continue;
      }
      seen.add(key);
    }
    out.add(layer);
  }
  return out;
}

String _selectionKey(List<Map<String, Object?>> layers) {
  if (layers.isEmpty) return 'overlay:none';
  final ids = <String>[];
  for (final layer in layers) {
    final id = _layerId(layer);
    if (id.isNotEmpty) {
      ids.add(id);
    }
  }
  if (ids.isEmpty) {
    return 'overlay:${layers.length}:${layers.hashCode}';
  }
  return 'overlay:${ids.join('|')}';
}

Curve _curveFromName(String name) {
  switch (name) {
    case 'linear':
      return Curves.linear;
    case 'easein':
    case 'ease_in':
      return Curves.easeIn;
    case 'easeout':
    case 'ease_out':
      return Curves.easeOut;
    case 'easeinout':
    case 'ease_in_out':
      return Curves.easeInOut;
    case 'fastoutslowin':
    case 'fast_out_slow_in':
      return Curves.fastOutSlowIn;
    case 'easeoutcubic':
    case 'ease_out_cubic':
    default:
      return Curves.easeOutCubic;
  }
}
