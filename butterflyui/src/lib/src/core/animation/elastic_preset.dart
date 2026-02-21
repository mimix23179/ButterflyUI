import 'package:flutter/material.dart';

class ElasticTransition extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final bool instant;
  final VoidCallback? onExitCompleted;

  const ElasticTransition({super.key, required this.child, this.visible = true, this.duration = const Duration(milliseconds: 500), this.instant = false, this.onExitCompleted});

  @override
  State<ElasticTransition> createState() => _ElasticTransitionState();
}

class _ElasticTransitionState extends State<ElasticTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    final duration = widget.instant ? Duration.zero : widget.duration;
    _controller = AnimationController(vsync: this, duration: duration, reverseDuration: duration);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    if (widget.visible) _controller.forward(); else _controller.value = 0.0;
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) widget.onExitCompleted?.call();
    });
  }

  @override
  void didUpdateWidget(covariant ElasticTransition oldWidget) {
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
      builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
      child: widget.child,
    );
  }
}
