library studio_panels_submodule;

import 'package:flutter/material.dart';

import '../studio_contract.dart';
import 'studio_submodule_context.dart';
import 'studio_submodule_registry.dart';

// ---------------------------------------------------------------------------
// Public entry-point
// ---------------------------------------------------------------------------

/// Builds the side-panel content widget for a Studio panel module.
///
/// Returns `null` when [ctx.module] is not in the panels category, so that
/// callers can fall through to the next category builder.
Widget? buildStudioPanelsSection(StudioSubmoduleContext ctx) {
  if (!studioIsPanelModule(ctx.module)) return null;
  switch (ctx.module) {
    case 'inspector':
    case 'properties_panel':
    case 'properties':
    case 'tokens_editor':
    case 'token_editor':
    case 'tokens':
    case 'bindings_editor':
      return _KeyValuePanelWidget(ctx: ctx);
    case 'actions_editor':
      return _ActionsEditorWidget(ctx: ctx);
    case 'project_panel':
      return _ProjectPanelWidget(ctx: ctx);
    case 'outline_tree':
    case 'layers':
    case 'layers_panel':
      return _OutlineTreeWidget(ctx: ctx);
    case 'asset_browser':
    case 'assets':
    case 'assets_panel':
      return _AssetBrowserWidget(ctx: ctx);
    case 'component_palette':
    case 'block_palette':
    default:
      return _PaletteWidget(ctx: ctx);
  }
}

// ---------------------------------------------------------------------------
// Key/value inspector panel (inspector, properties, tokens, bindings)
// ---------------------------------------------------------------------------

