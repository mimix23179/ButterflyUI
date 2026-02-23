import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildMessageDividerControl(Map<String, Object?> props) {
  final label = (props['label'] ?? '').toString();
  final color = coerceColor(props['color']) ?? Colors.white24;
  final textColor = coerceColor(props['text_color']) ?? Colors.white70;
  final padding = coercePadding(props['padding']) ?? const EdgeInsets.symmetric(vertical: 8);

  return Padding(
    padding: padding,
    child: Row(
      children: [
        Expanded(child: Divider(color: color, height: 1)),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: textColor, fontSize: 12)),
          const SizedBox(width: 8),
        ],
        Expanded(child: Divider(color: color, height: 1)),
      ],
    ),
  );
}
