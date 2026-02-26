library skins_submodule_commands;

import 'package:flutter/material.dart';

import 'skins_submodule_context.dart';

// ---------------------------------------------------------------------------
// Dispatch
// ---------------------------------------------------------------------------

/// Module names handled by this category.
const Set<String> _commandModules = {
  'apply',
  'clear',
  'create_skin',
  'edit_skin',
  'delete_skin',
};

/// Builds a command/action Skins submodule widget, or returns `null` if
/// [module] is not a command module.
Widget? buildSkinsCommandsSection(String module, SkinsSubmoduleContext ctx) {
  if (!_commandModules.contains(module)) return null;
  return _ActionButtonWidget(ctx: ctx);
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class _ActionButtonWidget extends StatelessWidget {
  const _ActionButtonWidget({required this.ctx});
  final SkinsSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final label =
        (ctx.section['label'] ?? ctx.module.replaceAll('_', ' ')).toString();
    return FilledButton.tonal(
      onPressed: () {
        ctx.onEmit(ctx.module, {
          'name': ctx.section['name'],
          'skin': ctx.section['skin'] ?? ctx.section['value'],
          'payload': ctx.section['payload'],
        });
      },
      child: Text(label),
    );
  }
}
