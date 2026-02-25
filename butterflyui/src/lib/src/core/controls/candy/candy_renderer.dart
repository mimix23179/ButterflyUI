import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/candy/candy_host.dart';
import 'package:butterflyui_runtime/src/core/controls/candy/candy_registry.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget? buildCandyAliasedControl({
  required String type,
  required String controlId,
  required Map<String, Object?> props,
  required List<dynamic> rawChildren,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> child) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  final module = candyModuleFromControlType(type);
  if (module == null) return null;
  return buildCandyFamilyControl(
    controlId,
    <String, Object?>{...props, 'module': module},
    rawChildren,
    tokens,
    buildChild,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
