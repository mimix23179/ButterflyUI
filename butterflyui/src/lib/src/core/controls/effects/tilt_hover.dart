import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTiltHoverControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _TiltHoverControl(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
    child: child,
  );
}

class _TiltHoverControl extends StatefulWidget {
  const _TiltHoverControl({
    required this.controlId,
    required this.props,
    required this.sendEvent,
    required this.child,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget child;

  @override
  State<_TiltHoverControl> createState() => _TiltHoverControlState();
}

class _TiltHoverControlState extends State<_TiltHoverControl> {
  Offset _normalized = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    if (!enabled) return widget.child;

    final maxTilt = coerceDouble(widget.props['max_tilt']) ?? 10.0;
    final perspective = coerceDouble(widget.props['perspective']) ?? 0.0012;
    final scale = coerceDouble(widget.props['scale']) ?? 1.0;
    final resetOnExit = widget.props['reset_on_exit'] == null || widget.props['reset_on_exit'] == true;

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
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, 'hover', {
            'x': local.dx,
            'y': local.dy,
            'tilt_x': _normalized.dy * maxTilt,
            'tilt_y': -_normalized.dx * maxTilt,
          });
        }
      },
      onExit: (_) {
        if (!resetOnExit) return;
        setState(() {
          _normalized = Offset.zero;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspective)
          ..rotateX((_normalized.dy * maxTilt) * (math.pi / 180.0))
          ..rotateY((-_normalized.dx * maxTilt) * (math.pi / 180.0))
          ..scale(scale),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
