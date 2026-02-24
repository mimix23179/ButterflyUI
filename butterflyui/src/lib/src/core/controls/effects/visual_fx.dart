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
  final intensity = coerceDouble(props['intensity']) ?? 1;
  final blur = (coerceDouble(props['blur']) ?? 16) * intensity;
  final spread = coerceDouble(props['spread']) ?? 0;
  final radius = coerceDouble(props['radius']) ?? 12;
  final direction = props['direction'];
  final offsetX = direction is List && direction.isNotEmpty
      ? ((direction.first as num?)?.toDouble() ?? 0)
      : (coerceDouble(props['offset_x']) ?? 0);
  final offsetY = direction is List && direction.length > 1
      ? ((direction[1] as num?)?.toDouble() ?? 0)
      : (coerceDouble(props['offset_y']) ?? 0);
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
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _GlassBlurControl(
    controlId: controlId,
    props: props,
    child: child,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

Widget buildChromaticShiftControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ChromaticShiftControl(
    controlId: controlId,
    props: props,
    child: child,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
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
  late bool _playing;
  late bool _loop;
  late double _angle;
  late List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _updateTiming();
    _playing = widget.props['playing'] == true || widget.props['play'] == true || widget.props['autoplay'] != false;
    _loop = widget.props['loop'] != false;
    _angle = coerceDouble(widget.props['angle']) ?? 0;
    _colors = _coerceColors(widget.props['colors']);
    if (_playing) {
      if (_loop) {
        _controller.repeat();
      } else {
        _controller.forward(from: 0);
      }
    }
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
    if (oldWidget.props != widget.props) {
      _playing = widget.props['playing'] == true || widget.props['play'] == true || widget.props['autoplay'] != false;
      _loop = widget.props['loop'] != false;
      _angle = coerceDouble(widget.props['angle']) ?? _angle;
      _colors = _coerceColors(widget.props['colors']);
      if (_playing) {
        if (_loop) {
          _controller.repeat();
        } else {
          _controller.forward(from: _controller.value);
        }
      } else {
        _controller.stop();
      }
    }
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
        _playing = true;
        if (_loop) {
          _controller.repeat();
        } else {
          _controller.forward(from: _controller.value);
        }
        return true;
      case 'pause':
        _playing = false;
        _controller.stop();
        return true;
      case 'get_state':
        return {
          'angle': coerceDouble(widget.props['angle']) ?? 0,
          'duration_ms': coerceOptionalInt(widget.props['duration_ms'] ?? widget.props['duration']) ?? 1800,
          'playing': _playing,
        };
      case 'set_angle':
        final next = coerceDouble(args['angle']);
        if (next != null) {
          setState(() {
            _angle = next;
          });
        }
        return _angle;
      case 'set_colors':
        final next = _coerceColors(args['colors']);
        if (next.isNotEmpty) {
          setState(() {
            _colors = next;
          });
        }
        widget.sendEvent(widget.controlId, 'change', {'colors': _colors.map((c) => c.value).toList(growable: false)});
        return true;
      default:
        throw UnsupportedError('Unknown gradient_sweep method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    final stops = _coerceStops(widget.props['stops'], colors.length);
    final opacity = (coerceDouble(widget.props['opacity']) ?? 0.6).clamp(0, 1).toDouble();
    final baseAngle = _angle * math.pi / 180;
    final startAngle = (coerceDouble(widget.props['start_angle']) ?? 0) * math.pi / 180;
    final endAngle = (coerceDouble(widget.props['end_angle']) ?? 360) * math.pi / 180;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final angle = baseAngle + (_controller.value * 2 * math.pi);
        return ShaderMask(
          shaderCallback: (rect) => SweepGradient(
            colors: colors,
            stops: stops,
            startAngle: startAngle,
            endAngle: endAngle,
            transform: GradientRotation(angle),
          ).createShader(rect),
          blendMode: BlendMode.srcATop,
          child: Opacity(opacity: opacity, child: child),
        );
      },
    );
  }
}

