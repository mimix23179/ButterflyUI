import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildProgressBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ProgressBarControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}

class _ProgressBarControl extends StatefulWidget {
  const _ProgressBarControl(
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
  State<_ProgressBarControl> createState() => _ProgressBarControlState();
}

class _ProgressBarControlState extends State<_ProgressBarControl> {
  double? _value;

  @override
  void initState() {
    super.initState();
    _value = _normalizeProgressValue(coerceDouble(widget.props['value']));
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ProgressBarControl oldWidget) {
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
      _value = _normalizeProgressValue(coerceDouble(widget.props['value']));
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_value':
        final next = _normalizeProgressValue(coerceDouble(args['value']));
        if (next != null || args.containsKey('value')) {
          setState(() => _value = next);
          _emit('change', _statePayload());
        }
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
        throw UnsupportedError('Unknown progress_bar method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'value': _value,
      'indeterminate': _value == null,
      if (_value != null) 'percent': (_value! * 100.0),
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final propValue = _normalizeProgressValue(
      coerceDouble(widget.props['value']),
    );
    final value = _value ?? propValue;
    final indeterminate =
        widget.props['indeterminate'] == true || value == null;
    final color = coerceColor(widget.props['color']);
    final backgroundColor = coerceColor(widget.props['background_color']);
    final strokeWidth = coerceDouble(widget.props['stroke_width']) ?? 4;
    final label = widget.props['label']?.toString();

    final indicator = LinearProgressIndicator(
      value: indeterminate ? null : value,
      minHeight: strokeWidth,
      color: color,
      backgroundColor: backgroundColor,
    );

    if (label == null || label.isEmpty) {
      return indicator;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

double? _normalizeProgressValue(double? raw) {
  if (raw == null) return null;
  final unit = raw > 1 ? (raw / 100.0) : raw;
  return unit.clamp(0.0, 1.0);
}
