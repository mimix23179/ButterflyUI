import 'package:flutter/material.dart';
import 'animated_transition.dart';

Widget fadePreset({
  required Widget child,
  bool visible = true,
  Duration duration = const Duration(milliseconds: 220),
  Curve curve = Curves.easeOut,
  bool instant = false,
  VoidCallback? onExitCompleted,
}) {
  return AnimatedTransition(
    child: child,
    visible: visible,
    duration: duration,
    curve: curve,
    offset: Offset.zero,
    instant: instant,
    onExitCompleted: onExitCompleted,
  );
}
