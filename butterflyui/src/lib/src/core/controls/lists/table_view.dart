import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/lists/data_table.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTableViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final merged = <String, Object?>{
    ...props,
    'dense': props['dense'] ?? false,
    'striped': props['striped'] ?? false,
    'show_header': props['show_header'] ?? true,
    'grid_mode': 'table_view',
  };
  return buildDataTableControl(
    controlId,
    merged,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
