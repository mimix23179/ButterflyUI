import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUISlider extends StatefulWidget {
  const ButterflyUISlider({
    super.key,
    required this.controlId,
    required this.value,
    required this.start,
    required this.end,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.labels,
    required this.enabled,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final double value;
  final double? start;
  final double? end;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool labels;
  final bool enabled;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUISlider> createState() => _ButterflyUISliderState();
}

class _ButterflyUISliderState extends State<ButterflyUISlider> {
  late double _value;
  late double _start;
  late double _end;

  bool get _isRange => widget.start != null || widget.end != null;

  double get _rangeMin => widget.min <= widget.max ? widget.min : widget.max;
  double get _rangeMax => widget.min <= widget.max ? widget.max : widget.min;

  @override
  void initState() {
    super.initState();
    _syncFromWidget();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUISlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value ||
        widget.start != oldWidget.start ||
        widget.end != oldWidget.end ||
        widget.min != oldWidget.min ||
        widget.max != oldWidget.max ||
        widget.divisions != oldWidget.divisions) {
      _syncFromWidget();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromWidget() {
    _value = _snap(_clamp(widget.value));
    final s = _snap(_clamp(widget.start ?? widget.value));
    final e = _snap(_clamp(widget.end ?? widget.value));
    _start = s <= e ? s : e;
    _end = s <= e ? e : s;
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
        final nextValue = _coerceDouble(args['value']);
        final nextStart = _coerceDouble(args['start']);
        final nextEnd = _coerceDouble(args['end']);
        setState(() {
          if (_isRange || nextStart != null || nextEnd != null) {
            final s = _snap(_clamp(nextStart ?? _start));
            final e = _snap(_clamp(nextEnd ?? _end));
            _start = s <= e ? s : e;
            _end = s <= e ? e : s;
          } else if (nextValue != null) {
            _value = _snap(_clamp(nextValue));
          }
        });
        return _statePayload();
      case 'increment':
        final amount =
            _coerceDouble(args['amount']) ??
            (_stepSize() > 0 ? _stepSize() : 1.0);
        setState(() {
          if (_isRange) {
            _end = _snap(_clamp(_end + amount));
            if (_end < _start) _start = _end;
          } else {
            _value = _snap(_clamp(_value + amount));
          }
        });
        return _statePayload();
      case 'decrement':
        final amount =
            _coerceDouble(args['amount']) ??
            (_stepSize() > 0 ? _stepSize() : 1.0);
        setState(() {
          if (_isRange) {
            _start = _snap(_clamp(_start - amount));
            if (_start > _end) _end = _start;
          } else {
            _value = _snap(_clamp(_value - amount));
          }
        });
        return _statePayload();
      case 'get_value':
        return _statePayload();
      default:
        throw UnsupportedError('Unknown slider method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    if (_isRange) {
      return <String, Object?>{
        'start': _start,
        'end': _end,
        'min': _rangeMin,
        'max': _rangeMax,
      };
    }
    return <String, Object?>{
      'value': _value,
      'min': _rangeMin,
      'max': _rangeMax,
    };
  }

  void _emitChange(Map<String, Object?> payload, {required String stage}) {
    widget.sendEvent(widget.controlId, stage, payload);
    if (stage == 'change') {
      widget.sendEvent(widget.controlId, 'input', payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isRange) {
      final values = RangeValues(_start, _end);
      return RangeSlider(
        values: values,
        min: _rangeMin,
        max: _rangeMax,
        divisions: widget.divisions,
        labels: widget.labels
            ? RangeLabels(_start.toStringAsFixed(2), _end.toStringAsFixed(2))
            : null,
        onChanged: widget.enabled
            ? (next) {
                setState(() {
                  _start = _snap(_clamp(next.start));
                  _end = _snap(_clamp(next.end));
                });
                _emitChange(_statePayload(), stage: 'change');
              }
            : null,
        onChangeStart: widget.enabled
            ? (next) => _emitChange(<String, Object?>{
                'start': next.start,
                'end': next.end,
              }, stage: 'change_start')
            : null,
        onChangeEnd: widget.enabled
            ? (next) => _emitChange(<String, Object?>{
                'start': next.start,
                'end': next.end,
              }, stage: 'change_end')
            : null,
      );
    }

    final resolvedLabel = widget.label?.replaceAll(
      '{value}',
      _value.toStringAsFixed(2),
    );
    return Slider(
      value: _value,
      min: _rangeMin,
      max: _rangeMax,
      divisions: widget.divisions,
      label: widget.labels
          ? (resolvedLabel ?? _value.toStringAsFixed(2))
          : resolvedLabel,
      onChanged: widget.enabled
          ? (next) {
              final snapped = _snap(next);
              setState(() {
                _value = snapped;
              });
              _emitChange(_statePayload(), stage: 'change');
            }
          : null,
      onChangeStart: widget.enabled
          ? (next) => _emitChange(<String, Object?>{
              'value': _snap(next),
            }, stage: 'change_start')
          : null,
      onChangeEnd: widget.enabled
          ? (next) => _emitChange(<String, Object?>{
              'value': _snap(next),
            }, stage: 'change_end')
          : null,
    );
  }
}
