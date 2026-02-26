library code_editor_submodule_diff;

import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';

import 'code_editor_submodule_context.dart';

const Set<String> _diffModules = {'diff', 'diff_narrator'};

/// Dispatch entry point: returns a Widget for diff/diff_narrator, or null.
Widget? buildCodeEditorDiffModule(
  String module,
  CodeEditorSubmoduleContext ctx,
) {
  if (!_diffModules.contains(module)) return null;
  if (module == 'diff_narrator') return _DiffNarratorWidget(ctx: ctx);
  return _DiffWidget(ctx: ctx);
}

// ---------------------------------------------------------------------------
// _DiffWidget
// ---------------------------------------------------------------------------

class _DiffWidget extends StatelessWidget {
  const _DiffWidget({required this.ctx});

  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final left = (props['left'] ?? props['before'] ?? '').toString();
    final right = (props['right'] ?? props['after'] ?? '').toString();
    final differ = DiffMatchPatch();
    final diffs = differ.diff(left, right);

    var addedChars = 0;
    var removedChars = 0;
    var unchangedChars = 0;
    final changedDiffs = <Diff>[];
    for (final diff in diffs) {
      if (diff.operation == DIFF_INSERT) {
        addedChars += diff.text.length;
        if (changedDiffs.length < 24 && diff.text.trim().isNotEmpty) {
          changedDiffs.add(diff);
        }
      } else if (diff.operation == DIFF_DELETE) {
        removedChars += diff.text.length;
        if (changedDiffs.length < 24 && diff.text.trim().isNotEmpty) {
          changedDiffs.add(diff);
        }
      } else {
        unchangedChars += diff.text.length;
      }
    }

    String clip(String text, {int max = 180}) {
      final compact = text.replaceAll('\r\n', '\n').replaceAll('\n', ' ');
      if (compact.length <= max) return compact;
      return '${compact.substring(0, max - 3)}...';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              label: Text('Added $addedChars'),
              backgroundColor: Colors.green.withValues(alpha: 0.14),
            ),
            Chip(
              label: Text('Removed $removedChars'),
              backgroundColor: Colors.red.withValues(alpha: 0.14),
            ),
            Chip(
              label: Text('Unchanged $unchangedChars'),
              backgroundColor: Colors.blueGrey.withValues(alpha: 0.12),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 180),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: changedDiffs.isEmpty
              ? const Text('No textual delta')
              : ListView(
                  children: [
                    for (final diff in changedDiffs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '${diff.operation == DIFF_INSERT ? '+' : '-'} ${clip(diff.text)}',
                          style: TextStyle(
                            color: diff.operation == DIFF_INSERT
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          title: const Text('Raw Before / After'),
          childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DiffTextPane(
                    title: 'Before',
                    value: left,
                    background: Colors.red.withValues(alpha: 0.06),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DiffTextPane(
                    title: 'After',
                    value: right,
                    background: Colors.green.withValues(alpha: 0.06),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () => ctx.onEmit('select', {
            'module': 'diff',
            'left': left,
            'right': right,
          }),
          child: const Text('Use Diff'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _DiffTextPane
// ---------------------------------------------------------------------------

class _DiffTextPane extends StatelessWidget {
  const _DiffTextPane({
    required this.title,
    required this.value,
    required this.background,
  });

  final String title;
  final String value;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 120, maxHeight: 280),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                value.isEmpty ? '-' : value,
                style: const TextStyle(fontFamily: 'JetBrains Mono'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DiffNarratorWidget
// ---------------------------------------------------------------------------

class _DiffNarratorWidget extends StatelessWidget {
  const _DiffNarratorWidget({required this.ctx});

  final CodeEditorSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final explicit =
        (props['text'] ?? props['summary'] ?? props['message'] ?? '')
            .toString()
            .trim();
    if (explicit.isNotEmpty) {
      return SelectableText(explicit);
    }

    final before = (props['left'] ?? props['before'] ?? '').toString();
    final after = (props['right'] ?? props['after'] ?? '').toString();
    if (before.isEmpty && after.isEmpty) {
      return const Text('No diff context available');
    }
    if (before == after) {
      return const Text(
        'No semantic change detected between compared versions.',
      );
    }

    final differ = DiffMatchPatch();
    final diffs = differ.diff(before, after);
    var addedChars = 0;
    var removedChars = 0;
    final highlights = <String>[];
    for (final diff in diffs) {
      final text = diff.text.trim();
      if (diff.operation == DIFF_INSERT) {
        addedChars += diff.text.length;
        if (text.isNotEmpty && highlights.length < 5) {
          highlights.add('Added: ${_clipNarrator(text)}');
        }
      } else if (diff.operation == DIFF_DELETE) {
        removedChars += diff.text.length;
        if (text.isNotEmpty && highlights.length < 5) {
          highlights.add('Removed: ${_clipNarrator(text)}');
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Change summary: +$addedChars / -$removedChars characters',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        if (highlights.isEmpty)
          const Text('No highlightable segments.')
        else
          for (final highlight in highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(highlight),
            ),
      ],
    );
  }
}

String _clipNarrator(String text) {
  final compact = text.replaceAll('\r\n', '\n').replaceAll('\n', ' ');
  if (compact.length <= 100) return compact;
  return '${compact.substring(0, 97)}...';
}
