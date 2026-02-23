import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCropBoxControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _CropBoxControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _CropBoxControl extends StatefulWidget {
  const _CropBoxControl({
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
  State<_CropBoxControl> createState() => _CropBoxControlState();
}

class _CropBoxControlState extends State<_CropBoxControl> {
  Map<String, Object?> _rect = const <String, Object?>{};

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _CropBoxControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (!mapEquals(oldWidget.props, widget.props)) {
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    final raw = widget.props['rect'];
    if (raw is Map) {
      _rect = coerceObjectMap(raw);
    }
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_rect':
        if (args['rect'] is Map) {
          setState(() => _rect = coerceObjectMap(args['rect'] as Map));
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
        throw UnsupportedError('Unknown crop_box method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{'rect': _rect};

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

    final x = coerceDouble(_rect['x']) ?? 24;
    final y = coerceDouble(_rect['y']) ?? 24;
    final w = coerceDouble(_rect['width']) ?? 120;
    final h = coerceDouble(_rect['height']) ?? 90;

    return SizedBox(
      height: coerceDouble(widget.props['height']) ?? 220,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            left: x,
            top: y,
            width: w,
            height: h,
            child: GestureDetector(
              onTap: () => _emit('select', _statePayload()),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: coerceColor(widget.props['border_color']) ?? Colors.blueAccent,
                    width: coerceDouble(widget.props['border_width']) ?? 2,
                  ),
                  color: (coerceColor(widget.props['shade_color']) ?? Colors.black26).withValues(alpha: 0.18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
