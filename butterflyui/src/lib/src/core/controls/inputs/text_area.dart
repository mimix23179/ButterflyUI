import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/inputs/text_field.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTextAreaControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUITextField(
    controlId: controlId,
    value: props['value']?.toString() ?? '',
    placeholder: props['placeholder']?.toString(),
    label: props['label']?.toString(),
    helperText: props['helper_text']?.toString(),
    errorText: props['error_text']?.toString(),
    multiline: true,
    minLines: coerceOptionalInt(props['min_lines']) ?? 3,
    maxLines: coerceOptionalInt(props['max_lines']),
    password: false,
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    readOnly: props['read_only'] == true,
    autofocus: props['autofocus'] == true,
    dense: props['dense'] == true,
    emitOnChange: props['emit_on_change'] == null
        ? true
        : (props['emit_on_change'] == true),
    debounceMs: coerceOptionalInt(props['debounce_ms']) ?? 250,
    events: props['events'],
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
