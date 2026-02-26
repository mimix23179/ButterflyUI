library terminal_submodule_views;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'terminal_submodule_context.dart';
import 'terminal_submodule_registry.dart';

/// Entry-point for the *views* category.
///
/// Returns `null` when [ctx.module] is not a views module so the caller
/// can fall through to the next category.
Widget? buildTerminalViewsSection(TerminalSubmoduleContext ctx) {
  if (!terminalIsViewModule(ctx.module)) return null;

  final module = ctx.module;

  if (module == 'workbench' || module == 'view') {
    return _WorkbenchViewWidget(ctx: ctx);
  }
  if (module == 'stream' || module == 'stream_view' || module == 'raw_view') {
    return _StreamViewWidget(ctx: ctx);
  }
  if (module == 'timeline' || module == 'replay') {
    return _TimelineViewWidget(ctx: ctx);
  }
  if (module == 'progress' || module == 'progress_view') {
    return _ProgressViewWidget(ctx: ctx);
  }
  if (module == 'log_viewer' || module == 'log_panel') {
    return _LogViewWidget(ctx: ctx);
  }

  // Generic key-value fallback for unmapped view modules.
  return _GenericViewWidget(ctx: ctx);
}

// ---------------------------------------------------------------------------
// Workbench / View
// ---------------------------------------------------------------------------

class _WorkbenchViewWidget extends StatelessWidget {
  const _WorkbenchViewWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final title =
        (section['title'] ?? section['label'] ?? ctx.module).toString();
    final state = (section['state'] ?? ctx.runtimeProps['state'] ?? '').toString();
    final engine = (section['engine'] ?? ctx.runtimeProps['engine'] ?? '').toString();
    final entries = section.entries
        .where((e) => e.key != 'events')
        .toList(growable: false);

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: title,
      child: ListView(
        children: [
          if (state.isNotEmpty)
            _PropRow(fg: fg, label: 'state', value: state),
          if (engine.isNotEmpty)
            _PropRow(fg: fg, label: 'engine', value: engine),
          for (final entry in entries.where(
            (e) => e.key != 'state' && e.key != 'engine',
          ).take(20))
            _PropRow(fg: fg, label: entry.key, value: entry.value.toString()),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stream / StreamView / RawView
// ---------------------------------------------------------------------------

class _StreamViewWidget extends StatelessWidget {
  const _StreamViewWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final lines = _extractLines(section);
    final text =
        (section['text'] ??
            section['raw_text'] ??
            section['output'] ??
            '')
        .toString();

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: ctx.module.replaceAll('_', ' '),
      child: lines.isNotEmpty
          ? ListView(
              reverse: true,
              children: [
                for (final line in lines.reversed.take(80))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      line.toString(),
                      style: TextStyle(color: fg.withValues(alpha: 0.85), fontSize: 11),
                    ),
                  ),
              ],
            )
          : text.isNotEmpty
              ? SingleChildScrollView(
                  child: Text(
                    text,
                    style: TextStyle(color: fg.withValues(alpha: 0.85), fontSize: 11),
                  ),
                )
              : Text(
                  'No output.',
                  style: TextStyle(color: fg.withValues(alpha: 0.5)),
                ),
    );
  }

  List<dynamic> _extractLines(Map<String, Object?> section) {
    for (final key in const ['lines', 'items', 'logs', 'entries']) {
      final v = section[key];
      if (v is List && v.isNotEmpty) return v;
    }
    return const [];
  }
}

// ---------------------------------------------------------------------------
// Timeline / Replay
// ---------------------------------------------------------------------------

