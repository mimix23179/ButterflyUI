import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCodeViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _CodeViewControl(
    controlId: controlId,
    initialProps: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _CodeViewControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> initialProps;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _CodeViewControl({
    required this.controlId,
    required this.initialProps,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_CodeViewControl> createState() => _CodeViewControlState();
}

class _CodeViewControlState extends State<_CodeViewControl> {
  late String _value =
      (widget.initialProps['value'] ?? widget.initialProps['text'] ?? '')
          .toString();

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _CodeViewControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.initialProps != widget.initialProps) {
      _value = (widget.initialProps['value'] ?? widget.initialProps['text'] ?? '')
          .toString();
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _value;
      case 'set_value':
        setState(() {
          _value = (args['value'] ?? '').toString();
        });
        return null;
      case 'emit':
        final event = (args['event'] ?? '').toString().trim();
        if (event.isEmpty) return null;
        final payload = args['payload'];
        widget.sendEvent(
          widget.controlId,
          event,
          payload is Map ? coerceObjectMap(payload) : <String, Object?>{},
        );
        return null;
      default:
        throw UnsupportedError('Unknown code_view method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.initialProps;
    final value = _value;
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
    final borderWidth = coerceDouble(props['border_width']) ?? 0.0;
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
        border: borderWidth > 0
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: codeText,
    );
  }
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
