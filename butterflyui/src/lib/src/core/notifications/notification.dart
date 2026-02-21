import 'package:flutter/material.dart';

import '../webview/webview_api.dart';

/// Base payload for a notification
class NotificationPayload {
  final String controlId;
  final String message;
  final int durationMs;
  final String? actionLabel;
  final String? label;
  final String? variant;
  final String? style;
  final IconData? icon;
  final Map<String, Object?>? animation;
  final ConduitSendRuntimeEvent sendEvent;
  final bool instant;
  final int priority;

  const NotificationPayload({
    required this.controlId,
    required this.message,
    required this.durationMs,
    required this.sendEvent,
    this.label,
    this.actionLabel,
    this.variant,
    this.style,
    this.icon,
    this.animation,
    this.instant = false,
    this.priority = 0,
  });
}

