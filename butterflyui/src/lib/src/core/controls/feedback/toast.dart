import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/notifications/notification_manager.dart';
import 'package:butterflyui_runtime/src/core/notifications/notification.dart';

class ButterflyUIToastWidget extends StatefulWidget {
  final String controlId;
  final String message;
  final String? label;
  final bool open;
  final int durationMs;
  final String? actionLabel;
  final String? variant;
  final String? style;
  final IconData? icon;
  final bool instant;
  final int priority;
  final Map<String, Object?>? animation;
  final bool useFlushbar;
  final bool useFlutterToast;
  final String? toastPosition;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIToastWidget({
    super.key,
    required this.controlId,
    required this.message,
    this.label,
    required this.open,
    required this.durationMs,
    required this.actionLabel,
    required this.variant,
    required this.style,
    required this.icon,
    this.animation,
    this.instant = false,
    this.priority = 0,
    this.useFlushbar = false,
    this.useFlutterToast = false,
    this.toastPosition,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIToastWidget> createState() => _ButterflyUIToastWidgetState();
}

class _ButterflyUIToastWidgetState extends State<ButterflyUIToastWidget> {

  String _lastMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No per-widget registration required; NotificationRoot provides global overlay.
    if (widget.open) {
      _show();
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIToastWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open) {
      if (!oldWidget.open || widget.message != _lastMessage) {
        _show();
      }
    } else if (oldWidget.open) {
      // Dismiss via NotificationManager and emit close event to python
      NotificationManager.instance.dismiss(widget.controlId, reason: 'dismiss', emitClose: true);
    }
  }

  @override
  void dispose() {
    // Ensure dismissal without emitting close (widget is being disposed)
    NotificationManager.instance.dismiss(widget.controlId, reason: 'dispose', emitClose: false);
    super.dispose();
  }

  void _show() {
    if (widget.message.trim().isEmpty) return;
    _lastMessage = widget.message;
    if (widget.useFlutterToast) {
      final pos = (widget.toastPosition ?? '').toLowerCase();
      ToastGravity gravity = ToastGravity.BOTTOM;
      if (pos.contains('top')) gravity = ToastGravity.TOP;
      if (pos.contains('center')) gravity = ToastGravity.CENTER;
      Fluttertoast.showToast(
        msg: widget.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
      );
      return;
    }
    if (widget.useFlushbar) {
      Flushbar(
        message: widget.message,
        duration: Duration(milliseconds: widget.durationMs),
        mainButton: widget.actionLabel == null
            ? null
            : TextButton(
                onPressed: () {
                  widget.sendEvent(widget.controlId, 'action', {});
                },
                child: Text(widget.actionLabel!),
              ),
      ).show(context);
      return;
    }
    final payload = NotificationPayload(
      controlId: widget.controlId,
      message: widget.message,
      label: widget.label,
      durationMs: widget.durationMs,
      actionLabel: widget.actionLabel,
      variant: widget.variant,
      style: widget.style,
      icon: widget.icon,
      animation: widget.animation,
      instant: widget.instant,
      priority: widget.priority,
      sendEvent: widget.sendEvent,
    );
    NotificationManager.instance.showToast(payload);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