class _KeyValuePanelWidget extends StatelessWidget {
  const _KeyValuePanelWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final values = section.entries
        .where((e) => e.key != 'events' && e.key != 'submodule_meta')
        .take(80);
    if (!values.iterator.moveNext()) {
      return Center(
        child: Text(
          'No ${ctx.module.replaceAll('_', ' ')} data',
        ),
      );
    }
    return ListView(
      children: [
        for (final entry in section.entries
            .where((e) => e.key != 'events' && e.key != 'submodule_meta')
            .take(80))
          ListTile(
            dense: true,
            title: Text(entry.key),
            subtitle: Text(entry.value?.toString() ?? ''),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Actions editor
// ---------------------------------------------------------------------------

class _ActionsEditorWidget extends StatelessWidget {
  const _ActionsEditorWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final rawActions = section['actions'];
    final targetId = (section['target_id'] ?? '').toString();
    final actions = <String, Object?>{};
    if (rawActions is Map) {
      for (final entry in rawActions.entries) {
        actions[entry.key.toString()] = entry.value;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (targetId.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Chip(label: Text('target: $targetId')),
          ),
        Expanded(
          child: actions.isEmpty
              ? const Center(child: Text('No actions'))
              : ListView(
                  children: [
                    for (final entry in actions.entries)
                      ListTile(
                        dense: true,
                        title: Text(entry.key),
                        subtitle: Text(entry.value?.toString() ?? ''),
                        onTap: () => ctx.onEmit('select', {
                          'module': ctx.module,
                          'action_key': entry.key,
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
// Project panel
// ---------------------------------------------------------------------------

class _ProjectPanelWidget extends StatelessWidget {
  const _ProjectPanelWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final project = studioCoerceObjectMap(section['project']);
    final documents = studioCoerceMapList(section['documents']);
    final assets = studioCoerceMapList(section['assets']);
    final name = (project['name'] ?? 'Untitled').toString();
    final target = (project['target'] ?? '').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              Chip(label: Text(name)),
              if (target.isNotEmpty) Chip(label: Text(target)),
              if (documents.isNotEmpty)
                Chip(label: Text('${documents.length} docs')),
            ],
          ),
        ),
        Expanded(
          child: assets.isEmpty && documents.isEmpty
              ? const Center(child: Text('No project items'))
              : ListView(
                  children: [
                    for (final doc in documents)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.description, size: 16),
                        title: Text(
                          (doc['name'] ?? doc['id'] ?? '').toString(),
                        ),
                        onTap: () => ctx.onEmit('select', {
                          'module': ctx.module,
                          'item': doc,
                        }),
                      ),
                    for (final asset in assets.take(40))
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.attach_file, size: 16),
                        title: Text(
                          (asset['label'] ?? asset['id'] ?? '').toString(),
                        ),
                        onTap: () => ctx.onEmit('select', {
                          'module': ctx.module,
                          'item': asset,
                        }),
                      ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              FilledButton.tonal(
                onPressed: () => ctx.onEmit('submit', {
                  'module': ctx.module,
                  'intent': 'save_project',
                }),
                child: const Text('Save'),
              ),
              FilledButton.tonal(
                onPressed: () => ctx.onEmit('submit', {
                  'module': ctx.module,
                  'intent': 'export_project',
                }),
                child: const Text('Export'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Outline / layers tree
// ---------------------------------------------------------------------------

class _OutlineTreeWidget extends StatelessWidget {
  const _OutlineTreeWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final nodes = studioCoerceMapList(
      section['nodes'] ?? section['items'] ?? section['children'],
    );
    if (nodes.isEmpty) {
      return Center(
        child: Text('No ${ctx.module.replaceAll('_', ' ')} items'),
      );
    }
    return ListView(
      children: [
        for (final node in nodes) _OutlineNode(node: node, ctx: ctx, depth: 0),
      ],
    );
  }
}

class _OutlineNode extends StatelessWidget {
  const _OutlineNode({
    required this.node,
    required this.ctx,
    required this.depth,
  });
  final Map<String, Object?> node;
  final StudioSubmoduleContext ctx;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final id = (node['id'] ?? '').toString();
    final label = (node['label'] ?? node['name'] ?? id).toString();
    final children = studioCoerceMapList(node['children']);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 8.0 + depth * 16),
          selected: ctx.selectedIds.contains(id),
          title: Text(label),
          onTap: () => ctx.onSelectEntity(id),
        ),
        for (final child in children)
          _OutlineNode(node: child, ctx: ctx, depth: depth + 1),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Asset browser
// ---------------------------------------------------------------------------

class _AssetBrowserWidget extends StatelessWidget {
  const _AssetBrowserWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final assets = studioCoerceMapList(
      section['assets'] ?? section['items'],
    );
    if (assets.isEmpty) {
      return const Center(child: Text('No assets'));
    }
    return ListView(
      children: [
        for (final asset in assets.take(120))
          ListTile(
            dense: true,
            leading: const Icon(Icons.insert_drive_file, size: 16),
            title: Text(
              (asset['label'] ?? asset['name'] ?? asset['id'] ?? '').toString(),
            ),
            subtitle: asset['type'] != null
                ? Text(asset['type'].toString())
                : null,
            onTap: () => ctx.onEmit('select', {
              'module': ctx.module,
              'item': asset,
            }),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Component / block palette
// ---------------------------------------------------------------------------

class _PaletteWidget extends StatelessWidget {
  const _PaletteWidget({required this.ctx});
  final StudioSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final section = ctx.section;
    final blocks = studioCoerceMapList(
      section['blocks'] ?? section['items'] ?? section['nodes'],
    );
    final query = (section['query'] ?? '').toString().toLowerCase();

    final visible = query.isEmpty
        ? blocks
        : blocks
            .where(
              (b) =>
                  (b['label'] ?? b['id'] ?? '')
                      .toString()
                      .toLowerCase()
                      .contains(query),
            )
            .toList();

    if (visible.isEmpty) {
      return Center(
        child: Text('No ${ctx.module.replaceAll('_', ' ')} items'),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        mainAxisExtent: 56,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: visible.length,
      itemBuilder: (context, index) {
        final block = visible[index];
        final label = (block['label'] ?? block['id'] ?? '').toString();
        return GestureDetector(
          onTap: () => ctx.onEmit('select', {
            'module': ctx.module,
            'item': block,
          }),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        );
      },
    );
  }
}
