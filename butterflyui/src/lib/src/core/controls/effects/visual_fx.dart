import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGlowEffectControl(
  Map<String, Object?> props,
  Widget child,
) {
  final color = coerceColor(props['color']) ?? const Color(0x8800FFFF);
  final blur = coerceDouble(props['blur']) ?? 16;
  final spread = coerceDouble(props['spread']) ?? 0;
  final radius = coerceDouble(props['radius']) ?? 12;
  final offsetX = coerceDouble(props['offset_x']) ?? 0;
  final offsetY = coerceDouble(props['offset_y']) ?? 0;
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: color,
          blurRadius: blur,
          spreadRadius: spread,
          offset: Offset(offsetX, offsetY),
        ),
      ],
    ),
    child: child,
  );
}

Widget buildGlassBlurControl(
  Map<String, Object?> props,
  Widget child,
) {
  final blur = coerceDouble(props['blur']) ?? 14;
  final opacity = coerceDouble(props['opacity']) ?? 0.16;
  final color = coerceColor(props['color']) ?? Colors.white;
  final radius = coerceDouble(props['radius']) ?? 12;
  final borderColor = coerceColor(props['border_color']);
  final borderWidth = coerceDouble(props['border_width']) ?? 1;

  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
          borderRadius: BorderRadius.circular(radius),
          border: borderColor == null ? null : Border.all(color: borderColor, width: borderWidth),
        ),
        child: child,
      ),
    ),
  );
}

Widget buildChromaticShiftControl(
  Map<String, Object?> props,
  Widget child,
) {
  final shift = coerceDouble(props['shift']) ?? 1.2;
  final opacity = (coerceDouble(props['opacity']) ?? 0.35).clamp(0, 1).toDouble();
  return Stack(
    children: [
      Transform.translate(
        offset: Offset(-shift, 0),
        child: Opacity(
          opacity: opacity,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.modulate),
            child: child,
          ),
        ),
      ),
      Transform.translate(
        offset: Offset(shift, 0),
        child: Opacity(
          opacity: opacity,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.modulate),
            child: child,
          ),
        ),
      ),
      child,
    ],
  );
}

Widget buildGradientSweepControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _GradientSweepControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    child: child,
  );
}

class _GradientSweepControl extends StatefulWidget {
  const _GradientSweepControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    required this.child,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget child;

  @override
  State<_GradientSweepControl> createState() => _GradientSweepControlState();
}

class _GradientSweepControlState extends State<_GradientSweepControl> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    _updateTiming();
    _controller.repeat();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _GradientSweepControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    _updateTiming();
  }

  void _updateTiming() {
    final durationMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 1800).clamp(1, 600000);
    _controller.duration = Duration(milliseconds: durationMs);
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'play':
        _controller.repeat();
        return true;
      case 'pause':
        _controller.stop();
        return true;
      default:
        throw UnsupportedError('Unknown gradient_sweep method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _coerceColors(widget.props['colors']);
    final opacity = (coerceDouble(widget.props['opacity']) ?? 0.6).clamp(0, 1).toDouble();
    final baseAngle = (coerceDouble(widget.props['angle']) ?? 0) * math.pi / 180;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final angle = baseAngle + (_controller.value * 2 * math.pi);
        return ShaderMask(
          shaderCallback: (rect) => SweepGradient(
            colors: colors,
            transform: GradientRotation(angle),
          ).createShader(rect),
          blendMode: BlendMode.srcATop,
          child: Opacity(opacity: opacity, child: child),
        );
      },
    );
  }
}

Widget buildConfettiBurstControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ConfettiBurstControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ConfettiBurstControl extends StatefulWidget {
  const _ConfettiBurstControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ConfettiBurstControl> createState() => _ConfettiBurstControlState();
}

class _ConfettiBurstControlState extends State<_ConfettiBurstControl> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  int _seed = 0;

  @override
  void initState() {
    super.initState();
    _controller.duration = Duration(milliseconds: (coerceOptionalInt(widget.props['duration_ms']) ?? 900).clamp(1, 600000));
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ConfettiBurstControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'burst':
        _burst();
        return true;
      default:
        throw UnsupportedError('Unknown confetti_burst method: $method');
    }
  }

  void _burst() {
    setState(() => _seed += 1);
    _controller.forward(from: 0);
    widget.sendEvent(widget.controlId, 'burst', {'seed': _seed});
  }

  @override
  Widget build(BuildContext context) {
    final colors = _coerceColors(widget.props['colors']);
    final count = (coerceOptionalInt(widget.props['count']) ?? 18).clamp(1, 200);

    return SizedBox(
      height: 64,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _ConfettiPainter(progress: _controller.value, colors: colors, count: count, seed: _seed),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FilledButton.tonal(onPressed: _burst, child: const Text('Burst')),
          ),
        ],
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress, required this.colors, required this.count, required this.seed});

  final double progress;
  final List<Color> colors;
  final int count;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    for (var i = 0; i < count; i++) {
      final x0 = random.nextDouble() * size.width;
      final vy = 20 + random.nextDouble() * 80;
      final vx = (random.nextDouble() - 0.5) * 50;
      final x = x0 + (vx * progress);
      final y = -8 + (vy * progress);
      final paint = Paint()..color = colors[i % colors.length].withOpacity((1 - progress).clamp(0, 1));
      canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: 4, height: 8), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return progress != oldDelegate.progress || seed != oldDelegate.seed || count != oldDelegate.count;
  }
}

List<Color> _coerceColors(Object? value) {
  if (value is List) {
    final colors = value.map(coerceColor).whereType<Color>().toList(growable: false);
    if (colors.isNotEmpty) return colors;
  }
  return const [Color(0xFF22D3EE), Color(0xFFA78BFA), Color(0xFFF472B6), Color(0xFF34D399)];
}
