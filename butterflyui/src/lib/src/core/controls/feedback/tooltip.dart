import 'package:flutter/material.dart';

class ConduitTooltipWidget extends StatelessWidget {
  final String message;
  final bool preferBelow;
  final int waitMs;
  final Widget child;

  const ConduitTooltipWidget({
    super.key,
    required this.message,
    required this.preferBelow,
    required this.waitMs,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      waitDuration: Duration(milliseconds: waitMs),
      child: child,
    );
  }
}
