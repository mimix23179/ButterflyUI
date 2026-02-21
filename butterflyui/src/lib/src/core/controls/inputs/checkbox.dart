import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUICheckbox extends StatefulWidget {
  final String controlId;
  final String? label;
  final bool? value;
  final bool enabled;
  final bool tristate;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUICheckbox({
    super.key,
    required this.controlId,
    required this.label,
    required this.value,
    required this.enabled,
    required this.tristate,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUICheckbox> createState() => _ButterflyUICheckboxState();
}

class _ButterflyUICheckboxState extends State<ButterflyUICheckbox> {
  bool? _value;

  @override
  void initState() {
    super.initState();
    _value = _normalizeValue(widget.value);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUICheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value ||
        widget.tristate != oldWidget.tristate) {
      _value = _normalizeValue(widget.value);
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  bool? _normalizeValue(bool? value) {
    if (widget.tristate) return value;
    return value == true;
  }

  bool? _nextToggleValue() {
    if (!widget.tristate) return !(_value == true);
    if (_value == null) return false;
    if (_value == false) return true;
    return null;
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_value':
        final requested = args.containsKey('value')
            ? args['value']
            : args['checked'];
        setState(() {
          _value = _normalizeValue(_coerceBoolOrNull(requested));
        });
        return _value;
      case 'toggle':
        setState(() {
          _value = _nextToggleValue();
        });
        return _value;
      case 'get_value':
        return _value;
      default:
        throw Exception('Unknown invoke method: $method');
    }
  }

  bool? _coerceBoolOrNull(Object? raw) {
    if (raw == null) return null;
    if (raw is bool) return raw;
    if (raw is num) return raw != 0;
    final s = raw.toString().toLowerCase();
    if (s == 'true' || s == '1' || s == 'yes' || s == 'on') return true;
    if (s == 'false' || s == '0' || s == 'no' || s == 'off') return false;
    if (s == 'null' || s == 'none') return null;
    return null;
  }

  void _handleChanged(bool? next) {
    final normalized = _normalizeValue(next);
    setState(() {
      _value = normalized;
    });
    if (widget.controlId.isEmpty) return;
    final payload = <String, Object?>{
      'value': normalized,
      'checked': normalized == true,
      'tristate': widget.tristate,
    };
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
    widget.sendEvent(widget.controlId, 'toggle', payload);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final tristate = widget.tristate;
    final value = tristate ? _value : (_value ?? false);
    if (label == null || label.trim().isEmpty) {
      return Checkbox(
        value: value,
        tristate: tristate,
        onChanged: widget.enabled ? _handleChanged : null,
      );
    }
    return CheckboxListTile(
      value: value,
      tristate: tristate,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: widget.enabled ? _handleChanged : null,
    );
  }
}
