import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildViewStackControl(
  String controlId,
  Map<String, Object?> props,
  List<Widget> children,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ViewStackControl(
    controlId: controlId,
    props: props,
    children: children,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ViewStackControl extends StatefulWidget {
  const _ViewStackControl({
    required this.controlId,
    required this.props,
    required this.children,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<Widget> children;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ViewStackControl> createState() => _ViewStackControlState();
}

class _ViewStackControlState extends State<_ViewStackControl> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = coerceOptionalInt(widget.props['index']) ?? 0;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ViewStackControl oldWidget) {
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
      case 'set_index':
        setState(() {
          _index = coerceOptionalInt(args['index']) ?? _index;
        });
        return _state();
      case 'get_state':
        return _state();
      default:
        throw UnsupportedError('Unknown view_stack method: $method');
    }
  }

  Map<String, Object?> _state() => <String, Object?>{'index': _index, 'count': widget.children.length};

  @override
  Widget build(BuildContext context) {
    final safeIndex = widget.children.isEmpty
        ? 0
        : _index.clamp(0, widget.children.length - 1);
    final animate = widget.props['animate'] == true;

    if (widget.children.isEmpty) return const SizedBox.shrink();

    if (!animate) {
      return IndexedStack(index: safeIndex, children: widget.children);
    }

    final duration = Duration(milliseconds: coerceOptionalInt(widget.props['duration_ms']) ?? 240);

    return AnimatedSwitcher(
      duration: duration,
      child: KeyedSubtree(
        key: ValueKey<int>(safeIndex),
        child: widget.children[safeIndex],
      ),
    );
  }
}
