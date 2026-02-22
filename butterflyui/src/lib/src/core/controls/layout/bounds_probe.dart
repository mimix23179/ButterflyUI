import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildBoundsProbeControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _BoundsProbeControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _BoundsProbeControl extends StatefulWidget {
  const _BoundsProbeControl({
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
  State<_BoundsProbeControl> createState() => _BoundsProbeControlState();
}

class _BoundsProbeControlState extends State<_BoundsProbeControl> {
  final GlobalKey _key = GlobalKey();
  Map<String, Object?> _bounds = const <String, Object?>{};

  @override
  void initState() {
    super.initState();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAndEmit(initial: true));
  }

  @override
  void didUpdateWidget(covariant _BoundsProbeControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAndEmit(initial: false));
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
      case 'get_bounds':
        _measureAndEmit(initial: false, force: true);
        return _bounds;
      case 'emit':
        final event = (args['event'] ?? 'bounds').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown bounds_probe method: $method');
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _measureAndEmit({required bool initial, bool force = false}) {
    if (widget.props['enabled'] == false) return;
    final context = _key.currentContext;
    if (context == null) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final offset = box.localToGlobal(Offset.zero);
    final next = <String, Object?>{
      'x': offset.dx,
      'y': offset.dy,
      'width': box.size.width,
      'height': box.size.height,
    };
    final changed = force || next.toString() != _bounds.toString();
    _bounds = next;
    final emitInitial = widget.props['emit_initial'] == true;
    final emitOnChange = widget.props['emit_on_change'] == null || widget.props['emit_on_change'] == true;
    if ((initial && emitInitial) || (!initial && emitOnChange && changed)) {
      _emit('bounds', next);
    }
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
    return Container(key: _key, child: child);
  }
}
