library code_editor_submodule_diagnostics;

import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _diagnosticsModules = {
  'diagnostics_panel',
  'diagnostic_stream',
  'inline_error_view',
};

Widget? buildCodeEditorDiagnosticsModule(
    String module, CodeEditorSubmoduleContext ctx) {
  if (!_diagnosticsModules.contains(module)) return null;
  return _DiagnosticsWidget(ctx: ctx);
}

class _DiagnosticsWidget extends StatelessWidget {
  const _DiagnosticsWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final module = ctx.module;

    final raw = m['items'] ?? m['diagnostics'] ?? m['markers'];
    final items = raw is List ? raw : const <dynamic>[];

    final counts = m['counts'];
    final errorCount =
        counts is Map ? (counts['error'] ?? counts['errors'] ?? 0) : 0;
    final warnCount =
        counts is Map ? (counts['warning'] ?? counts['warnings'] ?? 0) : 0;
    final infoCount =
        counts is Map ? (counts['info'] ?? counts['information'] ?? 0) : 0;

    Color severityColor(String severity) {
      switch (severity.toLowerCase()) {
        case 'error':
          return Colors.red.shade700;
        case 'warning':
        case 'warn':
          return Colors.orange.shade700;
        case 'hint':
          return Colors.blue.shade400;
        default:
          return Colors.blueGrey;
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with counts
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(Icons.bug_report_outlined, size: 14),
                const SizedBox(width: 6),
                Text(module.replaceAll('_', ' '),
                    style: Theme.of(context).textTheme.labelMedium),
                const Spacer(),
                if (errorCount is num && errorCount > 0)
                  _badge(context, '$errorCount ✕', Colors.red),
                if (warnCount is num && warnCount > 0)
                  _badge(context, '$warnCount ⚠', Colors.orange),
                if (infoCount is num && infoCount > 0)
                  _badge(context, '$infoCount ℹ', Colors.blue),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                  'No diagnostics for ${module.replaceAll('_', ' ')}',
                  style: Theme.of(context).textTheme.bodySmall),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length.clamp(0, 50),
                itemBuilder: (context, i) {
                  final item = items[i];
                  final message = item is Map
                      ? (item['message'] ?? item['text'] ?? item).toString()
                      : item.toString();
                  final severity = item is Map
                      ? (item['severity'] ?? 'info').toString()
                      : 'info';
                  final line = item is Map ? item['line'] : null;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.5)),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 3,
                          height: 16,
                          margin: const EdgeInsets.only(right: 8, top: 2),
                          decoration: BoxDecoration(
                            color: severityColor(severity),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: Text(message,
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                        if (line != null)
                          Text('L$line',
                              style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
