import 'package:flutter/material.dart';

import 'notification_manager.dart';

/// Widget that provides a global overlay for notifications.
/// Place this high in the widget tree (it's added to `main.dart` by this change).
class NotificationRoot extends StatelessWidget {
  final Widget child;

  const NotificationRoot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Put the child into an Overlay so we have a stable OverlayState to use later.
    return Overlay(
      key: NotificationManager.overlayKey,
      initialEntries: [OverlayEntry(builder: (context) => child)],
    );
  }
}