class _GlassBlurControl extends StatefulWidget {
  const _GlassBlurControl({
    required this.controlId,
    required this.props,
    required this.child,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_GlassBlurControl> createState() => _GlassBlurControlState();
}

class _GlassBlurControlState extends State<_GlassBlurControl> {
  late Map<String, Object?> _props;

  @override
  void initState() {
    super.initState();
    _props = Map<String, Object?>.from(widget.props);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _GlassBlurControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      _props = Map<String, Object?>.from(widget.props);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_style':
        setState(() {
          _props.addAll(args);
        });
        widget.sendEvent(widget.controlId, 'change', {'props': _props});
        return true;
      case 'get_state':
        return {'props': _props};
      default:
        throw UnsupportedError('Unknown glass_blur method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final blur = coerceDouble(_props['blur']) ?? 14;
    final opacity = coerceDouble(_props['opacity']) ?? 0.16;
    final color = coerceColor(_props['color']) ?? Colors.white;
    final radius = coerceDouble(_props['radius']) ?? 12;
    final borderColor = coerceColor(_props['border_color']);
    final borderGlow = coerceColor(_props['border_glow']);
    final noiseOpacity = (coerceDouble(_props['noise_opacity']) ?? 0).clamp(0, 1).toDouble();
    final borderWidth = coerceDouble(_props['border_width']) ?? 1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: BorderRadius.circular(radius),
            border: borderColor == null ? null : Border.all(color: borderColor, width: borderWidth),
            boxShadow: borderGlow == null
                ? null
                : [
                    BoxShadow(
                      color: borderGlow.withOpacity(0.35),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: Stack(
            children: [
              widget.child,
              if (noiseOpacity > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _NoiseVeilPainter(opacity: noiseOpacity),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChromaticShiftControl extends StatefulWidget {
  const _ChromaticShiftControl({
    required this.controlId,
    required this.props,
    required this.child,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ChromaticShiftControl> createState() => _ChromaticShiftControlState();
}

class _ChromaticShiftControlState extends State<_ChromaticShiftControl> {
  late Map<String, Object?> _props;

  @override
  void initState() {
    super.initState();
    _props = Map<String, Object?>.from(widget.props);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ChromaticShiftControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      _props = Map<String, Object?>.from(widget.props);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_shift':
        final value = coerceDouble(args['value']);
        if (value != null) {
          setState(() {
            _props['shift'] = value;
          });
        }
        return _props['shift'];
      case 'set_style':
        setState(() {
          _props.addAll(args);
        });
        widget.sendEvent(widget.controlId, 'change', {'props': _props});
        return true;
      case 'get_state':
        return {'props': _props};
      default:
        throw UnsupportedError('Unknown chromatic_shift method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final shift = coerceDouble(_props['shift']) ?? 1.2;
    final opacity = (coerceDouble(_props['opacity']) ?? 0.35).clamp(0, 1).toDouble();
    final axis = (_props['axis'] ?? 'x').toString().toLowerCase();
    final red = coerceColor(_props['red']) ?? Colors.red;
    final blue = coerceColor(_props['blue']) ?? Colors.blue;
    final dx = axis == 'y' ? 0.0 : shift;
    final dy = axis == 'y' ? shift : 0.0;
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(-dx, -dy),
          child: Opacity(
            opacity: opacity,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(red, BlendMode.modulate),
              child: widget.child,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(dx, dy),
          child: Opacity(
            opacity: opacity,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(blue, BlendMode.modulate),
              child: widget.child,
            ),
          ),
        ),
        widget.child,
      ],
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
    _controller.duration = Duration(milliseconds: (coerceOptionalInt(widget.props['duration_ms'] ?? widget.props['duration']) ?? 900).clamp(1, 600000));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.props['emit_on_complete'] == true) {
        widget.sendEvent(widget.controlId, 'complete', {'seed': _seed});
      }
    });
    if (widget.props['autoplay'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _burst();
        }
      });
    }
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ConfettiBurstControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      _controller.duration = Duration(milliseconds: (coerceOptionalInt(widget.props['duration_ms'] ?? widget.props['duration']) ?? 900).clamp(1, 600000));
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
          if (widget.props['hide_button'] != true)
            Align(
              alignment: Alignment.center,
              child: FilledButton.tonal(onPressed: _burst, child: const Text('Burst')),
            ),
        ],
      ),
    );
  }
}

class _NoiseVeilPainter extends CustomPainter {
  const _NoiseVeilPainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(19);
    final paint = Paint()..color = Colors.white.withOpacity(opacity);
    for (var i = 0; i < 350; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoiseVeilPainter oldDelegate) =>
      opacity != oldDelegate.opacity;
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

List<double>? _coerceStops(Object? raw, int colorCount) {
  if (colorCount < 2) return null;
  if (raw is! List) return null;
  final stops = raw
      .map(coerceDouble)
      .whereType<double>()
      .map((value) => value.clamp(0.0, 1.0))
      .toList(growable: false);
  if (stops.length != colorCount) return null;
  return stops;
}
