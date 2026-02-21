import 'dart:async';

import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/webview/webview_api.dart';

class ConduitTextField extends StatefulWidget {
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
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitTextField({
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
    required this.sendEvent,
  });

  @override
  State<ConduitTextField> createState() => _ConduitTextFieldState();
}

class _ConduitTextFieldState extends State<ConduitTextField> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);
  bool _suppressChange = false;
  Timer? _debounce;

  @override
  void didUpdateWidget(covariant ConduitTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    _controller.dispose();
    super.dispose();
  }

  void _handleChange(String value) {
    if (_suppressChange) return;
    if (!widget.emitOnChange) return;
    _debounce?.cancel();
    final ms = widget.debounceMs;
    if (ms <= 0) {
      widget.sendEvent(widget.controlId, 'change', {'value': value});
      return;
    }
    _debounce = Timer(Duration(milliseconds: ms), () {
      widget.sendEvent(widget.controlId, 'change', {'value': value});
    });
  }

  void _handleSubmit(String value) {
    _debounce?.cancel();
    widget.sendEvent(widget.controlId, 'submit', {'value': value});
  }

  @override
  Widget build(BuildContext context) {
    final keyboardType = widget.multiline ? TextInputType.multiline : TextInputType.text;
    final minLines = widget.multiline ? widget.minLines : 1;
    final maxLines = widget.multiline ? widget.maxLines : 1;
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: widget.password,
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
    );
  }
}

