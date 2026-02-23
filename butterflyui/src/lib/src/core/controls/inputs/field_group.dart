import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildFieldGroupControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final label = props['label']?.toString();
  final helperText = props['helper_text']?.toString();
  final errorText = props['error_text']?.toString();
  final requiredField = props['required'] == true;
  final spacing = coerceDouble(props['spacing']) ?? 8;

  final children = <Widget>[];
  for (final raw in rawChildren) {
    if (raw is Map) {
      children.add(buildChild(coerceObjectMap(raw)));
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null && label.isNotEmpty)
        Text.rich(
          TextSpan(
            text: label,
            children: requiredField
                ? const [
                    TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent)),
                  ]
                : const [],
          ),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      if (label != null && label.isNotEmpty) SizedBox(height: spacing),
      ..._withSpacing(children, spacing),
      if (helperText != null && helperText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(helperText, style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: 12)),
        ),
      if (errorText != null && errorText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(errorText, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
        ),
    ],
  );
}

List<Widget> _withSpacing(List<Widget> children, double spacing) {
  if (children.length < 2 || spacing <= 0) return children;
  final out = <Widget>[];
  for (var i = 0; i < children.length; i += 1) {
    if (i > 0) out.add(SizedBox(height: spacing));
    out.add(children[i]);
  }
  return out;
}
