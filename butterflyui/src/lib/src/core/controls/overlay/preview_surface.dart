import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPreviewSurfaceControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  Widget content = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      content = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  final title = props['title']?.toString();
  final subtitle = props['subtitle']?.toString();
  final source = props['source']?.toString();
  final loading = props['loading'] == true;

  return InkWell(
    onTap: controlId.isEmpty
        ? null
        : () {
            sendEvent(controlId, 'open', {
              'source': source,
              'title': title,
            });
          },
    child: Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.4),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null || subtitle != null)
                ListTile(
                  dense: true,
                  title: title == null ? null : Text(title),
                  subtitle: subtitle == null ? null : Text(subtitle),
                ),
              if (loading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else
                content,
            ],
          ),
        );
      },
    ),
  );
}
