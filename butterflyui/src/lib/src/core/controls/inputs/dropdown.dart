import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/inputs/combo_box.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDropdownControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildComboboxControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
