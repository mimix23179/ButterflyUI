import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Widget sharedAxisPreset({
  required Widget child,
  Key? key,
  Duration duration = const Duration(milliseconds: 240),
  SharedAxisTransitionType transitionType = SharedAxisTransitionType.scaled,
}) {
  return PageTransitionSwitcher(
    duration: duration,
    transitionBuilder: (child, primary, secondary) {
      return SharedAxisTransition(
        animation: primary,
        secondaryAnimation: secondary,
        transitionType: transitionType,
        child: child,
      );
    },
    child: KeyedSubtree(key: key ?? ValueKey(child.hashCode), child: child),
  );
}
