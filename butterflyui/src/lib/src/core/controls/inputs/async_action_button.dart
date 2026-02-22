import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAsyncActionButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AsyncActionButtonControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _AsyncActionButtonControl extends StatefulWidget {
  const _AsyncActionButtonControl({
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
  State<_AsyncActionButtonControl> createState() => _AsyncActionButtonControlState();
}

class _AsyncActionButtonControlState extends State<_AsyncActionButtonControl> {
  late bool _busy;

  @override
  void initState() {
    super.initState();
    _busy = widget.props['busy'] == true || widget.props['loading'] == true;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _AsyncActionButtonControl oldWidget) {
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
      _busy = widget.props['busy'] == true || widget.props['loading'] == true;
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_busy':
        setState(() => _busy = args['value'] == true);
        _emit('state', _statePayload());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'action').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown async_action_button method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'busy': _busy, 'loading': _busy};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final label = (widget.props['text'] ?? widget.props['label'] ?? 'Run').toString();
    final busyLabel = (widget.props['busy_label'] ?? 'Working...').toString();
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final disabledWhileBusy = widget.props['disabled_while_busy'] == null || widget.props['disabled_while_busy'] == true;
    final canPress = enabled && !(_busy && disabledWhileBusy);

    return FilledButton.icon(
      onPressed: canPress
          ? () {
              _emit('click', <String, Object?>{'busy': _busy});
            }
          : null,
      icon: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.play_arrow),
      label: Text(_busy ? busyLabel : label),
    );
  }
}
