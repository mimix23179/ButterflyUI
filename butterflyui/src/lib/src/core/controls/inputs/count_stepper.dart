import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCountStepperControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _CountStepperControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _CountStepperControl extends StatefulWidget {
  const _CountStepperControl({
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
  State<_CountStepperControl> createState() => _CountStepperControlState();
}

class _CountStepperControlState extends State<_CountStepperControl> {
  late double _value;
  late double _min;
  late double _max;
  late double _step;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _CountStepperControl oldWidget) {
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

  void _syncFromProps() {
    _min = coerceDouble(widget.props['min']) ?? 0;
    _max = coerceDouble(widget.props['max']) ?? 100;
    if (_max < _min) {
      final t = _min;
      _min = _max;
      _max = t;
    }
    _step = (coerceDouble(widget.props['step']) ?? 1).abs();
    if (_step <= 0) _step = 1;
    _value = (coerceDouble(widget.props['value']) ?? _min).clamp(_min, _max);
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_value':
        final next = coerceDouble(args['value']);
        if (next != null) {
          setState(() => _value = next.clamp(_min, _max));
          _emit('change', _statePayload());
        }
        return _statePayload();
      case 'increment':
        _applyDelta(coerceDouble(args['amount']) ?? _step);
        return _statePayload();
      case 'decrement':
        _applyDelta(-(coerceDouble(args['amount']) ?? _step));
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
        throw UnsupportedError('Unknown count_stepper method: $method');
    }
  }

  void _applyDelta(double delta) {
    final wrap = widget.props['wrap'] == true;
    setState(() {
      var next = _value + delta;
      if (wrap) {
        if (next > _max) next = _min;
        if (next < _min) next = _max;
      }
      _value = next.clamp(_min, _max);
    });
    _emit('change', _statePayload());
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'value': _value,
      'min': _min,
      'max': _max,
      'step': _step,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final whole = _step.roundToDouble() == _step;
    final valueText = whole ? _value.round().toString() : _value.toStringAsFixed(2);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: enabled ? () => _applyDelta(-_step) : null,
          icon: const Icon(Icons.remove),
        ),
        Text(valueText),
        IconButton(
          onPressed: enabled ? () => _applyDelta(_step) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
