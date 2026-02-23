import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildOwnershipMarkerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final dense = props['dense'] == true;
  final items = _coerceItems(props['items']);
  if (items.isEmpty) return const SizedBox.shrink();

  return Wrap(
    spacing: dense ? 4 : 8,
    runSpacing: dense ? 4 : 8,
    children: items
        .map(
          (item) {
            final id = (item['id'] ?? item['owner_id'] ?? '').toString();
            final label = (item['label'] ?? item['owner'] ?? item['name'] ?? id).toString();
            final color = coerceColor(item['color']) ?? const Color(0xff475569);
            return ActionChip(
              label: Text(label),
              backgroundColor: color.withOpacity(0.15),
              onPressed: controlId.isEmpty
                  ? null
                  : () {
                      sendEvent(controlId, 'select', {
                        'id': id,
                        'label': label,
                        'item': item,
                      });
                    },
            );
          },
        )
        .toList(growable: false),
  );
}

List<Map<String, Object?>> _coerceItems(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  final out = <Map<String, Object?>>[];
  for (final item in raw) {
    if (item is Map) out.add(coerceObjectMap(item));
  }
  return out;
}
