import 'package:flutter/material.dart';

class ScalePop extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final bool instant;
  final VoidCallback? onExitCompleted;

  const ScalePop({super.key, required this.child, this.visible = true, this.duration = const Duration(milliseconds: 300), this.instant = false, this.onExitCompleted});

  @override
  State<ScalePop> createState() => _ScalePopState();
}

class _ScalePopState extends State<ScalePop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    final duration = widget.instant ? Duration.zero : widget.duration;
    _controller = AnimationController(vsync: this, duration: duration, reverseDuration: duration);
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05).chain(CurveTween(curve: Curves.easeOut)), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 30),
    ]).animate(_controller);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    if (widget.visible) {
      _controller.forward();
    } else {
      _controller.value = 0.0;
    }
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.onExitCompleted?.call();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ScalePop oldWidget) {
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
      builder: (context, child) => Transform.scale(scale: _scale.value, child: Opacity(opacity: _opacity.value, child: child)),
      child: widget.child,
    );
  }
}