class _TimelineViewWidget extends StatelessWidget {
  const _TimelineViewWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final events = _extractEvents(section);

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: ctx.module.replaceAll('_', ' '),
      child: events.isEmpty
          ? Text(
              'No events recorded.',
              style: TextStyle(color: fg.withValues(alpha: 0.5)),
            )
          : ListView(
              children: [
                for (final event in events.take(60))
                  ListTile(
                    dense: true,
                    title: Text(
                      _labelFromEvent(event),
                      style: TextStyle(color: fg, fontSize: 12),
                    ),
                    subtitle: Text(
                      event.toString(),
                      style: TextStyle(
                        color: fg.withValues(alpha: 0.6),
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
    );
  }

  List<Map<String, Object?>> _extractEvents(Map<String, Object?> section) {
    for (final key in const ['events', 'items', 'entries', 'steps', 'logs']) {
      final v = section[key];
      if (v is List) {
        return v
            .whereType<Map>()
            .map(coerceObjectMap)
            .toList(growable: false);
      }
    }
    return const [];
  }

  String _labelFromEvent(Map<String, Object?> event) {
    return (event['label'] ??
            event['name'] ??
            event['type'] ??
            event['id'] ??
            '')
        .toString();
  }
}

// ---------------------------------------------------------------------------
// Progress / ProgressView
// ---------------------------------------------------------------------------

class _ProgressViewWidget extends StatelessWidget {
  const _ProgressViewWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final steps = _extractSteps(section);
    final rawValue = section['value'] ?? section['progress'];
    final progressValue = rawValue != null
        ? ((coerceDouble(rawValue) ?? 0.0) / 100.0).clamp(0.0, 1.0)
        : null;
    final label =
        (section['label'] ?? section['title'] ?? 'Progress').toString();

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (progressValue != null) ...[
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: fg.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(fg.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 6),
            Text(
              '${(progressValue * 100).round()}%',
              style: TextStyle(color: fg.withValues(alpha: 0.7), fontSize: 12),
            ),
            const SizedBox(height: 10),
          ],
          if (steps.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  for (final step in steps.take(40))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        (step['label'] ?? step['name'] ?? step['id'] ?? step.toString())
                            .toString(),
                        style: TextStyle(color: fg.withValues(alpha: 0.85), fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, Object?>> _extractSteps(Map<String, Object?> section) {
    for (final key in const ['steps', 'items', 'tasks']) {
      final v = section[key];
      if (v is List) {
        return v
            .whereType<Map>()
            .map(coerceObjectMap)
            .toList(growable: false);
      }
    }
    return const [];
  }
}

// ---------------------------------------------------------------------------
// LogViewer / LogPanel
// ---------------------------------------------------------------------------

class _LogViewWidget extends StatelessWidget {
  const _LogViewWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final logs = _extractLogs(section);

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: ctx.module == 'log_panel' ? 'Log Panel' : 'Log Viewer',
      child: logs.isEmpty
          ? Text(
              'No log entries.',
              style: TextStyle(color: fg.withValues(alpha: 0.5)),
            )
          : ListView(
              reverse: true,
              children: [
                for (final log in logs.reversed.take(80))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      _formatLog(log),
                      style: TextStyle(
                        color: _logColor(log, fg),
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  List<Map<String, Object?>> _extractLogs(Map<String, Object?> section) {
    for (final key in const ['logs', 'items', 'entries', 'lines']) {
      final v = section[key];
      if (v is List) {
        return v
            .whereType<Map>()
            .map(coerceObjectMap)
            .toList(growable: false);
      }
    }
    return const [];
  }

  String _formatLog(Map<String, Object?> log) {
    final level = (log['level'] ?? '').toString().toUpperCase();
    final msg = (log['message'] ?? log['text'] ?? log['label'] ?? '').toString();
    return level.isNotEmpty ? '[$level] $msg' : msg;
  }

  Color _logColor(Map<String, Object?> log, Color fg) {
    final level = (log['level'] ?? '').toString().toLowerCase();
    if (level == 'error') return const Color(0xffff6b6b);
    if (level == 'warn' || level == 'warning') return const Color(0xffffcc00);
    return fg.withValues(alpha: 0.85);
  }
}

// ---------------------------------------------------------------------------
// Generic fallback for unmapped view modules
// ---------------------------------------------------------------------------

class _GenericViewWidget extends StatelessWidget {
  const _GenericViewWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final fg = ctx.fg;
    final entries = ctx.section.entries
        .where((e) => e.key != 'events')
        .toList(growable: false);
    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: ctx.module.replaceAll('_', ' '),
      child: ListView(
        children: [
          for (final entry in entries.take(20))
            _PropRow(fg: fg, label: entry.key, value: entry.value.toString()),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

class _PanelShell extends StatelessWidget {
  const _PanelShell({
    required this.fg,
    required this.bg,
    required this.title,
    required this.child,
  });

  final Color fg;
  final Color bg;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: child),
      ],
    );
  }
}

class _PropRow extends StatelessWidget {
  const _PropRow({required this.fg, required this.label, required this.value});
  final Color fg;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label: $value',
        style: TextStyle(color: fg.withValues(alpha: 0.85), fontSize: 12),
      ),
    );
  }
}
