import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPersonaControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final name = (props['name'] ?? '').toString();
  final subtitle = props['subtitle']?.toString();
  final status = props['status']?.toString();
  final initials = (props['initials'] ?? _initialsFromName(name)).toString();
  final dense = props['dense'] == true;
  final avatarColor = coerceColor(props['avatar_color']) ?? const Color(0xff334155);

  return ListTile(
    dense: dense,
    contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 8) : null,
    leading: CircleAvatar(
      backgroundColor: avatarColor,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    ),
    title: Text(name.isEmpty ? 'Persona' : name),
    subtitle: subtitle == null || subtitle.isEmpty
        ? (status == null || status.isEmpty ? null : Text(status))
        : Text(
            status == null || status.isEmpty ? subtitle : '$subtitle • $status',
          ),
    onTap: controlId.isEmpty
        ? null
        : () {
            sendEvent(controlId, 'click', {
              'name': name,
              'subtitle': subtitle,
              'status': status,
            });
          },
  );
}

String _initialsFromName(String name) {
  final parts = name
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) return '';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
}
