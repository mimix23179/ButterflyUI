import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildMentionPillControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final label = (props['label'] ?? '').toString();
  final color = coerceColor(props['color']) ?? const Color(0xff2563eb);
  final textColor = coerceColor(props['text_color']) ?? Colors.white;
  final clickable = props['clickable'] == true;

  Widget pill = Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(label, style: TextStyle(color: textColor)),
  );

  if (clickable && controlId.isNotEmpty) {
    pill = InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => sendEvent(controlId, 'click', {'label': label}),
      child: pill,
    );
  }

  return pill;
}
