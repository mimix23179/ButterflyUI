library gallery_submodule_commands;

import 'package:flutter/material.dart';

import 'gallery_submodule_context.dart';

const Set<String> _commandModules = {
  'apply',
  'clear',
  'select_all',
  'deselect_all',
  'apply_font',
  'apply_image',
  'set_as_wallpaper',
};

/// Dispatch entry point for action-command modules.
Widget? buildGalleryCommandsSection(
  String module,
  GallerySubmoduleContext ctx,
) {
  if (!_commandModules.contains(module)) return null;
  return _ActionButtonWidget(ctx: ctx);
}

// ---------------------------------------------------------------------------
// _ActionButtonWidget — apply, clear, select_all, deselect_all, etc.
// ---------------------------------------------------------------------------

class _ActionButtonWidget extends StatelessWidget {
  const _ActionButtonWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final label =
        (ctx.section['label'] ?? ctx.module.replaceAll('_', ' ')).toString();

    return FilledButton.tonal(
      onPressed: () => ctx.onEmit(ctx.module, {
        'value': ctx.section['value'],
        'payload': ctx.section['payload'],
      }),
      child: Text(label),
    );
  }
}
