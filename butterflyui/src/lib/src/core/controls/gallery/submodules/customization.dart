library gallery_submodule_customization;

import 'package:flutter/material.dart';

import 'gallery_submodule_context.dart';

const Set<String> _customizationModules = {'presets', 'skins'};

/// Dispatch entry point for customization modules (presets + skins).
Widget? buildGalleryCustomizationSection(
  String module,
  GallerySubmoduleContext ctx,
) {
  if (!_customizationModules.contains(module)) return null;
  return _CustomizationCollectionWidget(ctx: ctx);
}

// ---------------------------------------------------------------------------
// _CustomizationCollectionWidget — presets, skins
// ---------------------------------------------------------------------------

class _CustomizationCollectionWidget extends StatelessWidget {
  const _CustomizationCollectionWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final items = props['items'] is List
        ? (props['items'] as List)
        : const <dynamic>[];

    if (items.isEmpty) {
      return Text(
        '${ctx.module.replaceAll('_', ' ')}: empty',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items.take(24))
          ActionChip(
            label: Text(
              item is Map
                  ? (item['label'] ?? item['name'] ?? item['id'] ?? '')
                        .toString()
                  : item.toString(),
            ),
            onPressed: () =>
                ctx.onEmit('select', {'module': ctx.module, 'item': item}),
          ),
      ],
    );
  }
}
