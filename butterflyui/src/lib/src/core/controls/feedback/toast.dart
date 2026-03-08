import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/notifications/notification_manager.dart';
import 'package:butterflyui_runtime/src/core/notifications/notification.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildToastOverlayControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent, {
  String? defaultStyle,
}) {
  return _ButterflyUIToastControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    defaultStyle: defaultStyle,
  );
}

class _ButterflyUIToastControl extends StatefulWidget {
  const _ButterflyUIToastControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    this.defaultStyle,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final String? defaultStyle;

  @override
  State<_ButterflyUIToastControl> createState() =>
      _ButterflyUIToastControlState();
}

class _ButterflyUIToastControlState extends State<_ButterflyUIToastControl> {
  Map<String, Object?> _liveProps = const <String, Object?>{};

  @override
  void initState() {
    super.initState();
    _liveProps = <String, Object?>{...widget.props};
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIToastControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      setState(() {
        _liveProps = <String, Object?>{...widget.props};
      });
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_open':
        {
          setState(() {
            _liveProps = <String, Object?>{
              ..._liveProps,
              'open': args['value'] == true || args['open'] == true,
            };
          });
          return _statePayload();
        }
      case 'show':
        {
          setState(() {
            _liveProps = <String, Object?>{..._liveProps, 'open': true};
          });
          return _statePayload();
        }
      case 'hide':
        {
          setState(() {
            _liveProps = <String, Object?>{..._liveProps, 'open': false};
          });
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            setState(() {
              _liveProps = <String, Object?>{
                ..._liveProps,
                ...coerceObjectMap(incoming),
              };
            });
          }
          return _statePayload();
        }
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'action' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          if (widget.controlId.isNotEmpty) {
            widget.sendEvent(widget.controlId, event, payload);
          }
          return true;
        }
      default:
        throw UnsupportedError('Unknown toast method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'open': _liveProps['open'] == true,
      'message': (_liveProps['message'] ?? _liveProps['text'] ?? '').toString(),
      'label': _liveProps['label']?.toString(),
      'style': (_liveProps['style'] ?? widget.defaultStyle)?.toString(),
      'variant': _liveProps['variant']?.toString(),
      'duration_ms': coerceOptionalInt(_liveProps['duration_ms']) ?? 2400,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ButterflyUIToastWidget(
      controlId: widget.controlId,
      message: (_liveProps['message'] ?? _liveProps['text'] ?? '').toString(),
      label: _liveProps['label']?.toString(),
      open: _liveProps['open'] == true,
      durationMs: coerceOptionalInt(_liveProps['duration_ms']) ?? 2400,
      actionLabel: _liveProps['action_label']?.toString(),
      variant: _liveProps['variant']?.toString(),
      style: (_liveProps['style'] ?? widget.defaultStyle)?.toString(),
      icon: parseIconDataLoose(_liveProps['icon']),
      animation: _liveProps['animation'] is Map
          ? coerceObjectMap(_liveProps['animation'] as Map)
          : null,
      instant: _liveProps['instant'] == true,
      priority: coerceOptionalInt(_liveProps['priority']) ?? 0,
      useFlushbar: _liveProps['use_flushbar'] == true,
      useFlutterToast: _liveProps['use_fluttertoast'] == true,
      toastPosition: _liveProps['toast_position']?.toString(),
      sendEvent: widget.sendEvent,
    );
  }
}

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
      NotificationManager.instance.dismiss(
        widget.controlId,
        reason: 'dismiss',
        emitClose: true,
      );
    }
  }

  @override
  void dispose() {
    // Ensure dismissal without emitting close (widget is being disposed)
    NotificationManager.instance.dismiss(
      widget.controlId,
      reason: 'dispose',
      emitClose: false,
    );
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
