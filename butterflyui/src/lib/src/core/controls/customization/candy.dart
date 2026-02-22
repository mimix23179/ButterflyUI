import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/card.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/column.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/row.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/stack.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/wrap.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCandySurfaceControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildContainerControl(props, rawChildren, buildChild);
}

Widget buildCandyRowControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildRowControl(props, rawChildren, tokens, buildChild);
}

Widget buildCandyColumnControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildColumnControl(props, rawChildren, tokens, buildChild);
}

Widget buildCandyStackControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildStackControl(props, rawChildren, buildChild);
}

Widget buildCandyWrapControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildWrapControl(props, rawChildren, tokens, buildChild);
}

Widget buildCandyButtonAliasControl(
  String controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildButtonControl(controlId, props, tokens, sendEvent);
}

Widget buildCandyCardAliasControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildCardControl(props, rawChildren, tokens, buildChild);
}
