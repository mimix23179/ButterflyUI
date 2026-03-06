import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/focusable_control_shell.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Future<Object?> handleFormFieldInvoke({
  required BuildContext context,
  required FocusNode focusNode,
  required String method,
  required Map<String, Object?> args,
  required FutureOr<Object?> Function(String method, Map<String, Object?> args)
  onUnhandled,
}) {
  return handleFocusableInvoke(
    context: context,
    focusNode: focusNode,
    method: method,
    args: args,
    onUnhandled: (name, payload) async => await onUnhandled(name, payload),
  );
}

void emitFormFieldValueEvents({
  required String controlId,
  required Object? subscribedEventsSource,
  required Map<String, Object?> payload,
  required ButterflyUISendRuntimeEvent sendEvent,
  bool emitChange = true,
  bool emitInput = true,
  bool emitToggle = false,
  bool emitSubmit = false,
}) {
  final subscribedEvents = resolveSubscribedEvents(subscribedEventsSource);

  void emit(String name) {
    if (controlId.isEmpty) return;
    if (subscribedEventsSource is List &&
        !isControlEventSubscribed(subscribedEvents, name)) {
      return;
    }
    sendEvent(controlId, name, payload);
  }

  if (emitChange) {
    emit('change');
  }
  if (emitInput) {
    emit('input');
  }
  if (emitToggle) {
    emit('toggle');
  }
  if (emitSubmit) {
    emit('submit');
  }
}

String? stepSelectionKey(
  List<String> keys,
  String? current,
  int delta, {
  bool wrap = true,
}) {
  if (keys.isEmpty) return null;
  final currentIndex = current == null ? -1 : keys.indexOf(current);
  final startIndex = currentIndex < 0 ? 0 : currentIndex;
  var nextIndex = startIndex + delta;
  if (wrap) {
    while (nextIndex < 0) {
      nextIndex += keys.length;
    }
    nextIndex = nextIndex % keys.length;
  } else {
    if (nextIndex < 0) nextIndex = 0;
    if (nextIndex >= keys.length) nextIndex = keys.length - 1;
  }
  return keys[nextIndex];
}

Widget wrapFocusableFormField({
  required FocusNode focusNode,
  required bool autofocus,
  required ValueChanged<bool>? onFocusChange,
  required Widget child,
}) {
  return Focus(
    focusNode: focusNode,
    autofocus: autofocus,
    onFocusChange: onFocusChange,
    child: child,
  );
}
