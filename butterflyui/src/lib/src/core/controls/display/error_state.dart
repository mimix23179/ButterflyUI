import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/controls/common/icon_value.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildErrorStateControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  final title = (props['title'] ?? 'Something went wrong').toString();
  final message = (props['message'] ?? props['text'] ?? 'Please try again.')
      .toString();
  final detail = props['detail']?.toString();
  final actionLabel = (props['action_label'] ?? 'Retry').toString();
  final icon =
      buildIconValue(props['icon'], size: 34) ??
      const Icon(Icons.error_outline, size: 34);

  return Builder(
    builder: (context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme(
                data: IconThemeData(color: Theme.of(context).colorScheme.error),
                child: icon,
              ),
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
              if (detail != null && detail.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    detail,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              FilledButton.tonal(
                onPressed: controlId.isEmpty
                    ? null
                    : () {
                        sendEvent(controlId, 'retry', {'label': actionLabel});
                        sendEvent(controlId, 'action', {'label': actionLabel});
                      },
                child: Text(actionLabel),
              ),
            ],
          ),
        ),
      );
    },
  );
}
