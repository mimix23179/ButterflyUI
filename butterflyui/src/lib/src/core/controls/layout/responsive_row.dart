import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/wrap.dart';

Widget buildResponsiveRowControl(
  Map<String, Object?> props,
  List<dynamic> children,
  CandyTokens tokens,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  final merged = <String, Object?>{...props};
  merged.putIfAbsent('direction', () => 'horizontal');
  return buildWrapControl(merged, children, tokens, buildFromControl);
}
