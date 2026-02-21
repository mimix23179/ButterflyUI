import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Widget fadeScalePreset({
  required Widget child,
  Key? key,
  Duration duration = const Duration(milliseconds: 220),
}) {
  return PageTransitionSwitcher(
    duration: duration,
    transitionBuilder: (child, primary, secondary) {
      return FadeScaleTransition(
        animation: primary,
        child: child,
      );
    },
    child: KeyedSubtree(key: key ?? ValueKey(child.hashCode), child: child),
  );
}
