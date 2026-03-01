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

  String _normalizeEventName(String value) {
    final input = value.trim().replaceAll('-', '_');
    if (input.isEmpty) return '';
    final out = StringBuffer();
    for (var i = 0; i < input.length; i += 1) {
      final ch = input[i];
      final isUpper = ch.toUpperCase() == ch && ch.toLowerCase() != ch;
      if (isUpper && i > 0 && input[i - 1] != '_') {
        out.write('_');
      }
      out.write(ch.toLowerCase());
    }
    return out.toString();
  }

  Set<String>? _subscribedEvents() {
    final events = widget.props['events'];
    if (events is! List) return null;
    return events
        .map((e) => _normalizeEventName(e?.toString() ?? ''))
        .where((name) => name.isNotEmpty)
        .toSet();
  }

  bool _isSubscribed(String name) {
    final subscribed = _subscribedEvents();
    if (subscribed == null) return name == 'click';
    return subscribed.contains(_normalizeEventName(name));
  }

  Map<String, Object?> _basePayload() {
    final label =
        (widget.props['text'] ?? widget.props['label'] ?? 'Run').toString();
    final payload = <String, Object?>{
      'label': label,
      if (widget.props['value'] != null) 'value': widget.props['value'],
      'busy': _busy,
      'loading': _busy,
    };
    final actionId = widget.props['action_id']?.toString();
    final actionEventName = widget.props['action_event']?.toString();
    final actionPayload = widget.props['action_payload'];
    if (actionId != null && actionId.isNotEmpty) {
      payload['action_id'] = actionId;
    }
    if (actionEventName != null && actionEventName.isNotEmpty) {
      payload['action_event'] = actionEventName;
    }
    if (actionPayload != null) {
      payload['action_payload'] = actionPayload;
    }
    return payload;
  }

  void _emitPressEvents() {
    final payload = _basePayload();
    final actionId = widget.props['action_id']?.toString();
    final actionEventName = widget.props['action_event']?.toString();
    final actionPayload = widget.props['action_payload'];

    void emitDeclarativeAction(Object? actionSpec, {bool force = false}) {
      var eventName = actionEventName;
      String? resolvedActionId = actionId;
      Object? resolvedActionPayload = actionPayload;

      if (actionSpec == null) {
      } else if (actionSpec is String) {
        final trimmed = actionSpec.trim();
        if (trimmed.isNotEmpty) {
          resolvedActionId = trimmed;
        }
      } else if (actionSpec is Map) {
        final map = coerceObjectMap(actionSpec);
        final mapId =
            map['id']?.toString() ??
            map['action_id']?.toString() ??
            map['name']?.toString();
        if (mapId != null && mapId.isNotEmpty) {
          resolvedActionId = mapId;
        }
        final mapEvent = map['event']?.toString();
        if (mapEvent != null && mapEvent.trim().isNotEmpty) {
          eventName = mapEvent;
        }
        if (map.containsKey('payload')) {
          resolvedActionPayload = map['payload'];
        }
      }

      final resolvedEvent = _normalizeEventName(
        (eventName == null || eventName.isEmpty) ? 'action' : eventName,
      );
      if (resolvedEvent.isEmpty || (!force && !_isSubscribed(resolvedEvent))) {
        return;
      }

      final actionEventPayload = <String, Object?>{
        ...payload,
        if (resolvedActionId != null && resolvedActionId.isNotEmpty)
          'action_id': resolvedActionId,
      };
      if (resolvedActionPayload is Map) {
        actionEventPayload.addAll(coerceObjectMap(resolvedActionPayload));
      } else if (resolvedActionPayload != null) {
        actionEventPayload['action_payload'] = resolvedActionPayload;
      }
      _emit(resolvedEvent, actionEventPayload);
    }

    final events = widget.props['events'];
    if (events is! List) {
      _emit('click', payload);
      emitDeclarativeAction(widget.props['action'], force: true);
      if (widget.props['actions'] is List) {
        for (final actionSpec in widget.props['actions'] as List) {
          emitDeclarativeAction(actionSpec, force: true);
        }
      } else if (actionId != null || actionPayload != null) {
        emitDeclarativeAction(const <String, Object?>{}, force: true);
      }
      return;
    }

    if (_isSubscribed('click')) {
      _emit('click', payload);
    }
    if (_isSubscribed('press')) {
      _emit('press', payload);
    }
    if (_isSubscribed('tap')) {
      _emit('tap', payload);
    }
    if (_isSubscribed('action')) {
      _emit('action', payload);
    }
    emitDeclarativeAction(widget.props['action']);
    if (widget.props['actions'] is List) {
      for (final actionSpec in widget.props['actions'] as List) {
        emitDeclarativeAction(actionSpec);
      }
    } else if (actionId != null || actionPayload != null) {
      emitDeclarativeAction(const <String, Object?>{});
    }
  }

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
      final nextBusy =
          widget.props['busy'] == true || widget.props['loading'] == true;
      if (_busy != nextBusy) {
        setState(() => _busy = nextBusy);
      } else {
        _busy = nextBusy;
      }
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
              _emitPressEvents();
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
