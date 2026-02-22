import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/overlay/slide_panel.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildBottomSheetControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _BottomSheetControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _BottomSheetControl extends StatefulWidget {
  const _BottomSheetControl({
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
  State<_BottomSheetControl> createState() => _BottomSheetControlState();
}

class _BottomSheetControlState extends State<_BottomSheetControl> {
  late bool _open;

  @override
  void initState() {
    super.initState();
    _open = widget.props['open'] == true;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _BottomSheetControl oldWidget) {
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
      _open = widget.props['open'] == true;
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
      case 'set_open':
        setState(() => _open = args['value'] == true);
        _emit('state', {'open': _open});
        return <String, Object?>{'open': _open};
      case 'get_state':
        return <String, Object?>{'open': _open};
      case 'emit':
        final event = (args['event'] ?? 'state').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown bottom_sheet method: $method');
    }
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

    final height = coerceDouble(widget.props['height']) ?? (MediaQuery.of(context).size.height * 0.35);

    return ButterflyUISlidePanel(
      controlId: widget.controlId,
      child: child,
      open: _open,
      side: 'bottom',
      size: height,
      scrimColor: coerceColor(widget.props['scrim_color']),
      dismissible: widget.props['dismissible'] == null || widget.props['dismissible'] == true,
      sendEvent: widget.sendEvent,
    );
  }
}
