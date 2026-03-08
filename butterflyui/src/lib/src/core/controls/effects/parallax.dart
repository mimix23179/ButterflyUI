import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildParallaxControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild, {
  String controlId = '',
  ButterflyUIRegisterInvokeHandler? registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent? sendEvent,
}) {
  return buildRuntimePropsControl(
    props: props,
    controlId: controlId,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    builder: (liveProps) {
      Widget child = const SizedBox.shrink();
      if (rawChildren.isNotEmpty && rawChildren.first is Map) {
        child = buildChild(coerceObjectMap(rawChildren.first as Map));
      } else if (liveProps['child'] is Map) {
        child = buildChild(coerceObjectMap(liveProps['child'] as Map));
      }

      return _ParallaxControl(props: liveProps, child: child);
    },
  );
}

class _ParallaxControl extends StatefulWidget {
  const _ParallaxControl({required this.props, required this.child});

  final Map<String, Object?> props;
  final Widget child;

  @override
  State<_ParallaxControl> createState() => _ParallaxControlState();
}

class _ParallaxControlState extends State<_ParallaxControl> {
  Offset _normalized = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final maxOffset = (coerceDouble(widget.props['max_offset']) ?? 14.0).clamp(
      0.0,
      200.0,
    );
    final resetOnExit = widget.props['reset_on_exit'] != false;

    return MouseRegion(
      onHover: (event) {
        final box = context.findRenderObject();
        if (box is! RenderBox) return;
        final local = box.globalToLocal(event.position);
        final size = box.size;
        if (size.width <= 0 || size.height <= 0) return;
        final dx = ((local.dx / size.width) * 2) - 1;
        final dy = ((local.dy / size.height) * 2) - 1;
        setState(() {
          _normalized = Offset(dx.clamp(-1.0, 1.0), dy.clamp(-1.0, 1.0));
        });
      },
      onExit: (_) {
        if (!resetOnExit) return;
        setState(() {
          _normalized = Offset.zero;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        transform: Matrix4.identity()
          ..translateByDouble(
            _normalized.dx * maxOffset,
            _normalized.dy * maxOffset,
            0,
            1,
          ),
        child: widget.child,
      ),
    );
  }
}
