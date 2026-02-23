import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSubmitScopeControl(
  String controlId,
  Map<String, Object?> props,
  List rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _SubmitScopeControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildFromControl: buildFromControl,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _SubmitIntent extends Intent {
  const _SubmitIntent(this.ctrl);
  final bool ctrl;
}

class _SubmitScopeControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List rawChildren;
  final Widget Function(Map<String, Object?> child) buildFromControl;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _SubmitScopeControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildFromControl,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_SubmitScopeControl> createState() => _SubmitScopeControlState();
}

class _SubmitScopeControlState extends State<_SubmitScopeControl> {
  Map<String, Object?> _payload = <String, Object?>{};

  bool get _enabled =>
      widget.props['enabled'] == null ? true : (widget.props['enabled'] == true);

  bool get _submitOnEnter => widget.props['submit_on_enter'] == true;
  bool get _submitOnCtrlEnter => widget.props['submit_on_ctrl_enter'] == true;

  @override
  void initState() {
    super.initState();
    _payload = _coercePayload(widget.props['payload']);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _SubmitScopeControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props['payload'] != widget.props['payload']) {
      _payload = _coercePayload(widget.props['payload']);
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
      case 'submit':
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : _payload;
        _submit(payload, trigger: 'invoke');
        return true;
      case 'get_state':
        return <String, Object?>{
          'enabled': _enabled,
          'submit_on_enter': _submitOnEnter,
          'submit_on_ctrl_enter': _submitOnCtrlEnter,
          'payload': _payload,
        };
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw UnsupportedError('Unknown submit_scope method: $method');
    }
  }

  void _submit(Map<String, Object?> payload, {required String trigger}) {
    if (!_enabled || widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, 'submit', {
      'trigger': trigger,
      'payload': payload,
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildFromControl(coerceObjectMap(raw));
        break;
      }
    }

    final shortcuts = <ShortcutActivator, Intent>{
      if (_submitOnEnter)
        const SingleActivator(LogicalKeyboardKey.enter): const _SubmitIntent(false),
      if (_submitOnCtrlEnter)
        const SingleActivator(
          LogicalKeyboardKey.enter,
          control: true,
        ): const _SubmitIntent(true),
    };

    if (shortcuts.isEmpty) return child;

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          _SubmitIntent: CallbackAction<_SubmitIntent>(
            onInvoke: (intent) {
              _submit(_payload, trigger: intent.ctrl ? 'ctrl_enter' : 'enter');
              return null;
            },
          ),
        },
        child: Focus(autofocus: widget.props['autofocus'] == true, child: child),
      ),
    );
  }
}

Map<String, Object?> _coercePayload(Object? raw) {
  if (raw is Map) return coerceObjectMap(raw);
  return <String, Object?>{};
}
