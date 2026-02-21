import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/controls/common/icon_value.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildBreadcrumbsControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  return Builder(
    builder: (context) {
      final rawItems = props['items'] ?? props['crumbs'] ?? props['routes'];
      final items = <Map<String, Object?>>[];
      if (rawItems is List) {
        for (var i = 0; i < rawItems.length; i += 1) {
          final raw = rawItems[i];
          if (raw is Map) {
            items.add(coerceObjectMap(raw));
          } else if (raw != null) {
            final label = raw.toString();
            items.add({'id': label, 'label': label});
          }
        }
      }
      if (items.isEmpty && props['path'] != null) {
        final path = props['path'].toString();
        for (final segment in path.split('/')) {
          if (segment.trim().isEmpty) continue;
          items.add({'id': segment, 'label': segment});
        }
      }

      if (items.isEmpty) {
        return const SizedBox.shrink();
      }

      final separator = props['separator']?.toString() ?? '/';
      final dense = props['dense'] == true;
      final maxItems = (coerceOptionalInt(props['max_items']) ?? 0).clamp(
        0,
        99,
      );

      final display = <Map<String, Object?>>[];
      if (maxItems > 0 && items.length > maxItems && maxItems >= 2) {
        display.add(items.first);
        display.add({'id': '__ellipsis__', 'label': '...'});
        display.addAll(items.sublist(items.length - (maxItems - 1)));
      } else {
        display.addAll(items);
      }

      final children = <Widget>[];
      for (var i = 0; i < display.length; i += 1) {
        final item = display[i];
        final isLast = i == display.length - 1;
        final isEllipsis = item['id']?.toString() == '__ellipsis__';
        final label =
            item['label']?.toString() ?? item['id']?.toString() ?? 'item';

        Widget crumb;
        if (isEllipsis) {
          crumb = Text(label, style: Theme.of(context).textTheme.bodySmall);
        } else {
          final icon = buildIconValue(item['icon'], size: 14);
          crumb = InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: controlId.isEmpty
                ? null
                : () {
                    sendEvent(controlId, 'select', {
                      'id': item['id']?.toString() ?? label,
                      'label': label,
                      'index': i,
                      'is_last': isLast,
                      'item': item,
                    });
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dense ? 4 : 6,
                vertical: dense ? 2 : 4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon, const SizedBox(width: 4)],
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isLast
                        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }

        children.add(crumb);

        if (!isLast) {
          children.add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: dense ? 2 : 4),
              child: Text(
                separator,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          );
        }
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: children),
      );
    },
  );
}
