library code_editor_submodule_editor;

import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _editorModules = {
  'ide',
  'editor_surface',
  'editor_view',
  'workbench_editor',
  'ghost_editor',
  'editor_minimap',
  'mini_map',
  'gutter',
  'hint',
  'inline_widget',
};

Widget? buildCodeEditorEditorModule(
    String module, CodeEditorSubmoduleContext ctx) {
  if (!_editorModules.contains(module)) return null;
  return _EditorSurfaceWidget(ctx: ctx);
}

class _EditorSurfaceWidget extends StatelessWidget {
  const _EditorSurfaceWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final module = ctx.module;

    // Workbench editor shows IDE overview
    if (module == 'workbench_editor') {
      final activeModule = (m['active_module'] ?? '').toString();
      final language = (m['language'] ?? 'plaintext').toString();
      final engine = (m['engine'] ?? 'monaco').toString();
      final enabledModules = (m['enabled_modules'] ?? '').toString();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workbench Editor',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            if (activeModule.isNotEmpty)
              Text('Active: ${activeModule.replaceAll('_', ' ')}'),
            Text('Language: $language'),
            Text('Engine: $engine'),
            if (enabledModules.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Modules: $enabledModules',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () => ctx.onEmit(
                  'change', {'module': 'workbench_editor', 'payload': m}),
              child: const Text('Emit Change'),
            ),
          ],
        ),
      );
    }

    // Editor minimap / mini_map shows viewport overview
    if (module == 'editor_minimap' || module == 'mini_map') {
      final enabled = m['enabled'] != false;
      final viewportHeight =
          (m['viewport_height'] ?? m['height']).toString();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.map_outlined,
                    size: 16, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 6),
                Text('${module.replaceAll('_', ' ').toUpperCase()}',
                    style: Theme.of(context).textTheme.labelSmall),
                const Spacer(),
                Text(enabled ? 'enabled' : 'disabled',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            if (viewportHeight != 'null')
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('viewport_height: $viewportHeight',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
          ],
        ),
      );
    }

    // Gutter shows line number/fold info
    if (module == 'gutter') {
      final lineCount = (m['line_count'] ?? m['lines'] ?? '').toString();
      final showFolding = m['show_folding'] != false;
      return Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Gutter', style: Theme.of(context).textTheme.labelSmall),
            if (lineCount.isNotEmpty && lineCount != 'null')
              Text('$lineCount lines',
                  style: Theme.of(context).textTheme.bodySmall),
            Text('folding: $showFolding',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
    }

    // Hint shows an inline hint/suggestion
    if (module == 'hint') {
      final hintText =
          (m['text'] ?? m['message'] ?? m['hint'] ?? '').toString().trim();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline,
                size: 14,
                color: Theme.of(context).colorScheme.onSecondaryContainer),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                hintText.isEmpty ? 'No hint available' : hintText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    // Inline widget renders an arbitrary inline element
    if (module == 'inline_widget') {
      final label = (m['label'] ?? m['type'] ?? 'inline widget').toString();
      final range = m['range']?.toString() ?? '';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.widgets_outlined, size: 12),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            if (range.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text('@$range',
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ],
        ),
      );
    }

    // Ghost editor / ide / editor_surface / editor_view — generic info card
    return buildCodeEditorGeneric(ctx);
  }
}
