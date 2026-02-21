import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildMarkdownViewControl(Map<String, Object?> props) {
  final value = (props['value'] ?? props['text'] ?? '').toString();
  final selectable = props['selectable'] == true;
  final scrollable = props['scrollable'] == null
      ? true
      : (props['scrollable'] == true);
  final useFlutterMarkdown = props['use_flutter_markdown'] == null
      ? true
      : (props['use_flutter_markdown'] == true);
  final padding = coercePadding(props['content_padding'] ?? props['padding']);

  if (value.isEmpty) {
    return const SizedBox.shrink();
  }

  if (!useFlutterMarkdown) {
    Widget fallback = selectable
        ? SelectableText(value)
        : Text(value, softWrap: true);
    if (padding != null) {
      fallback = Padding(padding: padding, child: fallback);
    }
    if (!scrollable) {
      return fallback;
    }
    return SingleChildScrollView(child: fallback);
  }

  if (scrollable) {
    return Markdown(
      data: value,
      selectable: selectable,
      shrinkWrap: props['shrink_wrap'] == true,
      padding: padding ?? EdgeInsets.zero,
    );
  }

  Widget body = MarkdownBody(data: value, selectable: selectable);
  if (padding != null) {
    body = Padding(padding: padding, child: body);
  }
  return body;
}
