import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/controls/common/icon_value.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildListTileControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  final title = (props['title'] ?? props['label'] ?? props['text'] ?? 'Item')
      .toString();
  final subtitle = props['subtitle']?.toString();
  final meta = (props['meta'] ?? props['trailing_text'])?.toString();
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);

  final leading = buildIconValue(
    props['leading_icon'] ?? props['icon'] ?? props['leading_text'],
    size: 18,
  );
  final trailing = buildIconValue(
    props['trailing_icon'],
    size: 18,
    textStyle: ThemeData.fallback().textTheme.labelMedium,
  );

  return ListTile(
    dense: props['dense'] == true,
    enabled: enabled,
    selected: props['selected'] == true,
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle),
    leading: leading,
    trailing: trailing ?? (meta == null ? null : Text(meta)),
    onTap: enabled
        ? () {
            if (controlId.isEmpty) return;
            sendEvent(controlId, 'select', {
              'id': props['id']?.toString() ?? title,
              'title': title,
              if (props['value'] != null) 'value': props['value'],
              if (props['meta'] != null) 'meta': props['meta'],
            });
          }
        : null,
  );
}
