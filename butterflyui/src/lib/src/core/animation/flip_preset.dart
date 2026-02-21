import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlipTransition extends StatefulWidget {
  final Widget child;
  final bool visible;
  final bool flipX; // true=flipX, false=flipY
  final Duration duration;
  final bool instant;
  final VoidCallback? onExitCompleted;

  const FlipTransition({super.key, required this.child, this.visible = true, this.flipX = false, this.duration = const Duration(milliseconds: 300), this.instant = false, this.onExitCompleted});

  @override
  State<FlipTransition> createState() => _FlipTransitionState();
}

class _FlipTransitionState extends State<FlipTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _angle;

  @override
  void initState() {
    super.initState();
    final dur = widget.instant ? Duration.zero : widget.duration;
    _controller = AnimationController(vsync: this, duration: dur, reverseDuration: dur);
    _angle = Tween<double>(begin: math.pi / 2, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    if (widget.visible) _controller.forward(); else _controller.value = 0.0;
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) widget.onExitCompleted?.call();
    });
  }

  @override
  void didUpdateWidget(covariant FlipTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) _controller.forward(); else _controller.reverse();
    }
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
      builder: (context, child) {
        final angle = _angle.value;
        final transform = Matrix4.identity();
        if (widget.flipX) {
          transform.rotateX(angle);
        } else {
          transform.rotateY(angle);
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Opacity(child: child, opacity: _controller.value),
        );
      },
      child: widget.child,
    );
  }
}
