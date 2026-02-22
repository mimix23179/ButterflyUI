import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _WorkspaceNode {
  final String id;
  final String label;
  final bool isDir;
  final List<_WorkspaceNode> children;

  const _WorkspaceNode({
    required this.id,
    required this.label,
    required this.isDir,
    required this.children,
  });
}

_WorkspaceNode _parseNode(Object? raw, int index) {
  if (raw is! Map) {
    final text = raw?.toString() ?? 'item_$index';
    return _WorkspaceNode(id: text, label: text, isDir: false, children: const []);
  }
  final map = coerceObjectMap(raw);
  final childrenRaw = map['children'];
  final children = <_WorkspaceNode>[];
  if (childrenRaw is List) {
    for (var i = 0; i < childrenRaw.length; i += 1) {
      children.add(_parseNode(childrenRaw[i], i));
    }
  }
  final id = (map['id'] ?? map['path'] ?? map['label'] ?? 'node_$index').toString();
  return _WorkspaceNode(
    id: id,
    label: (map['label'] ?? map['name'] ?? id).toString(),
    isDir: map['is_dir'] == true || children.isNotEmpty,
    children: children,
  );
}

Widget _buildNode(
  String controlId,
  _WorkspaceNode node,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  if (!node.isDir) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.description_outlined, size: 18),
      title: Text(node.label, overflow: TextOverflow.ellipsis),
      onTap: () {
        sendEvent(controlId, 'open', {'id': node.id, 'label': node.label});
      },
    );
  }

  return ExpansionTile(
    dense: true,
    leading: const Icon(Icons.folder_outlined, size: 18),
    title: Text(node.label, overflow: TextOverflow.ellipsis),
    children: node.children
        .map((child) => _buildNode(controlId, child, sendEvent))
        .toList(growable: false),
  );
}

Widget buildWorkspaceTreeControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final nodes = <_WorkspaceNode>[];
  final raw = props['nodes'] ?? props['items'] ?? props['roots'];
  if (raw is List) {
    for (var i = 0; i < raw.length; i += 1) {
      nodes.add(_parseNode(raw[i], i));
    }
  }

  if (nodes.isEmpty) {
    return const Center(child: Text('No workspace nodes'));
  }

  return ListView(
    children: nodes
        .map((node) => _buildNode(controlId, node, sendEvent))
        .toList(growable: false),
  );
}
