import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/inputs/form.dart';

Widget buildRuntimeFormFieldControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  return buildFormFieldControl(props, rawChildren, buildChild);
}
