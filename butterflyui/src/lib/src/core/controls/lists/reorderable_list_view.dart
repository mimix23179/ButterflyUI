import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildReorderableListViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ReorderableListViewControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}

class _ReorderableListViewControl extends StatefulWidget {
  const _ReorderableListViewControl(
    this.controlId,
    this.props,
    this.registerInvokeHandler,
    this.unregisterInvokeHandler,
    this.sendEvent,
  );

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ReorderableListViewControl> createState() =>
      _ReorderableListViewControlState();
}

class _ReorderableListViewControlState
    extends State<_ReorderableListViewControl> {
  List<Map<String, Object?>> _items = const <Map<String, Object?>>[];

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ReorderableListViewControl oldWidget) {
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
    _items = _coerceItems(widget.props['items']);
  }

  List<Map<String, Object?>> _coerceItems(Object? value) {
    if (value is! List) return const <Map<String, Object?>>[];
    return value.whereType<Map>().map(coerceObjectMap).toList(growable: true);
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'items': _items};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_items':
        setState(() {
          _items = _coerceItems(args['items']);
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
        throw UnsupportedError('Unknown reorderable_list_view method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;
    final showHandle = widget.props['handle'] == null
        ? true
        : (widget.props['handle'] == true);

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
        _emit('reorder', {'from': oldIndex, 'to': newIndex, 'items': _items});
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        final id = (item['id'] ?? item['key'] ?? index).toString();
        final title = (item['title'] ?? item['label'] ?? item['name'] ?? id)
            .toString();
        final subtitle =
            item['subtitle']?.toString() ?? item['description']?.toString();

        return ListTile(
          key: ValueKey<String>(id),
          dense: dense,
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle),
          trailing: showHandle
              ? ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                )
              : null,
          onTap: widget.controlId.isEmpty
              ? null
              : () {
                  _emit('select', {'id': id, 'index': index, 'item': item});
                },
        );
      },
    );
  }
}
