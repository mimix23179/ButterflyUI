import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/controls/common/icon_value.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildTreeViewControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  return ConduitTreeView(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
  );
}

Widget buildTreeNodeControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  final label =
      (props['label'] ??
              props['text'] ??
              props['title'] ??
              props['id'] ??
              'Node')
          .toString();
  final icon = buildIconValue(props['icon'], size: 18);
  final depth = coerceOptionalInt(props['depth']) ?? 0;
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);

  return Padding(
    padding: EdgeInsets.only(left: (depth * 14).toDouble()),
    child: ListTile(
      dense: props['dense'] == true,
      selected: props['selected'] == true,
      enabled: enabled,
      leading: icon,
      title: Text(label),
      onTap: enabled
          ? () {
              if (controlId.isEmpty) return;
              sendEvent(controlId, 'select', {
                'id': props['id']?.toString() ?? label,
                'label': label,
              });
            }
          : null,
    ),
  );
}

class _TreeNodeData {
  final String id;
  final String label;
  final Object? icon;
  final bool disabled;
  final bool selected;
  final bool expanded;
  final List<_TreeNodeData> children;
  final Map<String, Object?> payload;

  const _TreeNodeData({
    required this.id,
    required this.label,
    required this.icon,
    required this.disabled,
    required this.selected,
    required this.expanded,
    required this.children,
    required this.payload,
  });
}

class ConduitTreeView extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitTreeView({
    super.key,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  @override
  State<ConduitTreeView> createState() => _ConduitTreeViewState();
}

class _ConduitTreeViewState extends State<ConduitTreeView> {
  final Set<String> _expanded = <String>{};
  final Set<String> _selected = <String>{};

  @override
  void initState() {
    super.initState();
    _syncFromProps();
  }

  @override
  void didUpdateWidget(covariant ConduitTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props != widget.props) {
      _syncFromProps();
    }
  }

  void _syncFromProps() {
    _expanded
      ..clear()
      ..addAll(_coerceStringSet(widget.props['expanded']));

    final selectedRaw = widget.props['selected'] ?? widget.props['value'];
    _selected
      ..clear()
      ..addAll(_coerceStringSet(selectedRaw));

    final nodes = _parseNodes(widget.props['nodes']);
    if (widget.props['expand_all'] == true) {
      for (final node in nodes) {
        _collectExpandable(node, _expanded);
      }
    }
    for (final node in nodes) {
      _applyInitialStates(node);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nodes = _parseNodes(widget.props['nodes']);
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    final dense = widget.props['dense'] == true;
    final showRoot = widget.props['show_root'] == null
        ? true
        : (widget.props['show_root'] == true);

    final children = <Widget>[];
    for (final node in nodes) {
      if (showRoot) {
        children.add(_buildNode(node, depth: 0, dense: dense));
      } else {
        for (final child in node.children) {
          children.add(_buildNode(child, depth: 0, dense: dense));
        }
      }
    }

    return ListView(
      shrinkWrap: widget.props['shrink_wrap'] == true,
      padding: coercePadding(widget.props['padding']),
      children: children,
    );
  }

  Widget _buildNode(
    _TreeNodeData node, {
    required int depth,
    required bool dense,
  }) {
    final hasChildren = node.children.isNotEmpty;
    final expanded = _expanded.contains(node.id);
    final selected = _selected.contains(node.id);
    final leading = buildIconValue(node.icon, size: 16);

    final tile = InkWell(
      onTap: node.disabled
          ? null
          : () {
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
              _emit('select', {
                'id': node.id,
                'label': node.label,
                'selected': _selected.toList(growable: false),
                'node': node.payload,
              });

              if (hasChildren && widget.props['expand_on_tap'] == true) {
                _toggle(node);
              }
            },
      onDoubleTap: hasChildren && !node.disabled ? () => _toggle(node) : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 8 : 10,
          vertical: dense ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.45)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(width: (depth * 14).toDouble()),
            if (hasChildren)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: node.disabled ? null : () => _toggle(node),
                child: Icon(
                  expanded ? Icons.expand_more : Icons.chevron_right,
                  size: 16,
                ),
              )
            else
              const SizedBox(width: 16),
            const SizedBox(width: 6),
            if (leading != null) ...[leading, const SizedBox(width: 8)],
            Expanded(
              child: Text(
                node.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: node.disabled
                    ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.45),
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

    final subtree = node.children
        .map((child) => _buildNode(child, depth: depth + 1, dense: dense))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [tile, ...subtree],
    );
  }

  void _toggle(_TreeNodeData node) {
    final expanded = _expanded.contains(node.id);
    setState(() {
      if (expanded) {
        _expanded.remove(node.id);
      } else {
        _expanded.add(node.id);
      }
    });

    _emit('toggle', {
      'id': node.id,
      'label': node.label,
      'expanded': !expanded,
      'expanded_ids': _expanded.toList(growable: false),
    });
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _collectExpandable(_TreeNodeData node, Set<String> out) {
    if (node.children.isNotEmpty) {
      out.add(node.id);
      for (final child in node.children) {
        _collectExpandable(child, out);
      }
    }
  }

  void _applyInitialStates(_TreeNodeData node) {
    if (node.expanded) {
      _expanded.add(node.id);
    }
    if (node.selected) {
      _selected.add(node.id);
    }
    for (final child in node.children) {
      _applyInitialStates(child);
    }
  }
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

List<_TreeNodeData> _parseNodes(Object? raw) {
  if (raw is! List) return const [];
  final out = <_TreeNodeData>[];
  for (final item in raw) {
    final node = _coerceNode(item);
    if (node != null) out.add(node);
  }
  return out;
}

_TreeNodeData? _coerceNode(Object? raw) {
  if (raw is! Map) return null;

  final map = coerceObjectMap(raw);
  final type = map['type']?.toString().toLowerCase();
  final props = (type == 'tree_node' && map['props'] is Map)
      ? coerceObjectMap(map['props'] as Map)
      : map;

  final id = (props['id'] ?? props['value'] ?? props['key'] ?? props['label'])
      ?.toString();
  if (id == null || id.isEmpty) return null;

  final label = (props['label'] ?? props['text'] ?? props['title'] ?? id)
      .toString();

  final nestedRaw = props['children'] ?? map['children'];
  final children = <_TreeNodeData>[];
  if (nestedRaw is List) {
    for (final child in nestedRaw) {
      final next = _coerceNode(child);
      if (next != null) children.add(next);
    }
  }

  return _TreeNodeData(
    id: id,
    label: label,
    icon: props['icon'],
    disabled: props['disabled'] == true || props['enabled'] == false,
    selected: props['selected'] == true,
    expanded: props['expanded'] == true,
    children: children,
    payload: props,
  );
}
