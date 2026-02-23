import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/inputs/emoji_picker.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildIconPickerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildEmojiPickerControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
