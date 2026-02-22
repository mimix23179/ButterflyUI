import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _BorderControl extends StatefulWidget {
  const _BorderControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?>) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_BorderControl> createState() => _BorderControlState();
}

class _BorderControlState extends State<_BorderControl> {
  late Color _color;
  late double _width;
  late double _radius;
  late String _side;

  @override
  void initState() {
    super.initState();
    _color =
        coerceColor(widget.props['color'] ?? widget.props['border_color']) ??
            const Color(0xff64748b);
    _width = coerceDouble(widget.props['width'] ?? widget.props['border_width']) ?? 1;
    _radius = coerceDouble(widget.props['radius']) ?? 0;
    _side = (widget.props['side'] ?? 'all').toString().toLowerCase();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _BorderControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_style':
        setState(() {
          _color = coerceColor(args['color']) ?? _color;
          _width = coerceDouble(args['width']) ?? _width;
          _radius = coerceDouble(args['radius']) ?? _radius;
          _side = (args['side'] ?? _side).toString().toLowerCase();
        });
        return null;
      default:
        throw UnsupportedError('Unknown border method: $method');
    }
  }

  Border _buildBorder() {
    final side = BorderSide(color: _color, width: _width);
    switch (_side) {
      case 'top':
        return Border(top: side);
      case 'left':
        return Border(left: side);
      case 'right':
        return Border(right: side);
      case 'bottom':
        return Border(bottom: side);
      default:
        return Border.all(color: _color, width: _width);
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        coercePadding(widget.props['padding']) ?? const EdgeInsets.all(8);
    Widget child = const SizedBox.shrink();
    if (widget.rawChildren.isNotEmpty && widget.rawChildren.first is Map) {
      child = widget.buildChild(coerceObjectMap(widget.rawChildren.first as Map));
    }
    return Container(
      decoration: BoxDecoration(
        border: _buildBorder(),
        borderRadius: BorderRadius.circular(_radius),
      ),
      padding: padding,
      child: child,
    );
  }
}

Widget buildBorderControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _BorderControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
