import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/lists/data_table.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDataGridControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final merged = <String, Object?>{
    ...props,
    'dense': props['dense'] ?? true,
    'striped': props['striped'] ?? true,
    'show_header': props['show_header'] ?? true,
    'grid_mode': 'data_grid',
  };
  return buildDataTableControl(
    controlId,
    merged,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
