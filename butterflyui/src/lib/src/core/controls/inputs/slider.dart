import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/webview/webview_api.dart';

class ConduitSlider extends StatefulWidget {
  final String controlId;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool enabled;
  final ConduitRegisterInvokeHandler registerInvokeHandler;
  final ConduitUnregisterInvokeHandler unregisterInvokeHandler;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitSlider({
    super.key,
    required this.controlId,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.enabled,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ConduitSlider> createState() => _ConduitSliderState();
}

class _ConduitSliderState extends State<ConduitSlider> {
  late double _value;

  double get _rangeMin => widget.min <= widget.max ? widget.min : widget.max;

  double get _rangeMax => widget.min <= widget.max ? widget.max : widget.min;

  @override
  void initState() {
    super.initState();
    _value = _clamp(widget.value);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ConduitSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value ||
        widget.min != oldWidget.min ||
        widget.max != oldWidget.max ||
        widget.divisions != oldWidget.divisions) {
      final next = _clamp(widget.value);
      if (next != _value) {
        _value = next;
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  double _clamp(double value) {
    if (value < _rangeMin) return _rangeMin;
    if (value > _rangeMax) return _rangeMax;
    return value;
  }

  double _stepSize() {
    final divisions = widget.divisions;
    if (divisions == null || divisions <= 0) return 0.0;
    return (_rangeMax - _rangeMin) / divisions;
  }

  double _snap(double value) {
    final step = _stepSize();
    if (step <= 0) return value;
    final ticks = ((value - _rangeMin) / step).roundToDouble();
    return _clamp(_rangeMin + (ticks * step));
  }

  double? _coerceDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_value':
        final raw = _coerceDouble(args['value']);
        if (raw != null) {
          setState(() {
            _value = _snap(_clamp(raw));
          });
        }
        return _value;
      case 'increment':
        final amount = _coerceDouble(args['amount']) ?? _stepSize();
        setState(() {
          _value = _snap(
            _clamp(
              _value +
                  (amount <= 0
                      ? (_stepSize() > 0 ? _stepSize() : 1.0)
                      : amount),
            ),
          );
        });
        return _value;
      case 'decrement':
        final amount = _coerceDouble(args['amount']) ?? _stepSize();
        setState(() {
          _value = _snap(
            _clamp(
              _value -
                  (amount <= 0
                      ? (_stepSize() > 0 ? _stepSize() : 1.0)
                      : amount),
            ),
          );
        });
        return _value;
      case 'get_value':
        return _value;
      default:
        throw Exception('Unknown invoke method: $method');
    }
  }

  void _handleChanged(double next) {
    final snapped = _snap(next);
    setState(() {
      _value = snapped;
    });
    final payload = <String, Object?>{
      'value': snapped,
      'min': _rangeMin,
      'max': _rangeMax,
    };
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
  }

  void _handleChangeStart(double next) {
    widget.sendEvent(widget.controlId, 'change_start', {
      'value': _snap(next),
      'min': _rangeMin,
      'max': _rangeMax,
    });
  }

  void _handleChangeEnd(double next) {
    final snapped = _snap(next);
    setState(() {
      _value = snapped;
    });
    widget.sendEvent(widget.controlId, 'change_end', {
      'value': snapped,
      'min': _rangeMin,
      'max': _rangeMax,
    });
  }

  @override
  Widget build(BuildContext context) {
    final resolvedLabel = widget.label?.replaceAll(
      '{value}',
      _value.toStringAsFixed(2),
    );
    return Slider(
      value: _value,
      min: _rangeMin,
      max: _rangeMax,
      divisions: widget.divisions,
      label: resolvedLabel,
      onChanged: widget.enabled ? _handleChanged : null,
      onChangeStart: widget.enabled ? _handleChangeStart : null,
      onChangeEnd: widget.enabled ? _handleChangeEnd : null,
    );
  }
}
