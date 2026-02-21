import 'dart:ui';
import 'package:flutter/material.dart';

Widget blurFade({required Widget child, bool visible = true, Duration duration = const Duration(milliseconds: 260), double maxSigma = 6.0, bool instant = false, VoidCallback? onExitCompleted}) {
  return _BlurFadeWrapper(child: child, visible: visible, duration: duration, maxSigma: maxSigma, instant: instant, onExitCompleted: onExitCompleted);
}

class _BlurFadeWrapper extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final double maxSigma;
  final bool instant;
  final VoidCallback? onExitCompleted;

  const _BlurFadeWrapper({super.key, required this.child, required this.visible, required this.duration, required this.maxSigma, required this.instant, this.onExitCompleted});

  @override
  State<_BlurFadeWrapper> createState() => _BlurFadeWrapperState();
}

class _BlurFadeWrapperState extends State<_BlurFadeWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sigma;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    final dur = widget.instant ? Duration.zero : widget.duration;
    _controller = AnimationController(vsync: this, duration: dur, reverseDuration: dur);
    _sigma = Tween<double>(begin: widget.maxSigma, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    if (widget.visible) _controller.forward(); else _controller.value = 0.0;
    _controller.addStatusListener((status) { if (status == AnimationStatus.dismissed) widget.onExitCompleted?.call(); });
  }

  @override
  void didUpdateWidget(covariant _BlurFadeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) { if (widget.visible) _controller.forward(); else _controller.reverse(); }
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final sigma = _sigma.value;
        return Opacity(
          opacity: _opacity.value,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
