import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/display/icon.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRuntimeEmojiIconControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildEmojiIconControl(controlId, props, sendEvent);
}
