library skins_submodule_tokens;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'skins_submodule_context.dart';

// ---------------------------------------------------------------------------
// Dispatch
// ---------------------------------------------------------------------------

/// Builds a token/collection Skins submodule widget.
///
/// This is the fallback builder; it always returns a widget regardless of
/// [module] name, matching the original `default:` branch in the host's
/// `_buildModuleWidget` switch statement.
Widget buildSkinsTokensSection(String module, SkinsSubmoduleContext ctx) {
  return _CollectionModuleWidget(ctx: ctx);
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class _CollectionModuleWidget extends StatelessWidget {
  const _CollectionModuleWidget({required this.ctx});
  final SkinsSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final items = ctx.section['items'] is List
        ? (ctx.section['items'] as List)
        : (ctx.section['options'] is List
              ? (ctx.section['options'] as List)
              : const <dynamic>[]);

    if (items.isEmpty) {
      return FilledButton.tonal(
        onPressed: () {
          ctx.onEmit('change', {
            'module': ctx.module,
            'action': 'touch',
          });
        },
        child: Text('Update ${ctx.module.replaceAll('_', ' ')}'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          FilterChip(
            selected: false,
            label: Text(
              item is Map
                  ? (coerceObjectMap(item)['label'] ??
                            coerceObjectMap(item)['name'] ??
                            coerceObjectMap(item)['id'] ??
                            '')
                        .toString()
                  : item.toString(),
            ),
            onSelected: (selected) {
              ctx.onEmit('change', {
                'module': ctx.module,
                'selected': selected,
                'value': item,
              });
            },
          ),
      ],
    );
  }
}
