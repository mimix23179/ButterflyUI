import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildHistoryStackControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _HistoryStackControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _HistoryStackControl extends StatefulWidget {
  const _HistoryStackControl({
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
  State<_HistoryStackControl> createState() => _HistoryStackControlState();
}

class _HistoryStackControlState extends State<_HistoryStackControl> {
  List<Map<String, Object?>> _items = const <Map<String, Object?>>[];
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _HistoryStackControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    _syncFromProps();
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
    _selectedId = widget.props['selected_id']?.toString();
  }

  List<Map<String, Object?>> _coerceItems(Object? value) {
    if (value is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (final item in value) {
      if (item is Map) out.add(coerceObjectMap(item));
    }
    return out;
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_items':
        setState(() {
          _items = _coerceItems(args['items']);
        });
        _emit('change', _state());
        return _state();
      case 'get_state':
        return _state();
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown history_stack method: $method');
    }
  }

  Map<String, Object?> _state() => {
    'items': _items,
    'selected_id': _selectedId,
  };

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true || widget.props['compact'] == true;
    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final id = (item['id'] ?? index.toString()).toString();
        final label = (item['label'] ?? item['title'] ?? id).toString();
        final subtitle = item['subtitle']?.toString();
        final selected = _selectedId == id;
        return ListTile(
          dense: dense,
          selected: selected,
          title: Text(label),
          subtitle: subtitle == null ? null : Text(subtitle),
          onTap: () {
            setState(() => _selectedId = id);
            _emit('select', {
              'id': id,
              'index': index,
              'item': item,
            });
          },
        );
      },
    );
  }
}
