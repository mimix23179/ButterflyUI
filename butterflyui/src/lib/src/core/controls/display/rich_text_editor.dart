import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUIRichTextEditor extends StatefulWidget {
  final String controlId;
  final String value;
  final String? placeholder;
  final bool readOnly;
  final bool autofocus;
  final bool emitOnChange;
  final int debounceMs;
  final int? minLines;
  final int? maxLines;
  final bool showToolbar;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIRichTextEditor({
    super.key,
    required this.controlId,
    required this.value,
    required this.placeholder,
    required this.readOnly,
    required this.autofocus,
    required this.emitOnChange,
    required this.debounceMs,
    required this.minLines,
    required this.maxLines,
    required this.showToolbar,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIRichTextEditor> createState() =>
      _ButterflyUIRichTextEditorState();
}

class _ButterflyUIRichTextEditorState extends State<ButterflyUIRichTextEditor> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _suppressChange = false;

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant ButterflyUIRichTextEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
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
    widget.unregisterInvokeHandler(widget.controlId);
    _debounce?.cancel();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _controller.text;
      case 'set_value':
        final value = args['value']?.toString() ?? '';
        _suppressChange = true;
        _controller.value = _controller.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
        _suppressChange = false;
        return null;
      case 'focus':
        _focusNode.requestFocus();
        return null;
      case 'blur':
        _focusNode.unfocus();
        return null;
      case 'select_all':
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
        return null;
      case 'insert_text':
        _insertText(args['value']?.toString() ?? '');
        return null;
      default:
        throw UnsupportedError('Unknown rich_text_editor method: $method');
    }
  }

  void _emitChange({bool immediate = false}) {
    if (_suppressChange || !widget.emitOnChange) return;
    _debounce?.cancel();
    if (immediate || widget.debounceMs <= 0) {
      widget.sendEvent(widget.controlId, 'change', {'value': _controller.text});
      return;
    }
    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () {
      widget.sendEvent(widget.controlId, 'change', {'value': _controller.text});
    });
  }

  void _insertText(String value) {
    if (value.isEmpty) return;
    final selection = _controller.selection;
    if (!selection.isValid) {
      _controller.text += value;
      _emitChange(immediate: true);
      return;
    }
    final base = selection.start;
    final extent = selection.end;
    final text = _controller.text;
    final next = text.replaceRange(base, extent, value);
    _controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: base + value.length),
    );
    _emitChange(immediate: true);
  }

  void _wrapSelection(String prefix, String suffix) {
    final selection = _controller.selection;
    if (!selection.isValid) {
      _insertText('$prefix$suffix');
      return;
    }
    final start = selection.start;
    final end = selection.end;
    final text = _controller.text;
    final selected = text.substring(start, end);
    final replaced = '$prefix$selected$suffix';
    final next = text.replaceRange(start, end, replaced);
    _controller.value = TextEditingValue(
      text: next,
      selection: TextSelection(baseOffset: start, extentOffset: start + replaced.length),
    );
    _emitChange(immediate: true);
  }

  Widget _toolbarButton(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: widget.readOnly ? null : onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(36, 30),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showToolbar)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _toolbarButton('B', () => _wrapSelection('**', '**')),
                _toolbarButton('I', () => _wrapSelection('*', '*')),
                _toolbarButton('U', () => _wrapSelection('<u>', '</u>')),
                _toolbarButton('•', () => _insertText('- ')),
                _toolbarButton('1.', () => _insertText('1. ')),
              ],
            ),
          ),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          minLines: widget.minLines ?? 8,
          maxLines: widget.maxLines,
          onChanged: (_) => _emitChange(),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }
}

Widget buildRichTextEditorControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIRichTextEditor(
    controlId: controlId,
    value: (props['value'] ?? props['text'] ?? '').toString(),
    placeholder: props['placeholder']?.toString(),
    readOnly: props['read_only'] == true,
    autofocus: props['autofocus'] == true,
    emitOnChange: props['emit_on_change'] == null
        ? true
        : (props['emit_on_change'] == true),
    debounceMs: (coerceOptionalInt(props['debounce_ms']) ?? 200).clamp(0, 2000),
    minLines: coerceOptionalInt(props['min_lines']),
    maxLines: coerceOptionalInt(props['max_lines']),
    showToolbar: props['show_toolbar'] == null
        ? true
        : (props['show_toolbar'] == true),
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
