import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildNoticeBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final text = (props['text'] ?? '').toString();
  final variant = (props['variant'] ?? 'info').toString().toLowerCase();
  final dismissible = props['dismissible'] == true;
  final actionLabel = props['action_label']?.toString();
  final actionId = props['action_id']?.toString() ?? 'action';

  final bg = switch (variant) {
    'success' => const Color(0xff14532d),
    'warning' => const Color(0xff78350f),
    'error' => const Color(0xff7f1d1d),
    _ => const Color(0xff1e3a8a),
  };

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
        if (actionLabel != null && actionLabel.isNotEmpty)
          TextButton(
            onPressed: controlId.isEmpty
                ? null
                : () => sendEvent(controlId, 'action', {
                    'action_id': actionId,
                    'action_label': actionLabel,
                  }),
            child: Text(actionLabel),
          ),
        if (dismissible)
          IconButton(
            onPressed: controlId.isEmpty
                ? null
                : () => sendEvent(controlId, 'dismiss', {}),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
      ],
    ),
  );
}
