library code_editor_submodule_commands;

import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _commandsModules = {
  'command_bar',
  'command_search',
  'editor_intent_router',
  'intent_router',
  'intent_panel',
  'scope_picker',
  'export_panel',
};

Widget? buildCodeEditorCommandsModule(
    String module, CodeEditorSubmoduleContext ctx) {
  if (!_commandsModules.contains(module)) return null;

  if (module == 'export_panel') return _ExportPanelWidget(ctx: ctx);
  if (module == 'scope_picker') return _ScopePickerWidget(ctx: ctx);
  return _CommandListWidget(ctx: ctx);
}

// Generic command list (command_bar, command_search, intent_router, intent_panel, editor_intent_router)
class _CommandListWidget extends StatelessWidget {
  const _CommandListWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final module = ctx.module;

    final candidates = [
      m['items'],
      m['actions'],
      m['routes'],
      m['commands'],
      m['options'],
    ];
    List<dynamic> values = const [];
    for (final candidate in candidates) {
      if (candidate is List) {
        values = candidate;
        break;
      }
    }

    final placeholder =
        (m['placeholder'] ?? 'Type a command...').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (module == 'command_bar' || module == 'command_search')
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                border: const OutlineInputBorder(),
                prefixIcon:
                    const Icon(Icons.terminal_outlined, size: 18),
                isDense: true,
              ),
              onSubmitted: (value) => ctx.onEmit('search', {
                'module': module,
                'query': value,
              }),
            ),
          ),
        if (values.isEmpty)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              (m['message'] ?? m['hint'] ?? 'No commands available')
                  .toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final value in values.take(30))
                  ActionChip(
                    avatar: const Icon(Icons.arrow_forward_ios, size: 10),
                    label: Text(
                      value is Map
                          ? (value['label'] ??
                                  value['name'] ??
                                  value['id'] ??
                                  '')
                              .toString()
                          : value.toString(),
                    ),
                    onPressed: () => ctx.onEmit('select', {
                      'module': module,
                      'item': value,
                    }),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// Scope picker
class _ScopePickerWidget extends StatelessWidget {
  const _ScopePickerWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final raw = m['scopes'] ?? m['options'] ?? m['items'];
    final scopes = raw is List ? raw : const <dynamic>[];
    final current =
        (m['scope'] ?? m['selected'] ?? m['value'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scope Picker',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: scopes.isEmpty
                ? [
                    Text('No scopes defined',
                        style: Theme.of(context).textTheme.bodySmall)
                  ]
                : [
                    for (final scope in scopes.take(20))
                      ChoiceChip(
                        label: Text(scope is Map
                            ? (scope['label'] ?? scope['id'] ?? scope)
                                .toString()
                            : scope.toString()),
                        selected: (scope is Map
                                ? (scope['id'] ?? scope['label'] ?? scope)
                                : scope)
                            .toString() ==
                            current,
                        onSelected: (_) => ctx.onEmit('select', {
                          'module': 'scope_picker',
                          'scope': scope,
                        }),
                      ),
                  ],
          ),
        ],
      ),
    );
  }
}

// Export panel
class _ExportPanelWidget extends StatelessWidget {
  const _ExportPanelWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final formats = m['formats'] is List
        ? (m['formats'] as List)
        : const <dynamic>['pdf', 'html', 'markdown', 'json'];
    final filename =
        (m['filename'] ?? m['name'] ?? '').toString();

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
              const Icon(Icons.file_download_outlined, size: 16),
              const SizedBox(width: 6),
              Text('Export Panel',
                  style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          if (filename.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text('File: $filename',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final fmt in formats.take(10))
                FilledButton.tonal(
                  onPressed: () => ctx.onEmit('select', {
                    'module': 'export_panel',
                    'format': fmt,
                    'filename': filename,
                  }),
                  child: Text(fmt.toString().toUpperCase()),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
