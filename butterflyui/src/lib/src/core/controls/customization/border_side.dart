import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _BorderSideControl extends StatefulWidget {
  const _BorderSideControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_BorderSideControl> createState() => _BorderSideControlState();
}

class _BorderSideControlState extends State<_BorderSideControl> {
  late String _side;
  late Color _color;
  late double _width;
  late double _length;

  @override
  void initState() {
    super.initState();
    _side = (widget.props['side'] ?? 'bottom').toString().toLowerCase();
    _color = coerceColor(widget.props['color']) ?? const Color(0xff64748b);
    _width = coerceDouble(widget.props['width']) ?? 1;
    _length = coerceDouble(widget.props['length']) ?? double.infinity;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _BorderSideControl oldWidget) {
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
          _side = (args['side'] ?? _side).toString().toLowerCase();
          _color = coerceColor(args['color']) ?? _color;
          _width = coerceDouble(args['width']) ?? _width;
          _length = coerceDouble(args['length']) ?? _length;
        });
        return null;
      default:
        throw UnsupportedError('Unknown border_side method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    Border border;
    switch (_side) {
      case 'top':
        border = Border(top: BorderSide(color: _color, width: _width));
        break;
      case 'left':
        border = Border(left: BorderSide(color: _color, width: _width));
        break;
      case 'right':
        border = Border(right: BorderSide(color: _color, width: _width));
        break;
      default:
        border = Border(bottom: BorderSide(color: _color, width: _width));
        break;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: _length,
        child: DecoratedBox(
          decoration: BoxDecoration(border: border),
          child: const SizedBox(height: 1),
        ),
      ),
    );
  }
}

Widget buildBorderSideControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _BorderSideControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
