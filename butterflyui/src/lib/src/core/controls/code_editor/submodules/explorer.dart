library code_editor_submodule_explorer;

import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _explorerModules = {
  'file_tree',
  'explorer_tree',
  'workspace_explorer',
  'tree',
};

Widget? buildCodeEditorExplorerModule(
    String module, CodeEditorSubmoduleContext ctx) {
  if (!_explorerModules.contains(module)) return null;
  return _ExplorerWidget(ctx: ctx);
}

class _ExplorerWidget extends StatelessWidget {
  const _ExplorerWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final module = ctx.module;

    final raw = m['nodes'] ?? m['items'] ?? m['files'] ?? m['children'] ??
        m['tree'];
    final nodes = raw is List ? raw : const <dynamic>[];

    final root =
        (m['root'] ?? m['workspace'] ?? m['path'] ?? '').toString().trim();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                Icon(
                  module == 'workspace_explorer'
                      ? Icons.folder_open_outlined
                      : Icons.account_tree_outlined,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    root.isNotEmpty ? root : module.replaceAll('_', ' '),
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('${nodes.length} items',
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          if (nodes.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('No tree nodes available',
                  style: Theme.of(context).textTheme.bodySmall),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: nodes.length.clamp(0, 40),
                itemBuilder: (context, i) {
                  final node = nodes[i];
                  final label = node is Map
                      ? (node['label'] ?? node['name'] ?? node['path'] ??
                              node['id'] ?? '')
                          .toString()
                      : node.toString();
                  final isDir = node is Map &&
                      (node['type'] == 'dir' ||
                          node['type'] == 'folder' ||
                          node['children'] is List);
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      isDir
                          ? Icons.folder_outlined
                          : Icons.insert_drive_file_outlined,
                      size: 15,
                    ),
                    title: Text(label,
                        style: Theme.of(context).textTheme.bodySmall),
                    onTap: () =>
                        ctx.onEmit('select', {'module': module, 'node': node}),
                  );
                },
              ),
            ),
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Expand All'),
                  visualDensity: VisualDensity.compact,
                  onPressed: () =>
                      ctx.onEmit('expand', {'module': module, 'all': true}),
                ),
                ActionChip(
                  label: const Text('Collapse All'),
                  visualDensity: VisualDensity.compact,
                  onPressed: () =>
                      ctx.onEmit('collapse', {'module': module, 'all': true}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
