import 'package:flutter/material.dart';
import 'animated_transition.dart';

Widget slideAndFade({required Widget child, bool visible = true, Duration duration = const Duration(milliseconds: 220), Curve curve = Curves.easeOut, Offset offset = const Offset(0.0, -0.06), bool instant = false, VoidCallback? onExitCompleted}) {
  return AnimatedTransition(child: child, visible: visible, duration: duration, curve: curve, offset: offset, instant: instant, onExitCompleted: onExitCompleted);
}
