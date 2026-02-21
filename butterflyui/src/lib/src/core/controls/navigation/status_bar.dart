import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/controls/common/icon_value.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildStatusBarControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  return Builder(
    builder: (context) {
      final items = <Map<String, Object?>>[];
      final rawItems = props['items'];
      if (rawItems is List) {
        for (final item in rawItems) {
          if (item is Map) {
            items.add(coerceObjectMap(item));
          } else if (item != null) {
            final text = item.toString();
            items.add({'id': text, 'label': text});
          }
        }
      }
      if (items.isEmpty && props['text'] != null) {
        final text = props['text']!.toString();
        items.add({'id': text, 'label': text});
      }

      final dense = props['dense'] == true;
      final padding =
          coercePadding(props['padding']) ??
          EdgeInsets.symmetric(
            horizontal: dense ? 8 : 12,
            vertical: dense ? 4 : 6,
          );
      final bgcolor =
          coerceColor(props['bgcolor'] ?? props['background']) ??
          Theme.of(context).colorScheme.surface;
      final borderColor =
          coerceColor(props['border_color']) ??
          Theme.of(context).colorScheme.outlineVariant;

      Widget itemToWidget(Map<String, Object?> item, int index) {
        final label =
            (item['label'] ??
                    item['text'] ??
                    item['title'] ??
                    item['id'] ??
                    'Item')
                .toString();
        final icon = buildIconValue(item['icon'], size: 14);
        final value = item['value']?.toString();
        final status = item['status']?.toString();
        final statusDot = status == null
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _statusColor(context, status),
                  shape: BoxShape.circle,
                ),
              );

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: controlId.isEmpty
              ? null
              : () {
                  sendEvent(controlId, 'select', {
                    'id': item['id']?.toString() ?? label,
                    'label': label,
                    'index': index,
                    'item': item,
                  });
                },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dense ? 4 : 6,
              vertical: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (statusDot != null) ...[statusDot, const SizedBox(width: 6)],
                if (icon != null) ...[icon, const SizedBox(width: 4)],
                Text(label),
                if (value != null && value.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(value, style: Theme.of(context).textTheme.labelSmall),
                ],
              ],
            ),
          ),
        );
      }

      final left = <Widget>[];
      final right = <Widget>[];
      for (var i = 0; i < items.length; i += 1) {
        final item = items[i];
        final align = item['align']?.toString().toLowerCase();
        if (align == 'right' || align == 'end') {
          right.add(itemToWidget(item, i));
        } else {
          left.add(itemToWidget(item, i));
        }
      }

      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: bgcolor,
          border: Border(top: BorderSide(color: borderColor.withOpacity(0.6))),
        ),
        child: Row(
          children: [
            Expanded(child: Wrap(spacing: 4, runSpacing: 2, children: left)),
            if (right.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 2,
                alignment: WrapAlignment.end,
                children: right,
              ),
          ],
        ),
      );
    },
  );
}

Color _statusColor(BuildContext context, String status) {
  switch (status.toLowerCase()) {
    case 'ok':
    case 'success':
      return Colors.green;
    case 'warn':
    case 'warning':
      return Colors.orange;
    case 'error':
    case 'danger':
      return Theme.of(context).colorScheme.error;
    case 'info':
      return Theme.of(context).colorScheme.primary;
    default:
      return Theme.of(context).colorScheme.secondary;
  }
}
