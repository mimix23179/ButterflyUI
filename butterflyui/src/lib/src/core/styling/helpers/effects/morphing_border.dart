import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildMorphingBorderControl(
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
      final effective = resolveStylingHelperProps(
        liveProps,
        controlType: 'morphing_border',
      );
      Widget child = const SizedBox.shrink();
      for (final raw in rawChildren) {
        if (raw is Map) {
          child = buildChild(coerceObjectMap(raw));
          break;
        }
      }

      child = wrapWithEffectRenderLayers(
        controlId: controlId.isEmpty ? 'morphing_border' : '$controlId::layers',
        props: effective,
        child: child,
      );

      return _MorphingBorderFrame(
        controlId: controlId,
        props: effective,
        child: child,
      );
    },
  );
}

class _MorphingBorderFrame extends StatefulWidget {
  const _MorphingBorderFrame({
    required this.controlId,
    required this.props,
    required this.child,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;

  @override
  State<_MorphingBorderFrame> createState() => _MorphingBorderFrameState();
}

class _MorphingBorderFrameState extends State<_MorphingBorderFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _animate => widget.props['animate'] != false;

  Duration get _duration => Duration(
    milliseconds:
        ((coerceOptionalInt(
                  widget.props['duration_ms'] ?? widget.props['duration'],
                ) ??
                1200))
            .clamp(1, 600000),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _syncPlayback(forceStart: true);
  }

  @override
  void didUpdateWidget(covariant _MorphingBorderFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props != widget.props) {
      _controller.duration = _duration;
      _syncPlayback();
    }
  }

  void _syncPlayback({bool forceStart = false}) {
    if (!_animate) {
      _controller.stop();
      return;
    }
    if (forceStart || !_controller.isAnimating) {
      _controller.repeat(reverse: widget.props['ping_pong'] != false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minRadius = coerceDouble(widget.props['min_radius']) ?? 8;
    final maxRadius = coerceDouble(widget.props['max_radius']) ?? 24;
    final color = coerceColor(widget.props['color']) ?? const Color(0xff60a5fa);
    final accent =
        coerceColor(widget.props['accent_color']) ?? const Color(0xff8b5cf6);
    final width = coerceDouble(widget.props['width']) ?? 1.6;
    final padding =
        coercePadding(widget.props['padding']) ?? const EdgeInsets.all(8);
    final glow = widget.props['glow'] == true;

    return AnimatedBuilder(
      animation: _controller,
      child: Padding(padding: padding, child: widget.child),
      builder: (context, child) {
        final curve = Curves.easeInOut.transform(_controller.value);
        final radius = ui.lerpDouble(minRadius, maxRadius, curve) ?? maxRadius;
        Widget built = CustomPaint(
          foregroundPainter: _MorphingBorderPainter(
            radius: radius,
            color: color,
            accent: accent,
            width: width,
            progress: _controller.value,
            variant: (widget.props['variant'] ?? 'morph').toString(),
            glow: glow,
          ),
          child: child,
        );

        if (glow) {
          built = DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(math.max(0, radius)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: accent.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: built,
          );
        }
        return built;
      },
    );
  }
}

class _MorphingBorderPainter extends CustomPainter {
  const _MorphingBorderPainter({
    required this.radius,
    required this.color,
    required this.accent,
    required this.width,
    required this.progress,
    required this.variant,
    required this.glow,
  });

  final double radius;
  final Color color;
  final Color accent;
  final double width;
  final double progress;
  final String variant;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = (Offset.zero & size).deflate(width / 2);
    final animatedRadius =
        radius * (0.9 + (math.sin(progress * math.pi * 2) + 1) * 0.08);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(math.max(0, animatedRadius)),
        ),
      );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final normalized = variant.toLowerCase();
    if (normalized == 'rainbow' ||
        normalized == 'liquid' ||
        normalized == 'morph') {
      paint.shader = SweepGradient(
        colors: <Color>[color, accent, color],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(rect);
    } else if (normalized == 'pulse') {
      paint.color = Color.lerp(
        color,
        accent,
        (math.sin(progress * math.pi * 2) + 1) * 0.5,
      )!;
    } else {
      paint.color = color;
    }

    if (glow) {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MorphingBorderPainter oldDelegate) {
    return radius != oldDelegate.radius ||
        color != oldDelegate.color ||
        accent != oldDelegate.accent ||
        width != oldDelegate.width ||
        progress != oldDelegate.progress ||
        variant != oldDelegate.variant ||
        glow != oldDelegate.glow;
  }
}
