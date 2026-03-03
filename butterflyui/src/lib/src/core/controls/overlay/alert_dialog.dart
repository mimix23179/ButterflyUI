import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/overlay/modal.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAlertDialogControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final transition = props['transition'] is Map
      ? coerceObjectMap(props['transition'] as Map)
      : const <String, Object?>{};

  Widget? child;
  final childFromChildren = rawChildren.whereType<Map>().map(coerceObjectMap);
  if (childFromChildren.isNotEmpty) {
    child = buildFromControl(childFromChildren.first);
  } else if (props['child'] is Map) {
    child = buildFromControl(coerceObjectMap(props['child'] as Map));
  }

  child ??= _buildAlertDialogBody(
    controlId,
    props,
    buildFromControl,
    sendEvent,
  );

  return ButterflyUIModal(
    controlId: controlId,
    child: child,
    initialOpen: props['open'] == true,
    dismissible: props['dismissible'] == true,
    closeOnEscape: props['close_on_escape'] == null
        ? true
        : (props['close_on_escape'] == true),
    trapFocus: props['trap_focus'] == null
        ? true
        : (props['trap_focus'] == true),
    duration: Duration(
      milliseconds:
          (coerceOptionalInt(
                    props['duration_ms'] ?? transition['duration_ms'],
                  ) ??
                  200)
              .clamp(0, 2000),
    ),
    transitionType:
        (props['transition_type']?.toString() ??
                transition['type']?.toString() ??
                'fade')
            .toLowerCase(),
    sourceRect: _coerceRect(props['source_rect'] ?? transition['origin']),
    scrimColor: coerceColor(props['scrim_color']),
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

Widget _buildAlertDialogBody(
  String controlId,
  Map<String, Object?> props,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final title = _coerceDialogNode(
    props['title'],
    buildFromControl,
    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
  );
  final content = _coerceDialogNode(props['content'], buildFromControl, null);

  final actions = _coerceActions(props['actions']);
  final actionWidgets = actions
      .map((action) => _buildActionButton(controlId, action, sendEvent))
      .whereType<Widget>()
      .toList();

  return ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: coerceDouble(props['max_width']) ?? 520,
      minWidth: coerceDouble(props['min_width']) ?? 280,
    ),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(coerceDouble(props['radius']) ?? 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) title,
            if (title != null && content != null) const SizedBox(height: 8),
            if (content != null) content,
            if (actionWidgets.isNotEmpty) const SizedBox(height: 16),
            if (actionWidgets.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var i = 0; i < actionWidgets.length; i += 1) ...[
                    if (i > 0) const SizedBox(width: 8),
                    actionWidgets[i],
                  ],
                ],
              ),
          ],
        ),
      ),
    ),
  );
}

Widget? _coerceDialogNode(
  Object? value,
  Widget Function(Map<String, Object?> child) buildFromControl,
  TextStyle? style,
) {
  if (value == null) return null;
  if (value is Map) {
    return buildFromControl(coerceObjectMap(value));
  }
  final text = value.toString();
  if (text.isEmpty) return null;
  return Text(text, style: style);
}

List<Map<String, Object?>> _coerceActions(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  return raw
      .map((entry) {
        if (entry is Map) return coerceObjectMap(entry);
        final label = entry?.toString();
        if (label == null || label.isEmpty) return null;
        return <String, Object?>{'label': label};
      })
      .whereType<Map<String, Object?>>()
      .toList();
}

Widget? _buildActionButton(
  String controlId,
  Map<String, Object?> action,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final label = (action['label'] ?? action['text'])?.toString();
  if (label == null || label.isEmpty) return null;
  final actionId = (action['id'] ?? label).toString();
  final variant = (action['variant'] ?? 'text').toString().toLowerCase();
  final enabled = action['enabled'] != false;
  final payload = <String, Object?>{
    'id': actionId,
    'label': label,
    if (action['value'] != null) 'value': action['value'],
  };

  void handleTap() {
    if (!enabled || controlId.isEmpty) return;
    sendEvent(controlId, 'action', payload);
  }

  switch (variant) {
    case 'filled':
    case 'elevated':
      return ElevatedButton(
        onPressed: enabled ? handleTap : null,
        child: Text(label),
      );
    case 'outlined':
      return OutlinedButton(
        onPressed: enabled ? handleTap : null,
        child: Text(label),
      );
    default:
      return TextButton(
        onPressed: enabled ? handleTap : null,
        child: Text(label),
      );
  }
}

Rect? _coerceRect(Object? raw) {
  if (raw is List && raw.length >= 4) {
    final left = coerceDouble(raw[0]);
    final top = coerceDouble(raw[1]);
    final width = coerceDouble(raw[2]);
    final height = coerceDouble(raw[3]);
    if (left != null && top != null && width != null && height != null) {
      return Rect.fromLTWH(left, top, width, height);
    }
  }
  if (raw is Map) {
    final map = coerceObjectMap(raw);
    final left = coerceDouble(map['x'] ?? map['left']);
    final top = coerceDouble(map['y'] ?? map['top']);
    final width = coerceDouble(map['width'] ?? map['w']);
    final height = coerceDouble(map['height'] ?? map['h']);
    if (left != null && top != null && width != null && height != null) {
      return Rect.fromLTWH(left, top, width, height);
    }
  }
  return null;
}
