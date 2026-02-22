import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart' as xterm;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUITerminal extends StatefulWidget {
  final String controlId;
  final List<dynamic> events;
  final List<dynamic> lines;
  final String? output;
  final String? rawText;
  final bool stripAnsi;
  final bool readOnly;
  final bool showInput;
  final bool clearOnSubmit;
  final bool autoFocus;
  final bool autoScroll;
  final bool wrapLines;
  final int maxLines;
  final String prompt;
  final String placeholder;
  final String submitLabel;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderWidth;
  final double radius;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITerminal({
    super.key,
    required this.controlId,
    required this.events,
    required this.lines,
    required this.output,
    required this.rawText,
    required this.stripAnsi,
    required this.readOnly,
    required this.showInput,
    required this.clearOnSubmit,
    required this.autoFocus,
    required this.autoScroll,
    required this.wrapLines,
    required this.maxLines,
    required this.prompt,
    required this.placeholder,
    required this.submitLabel,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
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
  State<ButterflyUITerminal> createState() => _ButterflyUITerminalState();
}

class _ButterflyUITerminalState extends State<ButterflyUITerminal> {
  late xterm.Terminal _terminal;
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  String _renderedSnapshot = '';
  bool _readOnly = false;

  @override
  void initState() {
    super.initState();
    _readOnly = widget.readOnly;
    _terminal = _createTerminal(maxLines: widget.maxLines);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    _syncTerminalBuffer(force: true);
  }

  @override
  void didUpdateWidget(covariant ButterflyUITerminal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (widget.maxLines != oldWidget.maxLines) {
      final nextTerminal = _createTerminal(maxLines: widget.maxLines);
      final snapshot = _renderedSnapshot;
      _terminal = nextTerminal;
      _renderedSnapshot = '';
      if (snapshot.isNotEmpty) {
        _appendText(snapshot, reset: true);
      }
    }
    _readOnly = widget.readOnly;
    _syncTerminalBuffer();
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  xterm.Terminal _createTerminal({required int maxLines}) {
    final terminal = xterm.Terminal(maxLines: maxLines);
    terminal.onOutput = (data) {
      if (_readOnly) return;
      widget.sendEvent(widget.controlId, 'input', {'data': data});
    };
    return terminal;
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'clear':
        _appendText('', reset: true);
        return null;
      case 'write':
      case 'append':
        final value = args['value']?.toString() ?? '';
        if (value.isNotEmpty) {
          _appendText(_normalizeOutput(value), reset: false);
        }
        return null;
      case 'append_lines':
        final raw = args['lines'];
        if (raw is List) {
          final lines = raw
              .map((item) => _lineFromEntry(item) ?? '')
              .where((line) => line.isNotEmpty)
              .join('\n');
          if (lines.isNotEmpty) {
            _appendText(_normalizeOutput(lines), reset: false);
          }
        }
        return null;
      case 'focus':
        _inputFocusNode.requestFocus();
        return null;
      case 'blur':
        _inputFocusNode.unfocus();
        return null;
      case 'set_input':
        final value = args['value']?.toString() ?? '';
        _inputController.text = value;
        return null;
      case 'set_read_only':
        _readOnly = args['value'] == true;
        setState(() {});
        return null;
      case 'get_value':
      case 'get_buffer':
        return _renderedSnapshot;
      case 'get_input':
        return _inputController.text;
      default:
        throw UnsupportedError('Unknown terminal method: $method');
    }
  }

  String? _lineFromEntry(Object? item) {
    if (item is Map) {
      final map = coerceObjectMap(item);
      return map['text']?.toString() ??
          map['line']?.toString() ??
          map['value']?.toString();
    }
    if (item == null) return null;
    final value = item.toString();
    return value.isEmpty ? null : value;
  }

  String _buildSnapshotFromProps() {
    final raw = widget.rawText?.trim();
    if (raw != null && raw.isNotEmpty) return raw;

    final directOutput = widget.output?.trim();
    if (directOutput != null && directOutput.isNotEmpty) return directOutput;

    final source = widget.lines.isNotEmpty ? widget.lines : widget.events;
    final out = <String>[];
    for (final item in source) {
      final line = _lineFromEntry(item);
      if (line != null && line.isNotEmpty) {
        out.add(line);
      }
    }
    return out.join('\n');
  }

  String _normalizeOutput(String value) {
    var normalized = value;
    if (widget.stripAnsi) {
      normalized = normalized.replaceAll(
        RegExp(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])'),
        '',
      );
    }
    return normalized;
  }

  void _appendText(String value, {required bool reset}) {
    final nextText = value;
    _renderedSnapshot = reset
        ? nextText
        : (_renderedSnapshot + (nextText.isEmpty ? '' : nextText));
    _terminal.write('\x1b[2J\x1b[H');
    if (_renderedSnapshot.isNotEmpty) {
      _terminal.write(_renderedSnapshot);
    }
  }

  void _syncTerminalBuffer({bool force = false}) {
    final snapshot = _normalizeOutput(_buildSnapshotFromProps());
    if (!force && snapshot == _renderedSnapshot) return;

    if (!force &&
        _renderedSnapshot.isNotEmpty &&
        snapshot.startsWith(_renderedSnapshot)) {
      final delta = snapshot.substring(_renderedSnapshot.length);
      if (delta.isNotEmpty) {
        _appendText(delta, reset: false);
      }
      return;
    }

    _appendText(snapshot, reset: true);
  }

  void _submit() {
    final value = _inputController.text;
    if (value.trim().isEmpty) return;
    widget.sendEvent(widget.controlId, 'submit', {'value': value});
    if (widget.clearOnSubmit) {
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _buildTerminalTheme(widget.backgroundColor, widget.textColor);
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: widget.borderColor != null && widget.borderWidth > 0
            ? Border.all(
                color: widget.borderColor!.withValues(alpha: 0.6),
                width: widget.borderWidth,
              )
            : null,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: xterm.TerminalView(
              _terminal,
              theme: theme,
              autofocus: widget.autoFocus,
              readOnly: _readOnly,
              textStyle: xterm.TerminalStyle(
                fontFamily: widget.fontFamily,
                fontSize: widget.fontSize,
                height: widget.lineHeight,
              ),
            ),
          ),
          if (widget.showInput)
            Container(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              decoration: BoxDecoration(
                color: widget.backgroundColor.withValues(alpha: 0.92),
                border: widget.borderColor != null && widget.borderWidth > 0
                    ? Border(
                        top: BorderSide(
                          color: widget.borderColor!.withValues(alpha: 0.5),
                          width: widget.borderWidth,
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  if (widget.prompt.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        widget.prompt,
                        style: TextStyle(
                          fontFamily: widget.fontFamily,
                          fontSize: widget.fontSize,
                          color: widget.textColor.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      focusNode: _inputFocusNode,
                      enabled: !_readOnly,
                      onChanged: (value) {
                        widget.sendEvent(widget.controlId, 'change', {
                          'value': value,
                        });
                      },
                      onSubmitted: (_) => _submit(),
                      style: TextStyle(
                        fontFamily: widget.fontFamily,
                        fontSize: widget.fontSize,
                        color: widget.textColor,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: widget.placeholder,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: widget.fontFamily,
                          color: widget.textColor.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: _readOnly ? null : _submit,
                    child: Text(widget.submitLabel),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

xterm.TerminalTheme _buildTerminalTheme(Color bg, Color fg) {
  Color blend(Color base, Color mix, double t) =>
      Color.lerp(base, mix, t) ?? base;
  const red = Color(0xffef4444);
  const green = Color(0xff22c55e);
  const yellow = Color(0xfff59e0b);
  const blue = Color(0xff3b82f6);
  const magenta = Color(0xffa855f7);
  const cyan = Color(0xff22d3ee);
  return xterm.TerminalTheme(
    background: bg,
    foreground: fg,
    cursor: fg,
    selection: fg.withValues(alpha: 0.25),
    black: bg,
    red: red,
    green: green,
    yellow: yellow,
    blue: blue,
    magenta: magenta,
    cyan: cyan,
    white: fg,
    brightBlack: blend(bg, Colors.white, 0.35),
    brightRed: blend(red, Colors.white, 0.2),
    brightGreen: blend(green, Colors.white, 0.2),
    brightYellow: blend(yellow, Colors.white, 0.2),
    brightBlue: blend(blue, Colors.white, 0.2),
    brightMagenta: blend(magenta, Colors.white, 0.2),
    brightCyan: blend(cyan, Colors.white, 0.2),
    brightWhite: blend(fg, Colors.white, 0.12),
    searchHitBackground: blend(blue, bg, 0.6),
    searchHitBackgroundCurrent: blend(magenta, bg, 0.55),
    searchHitForeground: fg,
  );
}

Widget buildTerminalControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUITerminal(
    controlId: controlId,
    events: props['events'] is List
        ? List<dynamic>.from(props['events'] as List)
        : const [],
    lines: props['lines'] is List
        ? List<dynamic>.from(props['lines'] as List)
        : const [],
    output: props['output']?.toString(),
    rawText: (props['raw_text'] ?? props['raw'])?.toString(),
    stripAnsi: props['strip_ansi'] == true,
    readOnly: props['read_only'] == true,
    showInput: props['show_input'] == null
        ? true
        : (props['show_input'] == true),
    clearOnSubmit: props['clear_on_submit'] == null
        ? true
        : (props['clear_on_submit'] == true),
    autoFocus: props['auto_focus'] == true || props['autofocus'] == true,
    autoScroll: props['auto_scroll'] == null
        ? true
        : (props['auto_scroll'] == true),
    wrapLines: props['wrap_lines'] == null
        ? true
        : (props['wrap_lines'] == true),
    maxLines: (coerceOptionalInt(props['max_lines']) ?? 4000).clamp(200, 20000),
    prompt: (props['prompt'] ?? '').toString(),
    placeholder: (props['placeholder'] ?? 'Type command...').toString(),
    submitLabel: (props['submit_label'] ?? 'Run').toString(),
    fontFamily: props['font_family']?.toString() ?? 'JetBrains Mono',
    fontSize: coerceDouble(props['font_size']) ?? 12,
    lineHeight: coerceDouble(props['line_height']) ?? 1.4,
    backgroundColor:
        coerceColor(props['bgcolor'] ?? props['background']) ??
        const Color(0xff050a06),
    textColor: coerceColor(props['text_color']) ?? const Color(0xffd1ffd6),
    borderColor: coerceColor(props['border_color']),
    borderWidth: coerceDouble(props['border_width']) ?? 0,
    radius: coerceDouble(props['radius']) ?? 10,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
