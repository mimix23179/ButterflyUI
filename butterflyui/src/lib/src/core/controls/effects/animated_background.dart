import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';

Widget buildAnimatedBackgroundControl(
  Map<String, Object?> props,
  List children,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  final colors = _coerceColorList(props['colors']);
  if (colors.isEmpty) return const SizedBox.shrink();

  final durationMs = coerceOptionalInt(props['duration_ms'] ?? props['duration']) ?? 2400;
  final loop = props['loop'] == null ? true : (props['loop'] == true);
  final curve = _parseCurve(props['curve']);
  final childMap = _firstChildMap(children);

  return ConduitAnimatedBackground(
    colors: colors,
    duration: Duration(milliseconds: durationMs.clamp(1, 600000)),
    curve: curve,
    loop: loop,
    child: childMap == null ? null : buildFromControl(childMap),
  );
}

Map<String, Object?>? _firstChildMap(List children) {
  for (final child in children) {
    if (child is Map) return coerceObjectMap(child);
  }
  return null;
}

class ConduitAnimatedBackground extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;
  final Curve curve;
  final bool loop;
  final Widget? child;

  const ConduitAnimatedBackground({
    super.key,
    required this.colors,
    required this.duration,
    required this.curve,
    required this.loop,
    required this.child,
  });

  @override
  State<ConduitAnimatedBackground> createState() => _ConduitAnimatedBackgroundState();
}

class _ConduitAnimatedBackgroundState extends State<ConduitAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late CurvedAnimation _curve = CurvedAnimation(parent: _controller, curve: widget.curve);

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant ConduitAnimatedBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.curve != widget.curve) {
      _curve = CurvedAnimation(parent: _controller, curve: widget.curve);
    }
    if (oldWidget.loop != widget.loop) {
      _start();
    }
  }

  void _start() {
    _controller.stop();
    if (widget.loop) {
      _controller.repeat();
      return;
    }
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.colors.length == 1) {
      return Container(color: widget.colors.first, child: widget.child);
    }
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final t = _curve.value;
        final layers = <Widget>[];
        for (var i = 0; i < widget.colors.length; i += 1) {
          final opacity = _layerOpacity(t, i, widget.colors.length);
          if (opacity <= 0) continue;
          layers.add(
            Positioned.fill(
              child: Opacity(
                opacity: opacity,
                child: Container(color: widget.colors[i]),
              ),
            ),
          );
        }
        if (child != null) {
          layers.add(Positioned.fill(child: child));
        }
        return Stack(fit: StackFit.expand, children: layers);
      },
      child: widget.child,
    );
  }
}

double _layerOpacity(double t, int index, int count) {
  if (count <= 1) return 1.0;
  final segment = 1.0 / count;
  final start = segment * index;
  final local = (t - start) / segment;
  if (local <= 0 || local >= 1) return 0.0;
  const fadePortion = 0.2;
  if (local < fadePortion) {
    return (local / fadePortion).clamp(0.0, 1.0);
  }
  if (local > 1.0 - fadePortion) {
    return ((1.0 - local) / fadePortion).clamp(0.0, 1.0);
  }
  return 1.0;
}

Curve _parseCurve(Object? value) {
  final key = value?.toString().toLowerCase().replaceAll(' ', '').replaceAll('_', '');
  switch (key) {
    case 'linear':
      return Curves.linear;
    case 'easein':
    case 'easeinquad':
      return Curves.easeIn;
    case 'easeout':
    case 'easeoutquad':
      return Curves.easeOut;
    case 'easeinout':
    case 'easeinoutquad':
      return Curves.easeInOut;
    case 'easeinback':
      return Curves.easeInBack;
    case 'easeoutback':
      return Curves.easeOutBack;
    case 'easeinoutback':
      return Curves.easeInOutBack;
    case 'easeinexpo':
      return Curves.easeInExpo;
    case 'easeoutexpo':
      return Curves.easeOutExpo;
    case 'easeinoutexpo':
      return Curves.easeInOutExpo;
    case 'easeinquadfast':
      return Curves.fastOutSlowIn;
    case 'fastoutslowin':
      return Curves.fastOutSlowIn;
    case 'decelerate':
      return Curves.decelerate;
    default:
      return Curves.easeInOut;
  }
}

List<Color> _coerceColorList(Object? value) {
  if (value is List) {
    return value.map(coerceColor).whereType<Color>().toList();
  }
  return <Color>[];
}
