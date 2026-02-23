import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildOutlineControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final nodes = _coerceNodeList(props['nodes']);
  final dense = props['dense'] == true;
  final showIcons = props['show_icons'] != false;
  final selectedId = props['selected_id']?.toString();

  if (nodes.isEmpty) return const SizedBox.shrink();

  return ListView(
    shrinkWrap: true,
    children: nodes
        .map(
          (node) => _buildNode(
            node,
            dense: dense,
            showIcons: showIcons,
            selectedId: selectedId,
            onSelect: (id, label) {
              if (controlId.isEmpty) return;
              sendEvent(controlId, 'select', {
                'selected_id': id,
                'id': id,
                'label': label,
              });
            },
          ),
        )
        .toList(growable: false),
  );
}

Widget _buildNode(
  Map<String, Object?> node, {
  required bool dense,
  required bool showIcons,
  required String? selectedId,
  required void Function(String id, String label) onSelect,
}) {
  final id = (node['id'] ?? node['key'] ?? node['label'] ?? '').toString();
  final label = (node['label'] ?? node['title'] ?? id).toString();
  final icon = showIcons ? _parseNodeIcon(node['icon']) : null;
  final children = _coerceNodeList(node['children']);
  final selected = selectedId != null && selectedId == id;

  if (children.isEmpty) {
    return ListTile(
      dense: dense,
      selected: selected,
      leading: icon == null ? null : Icon(icon, size: dense ? 16 : 18),
      title: Text(label),
      onTap: () => onSelect(id, label),
    );
  }

  return ExpansionTile(
    tilePadding: dense ? const EdgeInsets.symmetric(horizontal: 8) : null,
    leading: icon == null ? null : Icon(icon, size: dense ? 16 : 18),
    title: Text(label),
    children: children
        .map(
          (child) => Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _buildNode(
              child,
              dense: dense,
              showIcons: showIcons,
              selectedId: selectedId,
              onSelect: onSelect,
            ),
          ),
        )
        .toList(growable: false),
  );
}

IconData? _parseNodeIcon(Object? raw) {
  final key = raw?.toString().toLowerCase();
  switch (key) {
    case 'class':
      return Icons.data_object;
    case 'method':
      return Icons.functions;
    case 'field':
      return Icons.tune;
    case 'folder':
      return Icons.folder_outlined;
    case 'file':
      return Icons.description_outlined;
    default:
      return null;
  }
}

List<Map<String, Object?>> _coerceNodeList(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  final out = <Map<String, Object?>>[];
  for (final item in raw) {
    if (item is Map) out.add(coerceObjectMap(item));
  }
  return out;
}
