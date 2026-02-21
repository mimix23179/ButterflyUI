import 'package:flutter/material.dart';

class CurtainReveal extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Axis axis;
  final Duration duration;
  final bool instant;
  final VoidCallback? onExitCompleted;

  const CurtainReveal({super.key, required this.child, this.visible = true, this.axis = Axis.vertical, this.duration = const Duration(milliseconds: 240), this.instant = false, this.onExitCompleted});

  @override
  State<CurtainReveal> createState() => _CurtainRevealState();
}

class _CurtainRevealState extends State<CurtainReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _factor;

  @override
  void initState() {
    super.initState();
    final dur = widget.instant ? Duration.zero : widget.duration;
    _controller = AnimationController(vsync: this, duration: dur, reverseDuration: dur);
    _factor = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    if (widget.visible) _controller.forward(); else _controller.value = 0.0;
    _controller.addStatusListener((s) { if (s == AnimationStatus.dismissed) widget.onExitCompleted?.call(); });
  }

  @override
  void didUpdateWidget(covariant CurtainReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) { if (widget.visible) _controller.forward(); else _controller.reverse(); }
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final factor = _factor.value;
          return Align(
            alignment: widget.axis == Axis.vertical ? Alignment.topCenter : Alignment.centerLeft,
            heightFactor: widget.axis == Axis.vertical ? factor : 1.0,
            widthFactor: widget.axis == Axis.horizontal ? factor : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
