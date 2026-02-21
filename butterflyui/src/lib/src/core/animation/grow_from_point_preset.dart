import 'package:flutter/material.dart';

class GrowFromPoint extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final Alignment origin;
  final bool instant;
  final VoidCallback? onExitCompleted;

  const GrowFromPoint({super.key, required this.child, this.visible = true, this.duration = const Duration(milliseconds: 260), this.origin = Alignment.center, this.instant = false, this.onExitCompleted});

  @override
  State<GrowFromPoint> createState() => _GrowFromPointState();
}

class _GrowFromPointState extends State<GrowFromPoint> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    final dur = widget.instant ? Duration.zero : widget.duration;
    _controller = AnimationController(vsync: this, duration: dur, reverseDuration: dur);
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    if (widget.visible) _controller.forward(); else _controller.value = 0.0;
    _controller.addStatusListener((status) { if (status == AnimationStatus.dismissed) widget.onExitCompleted?.call(); });
  }

  @override
  void didUpdateWidget(covariant GrowFromPoint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) _controller.forward(); else _controller.reverse();
    }
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scale.value, alignment: widget.origin, child: Opacity(opacity: _opacity.value, child: child));
      },
      child: widget.child,
    );
  }
}
