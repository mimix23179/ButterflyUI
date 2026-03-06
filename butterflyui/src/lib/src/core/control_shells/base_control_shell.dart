import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

String normalizeControlEventName(String value) {
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

Set<String>? resolveSubscribedEvents(Object? events) {
  if (events is! List) return null;
  return events
      .map((event) => normalizeControlEventName(event?.toString() ?? ''))
      .where((event) => event.isNotEmpty)
      .toSet();
}

bool isControlEventSubscribed(Set<String>? subscribedEvents, String name) {
  if (subscribedEvents == null) return name == 'click';
  return subscribedEvents.contains(normalizeControlEventName(name));
}

bool? coerceShellBoolOrNull(Object? raw) {
  if (raw == null) return null;
  if (raw is bool) return raw;
  if (raw is num) return raw != 0;
  final s = raw.toString().trim().toLowerCase();
  if (s == 'true' || s == '1' || s == 'yes' || s == 'on') return true;
  if (s == 'false' || s == '0' || s == 'no' || s == 'off') return false;
  if (s == 'null' || s == 'none') return null;
  return null;
}

bool coerceShellBool(Object? raw, {required bool fallback}) {
  return coerceShellBoolOrNull(raw) ?? fallback;
}

void registerInvokeHandlerIfNeeded({
  required String controlId,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIInvokeHandler handler,
}) {
  if (controlId.isEmpty) return;
  registerInvokeHandler(controlId, handler);
}

void unregisterInvokeHandlerIfNeeded({
  required String controlId,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
}) {
  if (controlId.isEmpty) return;
  unregisterInvokeHandler(controlId);
}

void syncInvokeHandlerRegistration({
  required String previousControlId,
  required String currentControlId,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUIInvokeHandler handler,
}) {
  if (previousControlId == currentControlId) return;
  unregisterInvokeHandlerIfNeeded(
    controlId: previousControlId,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
  registerInvokeHandlerIfNeeded(
    controlId: currentControlId,
    registerInvokeHandler: registerInvokeHandler,
    handler: handler,
  );
}

void emitSubscribedEvent({
  required String controlId,
  required Object? subscribedEventsSource,
  required String name,
  required Map<String, Object?> payload,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  if (controlId.isEmpty) return;
  final subscribedEvents = resolveSubscribedEvents(subscribedEventsSource);
  if (!isControlEventSubscribed(subscribedEvents, name)) return;
  sendEvent(controlId, normalizeControlEventName(name), payload);
}
