import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRailNavControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final rawItems = props['items'];
  final items = <Map<String, Object?>>[];
  if (rawItems is List) {
    for (final item in rawItems) {
      if (item is Map) {
        items.add(coerceObjectMap(item));
      }
    }
  }

  if (items.isEmpty) return const SizedBox.shrink();

  final selectedId = props['selected_id']?.toString();
  var selectedIndex = 0;
  if (selectedId != null && selectedId.isNotEmpty) {
    final idx = items.indexWhere((e) => e['id']?.toString() == selectedId);
    if (idx >= 0) selectedIndex = idx;
  }

  return NavigationRail(
    extended: props['extended'] == true,
    labelType: props['extended'] == true ? null : NavigationRailLabelType.selected,
    selectedIndex: selectedIndex,
    onDestinationSelected: controlId.isEmpty
        ? null
        : (index) {
            final item = items[index];
            sendEvent(controlId, 'select', {
              'id': (item['id'] ?? index).toString(),
              'index': index,
              'item': item,
            });
          },
    destinations: items
        .map(
          (item) => NavigationRailDestination(
            icon: const Icon(Icons.circle_outlined, size: 18),
            selectedIcon: const Icon(Icons.circle, size: 18),
            label: Text((item['label'] ?? item['title'] ?? item['id'] ?? '').toString()),
          ),
        )
        .toList(growable: false),
  );
}
