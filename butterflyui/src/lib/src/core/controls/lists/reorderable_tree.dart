import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildReorderableTreeControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ReorderableTreeControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ReorderableTreeControl extends StatefulWidget {
  const _ReorderableTreeControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ReorderableTreeControl> createState() => _ReorderableTreeControlState();
}

class _ReorderableTreeControlState extends State<_ReorderableTreeControl> {
  List<Map<String, Object?>> _nodes = const <Map<String, Object?>>[];

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ReorderableTreeControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _nodes = _coerceNodes(widget.props['nodes']);
  }

  List<Map<String, Object?>> _coerceNodes(Object? value) {
    if (value is! List) return const <Map<String, Object?>>[];
    return value.whereType<Map>().map(coerceObjectMap).toList(growable: true);
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'nodes': _nodes};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_nodes':
        setState(() {
          _nodes = _coerceNodes(args['nodes']);
        });
        _emit('change', _statePayload());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown reorderable_tree method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _nodes.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _nodes.removeAt(oldIndex);
          _nodes.insert(newIndex, item);
        });
        _emit('reorder', {
          'from': oldIndex,
          'to': newIndex,
          'nodes': _nodes,
        });
      },
      itemBuilder: (context, index) {
        final node = _nodes[index];
        final id = (node['id'] ?? node['key'] ?? index).toString();
        final label =
            (node['label'] ?? node['title'] ?? node['name'] ?? id).toString();
        final depth = coerceOptionalInt(node['depth']) ?? 0;

        return ListTile(
          key: ValueKey<String>(id),
          dense: dense,
          leading: SizedBox(width: (depth * 12).toDouble()),
          title: Text(label),
          trailing: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle),
          ),
          onTap: widget.controlId.isEmpty
              ? null
              : () {
                  _emit('select', {
                    'id': id,
                    'index': index,
                    'node': node,
                  });
                },
        );
      },
    );
  }
}
