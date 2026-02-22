import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildParticleFieldControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ParticleFieldControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ParticleFieldControl extends StatefulWidget {
  const _ParticleFieldControl({
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
  State<_ParticleFieldControl> createState() => _ParticleFieldControlState();
}

class _ParticleFieldControlState extends State<_ParticleFieldControl> {
  late bool _play;
  late int? _seed;

  @override
  void initState() {
    super.initState();
    final playValue = widget.props.containsKey('play')
        ? widget.props['play']
        : (widget.props.containsKey('playing')
              ? widget.props['playing']
              : widget.props['autoplay']);
    _play = playValue == null ? true : (playValue == true);
    _seed = coerceOptionalInt(widget.props['seed']);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ParticleFieldControl oldWidget) {
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
      case 'get_state':
        return {'play': _play, 'seed': _seed};
      case 'play':
        setState(() {
          _play = true;
        });
        return null;
      case 'pause':
        setState(() {
          _play = false;
        });
        return null;
      case 'set_seed':
        setState(() {
          _seed = coerceOptionalInt(args['seed']) ?? _seed;
        });
        widget.sendEvent(widget.controlId, 'seed_change', {'seed': _seed});
        return _seed;
      default:
        throw UnsupportedError('Unknown particle_field method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
  final count = (coerceOptionalInt(widget.props['count']) ?? 40)
      .clamp(0, 2000)
      .toInt();
  final colors = _coerceColorList(widget.props['colors']);
  final size = coerceDouble(widget.props['size']);
  final minSize = coerceDouble(widget.props['min_size']) ?? size ?? 2.0;
  final maxSize = coerceDouble(widget.props['max_size']) ?? size ?? 6.0;
  final speed = coerceDouble(widget.props['speed']);
  final minSpeed = coerceDouble(widget.props['min_speed']) ?? speed ?? 8.0;
  final maxSpeed = coerceDouble(widget.props['max_speed']) ?? speed ?? 32.0;
  final direction = coerceDouble(
    widget.props['direction'] ??
        widget.props['direction_deg'] ??
        widget.props['direction_degrees'],
  );
  final spread = coerceDouble(widget.props['spread']);
  final opacity = (coerceDouble(widget.props['opacity']) ?? 0.6).clamp(0.0, 1.0);
  final loop = widget.props['loop'] == null
      ? true
      : (widget.props['loop'] == true);
  final shape = widget.props['shape']?.toString() ?? 'circle';

  return ButterflyUIParticleField(
    key: ValueKey('${widget.controlId}:$_seed:$_play'),
    count: count,
    colors: colors,
    minSize: minSize,
    maxSize: maxSize,
    minSpeed: minSpeed,
    maxSpeed: maxSpeed,
    direction: direction,
    spread: spread,
    opacity: opacity,
    seed: _seed,
    loop: loop,
    play: _play,
    shape: shape,
  );
  }
}

class ButterflyUIParticleField extends StatefulWidget {
  final int count;
  final List<Color> colors;
  final double minSize;
  final double maxSize;
  final double minSpeed;
  final double maxSpeed;
  final double? direction;
  final double? spread;
  final double opacity;
  final int? seed;
  final bool loop;
  final bool play;
  final String shape;

  const ButterflyUIParticleField({
    super.key,
    required this.count,
    required this.colors,
    required this.minSize,
    required this.maxSize,
    required this.minSpeed,
    required this.maxSpeed,
    required this.direction,
    required this.spread,
    required this.opacity,
    required this.seed,
    required this.loop,
    required this.play,
    required this.shape,
  });

  @override
  State<ButterflyUIParticleField> createState() => _ButterflyUIParticleFieldState();
}

class _ButterflyUIParticleFieldState extends State<ButterflyUIParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(hours: 1),
  );
  late List<_Particle> _particles;
  List<Color> _resolvedColors = const [];

  @override
  void initState() {
    super.initState();
    _resolveColors();
    _particles = _buildParticles();
    _syncPlayback();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final before = _resolvedColors;
    _resolveColors();
    if (!identical(before, _resolvedColors)) {
      _particles = _buildParticles();
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIParticleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolveColors();
    if (_shouldRebuildParticles(oldWidget)) {
      _particles = _buildParticles();
    }
    if (oldWidget.play != widget.play || oldWidget.loop != widget.loop) {
      _syncPlayback();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.count <= 0) {
      return const SizedBox.shrink();
    }
    return CustomPaint(
      painter: _ParticlePainter(
        particles: _particles,
        animation: _controller,
        opacity: widget.opacity,
        loop: widget.loop,
        shape: widget.shape,
      ),
      size: Size.infinite,
    );
  }

  bool _shouldRebuildParticles(ButterflyUIParticleField oldWidget) {
    return oldWidget.count != widget.count ||
        oldWidget.minSize != widget.minSize ||
        oldWidget.maxSize != widget.maxSize ||
        oldWidget.minSpeed != widget.minSpeed ||
        oldWidget.maxSpeed != widget.maxSpeed ||
        oldWidget.direction != widget.direction ||
        oldWidget.spread != widget.spread ||
        oldWidget.seed != widget.seed ||
        oldWidget.colors != widget.colors;
  }

  void _syncPlayback() {
    if (widget.play) {
      if (!_controller.isAnimating) {
        if (widget.loop) {
          _controller.repeat();
        } else {
          _controller.forward(from: 0.0);
        }
      }
    } else {
      _controller.stop();
    }
  }

  void _resolveColors() {
    final next = widget.colors.isNotEmpty
        ? widget.colors
        : butterflyuiAccentPalette(context);
    if (_resolvedColors.length != next.length ||
        !_resolvedColors.asMap().entries.every((e) => e.value == next[e.key])) {
      _resolvedColors = next;
    }
  }

  List<_Particle> _buildParticles() {
    final random = math.Random(widget.seed);
    final colors = _resolvedColors.isNotEmpty
        ? _resolvedColors
        : [butterflyuiText(context)];
    final minSize = math.min(widget.minSize, widget.maxSize);
    final maxSize = math.max(widget.minSize, widget.maxSize);
    final minSpeed = math.min(widget.minSpeed, widget.maxSpeed);
    final maxSpeed = math.max(widget.minSpeed, widget.maxSpeed);
    return List<_Particle>.generate(widget.count, (_) {
      final angle = _randomAngle(random, widget.direction, widget.spread);
      final size = _lerp(minSize, maxSize, random.nextDouble());
      final speed = _lerp(minSpeed, maxSpeed, random.nextDouble());
      final color = colors[random.nextInt(colors.length)];
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        angle: angle,
        speed: speed,
        size: size,
        color: color,
      );
    }, growable: false);
  }
}

class _Particle {
  final double x;
  final double y;
  final double angle;
  final double speed;
  final double size;
  final Color color;

  const _Particle({
    required this.x,
    required this.y,
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final AnimationController animation;
  final double opacity;
  final bool loop;
  final String shape;

  _ParticlePainter({
    required this.particles,
    required this.animation,
    required this.opacity,
    required this.loop,
    required this.shape,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final elapsed = animation.lastElapsedDuration?.inMilliseconds ?? 0;
    final t = elapsed / 1000.0;
    final paint = Paint();
    final drawSquare = shape.toLowerCase() == 'square';

    for (final particle in particles) {
      final baseX = particle.x * size.width;
      final baseY = particle.y * size.height;
      var dx = baseX + math.cos(particle.angle) * particle.speed * t;
      var dy = baseY + math.sin(particle.angle) * particle.speed * t;

      if (loop) {
        dx = _wrap(dx, size.width);
        dy = _wrap(dy, size.height);
      } else {
        if (dx < 0 || dx > size.width || dy < 0 || dy > size.height) {
          continue;
        }
      }

      final color = particle.color.withOpacity(
        (particle.color.opacity * opacity).clamp(0.0, 1.0),
      );
      paint.color = color;
      if (drawSquare) {
        final half = particle.size / 2.0;
        canvas.drawRect(
          Rect.fromLTWH(dx - half, dy - half, particle.size, particle.size),
          paint,
        );
      } else {
        canvas.drawCircle(Offset(dx, dy), particle.size / 2.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.particles != particles ||
        oldDelegate.opacity != opacity ||
        oldDelegate.loop != loop ||
        oldDelegate.shape != shape;
  }
}

List<Color> _coerceColorList(Object? value) {
  if (value is List) {
    return value.map(coerceColor).whereType<Color>().toList();
  }
  return <Color>[];
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

double _randomAngle(math.Random random, double? direction, double? spread) {
  if (direction == null) {
    return random.nextDouble() * math.pi * 2.0;
  }
  final spreadDegrees = spread ?? 30.0;
  final half = spreadDegrees * 0.5;
  final jitter = (random.nextDouble() * spreadDegrees) - half;
  final degrees = direction + jitter;
  return degrees * math.pi / 180.0;
}

double _wrap(double value, double max) {
  if (max <= 0) return value;
  var v = value % max;
  if (v < 0) v += max;
  return v;
}
