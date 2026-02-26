library studio_tools_submodule;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:flutter/material.dart';

import '../studio_contract.dart';
import 'studio_submodule_context.dart';
import 'studio_submodule_registry.dart';

// ---------------------------------------------------------------------------
// Public entry-point
// ---------------------------------------------------------------------------

/// Builds the side-panel content widget for a Studio tool module.
///
/// Returns `null` when [ctx.module] is not in the tools category, so that
/// callers can fall through or fall back.
Widget? buildStudioToolsSection(StudioSubmoduleContext ctx) {
  if (!studioIsToolModule(ctx.module)) return null;
  switch (ctx.module) {
    case 'selection_tools':
    case 'toolbox':
      return _SelectionToolsWidget(ctx: ctx);
    case 'transform_box':
    case 'transform':
      return _TransformBoxWidget(ctx: ctx);
    case 'transform_toolbar':
    case 'transform_tools':
      return _TransformToolbarWidget(ctx: ctx);
    case 'responsive_toolbar':
    case 'responsive':
    default:
      return _ResponsiveToolbarWidget(ctx: ctx);
  }
}

// ---------------------------------------------------------------------------
// Selection tools
// ---------------------------------------------------------------------------

class _SelectionToolsWidget extends StatelessWidget {
  const _SelectionToolsWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final tools = studioCoerceMapList(
      section['items'] ?? section['tools'],
    );
    final activeTool = (section['active'] ?? section['active_tool'] ?? 'select')
        .toString();
    final selectedId = (section['selected_id'] ?? '').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final tool in tools)
                FilterChip(
                  selected: tool['id'].toString() == activeTool,
                  label: Text(
                    (tool['label'] ?? tool['id'] ?? '').toString(),
                  ),
                  onSelected: (_) => ctx.onEmit('change', {
                    'module': ctx.module,
                    'payload': {'active_tool': tool['id']},
                  }),
                ),
            ],
          ),
        ),
        if (selectedId.isNotEmpty)
          ListTile(
            dense: true,
            title: const Text('selected'),
            subtitle: Text(selectedId),
          ),
        if (ctx.selectedIds.length > 1)
          ListTile(
            dense: true,
            title: Text('${ctx.selectedIds.length} selected'),
            subtitle: Text(ctx.selectedIds.take(5).join(', ')),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Transform box
// ---------------------------------------------------------------------------

class _TransformBoxWidget extends StatelessWidget {
  const _TransformBoxWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final x = coerceDouble(section['x']) ?? 0;
    final y = coerceDouble(section['y']) ?? 0;
    final w = coerceDouble(section['width']) ?? 0;
    final h = coerceDouble(section['height']) ?? 0;
    final rot = coerceDouble(section['rotation']) ?? 0;

    return ListView(
      children: [
        ListTile(
          dense: true,
          title: const Text('position'),
          subtitle: Text('x:${x.toInt()} y:${y.toInt()}'),
        ),
        ListTile(
          dense: true,
          title: const Text('size'),
          subtitle: Text('${w.toInt()} × ${h.toInt()}'),
        ),
        ListTile(
          dense: true,
          title: const Text('rotation'),
          subtitle: Text('${rot.toStringAsFixed(1)}°'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Transform toolbar
// ---------------------------------------------------------------------------

class _TransformToolbarWidget extends StatelessWidget {
  const _TransformToolbarWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final items = studioCoerceMapList(section['items']);
    if (items.isEmpty) {
      return const Center(child: Text('No transform actions'));
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final item in items)
          ActionChip(
            label: Text(
              (item['label'] ?? item['id'] ?? '').toString(),
            ),
            onPressed: () => ctx.onEmit('submit', {
              'module': ctx.module,
              'item': item,
            }),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Responsive toolbar
// ---------------------------------------------------------------------------

class _ResponsiveToolbarWidget extends StatelessWidget {
  const _ResponsiveToolbarWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final breakpoints = studioCoerceMapList(section['breakpoints']);
    final currentId = (section['current_id'] ?? '').toString();
    final width = (coerceDouble(section['width']) ?? 1280).toInt();
    final height = (coerceDouble(section['height']) ?? 720).toInt();
    final zoom = (coerceDouble(section['zoom']) ?? ctx.zoom);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              Chip(label: Text('${width}×$height')),
              Chip(label: Text('zoom ${zoom.toStringAsFixed(2)}')),
            ],
          ),
        ),
        if (breakpoints.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Breakpoints',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final bp in breakpoints)
                FilterChip(
                  selected: bp['id'].toString() == currentId,
                  label: Text(
                    '${bp['label'] ?? bp['id']} (${bp['width']})',
                  ),
                  onSelected: (_) => ctx.onEmit('change', {
                    'module': ctx.module,
                    'payload': {
                      'current_id': bp['id'],
                      'width': bp['width'],
                    },
                  }),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
