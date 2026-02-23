import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildQueueListControl(
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

  final dense = props['dense'] == true;
  final showProgress = props['show_progress'] == true;
  final maxItems = (coerceOptionalInt(props['max_items']) ?? items.length).clamp(0, items.length);

  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: maxItems,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (context, index) {
      final item = items[index];
      final id = (item['id'] ?? item['key'] ?? index).toString();
      final title = (item['title'] ?? item['label'] ?? item['name'] ?? id).toString();
      final subtitle = item['subtitle']?.toString() ?? item['description']?.toString();
      final progress = coerceDouble(item['progress'] ?? item['value']);
      final enabled = item['enabled'] == null ? true : (item['enabled'] == true);

      return ListTile(
        dense: dense,
        enabled: enabled,
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subtitle != null && subtitle.isNotEmpty) Text(subtitle),
            if (showProgress && progress != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
              ),
          ],
        ),
        onTap: !enabled || controlId.isEmpty
            ? null
            : () {
                sendEvent(controlId, 'select', {
                  'id': id,
                  'index': index,
                  'item': item,
                });
              },
      );
    },
  );
}
