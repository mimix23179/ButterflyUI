import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildProgressOverlayControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final open = props['open'] == true;
  final progress = coerceDouble(props['progress']);
  final indeterminate = props['indeterminate'] == true || progress == null;
  final label = props['label']?.toString();
  final cancellable = props['cancellable'] == true;

  if (!open) return child;

  return Builder(
    builder: (context) {
      final scrimColor = Theme.of(context).colorScheme.scrim.withOpacity(0.35);
      return Stack(
        fit: StackFit.passthrough,
        children: [
          child,
          Positioned.fill(
            child: GestureDetector(
              onTap: !cancellable || controlId.isEmpty
                  ? null
                  : () => sendEvent(controlId, 'cancel', const {}),
              child: ColoredBox(
                color: scrimColor,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 220,
                            child: indeterminate
                                ? const LinearProgressIndicator()
                                : LinearProgressIndicator(
                                    value: progress.clamp(0.0, 1.0),
                                  ),
                          ),
                          if (label != null && label.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(label),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
