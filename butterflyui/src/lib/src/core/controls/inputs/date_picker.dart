import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUIDatePicker extends StatefulWidget {
  final String controlId;
  final DateTime? value;
  final DateTime? minDate;
  final DateTime? maxDate;
  final String? label;
  final String? placeholder;
  final bool enabled;
  final bool dense;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIDatePicker({
    super.key,
    required this.controlId,
    required this.value,
    required this.minDate,
    required this.maxDate,
    required this.label,
    required this.placeholder,
    required this.enabled,
    required this.dense,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIDatePicker> createState() => _ButterflyUIDatePickerState();
}

class _ButterflyUIDatePickerState extends State<ButterflyUIDatePicker> {
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant ButterflyUIDatePicker oldWidget) {
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
        await _pickDate();
        return null;
      case 'clear':
        setState(() {
          _value = null;
        });
        widget.sendEvent(widget.controlId, 'change', {
          'value': null,
        });
        return null;
      case 'set_value':
        final next = _parseDate(args['value']);
        setState(() {
          _value = next;
        });
        return null;
      case 'get_value':
        return _formatDate(_value);
      default:
        throw UnsupportedError('Unknown date_picker method: $method');
    }
  }

  DateTime _firstDate() => widget.minDate ?? DateTime(1900, 1, 1);
  DateTime _lastDate() => widget.maxDate ?? DateTime(2100, 12, 31);

  Future<void> _pickDate() async {
    if (!widget.enabled) return;
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
    final payload = {
      'value': _formatDate(_value),
      'year': picked.year,
      'month': picked.month,
      'day': picked.day,
    };
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
  }

  @override
  Widget build(BuildContext context) {
    final text = _formatDate(_value) ?? widget.placeholder ?? 'Select date';
    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        isDense: widget.dense,
        border: const OutlineInputBorder(),
      ),
      child: InkWell(
        onTap: widget.enabled ? _pickDate : null,
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
            const Icon(Icons.calendar_today_outlined, size: 18),
          ],
        ),
      ),
    );
  }
}

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
    minDate: _parseDate(props['min_date'] ?? props['min']),
    maxDate: _parseDate(props['max_date'] ?? props['max']),
    label: props['label']?.toString(),
    placeholder: props['placeholder']?.toString(),
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    dense: props['dense'] == true,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
