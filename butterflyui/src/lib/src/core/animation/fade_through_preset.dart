import 'package:flutter/material.dart';

Widget fadeThrough({required Widget child, Key? key, Duration duration = const Duration(milliseconds: 220)}) {
  return AnimatedSwitcher(
    duration: duration,
    switchInCurve: Curves.easeOut,
    switchOutCurve: Curves.easeIn,
    child: child,
    transitionBuilder: (widget, animation) => FadeTransition(opacity: animation, child: widget),
  );
}
