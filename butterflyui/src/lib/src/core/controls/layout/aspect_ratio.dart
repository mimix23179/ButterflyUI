import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/layout_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAspectRatioControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AspectRatioControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _AspectRatioControl extends StatefulWidget {
  const _AspectRatioControl({
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
  State<_AspectRatioControl> createState() => _AspectRatioControlState();
}

class _AspectRatioControlState extends State<_AspectRatioControl> {
  late double _ratio;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant _AspectRatioControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (oldWidget.props != widget.props) {
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    super.dispose();
  }

  void _syncFromProps() {
    final ratio =
        coerceDouble(widget.props['ratio'] ?? widget.props['aspect_ratio']) ??
        1.0;
    _ratio = ratio <= 0 ? 1.0 : ratio;
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'ratio': _ratio};
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_ratio':
      case 'set_layout':
        final next =
            coerceDouble(args['ratio'] ?? args['aspect_ratio']) ?? _ratio;
        setState(() {
          _ratio = next <= 0 ? 1.0 : next;
        });
        return _statePayload();
      case 'get_state':
      case 'get_layout':
        return _statePayload();
      default:
        throw UnsupportedError('Unknown aspect_ratio method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = firstControlChildMap(widget.rawChildren, props: widget.props);
    return AspectRatio(
      aspectRatio: _ratio,
      child: child == null ? const SizedBox.shrink() : widget.buildChild(child),
    );
  }
}
