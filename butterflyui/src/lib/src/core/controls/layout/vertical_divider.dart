import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/divider.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildVerticalDividerControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> children,
  Widget Function(Map<String, Object?> child) buildFromControl, {
  Color? fallbackColor,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
}) {
  final merged = <String, Object?>{...props};
  merged.putIfAbsent('vertical', () => true);
  return buildDividerControl(
    controlId,
    merged,
    children,
    buildFromControl,
    fallbackColor: fallbackColor,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
