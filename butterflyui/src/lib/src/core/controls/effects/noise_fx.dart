import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildNeonEdgeControl(
  Map<String, Object?> props,
  Widget child,
) {
  final color = coerceColor(props['color']) ?? const Color(0xFF22D3EE);
  final width = coerceDouble(props['width']) ?? 1.6;
  final glow = coerceDouble(props['glow']) ?? 10;
  final spread = coerceDouble(props['spread']) ?? 0;
  final radius = coerceDouble(props['radius']) ?? 12;
  final animated = props['animated'] == true;
  final durationMs = (coerceOptionalInt(props['duration_ms']) ?? 300).clamp(1, 600000);
  final decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: color.withOpacity(0.9), width: width),
    boxShadow: [
      BoxShadow(
        color: color.withOpacity(0.55),
        blurRadius: glow,
        spreadRadius: spread,
      ),
    ],
  );
  if (animated) {
    return AnimatedContainer(
      duration: Duration(milliseconds: durationMs),
      decoration: decoration,
      child: child,
    );
  }
  return Container(
    decoration: decoration,
    child: child,
  );
}

Widget buildGrainOverlayControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _GrainOverlayControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    child: child,
  );
}

class _GrainOverlayControl extends StatefulWidget {
  const _GrainOverlayControl({
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
  State<_GrainOverlayControl> createState() => _GrainOverlayControlState();
}

class _GrainOverlayControlState extends State<_GrainOverlayControl> {
  late int _seed;

  @override
  void initState() {
    super.initState();
    _seed = coerceOptionalInt(widget.props['seed']) ?? 0;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _GrainOverlayControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      final nextSeed = coerceOptionalInt(widget.props['seed']);
      if (nextSeed != null && nextSeed != _seed) {
        setState(() => _seed = nextSeed);
      }
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return {'seed': _seed};
      case 'trigger':
        setState(() => _seed += 1);
        widget.sendEvent(widget.controlId, 'trigger', {'seed': _seed});
        return true;
      case 'set_props':
        if (args['props'] is Map) {
          final next = coerceObjectMap(args['props'] as Map);
          final seed = coerceOptionalInt(next['seed']);
          if (seed != null) {
            setState(() => _seed = seed);
          }
        }
        return {'seed': _seed};
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown grain_overlay method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final opacity = (coerceDouble(widget.props['opacity']) ?? 0.08).clamp(0, 1).toDouble();
    final density = (coerceDouble(widget.props['density']) ?? 0.45).clamp(0, 1).toDouble();
    final color = coerceColor(widget.props['color']) ?? Colors.white;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _GrainPainter(opacity: opacity, density: density, seed: _seed, color: color),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildNoiseDisplacementControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _NoiseDisplacementControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    child: child,
  );
}

class _NoiseDisplacementControl extends StatefulWidget {
  const _NoiseDisplacementControl({
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
  State<_NoiseDisplacementControl> createState() => _NoiseDisplacementControlState();
}

class _NoiseDisplacementControlState extends State<_NoiseDisplacementControl> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  int _seed = 0;
  double _strength = 3;
  double _speed = 1;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _NoiseDisplacementControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      _syncFromProps(widget.props);
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
      case 'trigger':
        final directStrength = coerceDouble(args['strength']);
        if (directStrength != null) {
          _strength = directStrength;
        }
        setState(() => _seed += 1);
        _controller.forward(from: 0);
        widget.sendEvent(widget.controlId, 'trigger', {'seed': _seed, 'strength': _strength});
        return true;
      case 'set_strength':
        final value = coerceDouble(args['value']);
        if (value != null) {
          setState(() {
            _strength = value;
          });
        }
        return _strength;
      case 'set_speed':
        final value = coerceDouble(args['value']);
        if (value != null) {
          setState(() {
            _speed = value.clamp(0.1, 6).toDouble();
            _controller.duration = _resolveDuration(widget.props, _speed);
          });
        }
        return _speed;
      case 'set_playing':
        final value = args['value'] == true;
        setState(() {
          _playing = value;
          if (_playing) {
            _controller.repeat(reverse: true);
          } else {
            _controller.stop();
          }
        });
        return _playing;
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown noise_displacement method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final random = math.Random((_controller.value * 1000).floor() + _seed);
        final taper = _playing ? 1.0 : (1 - _controller.value);
        final axis = (widget.props['axis'] ?? 'both').toString().toLowerCase();
        final deltaX = (random.nextDouble() - 0.5) * _strength * taper;
        final deltaY = (random.nextDouble() - 0.5) * _strength * taper;
        final dx = axis == 'y' ? 0.0 : deltaX;
        final dy = axis == 'x' ? 0.0 : deltaY;
        return Transform.translate(offset: Offset(dx, dy), child: child);
      },
    );
  }

