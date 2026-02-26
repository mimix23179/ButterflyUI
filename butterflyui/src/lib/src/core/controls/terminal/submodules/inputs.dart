library terminal_submodule_inputs;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'terminal_submodule_context.dart';
import 'terminal_submodule_registry.dart';

/// Entry-point for the *inputs* category.
///
/// Returns `null` when [ctx.module] is not an inputs module.
Widget? buildTerminalInputsSection(TerminalSubmoduleContext ctx) {
  if (!terminalIsInputModule(ctx.module)) return null;

  final module = ctx.module;

  if (module == 'prompt' || module == 'stdin' || module == 'stdin_injector') {
    return _PromptWidget(ctx: ctx);
  }
  if (module == 'command_builder') {
    return _CommandBuilderWidget(ctx: ctx);
  }
  if (module == 'flow_gate' || module == 'execution_lane') {
    return _FlowGateWidget(ctx: ctx);
  }
  if (module == 'presets') {
    return _PresetsWidget(ctx: ctx);
  }
  if (module == 'tabs' || module == 'session') {
    return _TabsSessionWidget(ctx: ctx);
  }

  return _GenericInputWidget(ctx: ctx);
}

// ---------------------------------------------------------------------------
// Prompt / Stdin / StdinInjector
// ---------------------------------------------------------------------------

