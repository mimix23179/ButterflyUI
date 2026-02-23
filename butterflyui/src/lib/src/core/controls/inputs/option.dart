import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildOptionControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final label = (props['label'] ?? props['value'] ?? '').toString();
  final description = props['description']?.toString();
  final iconData = _parseIconData(props['icon']);
  final selected = props['selected'] == true;
  final enabled = props['enabled'] == null || props['enabled'] == true;
  final dense = props['dense'] == true;

  void emit(String event) {
    if (controlId.isEmpty) return;
    sendEvent(controlId, event, {
      'label': label,
      'value': props['value'] ?? label,
      'selected': selected,
    });
  }

  return Card(
    margin: EdgeInsets.zero,
    child: ListTile(
      dense: dense,
      enabled: enabled,
      selected: selected,
      leading: iconData == null ? null : Icon(iconData),
      title: Text(label),
      subtitle: description == null || description.isEmpty ? null : Text(description),
      trailing: selected ? const Icon(Icons.check, size: 18) : null,
      onTap: enabled
          ? () {
              emit('select');
            }
          : null,
      onLongPress: enabled ? () => emit('long_press') : null,
    ),
  );
}

IconData? _parseIconData(Object? value) {
  final key = value?.toString().trim().toLowerCase();
  if (key == null || key.isEmpty) return null;
  switch (key) {
    case 'folder':
    case 'folder_open':
      return Icons.folder_outlined;
    case 'file':
    case 'description':
      return Icons.description_outlined;
    case 'person':
    case 'user':
      return Icons.person_outline;
    case 'star':
      return Icons.star_border;
    case 'check':
      return Icons.check;
    default:
      return null;
  }
}
