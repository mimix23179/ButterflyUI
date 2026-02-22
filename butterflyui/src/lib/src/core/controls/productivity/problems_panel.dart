import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _ProblemItem {
  final String id;
  final String severity;
  final String message;
  final String? file;
  final int? line;
  final int? column;

  const _ProblemItem({
    required this.id,
    required this.severity,
    required this.message,
    required this.file,
    required this.line,
    required this.column,
  });
}

_ProblemItem _parseProblem(Object? raw, int index) {
  final map = raw is Map ? coerceObjectMap(raw) : const <String, Object?>{};
  final id = (map['id'] ?? map['code'] ?? 'problem_$index').toString();
  return _ProblemItem(
    id: id,
    severity: (map['severity'] ?? 'info').toString().toLowerCase(),
    message: (map['message'] ?? map['text'] ?? id).toString(),
    file: map['file']?.toString(),
    line: (map['line'] as num?)?.toInt(),
    column: (map['column'] as num?)?.toInt(),
  );
}

IconData _iconForSeverity(String severity) {
  switch (severity) {
    case 'error':
      return Icons.error_outline;
    case 'warning':
      return Icons.warning_amber_outlined;
    default:
      return Icons.info_outline;
  }
}

Color? _colorForSeverity(BuildContext context, String severity) {
  final scheme = Theme.of(context).colorScheme;
  switch (severity) {
    case 'error':
      return scheme.error;
    case 'warning':
      return scheme.tertiary;
    default:
      return scheme.primary;
  }
}

Widget buildProblemsPanelControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final problems = <_ProblemItem>[];
  final raw = props['problems'] ?? props['items'];
  if (raw is List) {
    for (var i = 0; i < raw.length; i += 1) {
      problems.add(_parseProblem(raw[i], i));
    }
  }

  if (problems.isEmpty) {
    return const Center(child: Text('No problems'));
  }

  return ListView.separated(
    itemCount: problems.length,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (context, index) {
      final item = problems[index];
      final location = [
        if (item.file != null && item.file!.isNotEmpty) item.file,
        if (item.line != null) 'L${item.line}',
        if (item.column != null) 'C${item.column}',
      ].join(':');
      return ListTile(
        dense: true,
        leading: Icon(
          _iconForSeverity(item.severity),
          size: 18,
          color: _colorForSeverity(context, item.severity),
        ),
        title: Text(item.message, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: location.isNotEmpty
            ? Text(location, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        onTap: () {
          sendEvent(controlId, 'select', {
            'id': item.id,
            'severity': item.severity,
            'message': item.message,
            if (item.file != null) 'file': item.file,
            if (item.line != null) 'line': item.line,
            if (item.column != null) 'column': item.column,
          });
        },
      );
    },
  );
}
