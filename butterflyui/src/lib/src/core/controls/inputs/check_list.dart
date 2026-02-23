import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCheckListControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _CheckListControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _CheckListControl extends StatefulWidget {
  const _CheckListControl({
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
  State<_CheckListControl> createState() => _CheckListControlState();
}

class _CheckListControlState extends State<_CheckListControl> {
  List<Map<String, Object?>> _options = const <Map<String, Object?>>[];
  final Set<String> _selected = <String>{};

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _CheckListControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (!mapEquals(oldWidget.props, widget.props)) {
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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_values':
        final next = _coerceValueSet(args['values']);
        setState(() {
          _selected
            ..clear()
            ..addAll(next);
        });
        return _statePayload();
      case 'get_values':
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
        throw UnsupportedError('Unknown check_list method: $method');
    }
  }

  void _syncFromProps() {
    _options = _coerceOptions(widget.props['options']);
    final next = _coerceValueSet(widget.props['values']);
    _selected
      ..clear()
      ..addAll(next);
  }

  List<Map<String, Object?>> _coerceOptions(Object? raw) {
    if (raw is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (var i = 0; i < raw.length; i += 1) {
      final item = raw[i];
      if (item is Map) {
        out.add(coerceObjectMap(item));
      } else if (item != null) {
        out.add(<String, Object?>{'id': '$i', 'label': item.toString()});
      }
    }
    return out;
  }

  Set<String> _coerceValueSet(Object? raw) {
    final out = <String>{};
    if (raw is List) {
      for (final value in raw) {
        final text = value?.toString();
        if (text != null && text.isNotEmpty) out.add(text);
      }
    }
    return out;
  }

  Map<String, Object?> _statePayload() {
    final values = _selected.toList(growable: false);
    return <String, Object?>{
      'values': values,
      'selected': values,
      'count': values.length,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final dense = widget.props['dense'] == true;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _options.length; i += 1)
          CheckboxListTile(
            dense: dense,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              (_options[i]['label'] ?? _options[i]['title'] ?? _options[i]['id'] ?? '$i').toString(),
            ),
            value: _selected.contains((_options[i]['id'] ?? i).toString()),
            onChanged: enabled
                ? (next) {
                    final id = (_options[i]['id'] ?? i).toString();
                    setState(() {
                      if (next == true) {
                        _selected.add(id);
                      } else {
                        _selected.remove(id);
                      }
                    });
                    _emit('change', {
                      'id': id,
                      ..._statePayload(),
                    });
                    _emit('select', {
                      'id': id,
                      ..._statePayload(),
                    });
                  }
                : null,
          ),
      ],
    );
  }
}
