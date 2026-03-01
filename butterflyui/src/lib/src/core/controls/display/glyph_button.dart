import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGlyphButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final glyph = (props['glyph'] ?? props['icon'] ?? '').toString();
  final tooltip = props['tooltip']?.toString();
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final events = props['events'];

  String normalizeEventName(String value) {
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

  final subscribedEvents = events is List
      ? events
            .map((e) => normalizeEventName(e?.toString() ?? ''))
            .where((name) => name.isNotEmpty)
            .toSet()
      : null;

  bool isSubscribed(String name) {
    if (subscribedEvents == null) return name == 'click';
    return subscribedEvents.contains(normalizeEventName(name));
  }

  final size = coerceDouble(props['size']);
  final color = coerceColor(props['color']);
  final iconWidget =
      buildIconValue(glyph, size: size, color: color) ??
      Icon(Icons.circle, size: size, color: color);
  final button = IconButton(
    icon: iconWidget,
    onPressed: !enabled
        ? null
        : () {
            if (controlId.isEmpty) return;
            final payload = <String, Object?>{
              'glyph': glyph,
              if (props['value'] != null) 'value': props['value'],
            };
            final actionId = props['action_id']?.toString();
            final actionEventName = props['action_event']?.toString();
            final actionPayload = props['action_payload'];
            if (actionId != null && actionId.isNotEmpty) {
              payload['action_id'] = actionId;
            }
            if (actionEventName != null && actionEventName.isNotEmpty) {
              payload['action_event'] = actionEventName;
            }
            if (actionPayload != null) {
              payload['action_payload'] = actionPayload;
            }

            void emitDeclarativeAction(Object? actionSpec, {bool force = false}) {
              var eventName = actionEventName;
              String? resolvedActionId = actionId;
              Object? resolvedActionPayload = actionPayload;

              if (actionSpec is String) {
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

              final resolvedEvent = normalizeEventName(
                (eventName == null || eventName.isEmpty) ? 'action' : eventName,
              );
              if (resolvedEvent.isEmpty || (!force && !isSubscribed(resolvedEvent))) {
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
              sendEvent(controlId, resolvedEvent, actionEventPayload);
            }

            if (events is! List) {
              sendEvent(controlId, 'click', payload);
              emitDeclarativeAction(props['action'], force: true);
              if (props['actions'] is List) {
                for (final actionSpec in props['actions'] as List) {
                  emitDeclarativeAction(actionSpec, force: true);
                }
              } else if (actionId != null || actionPayload != null) {
                emitDeclarativeAction(const <String, Object?>{}, force: true);
              }
              return;
            }

            if (isSubscribed('click')) {
              sendEvent(controlId, 'click', payload);
            }
            if (isSubscribed('press')) {
              sendEvent(controlId, 'press', payload);
            }
            if (isSubscribed('tap')) {
              sendEvent(controlId, 'tap', payload);
            }
            if (isSubscribed('action')) {
              sendEvent(controlId, 'action', payload);
            }
            emitDeclarativeAction(props['action']);
            if (props['actions'] is List) {
              for (final actionSpec in props['actions'] as List) {
                emitDeclarativeAction(actionSpec);
              }
            } else if (actionId != null || actionPayload != null) {
              emitDeclarativeAction(const <String, Object?>{});
            }
          },
  );

  if (tooltip == null || tooltip.isEmpty) return button;
  return Tooltip(message: tooltip, child: button);
}

