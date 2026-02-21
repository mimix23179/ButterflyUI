import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildCodeViewControl(Map<String, Object?> props) {
  final value = (props['value'] ?? props['text'] ?? '').toString();
  final selectable = props['selectable'] == null
      ? true
      : (props['selectable'] == true);
  final wrap = props['wrap'] == true || props['word_wrap'] == true;
  final showLineNumbers =
      props['show_line_numbers'] == true || props['line_numbers'] == true;
  final scrollable = props['scrollable'] == null
      ? true
      : (props['scrollable'] == true);

  final fontSize = coerceDouble(props['font_size']) ?? 13;
  final radius = coerceDouble(props['radius']) ?? 10;
  final borderWidth = coerceDouble(props['border_width']) ?? 1.0;
  final bg =
      coerceColor(props['bgcolor'] ?? props['background']) ??
      const Color(0xff0f172a);
  final fg = coerceColor(props['text_color']) ?? const Color(0xffe2e8f0);
  final borderColor =
      coerceColor(props['border_color']) ?? const Color(0xff334155);
  final padding =
      coercePadding(props['content_padding'] ?? props['padding']) ??
      const EdgeInsets.all(12);

  final withNumbers = showLineNumbers ? _withLineNumbers(value) : value;

  Widget codeText = selectable
      ? SelectableText(
          withNumbers,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: fontSize,
            color: fg,
            height: 1.35,
          ),
        )
      : Text(
          withNumbers,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: fontSize,
            color: fg,
            height: 1.35,
          ),
          softWrap: wrap,
        );

  if (!wrap) {
    codeText = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: codeText,
    );
  }
  if (scrollable) {
    codeText = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: codeText,
    );
  }

  return Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
    ),
    child: codeText,
  );
}

String _withLineNumbers(String text) {
  if (text.isEmpty) return '';
  final lines = text.split('\n');
  final width = lines.length.toString().length;
  final out = StringBuffer();
  for (var i = 0; i < lines.length; i += 1) {
    final index = (i + 1).toString().padLeft(width, ' ');
    out.writeln('$index | ${lines[i]}');
  }
  return out.toString().trimRight();
}
