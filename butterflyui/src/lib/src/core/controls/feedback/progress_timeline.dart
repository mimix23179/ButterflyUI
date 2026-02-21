import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildProgressTimelineControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final items = _coerceTimelineItems(props['items']);
  if (items.isEmpty) return const SizedBox.shrink();
  final currentIndex = coerceOptionalInt(props['current_index']) ?? -1;
  final dense = props['dense'] == true;
  final showConnector = props['show_connector'] == null
      ? true
      : (props['show_connector'] == true);

  final children = <Widget>[];
  for (var i = 0; i < items.length; i += 1) {
    final item = items[i];
    final status = _resolveStatus(item.status, i, currentIndex);
    final connectorVisible = showConnector && i < items.length - 1;
    children.add(
      _TimelineRow(
        item: item,
        index: i,
        status: status,
        dense: dense,
        showConnector: connectorVisible,
        onTap: controlId.isEmpty
            ? null
            : () {
                sendEvent(controlId, 'select', {
                  'index': i,
                  'id': item.id,
                  'label': item.label,
                  'status': status.name,
                  'item': item.payload,
                });
              },
      ),
    );
  }

  return ListView(
    shrinkWrap: props['shrink_wrap'] == null
        ? true
        : (props['shrink_wrap'] == true),
    physics: const NeverScrollableScrollPhysics(),
    padding: coercePadding(props['padding']),
    children: children,
  );
}

class _TimelineRow extends StatelessWidget {
  final _TimelineItem item;
  final int index;
  final _TimelineStatus status;
  final bool dense;
  final bool showConnector;
  final VoidCallback? onTap;

  const _TimelineRow({
    required this.item,
    required this.index,
    required this.status,
    required this.dense,
    required this.showConnector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (dotColor, icon) = switch (status) {
      _TimelineStatus.completed => (colors.primary, Icons.check),
      _TimelineStatus.current => (colors.tertiary, Icons.adjust),
      _TimelineStatus.error => (colors.error, Icons.close),
      _TimelineStatus.pending => (colors.outline, Icons.circle_outlined),
    };

    final titleStyle = status == _TimelineStatus.pending
        ? Theme.of(context).textTheme.bodyMedium
        : Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final connectorColor = status == _TimelineStatus.completed
        ? colors.primary.withValues(alpha: 0.6)
        : colors.outline.withValues(alpha: 0.45);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: dense ? 4 : 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: dense ? 22 : 26,
              child: Column(
                children: [
                  Container(
                    width: dense ? 18 : 20,
                    height: dense ? 18 : 20,
                    decoration: BoxDecoration(
                      color: dotColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: dotColor, width: 1.4),
                    ),
                    child: Icon(icon, size: dense ? 11 : 12, color: dotColor),
                  ),
                  if (showConnector)
                    Container(
                      width: 2,
                      height: dense ? 24 : 28,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: connectorColor,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: titleStyle),
                  if (item.description != null &&
                      item.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.description!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _TimelineStatus { pending, current, completed, error }

_TimelineStatus _resolveStatus(String? status, int index, int currentIndex) {
  final value = status?.toLowerCase().trim();
  if (value == 'complete' || value == 'completed' || value == 'done') {
    return _TimelineStatus.completed;
  }
  if (value == 'current' || value == 'active' || value == 'in_progress') {
    return _TimelineStatus.current;
  }
  if (value == 'error' || value == 'failed' || value == 'blocked') {
    return _TimelineStatus.error;
  }
  if (currentIndex < 0) return _TimelineStatus.pending;
  if (index < currentIndex) return _TimelineStatus.completed;
  if (index == currentIndex) return _TimelineStatus.current;
  return _TimelineStatus.pending;
}

class _TimelineItem {
  final String id;
  final String label;
  final String? description;
  final String? status;
  final Map<String, Object?> payload;

  const _TimelineItem({
    required this.id,
    required this.label,
    required this.description,
    required this.status,
    required this.payload,
  });
}

List<_TimelineItem> _coerceTimelineItems(Object? raw) {
  if (raw is! List) return const [];
  final out = <_TimelineItem>[];
  for (var i = 0; i < raw.length; i += 1) {
    final item = raw[i];
    if (item is Map) {
      final map = coerceObjectMap(item);
      final id =
          (map['id'] ?? map['key'] ?? map['value'] ?? map['label'] ?? 'step_$i')
              .toString();
      final label = (map['label'] ?? map['title'] ?? map['text'] ?? id)
          .toString();
      out.add(
        _TimelineItem(
          id: id,
          label: label,
          description: (map['description'] ?? map['subtitle'])?.toString(),
          status: map['status']?.toString(),
          payload: map,
        ),
      );
      continue;
    }
    final text = item?.toString() ?? '';
    if (text.isEmpty) continue;
    out.add(
      _TimelineItem(
        id: 'step_$i',
        label: text,
        description: null,
        status: null,
        payload: {'value': text},
      ),
    );
  }
  return out;
}
