library code_editor_submodule_tabs;

import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _tabsModules = {
  'editor_tabs',
  'document_tab_strip',
  'file_tabs',
};

Widget? buildCodeEditorTabsModule(
    String module, CodeEditorSubmoduleContext ctx) {
  if (!_tabsModules.contains(module)) return null;
  return _TabsWidget(ctx: ctx);
}

class _TabsWidget extends StatelessWidget {
  const _TabsWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final module = ctx.module;

    final raw = m['tabs'] ?? m['items'] ?? m['documents'];
    final tabs = raw is List ? raw : const <dynamic>[];

    if (tabs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('No tabs (${module.replaceAll('_', ' ')})',
            style: Theme.of(context).textTheme.bodySmall),
      );
    }

    final activeTab =
        (m['active_tab'] ?? m['active'] ?? m['selected'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final tab in tabs)
            _buildTabChip(context, tab, activeTab, module),
        ],
      ),
    );
  }

  Widget _buildTabChip(BuildContext context, dynamic tab, String activeTab,
      String module) {
    final label = tab is Map
        ? (tab['label'] ?? tab['title'] ?? tab['name'] ?? tab['id'] ?? '')
            .toString()
        : tab.toString();
    final id = tab is Map ? (tab['id'] ?? tab['uri'] ?? label) : label;
    final dirty = tab is Map && tab['dirty'] == true;
    final isActive = id.toString() == activeTab || label == activeTab;

    return RawChip(
      selected: isActive,
      onSelected: (_) => ctx.onEmit('select', {
        'module': module,
        'tab': tab,
        'id': id,
      }),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (dirty)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.circle, size: 7, color: Colors.amber),
            ),
        ],
      ),
    );
  }
}
