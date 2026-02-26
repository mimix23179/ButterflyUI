library skins_submodule_editors;

import 'package:flutter/material.dart';

import 'skins_submodule_context.dart';

// ---------------------------------------------------------------------------
// Dispatch
// ---------------------------------------------------------------------------

/// Module names handled by this category.
const Set<String> _editorModules = {
  'effect_editor',
  'particle_editor',
  'shader_editor',
  'material_editor',
  'icon_editor',
  'font_editor',
  'color_editor',
  'background_editor',
  'border_editor',
  'shadow_editor',
  'outline_editor',
};

/// Builds a named-editor Skins submodule widget, or returns `null` if
/// [module] is not an editor module.
Widget? buildSkinsEditorsSection(String module, SkinsSubmoduleContext ctx) {
  if (!_editorModules.contains(module)) return null;
  return _NamedEditorWidget(ctx: ctx);
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class _NamedEditorWidget extends StatefulWidget {
  const _NamedEditorWidget({required this.ctx});
  final SkinsSubmoduleContext ctx;

  @override
  State<_NamedEditorWidget> createState() => _NamedEditorWidgetState();
}

class _NamedEditorWidgetState extends State<_NamedEditorWidget> {
  late final TextEditingController _controller = TextEditingController(
    text:
        (widget.ctx.section['value'] ?? widget.ctx.section['text'] ?? '')
            .toString(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        (widget.ctx.section['title'] ??
                widget.ctx.module.replaceAll('_', ' '))
            .toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          minLines: 3,
          maxLines: 10,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () {
            widget.ctx.onEmit('change', {
              'module': widget.ctx.module,
              'name': widget.ctx.section['name']?.toString(),
              'value': _controller.text,
            });
          },
          child: const Text('Save Module'),
        ),
      ],
    );
  }
}
