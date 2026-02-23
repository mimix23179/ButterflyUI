import 'package:flutter/material.dart';

Widget buildMessageMetaControl(Map<String, Object?> props) {
  final timestamp = (props['timestamp'] ?? '').toString();
  final status = (props['status'] ?? '').toString();
  final edited = props['edited'] == true;
  final pinned = props['pinned'] == true;
  final dense = props['dense'] == true;
  final align = (props['align'] ?? 'start').toString().toLowerCase();

  final parts = <String>[];
  if (timestamp.isNotEmpty) parts.add(timestamp);
  if (status.isNotEmpty) parts.add(status);
  if (edited) parts.add('edited');
  if (pinned) parts.add('pinned');

  final text = parts.join(' • ');
  final widget = Text(
    text,
    style: TextStyle(
      fontSize: dense ? 10 : 12,
      color: Colors.white60,
    ),
  );

  switch (align) {
    case 'center':
      return Center(child: widget);
    case 'right':
    case 'end':
      return Align(alignment: Alignment.centerRight, child: widget);
    default:
      return Align(alignment: Alignment.centerLeft, child: widget);
  }
}
