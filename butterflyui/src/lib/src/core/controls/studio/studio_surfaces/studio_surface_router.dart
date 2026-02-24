import 'package:flutter/material.dart';

import '../studio_contract.dart';
import 'canvas_surface/studio_canvas_surface.dart';
import 'node_surface/studio_node_surface.dart';
import 'timeline_surface/studio_timeline_surface.dart';

class StudioSurfaceRouter extends StatelessWidget {
  const StudioSurfaceRouter({
    super.key,
    required this.runtimeProps,
    required this.activeSurface,
    required this.selectedIds,
    required this.zoom,
    required this.onSelectEntity,
  });

  final Map<String, Object?> runtimeProps;
  final String activeSurface;
  final Set<String> selectedIds;
  final double zoom;
  final void Function(String id, {bool additive}) onSelectEntity;

  @override
  Widget build(BuildContext context) {
    final surface = normalizeStudioSurfaceToken(activeSurface);
    switch (surface) {
      case 'timeline_surface':
        return StudioTimelineSurface(
          surfaceProps: _section('timeline_surface'),
          selectedIds: selectedIds,
          onSelectClip: onSelectEntity,
        );
      case 'node_surface':
        return StudioNodeSurface(
          surfaceProps: _section('node_surface'),
          selectedIds: selectedIds,
          onSelectNode: onSelectEntity,
        );
      case 'preview_surface':
        return _PreviewSurface(surfaceProps: _section('preview_surface'));
      case 'canvas':
      default:
        return StudioCanvasSurface(
          surfaceProps: _section('canvas'),
          selectedIds: selectedIds,
          zoom: zoom,
          onSelect: onSelectEntity,
        );
    }
  }

  Map<String, Object?> _section(String key) =>
      studioSectionProps(runtimeProps, key) ?? <String, Object?>{};
}

class _PreviewSurface extends StatelessWidget {
  const _PreviewSurface({required this.surfaceProps});

  final Map<String, Object?> surfaceProps;

  @override
  Widget build(BuildContext context) {
    final title = (surfaceProps['title'] ?? 'Preview Surface').toString();
    final subtitle = (surfaceProps['subtitle'] ?? 'No preview source selected')
        .toString();
    final status = (surfaceProps['status'] ?? 'idle').toString();
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Chip(label: Text('status: $status')),
            ],
          ),
        ),
      ),
    );
  }
}
