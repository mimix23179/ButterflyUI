import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDropZoneControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final enabled = props['enabled'] == null || props['enabled'] == true;
  final accepts = _coerceStringSet(props['accepts'] ?? props['accept_types']);
  final title = (props['title'] ?? 'Drop Here').toString();
  final subtitle = props['subtitle']?.toString();

  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  return DragTarget<Map<String, Object?>>(
    onWillAcceptWithDetails: enabled
        ? (details) {
            final payload = details.data;
            final dragType = payload['drag_type']?.toString();
            final accepted = accepts.isEmpty || (dragType != null && accepts.contains(dragType));
            _emit(sendEvent, controlId, accepted ? 'enter' : 'reject', {
              'accepted': accepted,
              'payload': payload,
            });
            return accepted;
          }
        : (_) => false,
    onAcceptWithDetails: (details) {
      _emit(sendEvent, controlId, 'drop', {'payload': details.data});
    },
    onLeave: (data) {
      _emit(sendEvent, controlId, 'leave', {'payload': data ?? const <String, Object?>{}});
    },
    builder: (context, candidateData, rejectedData) {
      final hovering = candidateData.isNotEmpty;
      final blocked = rejectedData.isNotEmpty;
      final borderColor = blocked
          ? Colors.redAccent
          : (hovering ? Colors.greenAccent : Colors.white24);
      final bg = blocked
          ? const Color(0x40ef4444)
          : (hovering ? const Color(0x4022c55e) : const Color(0x221e293b));

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child is SizedBox
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.72))),
                    ),
                ],
              )
            : child,
      );
    },
  );
}

Set<String> _coerceStringSet(Object? value) {
  if (value is! List) return <String>{};
  return value
      .map((entry) => entry?.toString() ?? '')
      .where((entry) => entry.isNotEmpty)
      .toSet();
}

void _emit(
  ButterflyUISendRuntimeEvent sendEvent,
  String controlId,
  String event,
  Map<String, Object?> payload,
) {
  if (controlId.isEmpty) return;
  sendEvent(controlId, event, payload);
}
