import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/effects/visuals/visual_effects.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildScanlineOverlayControl(
  String controlId,
  Map<String, Object?> props,
  Widget child, {
  required Color defaultText,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
}) {
  final resolved = resolveStylingHelperProps(
    props,
    controlType: 'scanline_overlay',
  );
  return wrapWithEffectRenderLayers(
    controlId: controlId.isEmpty
        ? 'scanline_overlay::layers'
        : '$controlId::layers',
    props: resolved,
    child: _ScanlineOverlayControl(
      controlId: controlId,
      props: resolved,
      defaultText: defaultText,
      registerInvokeHandler: registerInvokeHandler,
      unregisterInvokeHandler: unregisterInvokeHandler,
      child: child,
    ),
  );
}

class _ScanlineOverlayControl extends StatefulWidget {
  const _ScanlineOverlayControl({
    required this.controlId,
    required this.props,
    required this.child,
    required this.defaultText,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final Color defaultText;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_ScanlineOverlayControl> createState() => _ScanlineOverlayControlState();
}

class _ScanlineOverlayControlState extends State<_ScanlineOverlayControl> {
  late double _spacing;
  late double _thickness;
  late double _opacity;
  late Color _color;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _spacing = (coerceDouble(widget.props['spacing'] ?? widget.props['line_spacing']) ?? 6)
        .clamp(1.0, 256.0);
    _thickness = (coerceDouble(widget.props['thickness'] ?? widget.props['line_thickness']) ?? 1)
        .clamp(0.5, 32.0);
    _opacity = (coerceDouble(widget.props['opacity']) ?? 0.18).clamp(0.0, 1.0);
    _color = coerceColor(widget.props['color']) ?? widget.defaultText;
    _enabled = widget.props['enabled'] == null ? true : (widget.props['enabled'] == true);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ScanlineOverlayControl oldWidget) {
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
          'spacing': _spacing,
          'thickness': _thickness,
          'opacity': _opacity,
          'enabled': _enabled,
        };
      case 'set_style':
        setState(() {
          _spacing = (coerceDouble(args['spacing']) ?? _spacing).clamp(1.0, 256.0);
          _thickness = (coerceDouble(args['thickness']) ?? _thickness).clamp(0.5, 32.0);
          _opacity = (coerceDouble(args['opacity']) ?? _opacity).clamp(0.0, 1.0);
          _color = coerceColor(args['color']) ?? _color;
          _enabled = args['enabled'] == null ? _enabled : (args['enabled'] == true);
        });
        return null;
      default:
        throw UnsupportedError('Unknown scanline_overlay method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return widget.child;
    return ButterflyUIScanlineOverlay(
      spacing: _spacing,
      thickness: _thickness,
      opacity: _opacity,
      color: _color,
      child: widget.child,
    );
  }
}
