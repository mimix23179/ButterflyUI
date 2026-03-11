import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildNoticeBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUINoticeBar(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUINoticeBar extends StatefulWidget {
  const _ButterflyUINoticeBar({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUINoticeBar> createState() => _ButterflyUINoticeBarState();
}

class _ButterflyUINoticeBarState extends State<_ButterflyUINoticeBar> {
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
  void didUpdateWidget(covariant _ButterflyUINoticeBar oldWidget) {
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
      case 'set_text':
        {
          setState(() {
            _liveProps = <String, Object?>{
              ..._liveProps,
              'text': args['text']?.toString() ?? '',
            };
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
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown notice_bar method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'text': (_liveProps['text'] ?? '').toString(),
      'variant': (_liveProps['variant'] ?? 'info').toString(),
      'dismissible': _liveProps['dismissible'] == true,
      'action_label': _liveProps['action_label']?.toString(),
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) {
      return;
    }
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final text = (_liveProps['text'] ?? '').toString();
    final variant = (_liveProps['variant'] ?? 'info').toString().toLowerCase();
    final dismissible = _liveProps['dismissible'] == true;
    final actionLabel = _liveProps['action_label']?.toString();
    final actionId = _liveProps['action_id']?.toString() ?? 'action';
    final fallbackBackground = switch (variant) {
      'success' => butterflyuiStatusColor(context, 'success').withValues(alpha: 0.18),
      'warning' => butterflyuiStatusColor(context, 'warning').withValues(alpha: 0.18),
      'error' => butterflyuiStatusColor(context, 'error').withValues(alpha: 0.18),
      _ => butterflyuiStatusColor(context, 'info').withValues(alpha: 0.18),
    };
    final surface = butterflyuiResolveSurfaceChrome(
      context,
      _liveProps,
      fallbackBackground: fallbackBackground,
      fallbackBorder: butterflyuiBorder(context).withValues(alpha: 0.6),
      fallbackRadius: coerceDouble(_liveProps['radius']) ?? 8,
      fallbackPadding:
          coercePadding(_liveProps['padding']) ??
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
    final labelColor = butterflyuiResolveSlotColor(
      context,
      _liveProps,
      slot: 'label',
      fallback: butterflyuiText(context),
    );
    final icon = buildIconValue(
      _liveProps['icon'],
      size: 16,
      color: labelColor,
    );

    final bar = Container(
      padding: surface.contentPadding,
      decoration: BoxDecoration(
        color: surface.backgroundColor,
        gradient: surface.gradient,
        borderRadius: BorderRadius.circular(surface.radius),
        border: Border.all(
          color: surface.borderColor,
          width: surface.borderWidth,
        ),
        boxShadow: surface.boxShadow,
      ),
      child: Row(
        children: [
          if (icon != null) ...[icon, const SizedBox(width: 8)],
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: labelColor),
            ),
          ),
          if (actionLabel != null && actionLabel.isNotEmpty)
            TextButton(
              onPressed: widget.controlId.isEmpty
                  ? null
                  : () => _emit('action', {
                      'action_id': actionId,
                      'action_label': actionLabel,
                    }),
              style: TextButton.styleFrom(foregroundColor: labelColor),
              child: Text(actionLabel),
            ),
          if (dismissible)
            IconButton(
              onPressed: widget.controlId.isEmpty
                  ? null
                  : () => _emit('dismiss', {}),
              icon: Icon(Icons.close, color: labelColor),
            ),
        ],
      ),
    );
    return applyControlFrameLayout(
      props: _liveProps,
      child: bar,
      clipToRadius: true,
      defaultRadius: surface.radius,
    );
  }
}
