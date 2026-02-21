import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/controls/common/icon_value.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildEmptyStateControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  final title = (props['title'] ?? 'Nothing here').toString();
  final message =
      (props['message'] ?? props['text'] ?? 'No items are available yet.')
          .toString();
  final actionLabel = props['action_label']?.toString();
  final icon =
      buildIconValue(props['icon'], size: 34) ??
      const Icon(Icons.inbox_outlined, size: 34);

  return Builder(
    builder: (context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (actionLabel != null && actionLabel.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: controlId.isEmpty
                      ? null
                      : () {
                          sendEvent(controlId, 'action', {
                            'label': actionLabel,
                          });
                        },
                  child: Text(actionLabel),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
