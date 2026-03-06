import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/form_field_control_shell.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUICheckbox extends StatefulWidget {
  final String controlId;
  final String? label;
  final bool? value;
  final bool enabled;
  final bool tristate;
  final bool autofocus;
  final Object? events;
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
    this.autofocus = false,
    this.events,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUICheckbox> createState() => _ButterflyUICheckboxState();
}

class _ButterflyUICheckboxState extends State<ButterflyUICheckbox> {
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:checkbox:${widget.controlId}',
  );
  bool? _value;

  @override
  void initState() {
    super.initState();
    _value = _normalizeValue(widget.value);
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUICheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (widget.value != oldWidget.value ||
        widget.tristate != oldWidget.tristate) {
      _value = _normalizeValue(widget.value);
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
    return handleFormFieldInvoke(
      context: context,
      focusNode: _focusNode,
      method: method,
      args: args,
      onUnhandled: (name, payload) async {
        switch (name) {
          case 'set_value':
            final requested = payload.containsKey('value')
                ? payload['value']
                : payload['checked'];
            setState(() {
              _value = _normalizeValue(coerceShellBoolOrNull(requested));
            });
            return _value;
          case 'toggle':
            setState(() {
              _value = _nextToggleValue();
            });
            return _value;
          case 'get_value':
          case 'get_state':
            return <String, Object?>{
              'value': _value,
              'checked': _value == true,
              'tristate': widget.tristate,
            };
          default:
            throw Exception('Unknown checkbox method: $name');
        }
      },
    );
  }

  void _handleChanged(bool? next) {
    final normalized = _normalizeValue(next);
    setState(() {
      _value = normalized;
    });
    final payload = <String, Object?>{
      'value': normalized,
      'checked': normalized == true,
      'tristate': widget.tristate,
    };
    emitFormFieldValueEvents(
      controlId: widget.controlId,
      subscribedEventsSource: widget.events,
      payload: payload,
      sendEvent: widget.sendEvent,
      emitToggle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final tristate = widget.tristate;
    final value = tristate ? _value : (_value ?? false);
    final control = (label == null || label.trim().isEmpty)
        ? Checkbox(
            value: value,
            tristate: tristate,
            onChanged: widget.enabled ? _handleChanged : null,
          )
        : CheckboxListTile(
            value: value,
            tristate: tristate,
            title: Text(label),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: widget.enabled ? _handleChanged : null,
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
      child: control,
    );
  }
}
