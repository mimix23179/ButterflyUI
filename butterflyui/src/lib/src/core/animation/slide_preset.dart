import 'package:flutter/material.dart';
import 'animated_transition.dart';

Widget slideFromTop({required Widget child, bool visible = true, Duration duration = const Duration(milliseconds: 220), Curve curve = Curves.easeOut, bool instant = false, VoidCallback? onExitCompleted}) {
  return AnimatedTransition(child: child, visible: visible, duration: duration, curve: curve, offset: const Offset(0.0, -0.12), instant: instant, onExitCompleted: onExitCompleted);
}

Widget slideFromBottom({required Widget child, bool visible = true, Duration duration = const Duration(milliseconds: 220), Curve curve = Curves.easeOut, bool instant = false, VoidCallback? onExitCompleted}) {
  return AnimatedTransition(child: child, visible: visible, duration: duration, curve: curve, offset: const Offset(0.0, 0.12), instant: instant, onExitCompleted: onExitCompleted);
}

Widget slideFromLeft({required Widget child, bool visible = true, Duration duration = const Duration(milliseconds: 220), Curve curve = Curves.easeOut, bool instant = false, VoidCallback? onExitCompleted}) {
  return AnimatedTransition(child: child, visible: visible, duration: duration, curve: curve, offset: const Offset(-0.12, 0.0), instant: instant, onExitCompleted: onExitCompleted);
}

Widget slideFromRight({required Widget child, bool visible = true, Duration duration = const Duration(milliseconds: 220), Curve curve = Curves.easeOut, bool instant = false, VoidCallback? onExitCompleted}) {
  return AnimatedTransition(child: child, visible: visible, duration: duration, curve: curve, offset: const Offset(0.12, 0.0), instant: instant, onExitCompleted: onExitCompleted);
}
