import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

typedef ButterflyUIRuntimePropsBuilder =
    Widget Function(Map<String, Object?> liveProps);
typedef ButterflyUIRuntimeStateBuilder =
    Map<String, Object?> Function(Map<String, Object?> liveProps);

Widget buildRuntimePropsControl({
  required Map<String, Object?> props,
  required ButterflyUIRuntimePropsBuilder builder,
  String controlId = '',
  ButterflyUIRegisterInvokeHandler? registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent? sendEvent,
  ButterflyUIRuntimeStateBuilder? stateBuilder,
}) {
  return _ButterflyUIRuntimePropsControl(
    controlId: controlId,
    props: props,
    builder: builder,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    stateBuilder: stateBuilder,
  );
}

class _ButterflyUIRuntimePropsControl extends StatefulWidget {
  const _ButterflyUIRuntimePropsControl({
    required this.controlId,
    required this.props,
    required this.builder,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    required this.stateBuilder,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRuntimePropsBuilder builder;
  final ButterflyUIRegisterInvokeHandler? registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent? sendEvent;
  final ButterflyUIRuntimeStateBuilder? stateBuilder;

  @override
  State<_ButterflyUIRuntimePropsControl> createState() =>
      _ButterflyUIRuntimePropsControlState();
}

class _ButterflyUIRuntimePropsControlState
    extends State<_ButterflyUIRuntimePropsControl> {
  Map<String, Object?> _liveProps = const <String, Object?>{};

  @override
  void initState() {
    super.initState();
    _liveProps = <String, Object?>{...widget.props};
    _register();
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIRuntimePropsControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId ||
        oldWidget.registerInvokeHandler != widget.registerInvokeHandler ||
        oldWidget.unregisterInvokeHandler != widget.unregisterInvokeHandler) {
      _unregister(
        controlId: oldWidget.controlId,
        unregisterInvokeHandler: oldWidget.unregisterInvokeHandler,
      );
      _register();
    }
    if (oldWidget.props != widget.props) {
      _liveProps = <String, Object?>{...widget.props};
    }
  }

  @override
  void dispose() {
    _unregister();
    super.dispose();
  }

  void _register() {
    if (widget.controlId.isEmpty || widget.registerInvokeHandler == null) {
      return;
    }
    widget.registerInvokeHandler!(widget.controlId, _handleInvoke);
  }

  void _unregister({
    String? controlId,
    ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
  }) {
    final id = controlId ?? widget.controlId;
    final handler = unregisterInvokeHandler ?? widget.unregisterInvokeHandler;
    if (id.isEmpty || handler == null) {
      return;
    }
    handler(id);
  }

  Map<String, Object?> _statePayload() {
    if (widget.stateBuilder != null) {
      return widget.stateBuilder!(_liveProps);
    }
    return <String, Object?>{..._liveProps};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty || widget.sendEvent == null) {
      return;
    }
    widget.sendEvent!(widget.controlId, event, payload);
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
          final fallback = method == 'trigger' ? 'change' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown runtime props method: $method');
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(_liveProps);
}
