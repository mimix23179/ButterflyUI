library code_editor_submodule_layout_modules;

import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _layoutModules = {
  'dock',
  'dock_graph',
  'dock_pane',
  'inspector',
  'empty_state_view',
  'empty_view',
};

Widget? buildCodeEditorLayoutModule(
    String module, CodeEditorSubmoduleContext ctx) {
  if (!_layoutModules.contains(module)) return null;

  if (module == 'empty_state_view' || module == 'empty_view') {
    return _EmptyStateWidget(ctx: ctx);
  }
  if (module == 'inspector') {
    return _InspectorWidget(ctx: ctx);
  }
  return _DockWidget(ctx: ctx);
}

// Empty state view
class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final title =
        (m['title'] ?? m['message'] ?? 'Nothing here yet').toString();
    final subtitle = (m['subtitle'] ?? m['description'] ?? '').toString();
    final iconName = (m['icon'] ?? '').toString();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconName.isNotEmpty
                  ? Icons.inbox_outlined
                  : Icons.folder_off_outlined,
              size: 48,
              color:
                  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

// Inspector
class _InspectorWidget extends StatelessWidget {
  const _InspectorWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final target = (m['target'] ?? m['selected'] ?? '').toString();
    final properties = m['properties'] is Map
        ? (m['properties'] as Map).cast<String, dynamic>()
        : (m['props'] is Map
              ? (m['props'] as Map).cast<String, dynamic>()
              : <String, dynamic>{});

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                const Icon(Icons.manage_search_outlined, size: 14),
                const SizedBox(width: 6),
                Text('Inspector',
                    style: Theme.of(context).textTheme.labelMedium),
                if (target.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text('→ $target',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
          if (properties.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('No properties to inspect',
                  style: Theme.of(context).textTheme.bodySmall),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final entry in properties.entries.take(40))
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.4)),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(entry.key,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall),
                          ),
                          Expanded(
                            child: Text(
                              entry.value?.toString() ?? 'null',
                              style:
                                  Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Dock / dock_graph / dock_pane
class _DockWidget extends StatelessWidget {
  const _DockWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final module = ctx.module;

    final panes = m['panes'] is List
        ? (m['panes'] as List)
        : (m['children'] is List
              ? (m['children'] as List)
              : const <dynamic>[]);

    final orientation =
        (m['orientation'] ?? m['direction'] ?? 'horizontal').toString();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                module == 'dock_graph'
                    ? Icons.account_tree_outlined
                    : Icons.view_column_outlined,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(module.replaceAll('_', ' '),
                  style: Theme.of(context).textTheme.labelMedium),
              const Spacer(),
              Text(orientation,
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          if (panes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final pane in panes.take(10))
                  Chip(
                    label: Text(
                      pane is Map
                          ? (pane['id'] ?? pane['label'] ?? pane['module'] ??
                                  pane)
                              .toString()
                          : pane.toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    avatar: const Icon(Icons.square_outlined, size: 10),
                  ),
              ],
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('No panes configured',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          const SizedBox(height: 6),
          FilledButton.tonal(
            onPressed: () =>
                ctx.onEmit('change', {'module': module, 'payload': m}),
            child: const Text('Emit Change'),
          ),
        ],
      ),
    );
  }
}
