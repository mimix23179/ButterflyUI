import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildFormControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final title = props['title']?.toString();
  final description = props['description']?.toString();
  final spacing = coerceDouble(props['spacing']) ?? 12;
  final padding =
      coercePadding(props['padding'] ?? props['content_padding']) ??
      const EdgeInsets.all(8);

  final children = <Widget>[];
  for (final raw in rawChildren) {
    if (raw is Map) {
      children.add(buildChild(coerceObjectMap(raw)));
    }
  }

  return Padding(
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null && title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        if (description != null && description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              description,
              style: TextStyle(color: Colors.white.withOpacity(0.75)),
            ),
          ),
        ..._withSpacing(children, spacing),
      ],
    ),
  );
}

Widget buildFormFieldControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final label = props['label']?.toString();
  final description = props['description']?.toString();
  final requiredField = props['required'] == true;
  final helperText = props['helper_text']?.toString();
  final errorText = props['error_text']?.toString();
  final spacing = coerceDouble(props['spacing']) ?? 6;

  Widget child = const SizedBox.shrink();
  if (rawChildren.isNotEmpty && rawChildren.first is Map) {
    child = buildChild(coerceObjectMap(rawChildren.first as Map));
  } else if (props['child'] is Map) {
    child = buildChild(coerceObjectMap(props['child'] as Map));
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
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ]
                : const [],
          ),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      if (description != null && description.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 12,
            ),
          ),
        ),
      SizedBox(height: spacing),
      child,
      if (helperText != null && helperText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            helperText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 12,
            ),
          ),
        ),
      if (errorText != null && errorText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            errorText,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
        ),
    ],
  );
}

Widget buildValidationSummaryControl(Map<String, Object?> props) {
  final errors = <String>[];
  final source = props['errors'] ?? props['messages'] ?? props['items'];
  if (source is List) {
    for (final item in source) {
      final text = item?.toString() ?? '';
      if (text.isNotEmpty) errors.add(text);
    }
  } else {
    final single = source?.toString() ?? '';
    if (single.isNotEmpty) errors.add(single);
  }
  if (errors.isEmpty) return const SizedBox.shrink();

  final title = (props['title'] ?? 'Please fix the following').toString();
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xff7f1d1d).withOpacity(0.25),
      border: Border.all(color: const Color(0xffef4444).withOpacity(0.55)),
      borderRadius: BorderRadius.circular(coerceDouble(props['radius']) ?? 10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xfffecaca),
          ),
        ),
        const SizedBox(height: 6),
        ...errors.map(
          (error) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              '- $error',
              style: const TextStyle(color: Color(0xfffee2e2)),
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> _withSpacing(List<Widget> children, double spacing) {
  if (children.isEmpty) return const [];
  if (spacing <= 0) return children;
  final out = <Widget>[];
  for (var i = 0; i < children.length; i += 1) {
    if (i > 0) out.add(SizedBox(height: spacing));
    out.add(children[i]);
  }
  return out;
}
