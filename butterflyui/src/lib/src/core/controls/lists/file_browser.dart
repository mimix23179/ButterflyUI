import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildFileBrowserControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  return ConduitFileBrowser(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
  );
}

class ConduitFileBrowser extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitFileBrowser({
    super.key,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  @override
  State<ConduitFileBrowser> createState() => _ConduitFileBrowserState();
}

class _ConduitFileBrowserState extends State<ConduitFileBrowser> {
  final Set<String> _expanded = <String>{};
  final Set<String> _selected = <String>{};

  @override
  void initState() {
    super.initState();
    _syncFromProps();
  }

  @override
  void didUpdateWidget(covariant ConduitFileBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props != widget.props) {
      _syncFromProps();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nodes = _parseNodes(widget.props['nodes']);
    if (nodes.isEmpty) return const SizedBox.shrink();

    final dense = widget.props['dense'] == true;
    final showRoot = widget.props['show_root'] == null
        ? true
        : (widget.props['show_root'] == true);

    final list = <Widget>[];
    for (final node in nodes) {
      if (showRoot) {
        list.add(_buildNode(node, depth: 0, dense: dense));
      } else {
        for (final child in node.children) {
          list.add(_buildNode(child, depth: 0, dense: dense));
        }
      }
    }

    return ListView(
      shrinkWrap: widget.props['shrink_wrap'] == true,
      padding: coercePadding(widget.props['padding']),
      children: list,
    );
  }

  void _syncFromProps() {
    _expanded
      ..clear()
      ..addAll(_coerceStringSet(widget.props['expanded']));

    final selectedRaw = widget.props['selected'] ?? widget.props['value'];
    _selected
      ..clear()
      ..addAll(_coerceStringSet(selectedRaw));
  }

  Widget _buildNode(_FileNode node, {required int depth, required bool dense}) {
    final hasChildren = node.children.isNotEmpty;
    final expanded = _expanded.contains(node.id);
    final selected = _selected.contains(node.id);
    final icon = node.isDirectory
        ? Icons.folder_outlined
        : Icons.description_outlined;

    final tile = InkWell(
      onTap: node.disabled ? null : () => _onNodeTap(node),
      onDoubleTap: node.disabled
          ? null
          : () {
              if (node.isDirectory) {
                _toggle(node);
              } else {
                _emit('open', node, {'id': node.id, 'path': node.path});
              }
            },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 8 : 10,
          vertical: dense ? 4 : 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected
              ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.45)
              : null,
        ),
        child: Row(
          children: [
            SizedBox(width: (depth * 14).toDouble()),
            if (hasChildren)
              InkWell(
                onTap: node.disabled ? null : () => _toggle(node),
                child: Icon(
                  expanded ? Icons.expand_more : Icons.chevron_right,
                  size: 16,
                ),
              )
            else
              const SizedBox(width: 16),
            const SizedBox(width: 6),
            Icon(
              icon,
              size: 18,
              color: node.isDirectory
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                node.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: node.disabled
                    ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.45),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );

    if (!hasChildren || !expanded) {
      return tile;
    }
    final children = node.children
        .map((child) => _buildNode(child, depth: depth + 1, dense: dense))
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [tile, ...children],
    );
  }

  void _onNodeTap(_FileNode node) {
    final multiSelect = widget.props['multi_select'] == true;
    setState(() {
      if (multiSelect) {
        if (_selected.contains(node.id)) {
          _selected.remove(node.id);
        } else {
          _selected.add(node.id);
        }
      } else {
        _selected
          ..clear()
          ..add(node.id);
      }
    });
    _emit('select', node, {
      'selected': _selected.toList(growable: false),
      'multi_select': multiSelect,
    });

    if (!node.isDirectory) {
      _emit('open', node, {'path': node.path});
    } else if (widget.props['toggle_on_tap'] == true) {
      _toggle(node);
    }
  }

  void _toggle(_FileNode node) {
    final expanded = _expanded.contains(node.id);
    setState(() {
      if (expanded) {
        _expanded.remove(node.id);
      } else {
        _expanded.add(node.id);
      }
    });
    _emit('toggle', node, {
      'expanded': !expanded,
      'expanded_ids': _expanded.toList(growable: false),
    });
  }

  void _emit(String event, _FileNode node, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, {
      'id': node.id,
      'label': node.label,
      'path': node.path,
      'is_dir': node.isDirectory,
      'node': node.payload,
      ...payload,
    });
  }
}

class _FileNode {
  final String id;
  final String label;
  final String path;
  final bool isDirectory;
  final bool disabled;
  final List<_FileNode> children;
  final Map<String, Object?> payload;

  const _FileNode({
    required this.id,
    required this.label,
    required this.path,
    required this.isDirectory,
    required this.disabled,
    required this.children,
    required this.payload,
  });
}

Set<String> _coerceStringSet(Object? value) {
  final out = <String>{};
  if (value is List) {
    for (final item in value) {
      final text = item?.toString();
      if (text != null && text.isNotEmpty) out.add(text);
    }
    return out;
  }
  final single = value?.toString();
  if (single != null && single.isNotEmpty) {
    out.add(single);
  }
  return out;
}

List<_FileNode> _parseNodes(Object? raw) {
  if (raw is! List) return const [];
  final out = <_FileNode>[];
  for (final item in raw) {
    final node = _coerceNode(item);
    if (node != null) {
      out.add(node);
    }
  }
  return out;
}

_FileNode? _coerceNode(Object? raw) {
  if (raw is! Map) return null;
  final map = coerceObjectMap(raw);
  final type = map['type']?.toString().toLowerCase();
  final props = (type == 'tree_node' && map['props'] is Map)
      ? coerceObjectMap(map['props'] as Map)
      : map;

  final id = (props['id'] ?? props['path'] ?? props['value'] ?? props['label'])
      ?.toString();
  if (id == null || id.isEmpty) return null;
  final label = (props['label'] ?? props['title'] ?? props['name'] ?? id)
      .toString();
  final path = (props['path'] ?? props['id'] ?? label).toString();

  final nestedRaw = props['children'] ?? map['children'];
  final children = <_FileNode>[];
  if (nestedRaw is List) {
    for (final child in nestedRaw) {
      final next = _coerceNode(child);
      if (next != null) children.add(next);
    }
  }

  final kind = (props['kind'] ?? props['type'])?.toString().toLowerCase();
  final isDirectory =
      props['is_dir'] == true ||
      props['directory'] == true ||
      kind == 'dir' ||
      kind == 'directory' ||
      children.isNotEmpty;

  return _FileNode(
    id: id,
    label: label,
    path: path,
    isDirectory: isDirectory,
    disabled: props['disabled'] == true || props['enabled'] == false,
    children: children,
    payload: props,
  );
}
