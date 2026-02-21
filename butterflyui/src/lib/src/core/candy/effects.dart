import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/control_theme.dart';
class ConduitGlowEffect extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blur;
  final double spread;
  final double radius;
  final Offset offset;
  final bool clip;

  const ConduitGlowEffect({
    super.key,
    required this.child,
    required this.color,
    required this.blur,
    required this.spread,
    required this.radius,
    required this.offset,
    required this.clip,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blur,
            spreadRadius: spread,
            offset: offset,
          ),
        ],
      ),
      child: child,
    );
    if (clip) {
      content = ClipRRect(borderRadius: BorderRadius.circular(radius), child: content);
    }
    return content;
  }
}

class ConduitNeonEdge extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double glow;
  final double spread;
  final double radius;

  const ConduitNeonEdge({
    super.key,
    required this.child,
    required this.color,
    required this.width,
    required this.glow,
    required this.spread,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: color, width: width),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.7),
            blurRadius: glow,
            spreadRadius: spread,
          ),
        ],
      ),
      child: child,
    );
  }
}

class ConduitGlassBlur extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color tint;
  final double radius;
  final Color? borderColor;
  final double borderWidth;

  const ConduitGlassBlur({
    super.key,
    required this.child,
    required this.blur,
    required this.opacity,
    required this.tint,
    required this.radius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final border = (borderColor != null && borderWidth > 0)
        ? Border.all(color: borderColor!, width: borderWidth)
        : null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: tint.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(radius),
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}

class ConduitGrainOverlay extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double density;
  final int seed;
  final Color color;

  const ConduitGrainOverlay({
    super.key,
    required this.child,
    required this.opacity,
    required this.density,
    required this.seed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _GrainPainter(seed: seed, density: density, opacity: opacity, color: color),
            ),
          ),
        ),
      ],
    );
  }
}

class _GrainPainter extends CustomPainter {
  final int seed;
  final double density;
  final double opacity;
  final Color color;

  _GrainPainter({
    required this.seed,
    required this.density,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(seed);
    final count = (size.width * size.height * density).round().clamp(0, 3000);
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = 1;
    final points = <Offset>[];
    for (var i = 0; i < count; i += 1) {
      points.add(Offset(rand.nextDouble() * size.width, rand.nextDouble() * size.height));
    }
    canvas.drawPoints(ui.PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant _GrainPainter oldDelegate) {
    return oldDelegate.seed != seed ||
        oldDelegate.density != density ||
        oldDelegate.opacity != opacity ||
        oldDelegate.color != color;
  }
}

class ConduitGradientSweep extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final int durationMs;
  final double angle;
  final double opacity;

  const ConduitGradientSweep({
    super.key,
    required this.child,
    required this.colors,
    required this.durationMs,
    required this.angle,
    required this.opacity,
  });

  @override
  State<ConduitGradientSweep> createState() => _ConduitGradientSweepState();
}

class _ConduitGradientSweepState extends State<ConduitGradientSweep> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angleRad = widget.angle * math.pi / 180.0;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final offset = -1.0 + (_controller.value * 2.0);
        final overlay = Opacity(
          opacity: widget.opacity,
          child: Transform.rotate(
            angle: angleRad,
            child: FractionalTranslation(
              translation: Offset(offset, 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        );
        return Stack(children: [widget.child, Positioned.fill(child: IgnorePointer(child: overlay))]);
      },
    );
  }
}

class ConduitShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final int durationMs;
  final double angle;
  final double opacity;

  const ConduitShimmer({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    required this.durationMs,
    required this.angle,
    required this.opacity,
  });

  @override
  State<ConduitShimmer> createState() => _ConduitShimmerState();
}

class _ConduitShimmerState extends State<ConduitShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angleRad = widget.angle * math.pi / 180.0;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final offset = -1.0 + (_controller.value * 2.0);
        final overlay = Opacity(
          opacity: widget.opacity,
          child: Transform.rotate(
            angle: angleRad,
            child: FractionalTranslation(
              translation: Offset(offset, 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        );
        return Stack(children: [widget.child, Positioned.fill(child: IgnorePointer(child: overlay))]);
      },
    );
  }
}

class ConduitShadowStack extends StatelessWidget {
  final Widget child;
  final List<BoxShadow> shadows;
  final double radius;

  const ConduitShadowStack({
    super.key,
    required this.child,
    required this.shadows,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows,
      ),
      child: child,
    );
  }
}

