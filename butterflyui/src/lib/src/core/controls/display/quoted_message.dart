import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildQuotedMessageControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final text = (props['text'] ?? '').toString();
  final author = props['author']?.toString();
  final timestamp = props['timestamp']?.toString();
  final compact = props['compact'] == true;

  if (text.isEmpty && (author == null || author.isEmpty)) {
    return const SizedBox.shrink();
  }

  return Builder(
    builder: (context) {
      final dividerColor = Theme.of(context).dividerColor;
      final mutedTextColor = Theme.of(
        context,
      ).textTheme.bodySmall?.color?.withOpacity(0.75);
      return InkWell(
        onTap: controlId.isEmpty
            ? null
            : () {
                sendEvent(controlId, 'click', {
                  'text': text,
                  'author': author,
                  'timestamp': timestamp,
                });
              },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: compact ? 6 : 10,
          ),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: dividerColor, width: 3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (author != null && author.isNotEmpty)
                Text(author, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(text),
                ),
              if (timestamp != null && timestamp.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    timestamp,
                    style: TextStyle(fontSize: 12, color: mutedTextColor),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
