library studio_surfaces_submodule;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:flutter/material.dart';

import '../studio_contract.dart';
import 'studio_submodule_context.dart';
import 'studio_submodule_registry.dart';

// ---------------------------------------------------------------------------
// Public entry-point
// ---------------------------------------------------------------------------

/// Builds the side-panel content widget for a Studio surface or builder
/// module.
///
/// Returns `null` when [ctx.module] is not in the surfaces category, so that
/// callers can fall through to the next category builder.
Widget? buildStudioSurfacesSection(StudioSubmoduleContext ctx) {
  if (!studioIsSurfaceModule(ctx.module)) return null;
  switch (ctx.module) {
    case 'canvas':
    case 'canvas_surface':
      return _CanvasPanelWidget(ctx: ctx);
    case 'timeline_surface':
    case 'timeline':
    case 'timeline_editor':
      return _TimelinePanelWidget(ctx: ctx);
    case 'node_surface':
    case 'node':
    case 'node_graph':
      return _NodePanelWidget(ctx: ctx);
    case 'preview_surface':
    case 'preview':
      return _PreviewPanelWidget(ctx: ctx);
    case 'builder':
    default:
      return _BuilderPanelWidget(ctx: ctx);
  }
}

// ---------------------------------------------------------------------------
// Builder surface panel
// ---------------------------------------------------------------------------

class _BuilderPanelWidget extends StatelessWidget {
  const _BuilderPanelWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final manifest = studioCoerceObjectMap(
      ctx.runtimeProps['manifest'],
    );
    final services = studioCoerceObjectMap(section['services']);
    final entries = <MapEntry<String, Object?>>[
      MapEntry('title', section['title'] ?? 'Studio Builder'),
      MapEntry('subtitle', section['subtitle'] ?? ''),
      MapEntry('state', ctx.runtimeProps['state'] ?? 'ready'),
      MapEntry('active_surface', ctx.activeSurface),
      if (manifest.isNotEmpty)
        MapEntry('starter_kit', manifest['starter_kit'] ?? ''),
    ];
    return ListView(
      children: [
        for (final entry in entries)
          if (entry.value.toString().isNotEmpty)
            ListTile(
              dense: true,
              title: Text(entry.key),
              subtitle: Text(entry.value.toString()),
            ),
        if (services.isNotEmpty)
          ListTile(
            dense: true,
            title: const Text('services'),
            subtitle: Text(services.keys.join(', ')),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Canvas surface panel
// ---------------------------------------------------------------------------

class _CanvasPanelWidget extends StatelessWidget {
  const _CanvasPanelWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final entities = studioCoerceMapList(
      section['entities'] ?? section['items'],
    );
    final background = (section['background'] ?? section['bgcolor'] ?? '#0b1220')
        .toString();
    final gridSize = (coerceDouble(section['grid_size']) ?? 24).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              Chip(label: Text('bg $background')),
              Chip(label: Text('grid $gridSize')),
              Chip(label: Text('zoom ${ctx.zoom.toStringAsFixed(2)}')),
              if (ctx.selectedIds.isNotEmpty)
                Chip(label: Text('sel ${ctx.selectedIds.length}')),
            ],
          ),
        ),
        Expanded(
          child: entities.isEmpty
              ? const Center(child: Text('No canvas entities'))
              : ListView(
                  children: [
                    for (final entity in entities)
                      ListTile(
                        dense: true,
                        selected: ctx.selectedIds.contains(
                          (entity['id'] ?? '').toString(),
                        ),
                        title: Text(
                          (entity['label'] ??
                                  entity['name'] ??
                                  entity['id'] ??
                                  '')
                              .toString(),
                        ),
                        subtitle: Text(
                          'x:${entity['x']} y:${entity['y']}',
                        ),
                        onTap: () => ctx.onSelectEntity(
                          (entity['id'] ?? '').toString(),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Timeline surface panel
// ---------------------------------------------------------------------------

class _TimelinePanelWidget extends StatelessWidget {
  const _TimelinePanelWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final tracks = studioCoerceMapList(section['tracks']);
    final playhead = (coerceDouble(section['playhead_seconds']) ?? 0).toStringAsFixed(2);
    final duration = (coerceDouble(section['duration_seconds']) ?? 0).toStringAsFixed(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              Chip(label: Text('${playhead}s / ${duration}s')),
              Chip(label: Text('${tracks.length} tracks')),
            ],
          ),
        ),
        Expanded(
          child: tracks.isEmpty
              ? const Center(child: Text('No timeline tracks'))
              : ListView(
                  children: [
                    for (final track in tracks)
                      ListTile(
                        dense: true,
                        title: Text(
                          (track['label'] ?? track['id'] ?? '').toString(),
                        ),
                        subtitle: Text(
                          'start:${track['start']} dur:${track['duration']}',
                        ),
                        onTap: () => ctx.onEmit('select', {
                          'module': ctx.module,
                          'item': track,
                        }),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Node graph surface panel
// ---------------------------------------------------------------------------

class _NodePanelWidget extends StatelessWidget {
  const _NodePanelWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final nodes = studioCoerceMapList(section['nodes']);
    final edges = studioCoerceMapList(section['edges']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              Chip(label: Text('${nodes.length} nodes')),
              Chip(label: Text('${edges.length} edges')),
            ],
          ),
        ),
        Expanded(
          child: nodes.isEmpty
              ? const Center(child: Text('No nodes'))
              : ListView(
                  children: [
                    for (final node in nodes)
                      ListTile(
                        dense: true,
                        selected:
                            ctx.selectedIds.contains(
                              (node['id'] ?? '').toString(),
                            ),
                        title: Text(
                          (node['label'] ?? node['id'] ?? '').toString(),
                        ),
                        onTap: () => ctx.onSelectEntity(
                          (node['id'] ?? '').toString(),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Preview surface panel
// ---------------------------------------------------------------------------

class _PreviewPanelWidget extends StatelessWidget {
  const _PreviewPanelWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final title = (section['title'] ?? 'Preview').toString();
    final subtitle = (section['subtitle'] ?? '').toString();
    final status = (section['status'] ?? 'idle').toString();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 8),
          Chip(label: Text(status)),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => ctx.onEmit('submit', {
              'module': ctx.module,
              'intent': 'start_preview',
            }),
            child: const Text('Start Preview'),
          ),
        ],
      ),
    );
  }
}
