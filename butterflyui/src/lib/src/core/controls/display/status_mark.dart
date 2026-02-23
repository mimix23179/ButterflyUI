import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildStatusMarkControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final label = (props['label'] ?? props['text'] ?? '').toString();
  final value = props['value']?.toString();
  final dense = props['dense'] == true;
  final status = (props['status'] ?? '').toString().toLowerCase();
  final color = coerceColor(props['color']) ?? _statusColor(status);
  final icon = buildIconValue(props['icon'], size: dense ? 12 : 14);

  return InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: controlId.isEmpty
        ? null
        : () {
            sendEvent(controlId, 'select', {
              'label': label,
              'value': value,
              'status': status,
            });
          },
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 6 : 8,
        vertical: dense ? 3 : 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dense ? 7 : 8,
            height: dense ? 7 : 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          if (icon != null) ...[
            const SizedBox(width: 6),
            icon,
          ],
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(label),
          ],
          if (value != null && value.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    ),
  );
}

Color _statusColor(String status) {
  switch (status) {
    case 'ok':
    case 'success':
      return Colors.green;
    case 'warn':
    case 'warning':
      return Colors.orange;
    case 'error':
    case 'danger':
      return Colors.redAccent;
    case 'info':
      return Colors.lightBlueAccent;
    default:
      return Colors.grey;
  }
}
