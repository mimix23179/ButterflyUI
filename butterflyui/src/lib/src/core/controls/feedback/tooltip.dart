import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTooltipControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUITooltipControl(
    controlId: controlId,
    props: props,
    child: child,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUITooltipControl extends StatefulWidget {
  const _ButterflyUITooltipControl({
    required this.controlId,
    required this.props,
    required this.child,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUITooltipControl> createState() =>
      _ButterflyUITooltipControlState();
}

class _ButterflyUITooltipControlState
    extends State<_ButterflyUITooltipControl> {
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
  void didUpdateWidget(covariant _ButterflyUITooltipControl oldWidget) {
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
          final fallback = method == 'trigger' ? 'show' : method;
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
        throw UnsupportedError('Unknown tooltip method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'message': (_liveProps['message'] ?? _liveProps['text'] ?? '').toString(),
      'prefer_below': _liveProps['prefer_below'] == null
          ? true
          : (_liveProps['prefer_below'] == true),
      'wait_ms': coerceOptionalInt(_liveProps['wait_ms']) ?? 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final message = (_liveProps['message'] ?? _liveProps['text'] ?? '')
        .toString();
    if (message.isEmpty) {
      return widget.child;
    }
    return Tooltip(
      message: message,
      preferBelow: _liveProps['prefer_below'] == null
          ? true
          : (_liveProps['prefer_below'] == true),
      waitDuration: Duration(
        milliseconds: coerceOptionalInt(_liveProps['wait_ms']) ?? 0,
      ),
      child: widget.child,
    );
  }
}
