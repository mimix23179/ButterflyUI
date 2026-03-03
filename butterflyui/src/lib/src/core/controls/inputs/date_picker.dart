import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

DateTime? _parseDate(Object? value) {
  final raw = value?.toString();
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

String? _formatDate(DateTime? value) {
  if (value == null) return null;
  final mm = value.month.toString().padLeft(2, '0');
  final dd = value.day.toString().padLeft(2, '0');
  return '${value.year}-$mm-$dd';
}

class ButterflyUIDatePicker extends StatefulWidget {
  const ButterflyUIDatePicker({
    super.key,
    required this.controlId,
    required this.value,
    required this.start,
    required this.end,
    required this.minDate,
    required this.maxDate,
    required this.mode,
    required this.label,
    required this.placeholder,
    required this.enabled,
    required this.dense,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final DateTime? value;
  final DateTime? start;
  final DateTime? end;
  final DateTime? minDate;
  final DateTime? maxDate;
  final String mode;
  final String? label;
  final String? placeholder;
  final bool enabled;
  final bool dense;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUIDatePicker> createState() => _ButterflyUIDatePickerState();
}

class _ButterflyUIDatePickerState extends State<ButterflyUIDatePicker> {
  DateTime? _value;
  DateTime? _start;
  DateTime? _end;

  bool get _isRange {
    final mode = widget.mode.toLowerCase();
    return mode == 'range' || mode == 'span';
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _start = widget.start;
    _end = widget.end;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant ButterflyUIDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.value != widget.value ||
        oldWidget.start != widget.start ||
        oldWidget.end != widget.end ||
        oldWidget.mode != widget.mode) {
      _value = widget.value;
      _start = widget.start;
      _end = widget.end;
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  DateTime _firstDate() => widget.minDate ?? DateTime(1900, 1, 1);
  DateTime _lastDate() => widget.maxDate ?? DateTime(2100, 12, 31);

  Map<String, Object?> _statePayload() {
    if (_isRange) {
      return <String, Object?>{
        'start': _formatDate(_start),
        'end': _formatDate(_end),
        'value': {'start': _formatDate(_start), 'end': _formatDate(_end)},
      };
    }
    return <String, Object?>{'value': _formatDate(_value)};
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'open':
        await _openPicker();
        return null;
      case 'clear':
        setState(() {
          _value = null;
          _start = null;
          _end = null;
        });
        widget.sendEvent(widget.controlId, 'change', _statePayload());
        return null;
      case 'set_value':
        setState(() {
          if (_isRange ||
              args.containsKey('start') ||
              args.containsKey('end')) {
            _start = _parseDate(args['start'] ?? args['start_date']);
            _end = _parseDate(args['end'] ?? args['end_date']);
          } else {
            _value = _parseDate(args['value']);
          }
        });
        return _statePayload();
      case 'get_value':
        return _statePayload();
      default:
        throw UnsupportedError('Unknown date_picker method: $method');
    }
  }

  Future<void> _openPicker() async {
    if (!widget.enabled) return;
    if (_isRange) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: _firstDate(),
        lastDate: _lastDate(),
        initialDateRange: (_start != null && _end != null)
            ? DateTimeRange(start: _start!, end: _end!)
            : null,
      );
      if (picked == null) return;
      setState(() {
        _start = DateTime(
          picked.start.year,
          picked.start.month,
          picked.start.day,
        );
        _end = DateTime(picked.end.year, picked.end.month, picked.end.day);
      });
      final payload = _statePayload();
      widget.sendEvent(widget.controlId, 'change', payload);
      widget.sendEvent(widget.controlId, 'input', payload);
      return;
    }

    final picked = await showDatePicker(
      context: context,
      firstDate: _firstDate(),
      lastDate: _lastDate(),
      initialDate: _value ?? DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      _value = DateTime(picked.year, picked.month, picked.day);
    });
    final payload = _statePayload();
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
  }

  @override
  Widget build(BuildContext context) {
    final text = _isRange
        ? ((_formatDate(_start) == null || _formatDate(_end) == null)
              ? (widget.placeholder ?? 'Select date range')
              : '${_formatDate(_start)} -> ${_formatDate(_end)}')
        : (_formatDate(_value) ?? widget.placeholder ?? 'Select date');
    final icon = _isRange
        ? Icons.date_range_outlined
        : Icons.calendar_today_outlined;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        isDense: widget.dense,
        border: const OutlineInputBorder(),
      ),
      child: InkWell(
        onTap: widget.enabled ? _openPicker : null,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color:
                      ((_isRange && (_start == null || _end == null)) ||
                          (!_isRange && _value == null))
                      ? Theme.of(context).hintColor
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Icon(icon, size: 18),
          ],
        ),
      ),
    );
  }
}

Widget buildDatePickerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIDatePicker(
    controlId: controlId,
    value: _parseDate(props['value'] ?? props['date']),
    start: _parseDate(props['start'] ?? props['start_date']),
    end: _parseDate(props['end'] ?? props['end_date']),
    minDate: _parseDate(props['min_date'] ?? props['min']),
    maxDate: _parseDate(props['max_date'] ?? props['max']),
    mode: props['mode']?.toString() ?? 'single',
    label: props['label']?.toString(),
    placeholder: props['placeholder']?.toString(),
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    dense: props['dense'] == true,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