class ConduitOutlineReveal extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double radius;
  final double progress;
  final bool animate;
  final int durationMs;

  const ConduitOutlineReveal({
    super.key,
    required this.child,
    required this.color,
    required this.width,
    required this.radius,
    required this.progress,
    required this.animate,
    required this.durationMs,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final duration = animate ? Duration(milliseconds: durationMs) : Duration.zero;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: clamped),
      duration: duration,
      builder: (context, value, child) {
        return CustomPaint(
          foregroundPainter: _OutlineRevealPainter(
            progress: value,
            color: color,
            width: width,
            radius: radius,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _OutlineRevealPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double width;
  final double radius;

  _OutlineRevealPainter({
    required this.progress,
    required this.color,
    required this.width,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final metrics = path.computeMetrics().toList();
    final total = metrics.fold<double>(0, (sum, metric) => sum + metric.length);
    var remaining = total * progress;

    for (final metric in metrics) {
      if (remaining <= 0) break;
      final length = math.min(metric.length, remaining);
      final extract = metric.extractPath(0, length);
      canvas.drawPath(extract, paint);
      remaining -= length;
    }
  }

  @override
  bool shouldRepaint(covariant _OutlineRevealPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.width != width ||
        oldDelegate.radius != radius;
  }
}

class ConduitRippleBurst extends StatefulWidget {
  final Widget child;
  final Color color;
  final double maxRadius;
  final int durationMs;

  const ConduitRippleBurst({
    super.key,
    required this.child,
    required this.color,
    required this.maxRadius,
    required this.durationMs,
  });

  @override
  State<ConduitRippleBurst> createState() => _ConduitRippleBurstState();
}

class _ConduitRippleBurstState extends State<ConduitRippleBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Offset? _center;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _trigger(Offset position) {
    _center = position;
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => _trigger(event.localPosition),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              if (_controller.isAnimating && _center != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _RipplePainter(
                        progress: _controller.value,
                        center: _center!,
                        color: widget.color,
                        maxRadius: widget.maxRadius,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Offset center;
  final Color color;
  final double maxRadius;

  _RipplePainter({
    required this.progress,
    required this.center,
    required this.color,
    required this.maxRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = maxRadius * progress;
    final paint = Paint()
      ..color = color.withValues(alpha: (1 - progress).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center ||
        oldDelegate.color != color ||
        oldDelegate.maxRadius != maxRadius;
  }
}

class ConduitConfettiBurst extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final int count;
  final int durationMs;
  final double gravity;

  const ConduitConfettiBurst({
    super.key,
    required this.child,
    required this.colors,
    required this.count,
    required this.durationMs,
    required this.gravity,
  });

  @override
  State<ConduitConfettiBurst> createState() => _ConduitConfettiBurstState();
}

class _ConduitConfettiBurstState extends State<ConduitConfettiBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Offset? _center;
  List<_ConfettiParticle> _particles = const [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _trigger(Offset position) {
    final rand = math.Random();
    final colors = widget.colors.isEmpty
        ? conduitAccentPalette(context)
        : widget.colors;
    final particles = <_ConfettiParticle>[];
    for (var i = 0; i < widget.count; i += 1) {
      final angle = rand.nextDouble() * math.pi * 2;
      final speed = 40 + rand.nextDouble() * 120;
      particles.add(_ConfettiParticle(
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
        color: colors[i % colors.length],
        size: 4 + rand.nextDouble() * 4,
        rotation: rand.nextDouble() * math.pi,
      ));
    }
    _center = position;
    _particles = particles;
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => _trigger(event.localPosition),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              if (_controller.isAnimating && _center != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _ConfettiPainter(
                        progress: _controller.value,
                        center: _center!,
                        particles: _particles,
                        gravity: widget.gravity,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _ConfettiParticle {
  final Offset velocity;
  final Color color;
  final double size;
  final double rotation;

  const _ConfettiParticle({
    required this.velocity,
    required this.color,
    required this.size,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final Offset center;
  final List<_ConfettiParticle> particles;
  final double gravity;

  _ConfettiPainter({
    required this.progress,
    required this.center,
    required this.particles,
    required this.gravity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final dx = center.dx + particle.velocity.dx * progress;
      final dy = center.dy + particle.velocity.dy * progress + gravity * progress * progress * 120;
      final paint = Paint()..color = particle.color.withValues(alpha: (1 - progress).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(particle.rotation * progress);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size * 1.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center ||
        oldDelegate.particles != particles ||
        oldDelegate.gravity != gravity;
  }
}

class ConduitNoiseDisplacement extends StatefulWidget {
  final Widget child;
  final double strength;
  final int durationMs;

  const ConduitNoiseDisplacement({
    super.key,
    required this.child,
    required this.strength,
    required this.durationMs,
  });

  @override
  State<ConduitNoiseDisplacement> createState() => _ConduitNoiseDisplacementState();
}

class _ConduitNoiseDisplacementState extends State<ConduitNoiseDisplacement> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value * 2 * math.pi;
        final dx = math.sin(t) * widget.strength;
        final dy = math.cos(t * 1.3) * widget.strength;
        return Transform.translate(offset: Offset(dx, dy), child: widget.child);
      },
    );
  }
}

class ConduitParallaxOffset extends StatelessWidget {
  final Widget child;
  final double dx;
  final double dy;
  final double depth;

  const ConduitParallaxOffset({
    super.key,
    required this.child,
    required this.dx,
    required this.dy,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: Offset(dx * depth, dy * depth), child: child);
  }
}

class ConduitLiquidMorph extends StatefulWidget {
  final Widget child;
  final double minRadius;
  final double maxRadius;
  final int durationMs;
  final bool animate;

  const ConduitLiquidMorph({
    super.key,
    required this.child,
    required this.minRadius,
    required this.maxRadius,
    required this.durationMs,
    required this.animate,
  });

  @override
  State<ConduitLiquidMorph> createState() => _ConduitLiquidMorphState();
}

class _ConduitLiquidMorphState extends State<ConduitLiquidMorph> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.durationMs),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.maxRadius),
        child: widget.child,
      );
    }
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        final t = _controller!.value;
        final radius = widget.minRadius + (widget.maxRadius - widget.minRadius) * t;
        return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
      },
      child: widget.child,
    );
  }
}

class ConduitChromaticShift extends StatelessWidget {
  final Widget child;
  final double shift;
  final double opacity;

  const ConduitChromaticShift({
    super.key,
    required this.child,
    required this.shift,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    final errorTone = conduitStatusColor(context, 'error');
    final infoTone = conduitStatusColor(context, 'info');
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(-shift, 0),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              errorTone.withValues(alpha: opacity),
              BlendMode.screen,
            ),
            child: child,
          ),
        ),
        Transform.translate(
          offset: Offset(shift, 0),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              infoTone.withValues(alpha: opacity),
              BlendMode.screen,
            ),
            child: child,
          ),
        ),
        child,
      ],
    );
  }
}

