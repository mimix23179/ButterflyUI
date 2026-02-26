library code_editor_submodule_context;

import 'package:flutter/material.dart';

class CodeEditorSubmoduleContext {
  const CodeEditorSubmoduleContext({
    required this.controlId,
    required this.module,
    required this.section,
    required this.onEmit,
  });
  final String controlId;
  final String module;
  final Map<String, Object?> section;
  final void Function(String event, Map<String, Object?> payload) onEmit;
}

String ceNorm(String v) =>
    v.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');

// Generic module widget used as the catch-all renderer.
class CodeEditorGenericWidget extends StatelessWidget {
  const CodeEditorGenericWidget({
    super.key,
    required this.controlId,
    required this.module,
    required this.props,
    required this.onEmit,
  });

  final String controlId;
  final String module;
  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  Widget build(BuildContext context) {
    final entries = props.entries
        .where((e) => e.key != 'events')
        .toList(growable: false);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entries.isEmpty)
            Text(
              'No payload for ${module.replaceAll('_', ' ')}',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            for (final entry in entries.take(24))
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${entry.key}: ${entry.value}'),
              ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () =>
                onEmit('change', {'module': module, 'payload': props}),
            child: const Text('Emit Change'),
          ),
        ],
      ),
    );
  }
}

Widget buildCodeEditorGeneric(CodeEditorSubmoduleContext ctx) =>
    CodeEditorGenericWidget(
      controlId: ctx.controlId,
      module: ctx.module,
      props: ctx.section,
      onEmit: ctx.onEmit,
    );
