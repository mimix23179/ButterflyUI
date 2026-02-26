library gallery_submodule_layout;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/display/empty_state.dart';
import 'package:butterflyui_runtime/src/core/controls/feedback/skeleton.dart';
import 'package:butterflyui_runtime/src/core/controls/inputs/search_bar.dart';
import 'package:flutter/material.dart';

import 'gallery_submodule_context.dart';

/// Dispatch entry point for layout/chrome modules.
/// Returns a Widget or null (= not this category).
Widget? buildGalleryLayoutSection(
  String module,
  GallerySubmoduleContext ctx,
) {
  switch (module) {
    case 'toolbar':
      return _ToolbarWidget(ctx: ctx);
    case 'filter_bar':
      return _FilterBarWidget(ctx: ctx);
    case 'sort_bar':
      return _SortBarWidget(ctx: ctx);
    case 'section_header':
      return _SectionHeaderWidget(ctx: ctx);
    case 'grid_layout':
      return _GridLayoutWidget(ctx: ctx);
    case 'pagination':
      return _PaginationWidget(ctx: ctx);
    case 'search_bar':
      return buildSearchBarControl(ctx.controlId, ctx.section, ctx.sendEvent);
    case 'loading_skeleton':
      return buildSkeletonLoaderControl(
        ctx.controlId,
        ctx.section,
        ctx.registerInvokeHandler,
        ctx.unregisterInvokeHandler,
      );
    case 'empty_state':
      return buildEmptyStateControl(ctx.controlId, ctx.section, ctx.sendEvent);
    default:
      return null;
  }
}

// ---------------------------------------------------------------------------
// _ToolbarWidget
// ---------------------------------------------------------------------------

class _ToolbarWidget extends StatelessWidget {
  const _ToolbarWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final title = (props['title'] ?? 'Gallery').toString();
    final subtitle = (props['subtitle'] ?? '').toString();
    final actions = props['actions'] is List
        ? (props['actions'] as List)
        : const <dynamic>[];

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle.isNotEmpty)
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        for (final action in actions)
          IconButton(
            onPressed: () {
              if (action is Map) {
                final map = coerceObjectMap(action);
                ctx.onEmit('action', {
                  'id':
                      (map['id'] ?? map['value'] ?? map['label'] ?? '')
                          .toString(),
                  'action': map,
                });
              }
            },
            icon: const Icon(Icons.more_horiz),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _FilterBarWidget
// ---------------------------------------------------------------------------

class _FilterBarWidget extends StatelessWidget {
  const _FilterBarWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final filters = props['filters'] is List
        ? (props['filters'] as List)
        : const <dynamic>[];
    final selected = <String>{};
    final values = props['values'];
    if (values is List) {
      for (final value in values) {
        final s = value?.toString();
        if (s != null && s.isNotEmpty) selected.add(s);
      }
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final filter in filters)
          FilterChip(
            selected: selected.contains(filter?.toString()),
            label: Text(filter?.toString() ?? ''),
            onSelected: (next) {
              ctx.onEmit('filter_change', {
                'filter': filter?.toString(),
                'selected': next,
              });
            },
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _SortBarWidget
// ---------------------------------------------------------------------------

class _SortBarWidget extends StatelessWidget {
  const _SortBarWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final options = props['options'] is List
        ? (props['options'] as List)
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList(growable: false)
        : const <String>[];
    final selected =
        (props['value'] ??
                props['selected'] ??
                (options.isEmpty ? '' : options.first))
            .toString();

    if (options.isEmpty) return const SizedBox.shrink();

    return DropdownButton<String>(
      value: options.contains(selected) ? selected : options.first,
      items: options
          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
          .toList(growable: false),
      onChanged: (value) {
        if (value == null) return;
        ctx.onEmit('sort_change', {'value': value});
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _SectionHeaderWidget
// ---------------------------------------------------------------------------

class _SectionHeaderWidget extends StatelessWidget {
  const _SectionHeaderWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final title = (props['title'] ?? '').toString();
    final subtitle = (props['subtitle'] ?? '').toString();
    final count = (props['count'] ?? '').toString();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              if (subtitle.isNotEmpty)
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        if (count.isNotEmpty) Text(count),
        IconButton(
          onPressed: () =>
              ctx.onEmit('section_action', {'id': props['id']}),
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _GridLayoutWidget
// ---------------------------------------------------------------------------

class _GridLayoutWidget extends StatelessWidget {
  const _GridLayoutWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final columns = (coerceOptionalInt(props['columns']) ?? 3).clamp(1, 8);
    final spacing = coerceDouble(props['spacing']) ?? 10;
    final childMaps = ctx.rawChildren
        .whereType<Map>()
        .map((e) => coerceObjectMap(e))
        .toList(growable: false);

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: childMaps.isEmpty
          ? const <Widget>[]
          : childMaps.map(ctx.buildChild).toList(growable: false),
    );
  }
}

// ---------------------------------------------------------------------------
// _PaginationWidget
// ---------------------------------------------------------------------------

class _PaginationWidget extends StatelessWidget {
  const _PaginationWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final page = (coerceOptionalInt(props['page']) ?? 1).clamp(1, 1000000);
    final pageCount =
        (coerceOptionalInt(props['page_count'] ?? props['pages']) ?? 1).clamp(
          1,
          1000000,
        );
    final enabled =
        props['enabled'] == null ? true : (props['enabled'] == true);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: enabled && page > 1
              ? () => ctx.onEmit('page_change', {'page': page - 1})
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text('$page / $pageCount'),
        IconButton(
          onPressed: enabled && page < pageCount
              ? () => ctx.onEmit('page_change', {'page': page + 1})
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
