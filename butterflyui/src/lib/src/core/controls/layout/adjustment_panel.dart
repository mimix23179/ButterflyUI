import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAdjustmentPanelControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIAdjustmentPanel(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIAdjustmentPanel extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIAdjustmentPanel({
    super.key,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIAdjustmentPanel> createState() => _ButterflyUIAdjustmentPanelState();
}

class _ButterflyUIAdjustmentPanelState extends State<ButterflyUIAdjustmentPanel> {
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
  void didUpdateWidget(covariant ButterflyUIAdjustmentPanel oldWidget) {
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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_item':
        final id = args['id']?.toString();
        final value = coerceDouble(args['value']);
        if (id != null && value != null) {
          _setItemValue(id, value, emit: false);
          _emit('change', {'id': id, 'value': value, 'items': _items});
        }
        return _statePayload();
      case 'reset':
        _resetValues(emit: true);
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
        throw UnsupportedError('Unknown adjustment_panel method: $method');
    }
  }

  void _syncFromProps() {
    final items = _coerceItems(widget.props['items'] ?? widget.props['adjustments']);
    setState(() => _items = items);
  }

  List<Map<String, Object?>> _coerceItems(Object? raw) {
    if (raw is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (var i = 0; i < raw.length; i += 1) {
      final value = raw[i];
      if (value is! Map) continue;
      final map = coerceObjectMap(value);
      final min = coerceDouble(map['min']) ?? 0.0;
      final max = coerceDouble(map['max']) ?? 100.0;
      final fallback = min <= 0 && max >= 0 ? 0.0 : min;
      final nextValue = (coerceDouble(map['value']) ?? fallback).clamp(min, max).toDouble();
      out.add(<String, Object?>{
        'id': (map['id'] ?? i).toString(),
        'label': (map['label'] ?? map['title'] ?? 'Adjustment ${i + 1}').toString(),
        'value': nextValue,
        'default': coerceDouble(map['default']) ?? nextValue,
        'min': min,
        'max': max,
        'step': coerceDouble(map['step']) ?? 1.0,
        'enabled': map['enabled'] == null ? true : (map['enabled'] == true),
        'show_toggle': map['show_toggle'] == true,
        'active': map['active'] == null ? true : (map['active'] == true),
      });
    }
    return out;
  }

  void _setItemValue(String id, double value, {required bool emit}) {
    final next = <Map<String, Object?>>[];
    for (final item in _items) {
      if (item['id']?.toString() != id) {
        next.add(item);
        continue;
      }
      final min = coerceDouble(item['min']) ?? 0.0;
      final max = coerceDouble(item['max']) ?? 100.0;
      next.add(<String, Object?>{
        ...item,
        'value': value.clamp(min, max).toDouble(),
      });
    }
    setState(() => _items = next);
    if (emit) {
      _emit('change', {'id': id, 'value': value, 'items': _items});
    }
  }

  void _resetValues({required bool emit}) {
    final next = <Map<String, Object?>>[];
    for (final item in _items) {
      next.add(<String, Object?>{
        ...item,
        'value': coerceDouble(item['default']) ?? coerceDouble(item['value']) ?? 0.0,
        'active': true,
      });
    }
    setState(() => _items = next);
    if (emit) {
      _emit('reset', {'items': _items});
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'items': _items,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;
    final enabled = widget.props['enabled'] == null
        ? true
        : (widget.props['enabled'] == true);
    final title = widget.props['title']?.toString();
    final showReset = widget.props['show_reset'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null && title.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (showReset)
                TextButton(
                  onPressed: enabled ? () => _resetValues(emit: true) : null,
                  child: const Text('Reset'),
                ),
            ],
          ),
        for (final item in _items) _buildItem(context, item, dense, enabled),
      ],
    );
  }

  Widget _buildItem(BuildContext context, Map<String, Object?> item, bool dense, bool panelEnabled) {
    final id = item['id']?.toString() ?? '';
    final itemEnabled = panelEnabled && (item['enabled'] == true);
    final label = item['label']?.toString() ?? id;
    final value = coerceDouble(item['value']) ?? 0.0;
    final min = coerceDouble(item['min']) ?? 0.0;
    final max = coerceDouble(item['max']) ?? 100.0;
    final step = coerceDouble(item['step']) ?? 1.0;
    final divisions = step <= 0 ? null : ((max - min) / step).round().clamp(1, 5000);
    final showToggle = item['show_toggle'] == true;
    final active = item['active'] != false;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 2 : 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(value.toStringAsFixed(2)),
              if (showToggle)
                Switch(
                  value: active,
                  onChanged: itemEnabled
                      ? (next) {
                          setState(() {
                            final items = <Map<String, Object?>>[];
                            for (final row in _items) {
                              if (row['id']?.toString() == id) {
                                items.add(<String, Object?>{...row, 'active': next});
                              } else {
                                items.add(row);
                              }
                            }
                            _items = items;
                          });
                          _emit('toggle', {'id': id, 'active': next, 'items': _items});
                        }
                      : null,
                ),
            ],
          ),
          Slider(
            min: min,
            max: max,
            value: value.clamp(min, max),
            divisions: divisions,
            label: value.toStringAsFixed(2),
            onChanged: (itemEnabled && active)
                ? (next) => _setItemValue(id, next, emit: true)
                : null,
            onChangeEnd: (next) {
              if (itemEnabled && active) {
                _emit('commit', {'id': id, 'value': next, 'items': _items});
              }
            },
          ),
        ],
      ),
    );
  }
}
