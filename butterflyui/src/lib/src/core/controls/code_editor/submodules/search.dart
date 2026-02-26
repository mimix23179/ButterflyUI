library code_editor_submodule_search;

import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _searchModules = {
  'smart_search_bar',
  'search_box',
  'search_field',
  'search_scope_selector',
  'search_source',
  'search_provider',
  'search_history',
  'search_intent',
  'search_item',
  'search_results_view',
  'search_everything_panel',
  'semantic_search',
  'scoped_search_replace',
  'inline_search_overlay',
  'intent_search',
  'query_token',
};

Widget? buildCodeEditorSearchModule(
    String module, CodeEditorSubmoduleContext ctx) {
  if (!_searchModules.contains(module)) return null;

  // Search results view: list of results
  if (module == 'search_results_view') {
    return _SearchResultsWidget(ctx: ctx);
  }
  // Search history: list of past queries
  if (module == 'search_history') {
    return _SearchHistoryWidget(ctx: ctx);
  }
  // Search source / provider: config view
  if (module == 'search_source' || module == 'search_provider') {
    return _SearchProviderWidget(ctx: ctx);
  }
  // Query token: token display
  if (module == 'query_token') {
    return _QueryTokenWidget(ctx: ctx);
  }
  // Default: active search input
  return _SearchInputWidget(ctx: ctx);
}

// Active search input (smart_search_bar, search_box, search_field, etc.)
class _SearchInputWidget extends StatefulWidget {
  const _SearchInputWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  State<_SearchInputWidget> createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInputWidget> {
  late final TextEditingController _controller = TextEditingController(
    text: (widget.ctx.section['query'] ??
            widget.ctx.section['value'] ??
            widget.ctx.section['input'] ??
            '')
        .toString(),
  );

  @override
  void didUpdateWidget(covariant _SearchInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = (widget.ctx.section['query'] ??
            widget.ctx.section['value'] ??
            '')
        .toString();
    if (_controller.text != next) _controller.text = next;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.ctx.section;
    final module = widget.ctx.module;
    final placeholder =
        (m['placeholder'] ?? m['hint_text'] ?? 'Search...').toString();
    final scope = (m['scope'] ?? '').toString();
    final isScopedReplace = module == 'scoped_search_replace';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                ),
                onSubmitted: (value) => widget.ctx.onEmit('search', {
                  'module': module,
                  'query': value,
                  'scope': scope,
                }),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: () => widget.ctx.onEmit('search', {
                'module': module,
                'query': _controller.text,
                'scope': scope,
              }),
              child: const Text('Search'),
            ),
          ],
        ),
        if (isScopedReplace) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Replace with...',
                    border: OutlineInputBorder(),
                    prefixIcon:
                        Icon(Icons.find_replace_outlined, size: 18),
                    isDense: true,
                  ),
                  onSubmitted: (value) => widget.ctx.onEmit('change', {
                    'module': module,
                    'action': 'replace',
                    'query': _controller.text,
                    'replacement': value,
                    'scope': scope,
                  }),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => widget.ctx.onEmit('change', {
                  'module': module,
                  'action': 'replace_all',
                }),
                child: const Text('Replace All'),
              ),
            ],
          ),
        ],
        if (scope.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Scope: $scope',
                style: Theme.of(context).textTheme.labelSmall),
          ),
      ],
    );
  }
}

// Search results list
class _SearchResultsWidget extends StatelessWidget {
  const _SearchResultsWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final raw = m['items'] ?? m['results'];
    final items = raw is List ? raw : const <dynamic>[];

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('No search results',
            style: Theme.of(context).textTheme.bodySmall),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length.clamp(0, 50),
        itemBuilder: (context, i) {
          final item = items[i];
          final label = item is Map
              ? (item['label'] ?? item['title'] ?? item['text'] ?? item['path'] ?? '')
                  .toString()
              : item.toString();
          final detail = item is Map
              ? (item['detail'] ?? item['description'] ?? '').toString()
              : '';
          final line = item is Map ? item['line']?.toString() : null;
          return ListTile(
            dense: true,
            leading: const Icon(Icons.search, size: 14),
            title: Text(label,
                style: Theme.of(context).textTheme.bodySmall),
            subtitle: detail.isNotEmpty
                ? Text(detail,
                    style: Theme.of(context).textTheme.labelSmall)
                : null,
            trailing: line != null
                ? Text('L$line',
                    style: Theme.of(context).textTheme.labelSmall)
                : null,
            onTap: () =>
                ctx.onEmit('select', {'module': ctx.module, 'item': item}),
          );
        },
      ),
    );
  }
}

// Search history
class _SearchHistoryWidget extends StatelessWidget {
  const _SearchHistoryWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final raw = m['history'] ?? m['items'];
    final items = raw is List ? raw : const <dynamic>[];

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
          for (final item in items.take(20))
            ActionChip(
              avatar: const Icon(Icons.history, size: 13),
              label: Text(item.toString(),
                  style: Theme.of(context).textTheme.bodySmall),
              onPressed: () => ctx.onEmit('search', {
                'module': ctx.module,
                'query': item,
              }),
            ),
          if (items.isEmpty)
            Text('No search history',
                style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

// Search provider/source config
class _SearchProviderWidget extends StatelessWidget {
  const _SearchProviderWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final module = ctx.module;
    final status = (m['status'] ?? 'idle').toString();
    final provider = (m['provider'] ?? '').toString();
    final lastAction = (m['last_action'] ?? '').toString();

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
              Icon(Icons.cable_outlined,
                  size: 14,
                  color: status == 'ready'
                      ? Colors.green
                      : status == 'error'
                          ? Colors.red
                          : Colors.grey),
              const SizedBox(width: 6),
              Text(module.replaceAll('_', ' '),
                  style: Theme.of(context).textTheme.labelMedium),
              const Spacer(),
              Text(status, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          if (provider.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Provider: $provider',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          if (lastAction.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('Last action: $lastAction',
                  style: Theme.of(context).textTheme.labelSmall),
            ),
          const SizedBox(height: 8),
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

// Query token display
class _QueryTokenWidget extends StatelessWidget {
  const _QueryTokenWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final tokens = m['tokens'];
    final tokenList = tokens is List ? tokens : const <dynamic>[];
    final query = (m['query'] ?? m['value'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('Query: $query',
                  style: Theme.of(context).textTheme.labelMedium),
            ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: tokenList.isEmpty
                ? [
                    Text('No query tokens',
                        style: Theme.of(context).textTheme.bodySmall)
                  ]
                : [
                    for (final t in tokenList.take(30))
                      Chip(
                        label: Text(t.toString(),
                            style: Theme.of(context).textTheme.labelSmall),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      )
                  ],
          ),
        ],
      ),
    );
  }
}
