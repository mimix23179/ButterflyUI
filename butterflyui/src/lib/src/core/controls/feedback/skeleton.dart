import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';

Widget buildSkeletonControl(Map<String, Object?> props) {
  return ConduitSkeleton(props: props);
}

Widget buildSkeletonLoaderControl(Map<String, Object?> props) {
  final count = (coerceOptionalInt(props['count']) ?? 1).clamp(1, 24);
  final spacing = coerceDouble(props['spacing']) ?? 8;
  if (count <= 1) {
    return ConduitSkeleton(props: props);
  }
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: List.generate(
      count,
      (_) => Padding(
        padding: EdgeInsets.only(bottom: spacing),
        child: ConduitSkeleton(props: props),
      ),
    ),
  );
}

class ConduitSkeleton extends StatefulWidget {
  final Map<String, Object?> props;

  const ConduitSkeleton({super.key, required this.props});

  @override
  State<ConduitSkeleton> createState() => _ConduitSkeletonState();
}

class _ConduitSkeletonState extends State<ConduitSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final durationMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 1100)
        .clamp(300, 6000);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant ConduitSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 1100)
        .clamp(300, 6000);
    if (nextMs != _controller.duration?.inMilliseconds) {
      _controller.duration = Duration(milliseconds: nextMs);
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final variant =
        (widget.props['variant']?.toString().toLowerCase() ?? 'rect').trim();
    final radius = coerceDouble(widget.props['radius']) ?? 10;
    final width = coerceDouble(widget.props['width']);
    final height = coerceDouble(widget.props['height']);
    final base =
        coerceColor(widget.props['color']) ??
        Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.55);
    final highlight =
        coerceColor(widget.props['highlight_color']) ??
        Theme.of(context).colorScheme.surface.withOpacity(0.65);

    double resolvedWidth = width ?? double.infinity;
    double resolvedHeight = height ?? 18;
    BorderRadius borderRadius = BorderRadius.circular(radius);

    if (variant == 'circle') {
      final size = width ?? height ?? 24;
      resolvedWidth = size;
      resolvedHeight = size;
      borderRadius = BorderRadius.circular(size);
    } else if (variant == 'text') {
      resolvedHeight = height ?? 14;
      resolvedWidth = width ?? 160;
      borderRadius = BorderRadius.circular(radius.clamp(2, 10));
    }

    final skeleton = SizedBox(
      width: resolvedWidth,
      height: resolvedHeight,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            final begin = Alignment(-1.2 + (2.4 * t), 0);
            final end = Alignment(-0.2 + (2.4 * t), 0);
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [base, highlight, base],
                  stops: const [0.1, 0.45, 0.9],
                ),
              ),
            );
          },
        ),
      ),
    );

    if (width == null && (variant == 'rect' || variant == 'line')) {
      return Align(alignment: Alignment.centerLeft, child: skeleton);
    }
    return skeleton;
  }
}
