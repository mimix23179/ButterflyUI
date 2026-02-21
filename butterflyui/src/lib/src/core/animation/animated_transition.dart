import 'package:flutter/material.dart';

/// A simple reusable transition wrapper that combines a fade + slide animation.
/// - Plays enter animation on mount (unless animateOnMount=false)
/// - When [visible] toggles false, plays reverse (exit) animation and calls [onExitCompleted]
class AnimatedTransition extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Offset offset; // entry offset (fractional)
  final bool animateOnMount;
  final bool instant; // if true, do not animate
  final VoidCallback? onEnterCompleted;
  final VoidCallback? onExitCompleted;

  const AnimatedTransition({
    super.key,
    required this.child,
    this.visible = true,
    this.duration = const Duration(milliseconds: 220),
    this.reverseDuration,
    this.curve = Curves.easeOut,
    this.offset = const Offset(0.0, -0.06),
    this.animateOnMount = true,
    this.instant = false,
    this.onEnterCompleted,
    this.onExitCompleted,
  });

  @override
  State<AnimatedTransition> createState() => _AnimatedTransitionState();
}

class _AnimatedTransitionState extends State<AnimatedTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  bool _mountedAndEntered = false;

  @override
  void initState() {
    super.initState();
    final duration = widget.instant ? Duration.zero : widget.duration;
    _controller = AnimationController(vsync: this, duration: duration, reverseDuration: widget.reverseDuration ?? duration);

    final curved = CurvedAnimation(parent: _controller, curve: widget.curve, reverseCurve: Curves.easeIn);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(curved);

    _controller.addStatusListener(_onStatus);

    if (widget.animateOnMount) {
      if (widget.visible) {
        if (widget.instant) {
          _controller.value = 1.0;
          WidgetsBinding.instance.addPostFrameCallback((_) => widget.onEnterCompleted?.call());
        } else {
          _controller.forward();
        }
      } else {
        // start hidden
        _controller.value = 0.0;
      }
    } else {
      // do not animate on mount: set to target visible state immediately
      _controller.value = widget.visible ? 1.0 : 0.0;
      if (widget.visible) WidgetsBinding.instance.addPostFrameCallback((_) => widget.onEnterCompleted?.call());
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _mountedAndEntered = true;
      widget.onEnterCompleted?.call();
    }
    if (status == AnimationStatus.dismissed) {
      widget.onExitCompleted?.call();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.instant && _controller.value != (widget.visible ? 1.0 : 0.0)) {
      _controller.value = widget.visible ? 1.0 : 0.0;
      if (widget.visible) widget.onEnterCompleted?.call(); else widget.onExitCompleted?.call();
      return;
    }

    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _opacity,
        child: widget.child,
      ),
    );
  }
}