  void _syncFromProps(Map<String, Object?> props) {
    _strength = coerceDouble(props['strength']) ?? _strength;
    _speed = (coerceDouble(props['speed']) ?? _speed).clamp(0.1, 6).toDouble();
    _controller.duration = _resolveDuration(props, _speed);
    final shouldPlay =
        props['play'] == true ||
        props['playing'] == true ||
        props['autoplay'] == true ||
        props['animated'] == true;
    if (shouldPlay != _playing) {
      _playing = shouldPlay;
      if (_playing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  Duration _resolveDuration(Map<String, Object?> props, double speed) {
    final base = (coerceOptionalInt(props['duration_ms']) ?? 350).clamp(50, 4000);
    return Duration(milliseconds: (base / speed).round().clamp(30, 4000));
  }
}

Widget buildNoiseFieldControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _NoiseFieldControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _NoiseFieldControl extends StatefulWidget {
  const _NoiseFieldControl({
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
  State<_NoiseFieldControl> createState() => _NoiseFieldControlState();
}

class _NoiseFieldControlState extends State<_NoiseFieldControl> {
  late int _seed;

  @override
  void initState() {
    super.initState();
    _seed = coerceOptionalInt(widget.props['seed']) ?? 0;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _NoiseFieldControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      final nextSeed = coerceOptionalInt(widget.props['seed']);
      if (nextSeed != null && nextSeed != _seed) {
        setState(() => _seed = nextSeed);
      }
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return {'seed': _seed};
      case 'set_props':
        if (args['props'] is Map) {
          final next = coerceObjectMap(args['props'] as Map);
          final seed = coerceOptionalInt(next['seed']);
          if (seed != null) setState(() => _seed = seed);
        }
        return {'seed': _seed};
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown noise_field method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final intensity = (coerceDouble(widget.props['intensity']) ?? 0.35).clamp(0, 1).toDouble();
    final color = coerceColor(widget.props['color']) ?? Colors.white;
    final height = coerceDouble(widget.props['height']) ?? 100;
    final animated = widget.props['animated'] == true;

    return GestureDetector(
      onTap: () {
        setState(() => _seed += 1);
        widget.sendEvent(widget.controlId, 'tap', {'seed': _seed});
      },
      child: SizedBox(
        height: height,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: animated ? 1 : 0),
          duration: const Duration(milliseconds: 350),
          builder: (context, anim, _) {
            return CustomPaint(
              painter: _NoiseFieldPainter(
                seed: _seed + (anim * 1000).round(),
                intensity: intensity,
                color: color,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  _GrainPainter({required this.opacity, required this.density, required this.seed, required this.color});

  final double opacity;
  final double density;
  final int seed;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final paint = Paint()..color = color.withOpacity(opacity);
    final count = (size.width * size.height * density * 0.01).round();
    for (var i = 0; i < count; i += 1) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GrainPainter oldDelegate) {
    return seed != oldDelegate.seed || opacity != oldDelegate.opacity || density != oldDelegate.density;
  }
}

class _NoiseFieldPainter extends CustomPainter {
  _NoiseFieldPainter({required this.seed, required this.intensity, required this.color});

  final int seed;
  final double intensity;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final paint = Paint();
    for (var y = 0.0; y < size.height; y += 2) {
      for (var x = 0.0; x < size.width; x += 2) {
        final alpha = random.nextDouble() * intensity;
        paint.color = color.withOpacity(alpha);
        canvas.drawRect(Rect.fromLTWH(x, y, 2, 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NoiseFieldPainter oldDelegate) {
    return seed != oldDelegate.seed || intensity != oldDelegate.intensity || color != oldDelegate.color;
  }
}
