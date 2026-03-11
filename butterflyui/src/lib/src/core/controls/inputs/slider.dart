import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/form_field_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUISlider extends StatefulWidget {
  const ButterflyUISlider({
    super.key,
    required this.controlId,
    required this.props,
    required this.value,
    required this.start,
    required this.end,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.labels,
    required this.enabled,
    this.autofocus = false,
    this.helper,
    this.helperText,
    this.buildChild,
    this.events,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final double value;
  final double? start;
  final double? end;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool labels;
  final bool enabled;
  final bool autofocus;
  final Object? helper;
  final String? helperText;
  final Widget Function(Map<String, Object?> child)? buildChild;
  final Object? events;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUISlider> createState() => _ButterflyUISliderState();
}

class _ButterflyUISliderState extends State<ButterflyUISlider> {
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:slider:${widget.controlId}',
  );
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
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUISlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
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
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    _focusNode.dispose();
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
    return handleFormFieldInvoke(
      context: context,
      focusNode: _focusNode,
      method: method,
      args: args,
      onUnhandled: (name, payload) async {
        switch (name) {
          case 'set_value':
            final nextValue = _coerceDouble(payload['value']);
            final nextStart = _coerceDouble(payload['start']);
            final nextEnd = _coerceDouble(payload['end']);
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
          case 'decrement':
            final amount =
                _coerceDouble(payload['amount']) ??
                (_stepSize() > 0 ? _stepSize() : 1.0);
            final signedAmount = name == 'increment' ? amount : -amount;
            setState(() {
              if (_isRange) {
                if (signedAmount >= 0) {
                  _end = _snap(_clamp(_end + signedAmount));
                  if (_end < _start) _start = _end;
                } else {
                  _start = _snap(_clamp(_start + signedAmount));
                  if (_start > _end) _end = _start;
                }
              } else {
                _value = _snap(_clamp(_value + signedAmount));
              }
            });
            return _statePayload();
          case 'get_value':
          case 'get_state':
            return _statePayload();
          default:
            throw UnsupportedError('Unknown slider method: $name');
        }
      },
    );
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
    emitSubscribedEvent(
      controlId: widget.controlId,
      subscribedEventsSource: widget.events,
      name: stage,
      payload: payload,
      sendEvent: widget.sendEvent,
    );
    if (stage == 'change') {
      emitSubscribedEvent(
        controlId: widget.controlId,
        subscribedEventsSource: widget.events,
        name: 'input',
        payload: payload,
        sendEvent: widget.sendEvent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = butterflyuiResolveSlotColor(
      context,
      widget.props,
      slot: 'background',
      explicit: widget.props['active_color'],
      fallback: butterflyuiPrimary(context),
    );
    final inactiveColor = butterflyuiResolveSlotColor(
      context,
      widget.props,
      slot: 'border',
      explicit: widget.props['inactive_color'],
      fallback: butterflyuiBorder(context),
    );
    final slider = Theme(
      data: Theme.of(context).copyWith(
        sliderTheme: Theme.of(context).sliderTheme.copyWith(
          activeTrackColor: activeColor,
          inactiveTrackColor: inactiveColor.withValues(alpha: 0.35),
          thumbColor: activeColor,
          overlayColor: activeColor.withValues(alpha: 0.14),
          valueIndicatorColor: activeColor,
          valueIndicatorTextStyle: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: butterflyuiBackground(context)),
        ),
      ),
      child: _isRange
          ? RangeSlider(
            values: RangeValues(_start, _end),
            min: _rangeMin,
            max: _rangeMax,
            divisions: widget.divisions,
            labels: widget.labels
                ? RangeLabels(
                    _start.toStringAsFixed(2),
                    _end.toStringAsFixed(2),
                  )
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
          )
          : Slider(
            value: _value,
            min: _rangeMin,
            max: _rangeMax,
            divisions: widget.divisions,
            label: widget.labels
                ? ((widget.label?.replaceAll(
                        '{value}',
                        _value.toStringAsFixed(2),
                      )) ??
                      _value.toStringAsFixed(2))
                : widget.label?.replaceAll(
                    '{value}',
                    _value.toStringAsFixed(2),
                  ),
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
          ),
    );
    final helper = _buildHelper(context);
    final child = helper == null
        ? slider
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [slider, const SizedBox(height: 4), helper],
          );

    return wrapFocusableFormField(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (value) {
        emitSubscribedEvent(
          controlId: widget.controlId,
          subscribedEventsSource: widget.events,
          name: value ? 'focus' : 'blur',
          payload: <String, Object?>{'focused': value},
          sendEvent: widget.sendEvent,
        );
      },
      child: child,
    );
  }

  Widget? _buildHelper(BuildContext context) {
    final helper = widget.helper;
    if (helper is Map && widget.buildChild != null) {
      return widget.buildChild!(
        Map<String, Object?>.fromEntries(
          helper.entries.map(
            (entry) => MapEntry(entry.key.toString(), entry.value),
          ),
        ),
      );
    }
    final helperText = widget.helperText?.trim();
    if (helperText == null || helperText.isEmpty) {
      return null;
    }
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: butterflyuiResolveSlotColor(
        context,
        widget.props,
        slot: 'helper',
        fallback: butterflyuiMutedText(context),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(helperText, style: style),
    );
  }
}
