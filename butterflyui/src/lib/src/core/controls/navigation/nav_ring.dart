import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildNavRingControl(
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

  final selectedId = props['selected_id']?.toString();
  final dense = props['dense'] == true;

  return Wrap(
    spacing: dense ? 4 : 8,
    runSpacing: dense ? 4 : 8,
    children: [
      for (var i = 0; i < items.length; i += 1)
        ChoiceChip(
          label: Text((items[i]['label'] ?? items[i]['id'] ?? '$i').toString()),
          selected: selectedId != null && selectedId == (items[i]['id']?.toString()),
          onSelected: controlId.isEmpty
              ? null
              : (_) {
                  sendEvent(controlId, 'select', {
                    'id': items[i]['id']?.toString() ?? '$i',
                    'index': i,
                    'item': items[i],
                  });
                },
        ),
    ],
  );
}
