import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/effects.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildVignetteControl(
  String controlId,
  Map<String, Object?> props,
  Widget child, {
  required Color defaultColor,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
}) {
  return _VignetteControl(
    controlId: controlId,
    props: props,
    child: child,
    defaultColor: defaultColor,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}

class _VignetteControl extends StatefulWidget {
  const _VignetteControl({
    required this.controlId,
    required this.props,
    required this.child,
    required this.defaultColor,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final Color defaultColor;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_VignetteControl> createState() => _VignetteControlState();
}

class _VignetteControlState extends State<_VignetteControl> {
  late double _intensity;
  late Color _color;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _intensity = (coerceDouble(widget.props['intensity'] ?? widget.props['opacity']) ?? 0.45)
        .clamp(0.0, 1.0);
    _color = coerceColor(widget.props['color']) ?? widget.defaultColor;
    _enabled = widget.props['enabled'] == null ? true : (widget.props['enabled'] == true);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _VignetteControl oldWidget) {
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
        return {'intensity': _intensity, 'enabled': _enabled};
      case 'set_style':
        setState(() {
          _intensity = (coerceDouble(args['intensity'] ?? args['opacity']) ?? _intensity)
              .clamp(0.0, 1.0);
          _color = coerceColor(args['color']) ?? _color;
          _enabled = args['enabled'] == null ? _enabled : (args['enabled'] == true);
        });
        return null;
      default:
        throw UnsupportedError('Unknown vignette method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return widget.child;
    return ButterflyUIVignette(
      child: widget.child,
      intensity: _intensity,
      color: _color,
    );
  }
}
