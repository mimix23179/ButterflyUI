import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

DateTime? _parseDateValue(Object? value) {
  final raw = value?.toString();
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

String? _formatDateValue(DateTime? value) {
  if (value == null) return null;
  final mm = value.month.toString().padLeft(2, '0');
  final dd = value.day.toString().padLeft(2, '0');
  return '${value.year}-$mm-$dd';
}

class ButterflyUIDateRangePicker extends StatefulWidget {
  final String controlId;
  final DateTimeRange? value;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool enabled;
  final String? label;
  final String? placeholder;
  final bool dense;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIDateRangePicker({
    super.key,
    required this.controlId,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.enabled,
    required this.label,
    required this.placeholder,
    required this.dense,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIDateRangePicker> createState() =>
      _ButterflyUIDateRangePickerState();
}

class _ButterflyUIDateRangePickerState extends State<ButterflyUIDateRangePicker> {
  DateTimeRange? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant ButterflyUIDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'open':
        await _pickRange();
        return null;
      case 'clear':
        setState(() {
          _value = null;
        });
        widget.sendEvent(widget.controlId, 'change', {
          'value': null,
          'start': null,
          'end': null,
        });
        return null;
      case 'get_value':
        return {
          'start': _formatDateValue(_value?.start),
          'end': _formatDateValue(_value?.end),
        };
      default:
        throw UnsupportedError('Unknown date_range_picker method: $method');
    }
  }

  Future<void> _pickRange() async {
    if (!widget.enabled) return;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      initialDateRange: _value,
    );
    if (picked == null) return;
    setState(() {
      _value = DateTimeRange(
        start: DateTime(picked.start.year, picked.start.month, picked.start.day),
        end: DateTime(picked.end.year, picked.end.month, picked.end.day),
      );
    });
    final payload = {
      'start': _formatDateValue(_value?.start),
      'end': _formatDateValue(_value?.end),
      'value': {
        'start': _formatDateValue(_value?.start),
        'end': _formatDateValue(_value?.end),
      },
    };
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
  }

  @override
  Widget build(BuildContext context) {
    final start = _formatDateValue(_value?.start);
    final end = _formatDateValue(_value?.end);
    final text = (start == null || end == null)
        ? (widget.placeholder ?? 'Select date range')
        : '$start → $end';

    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        isDense: widget.dense,
        border: const OutlineInputBorder(),
      ),
      child: InkWell(
        onTap: widget.enabled ? _pickRange : null,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: _value == null
                      ? Theme.of(context).hintColor
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const Icon(Icons.date_range_outlined, size: 18),
          ],
        ),
      ),
    );
  }
}

Widget buildDateRangePickerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final start = _parseDateValue(props['start_date'] ?? props['start']);
  final end = _parseDateValue(props['end_date'] ?? props['end']);
  DateTimeRange? value;
  if (start != null && end != null) {
    value = DateTimeRange(start: start, end: end);
  }

  return ButterflyUIDateRangePicker(
    controlId: controlId,
    value: value,
    firstDate: _parseDateValue(props['min_date'] ?? props['min']) ?? DateTime(1900, 1, 1),
    lastDate: _parseDateValue(props['max_date'] ?? props['max']) ?? DateTime(2100, 12, 31),
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    label: props['label']?.toString(),
    placeholder: props['placeholder']?.toString(),
    dense: props['dense'] == true,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
