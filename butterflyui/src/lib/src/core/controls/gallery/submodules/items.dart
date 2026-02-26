library gallery_submodule_items;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:flutter/material.dart';

import 'gallery_submodule_context.dart';

const Set<String> _itemModules = {
  'item_tile',
  'item_badge',
  'item_meta_row',
  'item_preview',
  'item_actions',
  'item_selectable',
  'item_drag_handle',
  'item_drop_target',
  'item_reorder_handle',
  'item_selection_checkbox',
  'item_selection_radio',
  'item_selection_switch',
};

/// Dispatch entry point for item-level modules.
Widget? buildGalleryItemsSection(
  String module,
  GallerySubmoduleContext ctx,
) {
  if (!_itemModules.contains(module)) return null;
  switch (module) {
    case 'item_tile':
      return _ItemTileWidget(ctx: ctx);
    case 'item_badge':
      return _ItemBadgeWidget(ctx: ctx);
    case 'item_meta_row':
      return _ItemMetaRowWidget(ctx: ctx);
    case 'item_preview':
      return _ItemPreviewWidget(ctx: ctx);
    case 'item_actions':
      return _ItemActionsWidget(ctx: ctx);
    case 'item_selectable':
      return _ItemSelectableWidget(ctx: ctx);
    case 'item_drag_handle':
    case 'item_reorder_handle':
      return _ItemHandleWidget(ctx: ctx);
    case 'item_drop_target':
      return _ItemDropTargetWidget(ctx: ctx);
    case 'item_selection_checkbox':
      return _SelectionCheckboxWidget(ctx: ctx);
    case 'item_selection_radio':
      return _SelectionRadioWidget(ctx: ctx);
    case 'item_selection_switch':
      return _SelectionSwitchWidget(ctx: ctx);
    default:
      return null;
  }
}

// ---------------------------------------------------------------------------
// _ItemTileWidget
// ---------------------------------------------------------------------------

class _ItemTileWidget extends StatelessWidget {
  const _ItemTileWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final title = (props['title'] ?? '').toString();
    final subtitle = (props['subtitle'] ?? '').toString();
    final id = (props['id'] ?? props['value'] ?? title).toString();

    return ListTile(
      title: Text(title),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      onTap: () => ctx.onEmit('select', {'id': id}),
    );
  }
}

// ---------------------------------------------------------------------------
// _ItemBadgeWidget
// ---------------------------------------------------------------------------

class _ItemBadgeWidget extends StatelessWidget {
  const _ItemBadgeWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final text =
        (ctx.section['text'] ?? ctx.section['label'] ?? '').toString();
    return Chip(label: Text(text));
  }
}

// ---------------------------------------------------------------------------
// _ItemMetaRowWidget
// ---------------------------------------------------------------------------

class _ItemMetaRowWidget extends StatelessWidget {
  const _ItemMetaRowWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final items = ctx.section['items'] is List
        ? (ctx.section['items'] as List)
        : const <dynamic>[];

    return Wrap(
      spacing: 10,
      children: [
        for (final item in items)
          Text(
            item?.toString() ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _ItemPreviewWidget
// ---------------------------------------------------------------------------

class _ItemPreviewWidget extends StatelessWidget {
  const _ItemPreviewWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    Map<String, Object?>? childMap;
    for (final raw in ctx.rawChildren) {
      if (raw is Map) {
        childMap = coerceObjectMap(raw);
        break;
      }
    }
    if (childMap != null) {
      return ctx.buildChild(childMap);
    }
    final label = (props['label'] ?? props['title'] ?? 'Preview').toString();
    return Container(
      height: coerceDouble(props['height']) ?? 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ctx.radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Text(label),
    );
  }
}

// ---------------------------------------------------------------------------
// _ItemActionsWidget
// ---------------------------------------------------------------------------

class _ItemActionsWidget extends StatelessWidget {
  const _ItemActionsWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final actions = ctx.section['actions'] is List
        ? (ctx.section['actions'] as List)
        : const <dynamic>[];

    return Wrap(
      spacing: 6,
      children: [
        for (final action in actions)
          FilledButton.tonal(
            onPressed: () => ctx.onEmit('action', {'action': action}),
            child: Text(
              action is Map
                  ? (action['label'] ?? action['id'] ?? 'Action').toString()
                  : action?.toString() ?? 'Action',
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _ItemSelectableWidget
// ---------------------------------------------------------------------------

class _ItemSelectableWidget extends StatelessWidget {
  const _ItemSelectableWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final selected = props['selected'] == true;

    return CheckboxListTile(
      value: selected,
      title: Text(
        (props['label'] ?? props['title'] ?? 'Selectable').toString(),
      ),
      onChanged: (value) =>
          ctx.onEmit('select_change', {'selected': value == true}),
    );
  }
}

// ---------------------------------------------------------------------------
// _ItemHandleWidget — handles item_drag_handle and item_reorder_handle
// ---------------------------------------------------------------------------

class _ItemHandleWidget extends StatelessWidget {
  const _ItemHandleWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => ctx.onEmit('drag_handle', {'kind': ctx.module}),
      icon: const Icon(Icons.drag_indicator),
    );
  }
}

// ---------------------------------------------------------------------------
// _ItemDropTargetWidget
// ---------------------------------------------------------------------------

class _ItemDropTargetWidget extends StatelessWidget {
  const _ItemDropTargetWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    return Container(
      height: coerceDouble(props['height']) ?? 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(ctx.radius),
      ),
      child: TextButton(
        onPressed: () => ctx.onEmit('drop_target', {}),
        child: Text((props['label'] ?? 'Drop Target').toString()),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SelectionCheckboxWidget
// ---------------------------------------------------------------------------

class _SelectionCheckboxWidget extends StatelessWidget {
  const _SelectionCheckboxWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final selected = ctx.section['selected'] == true;
    return Checkbox(
      value: selected,
      onChanged: (value) =>
          ctx.onEmit('select_change', {'selected': value == true}),
    );
  }
}

// ---------------------------------------------------------------------------
// _SelectionRadioWidget
// ---------------------------------------------------------------------------

class _SelectionRadioWidget extends StatelessWidget {
  const _SelectionRadioWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final selected = ctx.section['selected'] == true;
    return Radio<bool>(
      value: true,
      groupValue: selected,
      onChanged: (value) =>
          ctx.onEmit('select_change', {'selected': value == true}),
    );
  }
}

// ---------------------------------------------------------------------------
// _SelectionSwitchWidget
// ---------------------------------------------------------------------------

class _SelectionSwitchWidget extends StatelessWidget {
  const _SelectionSwitchWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final selected = ctx.section['selected'] == true;
    return Switch(
      value: selected,
      onChanged: (value) =>
          ctx.onEmit('select_change', {'selected': value}),
    );
  }
}
