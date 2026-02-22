import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _DividerControl extends StatefulWidget {
  const _DividerControl({
    required this.controlId,
    required this.props,
    required this.fallbackColor,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Color? fallbackColor;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_DividerControl> createState() => _DividerControlState();
}

class _DividerControlState extends State<_DividerControl> {
  late bool _vertical;
  late double? _thickness;
  late double? _indent;
  late double? _endIndent;
  late Color? _color;

  @override
  void initState() {
    super.initState();
    _vertical = widget.props['vertical'] == true;
    _thickness = coerceDouble(widget.props['thickness']);
    _indent = coerceDouble(widget.props['indent']);
    _endIndent = coerceDouble(widget.props['end_indent']);
    _color = coerceColor(widget.props['color']) ?? widget.fallbackColor;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _DividerControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return {
          'vertical': _vertical,
          'thickness': _thickness,
          'indent': _indent,
          'end_indent': _endIndent,
        };
      case 'set_style':
        setState(() {
          _vertical = args['vertical'] == true ? true : _vertical;
          _thickness = coerceDouble(args['thickness']) ?? _thickness;
          _indent = coerceDouble(args['indent']) ?? _indent;
          _endIndent = coerceDouble(args['end_indent']) ?? _endIndent;
          _color = coerceColor(args['color']) ?? _color;
        });
        return null;
      default:
        throw UnsupportedError('Unknown divider method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _vertical
        ? VerticalDivider(
            thickness: _thickness,
            width: _thickness,
            indent: _indent,
            endIndent: _endIndent,
            color: _color,
          )
        : Divider(
            thickness: _thickness,
            indent: _indent,
            endIndent: _endIndent,
            color: _color,
          );
  }
}

Widget buildDividerControl(
  String controlId,
  Map<String, Object?> props,
  List children,
  Widget Function(Map<String, Object?> child) buildFromControl, {
  Color? fallbackColor,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
}) {
  return _DividerControl(
    controlId: controlId,
    props: props,
    fallbackColor: fallbackColor,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}