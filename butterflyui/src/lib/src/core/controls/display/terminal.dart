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
  final String prompt;
  final String placeholder;
  final String submitLabel;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double radius;
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
    required this.prompt,
    required this.placeholder,
    required this.submitLabel,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.radius,
    required this.sendEvent,
  });

  @override
  State<ButterflyUITerminal> createState() => _ButterflyUITerminalState();
}

class _ButterflyUITerminalState extends State<ButterflyUITerminal> {
  late final xterm.Terminal _terminal = xterm.Terminal(maxLines: 4000);
  final TextEditingController _inputController = TextEditingController();
  String _lastSnapshot = '';

  @override
  void initState() {
    super.initState();
    _terminal.onOutput = (data) {
      if (widget.readOnly) return;
      widget.sendEvent(widget.controlId, 'input', {'data': data});
    };
    _syncTerminalBuffer();
  }

  @override
  void didUpdateWidget(covariant ButterflyUITerminal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTerminalBuffer();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String _buildOutputSnapshot() {
    final raw = widget.rawText?.trim();
    if (raw != null && raw.isNotEmpty) return raw;
    final directOutput = widget.output?.trim();
    if (directOutput != null && directOutput.isNotEmpty) return directOutput;
    final buffer = StringBuffer();
    final source = widget.lines.isNotEmpty ? widget.lines : widget.events;
    for (final item in source) {
      if (item is Map) {
        final line =
            item['text']?.toString() ??
            item['line']?.toString() ??
            item['value']?.toString();
        if (line != null && line.isNotEmpty) buffer.writeln(line);
      } else if (item != null) {
        final line = item.toString();
        if (line.isNotEmpty) buffer.writeln(line);
      }
    }
    return buffer.toString();
  }

  void _syncTerminalBuffer() {
    var snapshot = _buildOutputSnapshot();
    if (widget.stripAnsi) {
      snapshot = snapshot.replaceAll(
        RegExp(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])'),
        '',
      );
    }
    if (snapshot == _lastSnapshot) return;
    _lastSnapshot = snapshot;
    _terminal.write('\x1b[2J\x1b[H');
    if (snapshot.isNotEmpty) {
      _terminal.write(snapshot);
    }
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
        border: Border.all(color: widget.borderColor.withOpacity(0.6)),
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
              readOnly: widget.readOnly,
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
                color: widget.backgroundColor.withOpacity(0.92),
                border: Border(
                  top: BorderSide(color: widget.borderColor.withOpacity(0.5)),
                ),
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
                          color: widget.textColor.withOpacity(0.85),
                        ),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      enabled: !widget.readOnly,
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
                          color: widget.textColor.withOpacity(0.45),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: widget.readOnly ? null : _submit,
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
    selection: fg.withOpacity(0.25),
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
    borderColor: coerceColor(props['border_color']) ?? const Color(0xff1e293b),
    radius: coerceDouble(props['radius']) ?? 10,
    sendEvent: sendEvent,
  );
}
