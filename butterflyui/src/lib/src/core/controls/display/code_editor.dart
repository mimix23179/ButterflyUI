import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

class ConduitCodeEditor extends StatefulWidget {
  final String controlId;
  final String value;
  final String? language;
  final bool readOnly;
  final bool autofocus;
  final bool wordWrap;
  final bool showLineNumbers;
  final bool emitOnChange;
  final int debounceMs;
  final double fontSize;
  final String fontFamily;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final ConduitRegisterInvokeHandler registerInvokeHandler;
  final ConduitUnregisterInvokeHandler unregisterInvokeHandler;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitCodeEditor({
    super.key,
    required this.controlId,
    required this.value,
    required this.language,
    required this.readOnly,
    required this.autofocus,
    required this.wordWrap,
    required this.showLineNumbers,
    required this.emitOnChange,
    required this.debounceMs,
    required this.fontSize,
    required this.fontFamily,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ConduitCodeEditor> createState() => _ConduitCodeEditorState();
}

class _ConduitCodeEditorState extends State<ConduitCodeEditor> {
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
  void didUpdateWidget(covariant ConduitCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controlId != oldWidget.controlId) {
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

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
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
        if (mounted) setState(() {});
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
        final value = args['value']?.toString() ?? '';
        if (value.isEmpty) return null;
        final selection = _controller.selection;
        if (!selection.isValid) {
          _controller.text += value;
        } else {
          final base = selection.start;
          final extent = selection.end;
          final text = _controller.text;
          final next = text.replaceRange(base, extent, value);
          _controller.value = TextEditingValue(
            text: next,
            selection: TextSelection.collapsed(offset: base + value.length),
          );
        }
        _emitChange(immediate: true);
        return null;
      case 'format_document':
        widget.sendEvent(widget.controlId, 'format_request', {
          'value': _controller.text,
          'language': widget.language ?? '',
        });
        return null;
      default:
        throw UnsupportedError('Unknown code_editor method: $method');
    }
  }

  void _emitChange({bool immediate = false}) {
    if (_suppressChange || !widget.emitOnChange) return;
    _debounce?.cancel();
    final text = _controller.text;
    if (immediate || widget.debounceMs <= 0) {
      widget.sendEvent(widget.controlId, 'change', {'value': text});
      return;
    }
    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () {
      widget.sendEvent(widget.controlId, 'change', {'value': text});
    });
  }

  void _emitSubmit() {
    _debounce?.cancel();
    widget.sendEvent(widget.controlId, 'submit', {
      'value': _controller.text,
      'language': widget.language ?? '',
    });
  }

  @override
  Widget build(BuildContext context) {
    final lineCount = '\n'.allMatches(_controller.text).length + 1;
    final lineNumbersText = List<String>.generate(
      lineCount,
      (index) => '${index + 1}',
    ).join('\n');

    final editor = TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      maxLines: null,
      minLines: 12,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
        fontFamily: widget.fontFamily,
        fontSize: widget.fontSize,
        color: widget.textColor,
        height: 1.45,
      ),
      onChanged: (_) => _emitChange(),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );

    final wrappedEditor = Focus(
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        final key = event.logicalKey;
        final ctrl = HardwareKeyboard.instance.isControlPressed;
        if (ctrl && key == LogicalKeyboardKey.enter) {
          _emitSubmit();
          return KeyEventResult.handled;
        }
        if (ctrl && key == LogicalKeyboardKey.keyS) {
          widget.sendEvent(widget.controlId, 'save', {
            'value': _controller.text,
          });
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: editor,
    );

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showLineNumbers)
            Container(
              width: 54,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              color: widget.backgroundColor.withOpacity(0.75),
              alignment: Alignment.topRight,
              child: Text(
                lineNumbersText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: widget.fontFamily,
                  fontSize: widget.fontSize - 1,
                  color: widget.textColor.withOpacity(0.55),
                  height: 1.45,
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: widget.wordWrap
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              child: SizedBox(
                width: widget.wordWrap ? null : 1200,
                child: wrappedEditor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCodeEditorControl(
  String controlId,
  Map<String, Object?> props,
  ConduitRegisterInvokeHandler registerInvokeHandler,
  ConduitUnregisterInvokeHandler unregisterInvokeHandler,
  ConduitSendRuntimeEvent sendEvent,
) {
  final value = (props['value'] ?? props['text'] ?? props['code'] ?? '')
      .toString();
  final fontSize = coerceDouble(props['font_size']) ?? 13;
  final fontFamily = props['font_family']?.toString() ?? 'JetBrains Mono';
  final backgroundColor =
      coerceColor(
        props['editor_bg'] ?? props['editor_background'] ?? props['bgcolor'],
      ) ??
      const Color(0xff0b1220);
  final textColor =
      coerceColor(props['editor_text_color'] ?? props['text_color']) ??
      const Color(0xffdbeafe);
  final borderColor =
      coerceColor(props['border_color']) ?? const Color(0xff334155);
  final borderWidth = coerceDouble(props['border_width']) ?? 1.0;
  final radius = coerceDouble(props['radius']) ?? 10.0;
  return ConduitCodeEditor(
    controlId: controlId,
    value: value,
    language: props['language']?.toString(),
    readOnly: props['read_only'] == true,
    autofocus: props['auto_focus'] == true || props['autofocus'] == true,
    wordWrap: props['word_wrap'] == true || props['wrap'] == true,
    showLineNumbers: props['line_numbers'] == null
        ? true
        : (props['line_numbers'] == true),
    emitOnChange: props['emit_on_change'] == null
        ? true
        : (props['emit_on_change'] == true),
    debounceMs: (coerceOptionalInt(props['debounce_ms']) ?? 180).clamp(0, 2000),
    fontSize: fontSize,
    fontFamily: fontFamily,
    backgroundColor: backgroundColor,
    textColor: textColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    radius: radius,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
