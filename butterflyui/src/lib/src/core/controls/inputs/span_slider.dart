import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSpanSliderControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _SpanSliderControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _SpanSliderControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _SpanSliderControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_SpanSliderControl> createState() => _SpanSliderControlState();
}

class _SpanSliderControlState extends State<_SpanSliderControl> {
  late RangeValues _values;

  double get _min => coerceDouble(widget.props['min']) ?? 0.0;
  double get _max {
    final raw = coerceDouble(widget.props['max']) ?? 100.0;
    return raw < _min ? _min : raw;
  }

  int? get _divisions {
    final raw = coerceOptionalInt(widget.props['divisions']);
    if (raw == null || raw <= 0) return null;
    return raw;
  }

  bool get _enabled => widget.props['enabled'] == null ? true : (widget.props['enabled'] == true);

  @override
  void initState() {
    super.initState();
    _values = _resolveValues(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _SpanSliderControl oldWidget) {
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
      _values = _resolveValues(widget.props);
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  RangeValues _resolveValues(Map<String, Object?> props) {
    var start = coerceDouble(props['start']) ?? _min;
    var end = coerceDouble(props['end']) ?? _max;
    start = start.clamp(_min, _max);
    end = end.clamp(_min, _max);
    if (start > end) {
      final swap = start;
      start = end;
      end = swap;
    }
    return RangeValues(start, end);
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_value':
        setState(() {
          _values = _resolveValues(args);
        });
        return <String, Object?>{'start': _values.start, 'end': _values.end};
      case 'get_value':
        return <String, Object?>{'start': _values.start, 'end': _values.end};
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw UnsupportedError('Unknown span_slider method: $method');
    }
  }

  void _emit(String event, RangeValues values) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, {
      'start': values.start,
      'end': values.end,
      'min': _min,
      'max': _max,
    });
  }

  @override
  Widget build(BuildContext context) {
    final showLabels = widget.props['labels'] == true;
    final labels = showLabels
        ? RangeLabels(
            _values.start.toStringAsFixed(2),
            _values.end.toStringAsFixed(2),
          )
        : null;

    return RangeSlider(
      values: _values,
      min: _min,
      max: _max,
      divisions: _divisions,
      labels: labels,
      onChanged: !_enabled
          ? null
          : (next) {
              setState(() => _values = next);
              _emit('change', next);
              _emit('input', next);
            },
      onChangeStart: !_enabled ? null : (next) => _emit('change_start', next),
      onChangeEnd: !_enabled ? null : (next) => _emit('change_end', next),
    );
  }
}