class ConduitScanlineOverlay extends StatelessWidget {
  final Widget child;
  final double spacing;
  final double thickness;
  final double opacity;
  final Color color;

  const ConduitScanlineOverlay({
    super.key,
    required this.child,
    required this.spacing,
    required this.thickness,
    required this.opacity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _ScanlinePainter(
                spacing: spacing,
                thickness: thickness,
                opacity: opacity,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  final double spacing;
  final double thickness;
  final double opacity;
  final Color color;

  _ScanlinePainter({
    required this.spacing,
    required this.thickness,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: opacity);
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, thickness), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) {
    return oldDelegate.spacing != spacing ||
        oldDelegate.thickness != thickness ||
        oldDelegate.opacity != opacity ||
        oldDelegate.color != color;
  }
}

class ConduitPixelate extends StatelessWidget {
  final Widget child;
  final double pixelSize;

  const ConduitPixelate({
    super.key,
    required this.child,
    required this.pixelSize,
  });

  @override
  Widget build(BuildContext context) {
    if (pixelSize <= 1) return child;
    final scale = 1 / pixelSize;
    return ClipRect(
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topLeft,
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: scale,
          heightFactor: scale,
          child: Transform.scale(
            scale: pixelSize,
            alignment: Alignment.topLeft,
            child: child,
          ),
        ),
      ),
    );
  }
}

class ConduitVignette extends StatelessWidget {
  final Widget child;
  final double intensity;
  final Color color;

  const ConduitVignette({
    super.key,
    required this.child,
    required this.intensity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    color.withValues(alpha: intensity),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConduitTiltHover extends StatefulWidget {
  final Widget child;
  final double maxAngle;
  final double perspective;
  final double scale;

  const ConduitTiltHover({
    super.key,
    required this.child,
    required this.maxAngle,
    required this.perspective,
    required this.scale,
  });

  @override
  State<ConduitTiltHover> createState() => _ConduitTiltHoverState();
}

class _ConduitTiltHoverState extends State<ConduitTiltHover> {
  Offset? _position;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final dx = _position == null || size.width == 0
            ? 0.0
            : ((_position!.dx / size.width) - 0.5) * 2;
        final dy = _position == null || size.height == 0
            ? 0.0
            : ((_position!.dy / size.height) - 0.5) * 2;
        final angle = widget.maxAngle * math.pi / 180.0;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(-dy * angle)
          ..rotateY(dx * angle)
          ..scale(widget.scale);
        return MouseRegion(
          onHover: (event) => setState(() => _position = event.localPosition),
          onExit: (_) => setState(() => _position = null),
          child: Transform(
            alignment: Alignment.center,
            transform: transform,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class ConduitMorphingBorder extends StatefulWidget {
  final Widget child;
  final double minRadius;
  final double maxRadius;
  final int durationMs;
  final bool animate;
  final Color color;
  final double width;

  const ConduitMorphingBorder({
    super.key,
    required this.child,
    required this.minRadius,
    required this.maxRadius,
    required this.durationMs,
    required this.animate,
    required this.color,
    required this.width,
  });

  @override
  State<ConduitMorphingBorder> createState() => _ConduitMorphingBorderState();
}

class _ConduitMorphingBorderState extends State<ConduitMorphingBorder> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.durationMs),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      final radius = BorderRadius.circular(widget.maxRadius);
      return Container(
        decoration: BoxDecoration(borderRadius: radius, border: Border.all(color: widget.color, width: widget.width)),
        child: ClipRRect(borderRadius: radius, child: widget.child),
      );
    }
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        final t = _controller!.value;
        final radiusValue = widget.minRadius + (widget.maxRadius - widget.minRadius) * t;
        final radius = BorderRadius.circular(radiusValue);
        return Container(
          decoration: BoxDecoration(borderRadius: radius, border: Border.all(color: widget.color, width: widget.width)),
          child: ClipRRect(borderRadius: radius, child: child),
        );
      },
      child: widget.child,
    );
  }
}
