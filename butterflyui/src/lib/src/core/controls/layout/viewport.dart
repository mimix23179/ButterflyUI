import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildViewportControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _ViewportControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    child: child,
  );
}

class _ViewportControl extends StatefulWidget {
  const _ViewportControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.child,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final Widget child;

  @override
  State<_ViewportControl> createState() => _ViewportControlState();
}

class _ViewportControlState extends State<_ViewportControl> {
  late double _x;
  late double _y;

  @override
  void initState() {
    super.initState();
    _x = coerceDouble(widget.props['x']) ?? 0;
    _y = coerceDouble(widget.props['y']) ?? 0;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ViewportControl oldWidget) {
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
      case 'set_offset':
        setState(() {
          _x = coerceDouble(args['x']) ?? _x;
          _y = coerceDouble(args['y']) ?? _y;
        });
        return _state();
      case 'get_state':
        return _state();
      default:
        throw UnsupportedError('Unknown viewport method: $method');
    }
  }

  Map<String, Object?> _state() => <String, Object?>{'x': _x, 'y': _y};

  @override
  Widget build(BuildContext context) {
    final width = coerceDouble(widget.props['width']);
    final height = coerceDouble(widget.props['height']);
    final clip = widget.props['clip'] == null || widget.props['clip'] == true;

    Widget shifted = Transform.translate(offset: Offset(-_x, -_y), child: widget.child);
    if (clip) {
      shifted = ClipRect(child: shifted);
    }

    return SizedBox(
      width: width,
      height: height,
      child: shifted,
    );
  }
}
