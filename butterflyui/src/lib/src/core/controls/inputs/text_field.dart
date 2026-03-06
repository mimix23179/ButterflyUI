import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/form_field_control_shell.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUITextField extends StatefulWidget {
  final String controlId;
  final String value;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool multiline;
  final int? minLines;
  final int? maxLines;
  final bool password;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool dense;
  final bool emitOnChange;
  final int debounceMs;
  final Object? events;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITextField({
    super.key,
    required this.controlId,
    required this.value,
    required this.placeholder,
    required this.label,
    required this.helperText,
    required this.errorText,
    required this.multiline,
    required this.minLines,
    required this.maxLines,
    required this.password,
    required this.enabled,
    required this.readOnly,
    required this.autofocus,
    required this.dense,
    this.emitOnChange = true,
    this.debounceMs = 250,
    this.events,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUITextField> createState() => _ButterflyUITextFieldState();
}

class _ButterflyUITextFieldState extends State<ButterflyUITextField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:text_field:${widget.controlId}',
  );
  bool _suppressChange = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUITextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _suppressChange = true;
      _controller.value = _controller.value.copyWith(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
      _suppressChange = false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
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
          case 'get_value':
            return <String, Object?>{'value': _controller.text};
          case 'get_state':
            return <String, Object?>{
              'value': _controller.text,
              'focused': _focusNode.hasFocus,
            };
          case 'set_value':
            final nextValue = payload['value']?.toString() ?? '';
            _suppressChange = true;
            _controller.value = _controller.value.copyWith(
              text: nextValue,
              selection: TextSelection.collapsed(offset: nextValue.length),
            );
            _suppressChange = false;
            return <String, Object?>{'value': _controller.text};
          default:
            throw Exception('Unknown text_field method: $name');
        }
      },
    );
  }

  void _handleChange(String value) {
    if (_suppressChange) return;
    if (!widget.emitOnChange) return;
    _debounce?.cancel();
    final ms = widget.debounceMs;
    if (ms <= 0) {
      emitFormFieldValueEvents(
        controlId: widget.controlId,
        subscribedEventsSource: widget.events,
        payload: <String, Object?>{'value': value},
        sendEvent: widget.sendEvent,
      );
      return;
    }
    _debounce = Timer(Duration(milliseconds: ms), () {
      emitFormFieldValueEvents(
        controlId: widget.controlId,
        subscribedEventsSource: widget.events,
        payload: <String, Object?>{'value': value},
        sendEvent: widget.sendEvent,
      );
    });
  }

  void _handleSubmit(String value) {
    _debounce?.cancel();
    emitFormFieldValueEvents(
      controlId: widget.controlId,
      subscribedEventsSource: widget.events,
      payload: <String, Object?>{'value': value},
      sendEvent: widget.sendEvent,
      emitInput: false,
      emitSubmit: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardType = widget.multiline
        ? TextInputType.multiline
        : TextInputType.text;
    final minLines = widget.multiline ? widget.minLines : 1;
    final maxLines = widget.multiline ? widget.maxLines : 1;
    return Focus(
      onFocusChange: (value) {
        emitSubscribedEvent(
          controlId: widget.controlId,
          subscribedEventsSource: widget.events,
          name: value ? 'focus' : 'blur',
          payload: <String, Object?>{
            'focused': value,
            'value': _controller.text,
          },
          sendEvent: widget.sendEvent,
        );
      },
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        obscureText: widget.password,
        focusNode: _focusNode,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: _handleChange,
        onSubmitted: _handleSubmit,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          labelText: widget.label,
          helperText: widget.helperText,
          errorText: widget.errorText,
          isDense: widget.dense,
        ),
        onTapOutside: (_) {
          emitSubscribedEvent(
            controlId: widget.controlId,
            subscribedEventsSource: widget.events,
            name: 'tap_outside',
            payload: <String, Object?>{'value': _controller.text},
            sendEvent: widget.sendEvent,
          );
        },
      ),
    );
  }
}
