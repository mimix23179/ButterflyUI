import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAlignControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AlignControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _AlignControl extends StatefulWidget {
  const _AlignControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_AlignControl> createState() => _AlignControlState();
}

class _AlignControlState extends State<_AlignControl> {
  late Alignment _alignment;

  @override
  void initState() {
    super.initState();
    _alignment = _parseAlignment(widget.props['alignment']) ?? Alignment.center;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _AlignControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _alignment = _parseAlignment(widget.props['alignment']) ?? Alignment.center;
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
      case 'set_alignment':
        final next = _parseAlignment(args['alignment']);
        if (next != null) {
          setState(() => _alignment = next);
          _emit('change', _statePayload());
        }
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown align method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'alignment': <String, Object?>{'x': _alignment.x, 'y': _alignment.y}};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }

    return Align(
      alignment: _alignment,
      widthFactor: coerceDouble(widget.props['width_factor']),
      heightFactor: coerceDouble(widget.props['height_factor']),
      child: child,
    );
  }
}

Alignment? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    final x = coerceDouble(value[0]) ?? 0.0;
    final y = coerceDouble(value[1]) ?? 0.0;
    return Alignment(x, y);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    final x = coerceDouble(map['x']);
    final y = coerceDouble(map['y']);
    if (x != null || y != null) {
      return Alignment(x ?? 0.0, y ?? 0.0);
    }
  }
  switch (value.toString().toLowerCase().replaceAll('-', '_')) {
    case 'top_left':
      return Alignment.topLeft;
    case 'top_center':
    case 'top':
      return Alignment.topCenter;
    case 'top_right':
      return Alignment.topRight;
    case 'center_left':
    case 'left':
      return Alignment.centerLeft;
    case 'center_right':
    case 'right':
      return Alignment.centerRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_center':
    case 'bottom':
      return Alignment.bottomCenter;
    case 'bottom_right':
      return Alignment.bottomRight;
    case 'center':
      return Alignment.center;
  }
  return null;
}
