import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildMarkdownViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _MarkdownViewControl(
    controlId: controlId,
    initialProps: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _MarkdownViewControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> initialProps;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _MarkdownViewControl({
    required this.controlId,
    required this.initialProps,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_MarkdownViewControl> createState() => _MarkdownViewControlState();
}

class _MarkdownViewControlState extends State<_MarkdownViewControl> {
  late String _value =
      (widget.initialProps['value'] ?? widget.initialProps['text'] ?? '')
          .toString();

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _MarkdownViewControl oldWidget) {
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
        throw UnsupportedError('Unknown markdown method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.initialProps;
    final value = _value;
    final selectable = props['selectable'] == true;
    final scrollable = props['scrollable'] == null
      ? true
      : (props['scrollable'] == true);
    final useFlutterMarkdown = props['use_flutter_markdown'] == null
      ? true
      : (props['use_flutter_markdown'] == true);
    final padding = coercePadding(props['content_padding'] ?? props['padding']);

    if (value.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!useFlutterMarkdown) {
      Widget fallback = selectable
          ? SelectableText(value)
          : Text(value, softWrap: true);
      if (padding != null) {
        fallback = Padding(padding: padding, child: fallback);
      }
      if (!scrollable) {
        return fallback;
      }
      return SingleChildScrollView(child: fallback);
    }

    if (!scrollable) {
      Widget body = MarkdownBody(data: value, selectable: selectable);
      if (padding != null) {
        body = Padding(padding: padding, child: body);
      }
      return body;
    }

    return Markdown(
      data: value,
      selectable: selectable,
      shrinkWrap: props['shrink_wrap'] == true,
      padding: padding ?? EdgeInsets.zero,
    );
  }
}
