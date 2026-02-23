import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTimeSelectControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _TimeSelectControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _TimeSelectControl extends StatefulWidget {
  const _TimeSelectControl({
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
  State<_TimeSelectControl> createState() => _TimeSelectControlState();
}

class _TimeSelectControlState extends State<_TimeSelectControl> {
  TimeOfDay? _value;

  @override
  void initState() {
    super.initState();
    _value = _parseTime(widget.props['value']);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _TimeSelectControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props['value'] != widget.props['value']) {
      _value = _parseTime(widget.props['value']);
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<void> _openPicker() async {
    final use24h = widget.props['use_24h'] == true;
    final selected = await showTimePicker(
      context: context,
      initialTime: _value ?? TimeOfDay.now(),
      builder: (context, child) {
        if (!use24h) return child ?? const SizedBox.shrink();
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (selected == null) return;
    setState(() {
      _value = selected;
    });
    if (widget.controlId.isNotEmpty) {
      widget.sendEvent(widget.controlId, 'change', {'value': _format(selected)});
    }
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'open':
        await _openPicker();
        return _format(_value);
      case 'get_value':
        return _format(_value);
      case 'set_value':
        setState(() {
          _value = _parseTime(args['value']);
        });
        return _format(_value);
      default:
        throw UnsupportedError('Unknown time_select method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final text = _format(_value) ?? (widget.props['placeholder']?.toString() ?? 'Select time');
    return InkWell(
      onTap: enabled ? _openPicker : null,
      child: InputDecorator(
        isEmpty: _value == null,
        decoration: InputDecoration(
          labelText: widget.props['label']?.toString(),
          suffixIcon: const Icon(Icons.access_time),
          enabled: enabled,
        ),
        child: Text(text),
      ),
    );
  }
}

TimeOfDay? _parseTime(Object? raw) {
  final value = raw?.toString();
  if (value == null || value.isEmpty) return null;
  final parts = value.split(':');
  if (parts.length != 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  return TimeOfDay(hour: hour, minute: minute);
}

String? _format(TimeOfDay? time) {
  if (time == null) return null;
  final hh = time.hour.toString().padLeft(2, '0');
  final mm = time.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}
