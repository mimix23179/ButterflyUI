library code_editor_submodule_document;

import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _documentModules = {
  'code_buffer',
  'code_category_layer',
  'code_document',
};

Widget? buildCodeEditorDocumentModule(
    String module, CodeEditorSubmoduleContext ctx) {
  if (!_documentModules.contains(module)) return null;
  return _DocumentWidget(ctx: ctx);
}

class _DocumentWidget extends StatelessWidget {
  const _DocumentWidget({required this.ctx});
  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final m = ctx.section;
    final module = ctx.module;

    final code =
        (m['code'] ?? m['content'] ?? m['text'] ?? m['value'] ?? '').toString();
    final language = (m['language'] ?? 'text').toString();
    final path = (m['path'] ?? m['uri'] ?? '').toString();
    final dirty = m['dirty'] == true;
    final readOnly = m['read_only'] == true;
    final encoding = (m['encoding'] ?? 'utf-8').toString();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                Icon(Icons.description_outlined,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    path.isNotEmpty
                        ? path.split(RegExp(r'[/\\]')).last
                        : module.replaceAll('_', ' '),
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (dirty)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.circle, size: 8, color: Colors.amber),
                  ),
                const SizedBox(width: 6),
                Text(language,
                    style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(width: 6),
                Text(encoding,
                    style: Theme.of(context).textTheme.labelSmall),
                if (readOnly)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.lock_outline, size: 12),
                  ),
              ],
            ),
          ),
          // Code preview
          Padding(
            padding: const EdgeInsets.all(10),
            child: code.isEmpty
                ? Text('No code content',
                    style: Theme.of(context).textTheme.bodySmall)
                : Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        code.length > 2000
                            ? '${code.substring(0, 2000)}\n…'
                            : code,
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
          ),
          // Emit action
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: FilledButton.tonal(
              onPressed: () =>
                  ctx.onEmit('change', {'module': module, 'payload': m}),
              child: const Text('Emit Change'),
            ),
          ),
        ],
      ),
    );
  }
}
