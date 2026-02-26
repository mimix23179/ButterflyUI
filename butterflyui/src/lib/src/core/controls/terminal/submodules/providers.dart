library terminal_submodule_providers;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'terminal_submodule_context.dart';
import 'terminal_submodule_registry.dart';

/// Entry-point for the *providers* category.
///
/// Returns `null` when [ctx.module] is not a providers module.
Widget? buildTerminalProvidersSection(TerminalSubmoduleContext ctx) {
  if (!terminalIsProviderModule(ctx.module)) return null;

  switch (ctx.module) {
    case 'process_bridge':
      return _ProcessBridgeWidget(ctx: ctx);
    case 'output_mapper':
      return _OutputMapperWidget(ctx: ctx);
    case 'capabilities':
      return _CapabilitiesWidget(ctx: ctx);
    default:
      return _GenericProviderWidget(ctx: ctx);
  }
}

// ---------------------------------------------------------------------------
// ProcessBridge
// ---------------------------------------------------------------------------

class _ProcessBridgeWidget extends StatelessWidget {
  const _ProcessBridgeWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final status =
        (section['status'] ?? section['state'] ?? 'unknown').toString();
    final bridge =
        (section['bridge'] ?? section['backend'] ?? '').toString();
    final cwd = (section['cwd'] ?? '').toString();
    final pid = section['pid'];
    final env = _extractEnv(section);

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: 'Process Bridge',
      child: ListView(
        children: [
          _StatusChip(fg: fg, status: status),
          const SizedBox(height: 8),
          if (bridge.isNotEmpty)
            _PropRow(fg: fg, label: 'bridge', value: bridge),
          if (cwd.isNotEmpty)
            _PropRow(fg: fg, label: 'cwd', value: cwd),
          if (pid != null)
            _PropRow(fg: fg, label: 'pid', value: pid.toString()),
          if (env.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Env (${env.length})',
              style: TextStyle(color: fg.withValues(alpha: 0.6), fontSize: 11),
            ),
            for (final entry in env.entries.take(20))
              _PropRow(
                fg: fg,
                label: entry.key,
                value: entry.value.toString(),
              ),
          ],
        ],
      ),
    );
  }

  Map<String, Object?> _extractEnv(Map<String, Object?> section) {
    final v = section['env'];
    if (v is Map) return coerceObjectMap(v);
    return const {};
  }
}

// ---------------------------------------------------------------------------
// OutputMapper
// ---------------------------------------------------------------------------

class _OutputMapperWidget extends StatelessWidget {
  const _OutputMapperWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final mapping = _extractMapping(section);

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: 'Output Mapper',
      child: mapping.isEmpty
          ? Text(
              'No output mappings.',
              style: TextStyle(color: fg.withValues(alpha: 0.45)),
            )
          : ListView(
              children: [
                for (final entry in mapping.entries.take(40))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              color: fg,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Text(' → ', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Text(
                            entry.value.toString(),
                            style: TextStyle(
                              color: fg.withValues(alpha: 0.75),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Map<String, Object?> _extractMapping(Map<String, Object?> section) {
    final v = section['mapping'] ?? section['map'] ?? section['rules'];
    if (v is Map) return coerceObjectMap(v);
    return const {};
  }
}

// ---------------------------------------------------------------------------
// Capabilities
// ---------------------------------------------------------------------------

class _CapabilitiesWidget extends StatelessWidget {
  const _CapabilitiesWidget({required this.ctx});
  final TerminalSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final fg = ctx.fg;
    final caps = _extractCapabilities(section);
    final backend =
        (section['backend'] ?? section['engine'] ?? '').toString();

    return _PanelShell(
      fg: fg,
      bg: ctx.bg,
      title: 'Capabilities',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (backend.isNotEmpty)
            _PropRow(fg: fg, label: 'backend', value: backend),
          const SizedBox(height: 6),
          if (caps.isEmpty)
            Text(
              'No capabilities reported.',
              style: TextStyle(color: fg.withValues(alpha: 0.45)),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  for (final cap in caps.take(40))
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: fg.withValues(alpha: 0.7),
                      ),
                      title: Text(
                        cap.toString(),
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

  List<dynamic> _extractCapabilities(Map<String, Object?> section) {
    for (final key in const ['capabilities', 'items', 'features', 'entries']) {
      final v = section[key];
      if (v is List && v.isNotEmpty) return v;
    }
    return const [];
  }
}

// ---------------------------------------------------------------------------
// Generic fallback for unmapped provider modules
// ---------------------------------------------------------------------------

class _GenericProviderWidget extends StatelessWidget {
  const _GenericProviderWidget({required this.ctx});
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.fg, required this.status});
  final Color fg;
  final String status;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    switch (status.toLowerCase()) {
      case 'running':
      case 'ready':
        color = const Color(0xff4caf50);
        icon = Icons.circle;
        break;
      case 'paused':
        color = const Color(0xffffcc00);
        icon = Icons.pause_circle_outline;
        break;
      case 'error':
      case 'failed':
        color = const Color(0xffff5252);
        icon = Icons.error_outline;
        break;
      default:
        color = fg.withValues(alpha: 0.5);
        icon = Icons.circle_outlined;
    }
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 6),
        Text(status, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