class _PromptWidget extends StatelessWidget {
  const _PromptWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final history = _extractHistory(section);
    final readOnly =
        (section['read_only'] ?? ctx.runtimeProps['read_only'] ?? false)
            as bool? ??
        false;
    final placeholder =
        (section['placeholder'] ?? section['hint'] ?? '').toString();

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: ctx.module.replaceAll('_', ' '),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (readOnly)
            Text(
              'Read-only mode',
              style: TextStyle(
                color: fg.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          if (placeholder.isNotEmpty)
            Text(
              'Placeholder: $placeholder',
              style: TextStyle(color: fg.withValues(alpha: 0.6), fontSize: 11),
            ),
          const SizedBox(height: 8),
          if (history.isEmpty)
            Text(
              'No input history.',
              style: TextStyle(color: fg.withValues(alpha: 0.45)),
            )
          else ...[
            Text(
              'History (${history.length})',
              style: TextStyle(
                color: fg.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                reverse: true,
                children: [
                  for (final entry in history.reversed.take(60))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        entry.toString(),
                        style: TextStyle(
                          color: fg.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<dynamic> _extractHistory(Map<String, Object?> section) {
    for (final key in const ['history', 'items', 'entries']) {
      final v = section[key];
      if (v is List && v.isNotEmpty) return v;
    }
    return const [];
  }
}

// ---------------------------------------------------------------------------
// CommandBuilder
// ---------------------------------------------------------------------------

class _CommandBuilderWidget extends StatelessWidget {
  const _CommandBuilderWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final commands = _extractCommands(section);
    final active =
        (section['command'] ?? section['active'] ?? '').toString();

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: 'Command Builder',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (active.isNotEmpty)
            _PropRow(fg: fg, label: 'active', value: active),
          const SizedBox(height: 6),
          if (commands.isEmpty)
            Text(
              'No commands configured.',
              style: TextStyle(color: fg.withValues(alpha: 0.45)),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  for (final cmd in commands.take(50))
                    ListTile(
                      dense: true,
                      title: Text(
                        (cmd['label'] ??
                                cmd['name'] ??
                                cmd['id'] ??
                                cmd.toString())
                            .toString(),
                        style: TextStyle(color: fg, fontSize: 12),
                      ),
                      onTap: () => ctx.sendEvent(
                        ctx.controlId,
                        'change',
                        <String, Object?>{
                          'module': 'command_builder',
                          'payload': <String, Object?>{'command': cmd},
                        },
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, Object?>> _extractCommands(Map<String, Object?> section) {
    for (final key in const ['commands', 'items', 'entries']) {
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
// FlowGate / ExecutionLane
// ---------------------------------------------------------------------------

class _FlowGateWidget extends StatelessWidget {
  const _FlowGateWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final isFlowGate = ctx.module == 'flow_gate';
    final gateOpen =
        section['open'] ?? section['enabled'] ?? section['active'];
    final lanes = _extractLanes(section);

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: isFlowGate ? 'Flow Gate' : 'Execution Lane',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (gateOpen != null)
            Row(
              children: [
                Icon(
                  gateOpen == true
                      ? Icons.lock_open
                      : Icons.lock,
                  size: 14,
                  color: gateOpen == true
                      ? const Color(0xff4caf50)
                      : const Color(0xffff5252),
                ),
                const SizedBox(width: 6),
                Text(
                  gateOpen == true ? 'Open' : 'Closed',
                  style: TextStyle(color: fg, fontSize: 12),
                ),
              ],
            ),
          const SizedBox(height: 8),
          if (lanes.isEmpty)
            Text(
              isFlowGate ? 'No gates defined.' : 'No lanes defined.',
              style: TextStyle(color: fg.withValues(alpha: 0.45)),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  for (final lane in lanes.take(40))
                    ListTile(
                      dense: true,
                      title: Text(
                        (lane['label'] ?? lane['id'] ?? lane.toString())
                            .toString(),
                        style: TextStyle(color: fg, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, Object?>> _extractLanes(Map<String, Object?> section) {
    for (final key in const ['lanes', 'gates', 'items']) {
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
// Presets
// ---------------------------------------------------------------------------

class _PresetsWidget extends StatelessWidget {
  const _PresetsWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final presets = _extractPresets(section);

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: 'Presets',
      child: presets.isEmpty
          ? Text(
              'No presets defined.',
              style: TextStyle(color: fg.withValues(alpha: 0.45)),
            )
          : ListView(
              children: [
                for (final preset in presets.take(60))
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.terminal, size: 14, color: fg.withValues(alpha: 0.7)),
                    title: Text(
                      (preset['label'] ?? preset['name'] ?? preset['id'] ?? '')
                          .toString(),
                      style: TextStyle(color: fg, fontSize: 12),
                    ),
                    subtitle: preset['command'] != null
                        ? Text(
                            preset['command'].toString(),
                            style: TextStyle(
                              color: fg.withValues(alpha: 0.6),
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () => ctx.sendEvent(
                      ctx.controlId,
                      'change',
                      <String, Object?>{
                        'module': 'presets',
                        'payload': <String, Object?>{'preset': preset},
                      },
                    ),
                  ),
              ],
            ),
    );
  }

  List<Map<String, Object?>> _extractPresets(Map<String, Object?> section) {
    for (final key in const ['presets', 'items', 'entries']) {
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
// Tabs / Session
// ---------------------------------------------------------------------------

class _TabsSessionWidget extends StatelessWidget {
  const _TabsSessionWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final tabs = _extractTabs(section);
    final isSession = ctx.module == 'session';

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: isSession ? 'Session' : 'Tabs',
      child: tabs.isEmpty
          ? Text(
              isSession ? 'No sessions.' : 'No tabs open.',
              style: TextStyle(color: fg.withValues(alpha: 0.45)),
            )
          : ListView(
              children: [
                for (final tab in tabs.take(40))
                  ListTile(
                    dense: true,
                    selected: (tab['id'] ?? '').toString() == ctx.activeSessionId,
                    selectedColor: fg,
                    title: Text(
                      (tab['label'] ??
                              tab['title'] ??
                              tab['name'] ??
                              tab['id'] ??
                              '')
                          .toString(),
                      style: TextStyle(color: fg, fontSize: 12),
                    ),
                    subtitle: tab['state'] != null
                        ? Text(
                            tab['state'].toString(),
                            style: TextStyle(
                              color: fg.withValues(alpha: 0.55),
                              fontSize: 10,
                            ),
                          )
                        : null,
                    onTap: () => ctx.sendEvent(
                      ctx.controlId,
                      'change',
                      <String, Object?>{
                        'module': ctx.module,
                        'payload': <String, Object?>{
                          'session_id': (tab['id'] ?? '').toString(),
                        },
                      },
                    ),
                  ),
              ],
            ),
    );
  }

  List<Map<String, Object?>> _extractTabs(Map<String, Object?> section) {
    for (final key in const ['tabs', 'items', 'sessions', 'entries']) {
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
// Generic fallback for unmapped input modules
// ---------------------------------------------------------------------------

class _GenericInputWidget extends StatelessWidget {
  const _GenericInputWidget({required this.ctx});
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
