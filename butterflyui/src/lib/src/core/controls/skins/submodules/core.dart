library skins_submodule_core;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'skins_submodule_context.dart';

// ---------------------------------------------------------------------------
// Chrome widgets (used directly in host build(), not via dispatch)
// ---------------------------------------------------------------------------

/// Header bar showing the current state and selected-skin summary.
class SkinsHeader extends StatelessWidget {
  const SkinsHeader({
    super.key,
    required this.state,
    required this.selectedSkin,
    required this.skinCount,
  });

  final String state;
  final String? selectedSkin;
  final int skinCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Skins', style: Theme.of(context).textTheme.titleMedium),
              Text(
                'State: $state',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Text('Selected: ${selectedSkin ?? 'none'}'),
        const SizedBox(width: 8),
        Text('Total: $skinCount'),
      ],
    );
  }
}

/// Horizontal chip-tab bar for switching the active module.
class SkinsModuleTabs extends StatelessWidget {
  const SkinsModuleTabs({
    super.key,
    required this.modules,
    required this.currentModule,
    required this.onSelected,
  });

  final List<String> modules;
  final String currentModule;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final module in modules)
          ChoiceChip(
            selected: currentModule == module,
            label: Text(module.replaceAll('_', ' ')),
            onSelected: (_) => onSelected(module),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dispatch
// ---------------------------------------------------------------------------

/// Builds a core-category Skins submodule widget, or returns `null` if
/// [module] is not a core module.
Widget? buildSkinsCoreSection(String module, SkinsSubmoduleContext ctx) {
  switch (module) {
    case 'selector':
      return _SelectorWidget(ctx: ctx);
    case 'preset':
      return _PresetListWidget(ctx: ctx);
    case 'editor':
      return _EditorWidget(ctx: ctx);
    case 'preview':
      return _PreviewWidget(ctx: ctx);
    case 'token_mapper':
      return _TokenMapperWidget(ctx: ctx);
    default:
      return null;
  }
}

// ---------------------------------------------------------------------------
// Private helpers (mirrors those in skins_host.dart)
// ---------------------------------------------------------------------------

List<String> _coerceSkins(Object? value) {
  final out = <String>[];
  if (value is List) {
    for (final item in value) {
      final name = item is Map
          ? (item['name'] ?? item['id'] ?? item['value'] ?? '').toString()
          : (item?.toString() ?? '');
      if (name.isNotEmpty && !out.contains(name)) {
        out.add(name);
      }
    }
  }
  return out;
}

String? _resolveSelected(Map<String, Object?> props, List<String> skins) {
  final selected =
      (props['selected_skin'] ?? props['skin'] ?? props['value'])?.toString();
  if (selected != null && selected.isNotEmpty) return selected;
  if (skins.isNotEmpty) return skins.first;
  return null;
}

// ---------------------------------------------------------------------------
// Module widgets
// ---------------------------------------------------------------------------

class _SelectorWidget extends StatelessWidget {
  const _SelectorWidget({required this.ctx});
  final SkinsSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final options = _coerceSkins(
      ctx.section['skins'] ?? ctx.section['options'] ?? ctx.section['items'],
    );
    if (options.isEmpty) return const SizedBox.shrink();
    final selected = _resolveSelected(ctx.section, options) ?? options.first;
    return DropdownButton<String>(
      value: options.contains(selected) ? selected : options.first,
      items: options
          .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
          .toList(growable: false),
      onChanged: (next) {
        if (next == null) return;
        ctx.onSelectSkin?.call(next);
        ctx.onEmit('select', {'skin': next});
      },
    );
  }
}

class _PresetListWidget extends StatelessWidget {
  const _PresetListWidget({required this.ctx});
  final SkinsSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final presets = _coerceSkins(
      ctx.section['presets'] ??
          ctx.section['items'] ??
          ctx.section['options'],
    );
    if (presets.isEmpty) {
      final label =
          (ctx.section['label'] ?? ctx.section['name'] ?? 'Preset').toString();
      return OutlinedButton(
        onPressed: () {
          ctx.onSelectSkin?.call(label);
          ctx.onEmit('select', {'skin': label});
        },
        child: Text(label),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final preset in presets)
          OutlinedButton(
            onPressed: () {
              ctx.onSelectSkin?.call(preset);
              ctx.onEmit('select', {'skin': preset});
            },
            child: Text(preset),
          ),
      ],
    );
  }
}

class _EditorWidget extends StatefulWidget {
  const _EditorWidget({required this.ctx});
  final SkinsSubmoduleContext ctx;

  @override
  State<_EditorWidget> createState() => _EditorWidgetState();
}

class _EditorWidgetState extends State<_EditorWidget> {
  late final TextEditingController _controller = TextEditingController(
    text: (widget.ctx.section['value'] ?? widget.ctx.section['text'] ?? '')
        .toString(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          minLines: 4,
          maxLines: 12,
          decoration: const InputDecoration(
            hintText: 'Edit skin JSON/tokens…',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () {
            widget.ctx.onEmit('edit_skin', {
              'name': widget.ctx.section['name']?.toString(),
              'value': _controller.text,
            });
          },
          child: const Text('Save Skin'),
        ),
      ],
    );
  }
}

class _PreviewWidget extends StatelessWidget {
  const _PreviewWidget({required this.ctx});
  final SkinsSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    Map<String, Object?>? firstChild;
    for (final raw in ctx.rawChildren) {
      if (raw is Map) {
        firstChild = coerceObjectMap(raw);
        break;
      }
    }
    final previewBg =
        coerceColor(
          ctx.section['preview_bg'] ??
              ctx.section['background'] ??
              ctx.section['bgcolor'],
        ) ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final borderColor =
        coerceColor(ctx.section['border_color']) ??
        Theme.of(context).dividerColor.withValues(alpha: 0.85);

    final swatches = <Color>[];
    final rawSwatches = ctx.section['swatches'];
    if (rawSwatches is List) {
      for (final entry in rawSwatches) {
        final color = coerceColor(entry);
        if (color != null) swatches.add(color);
      }
    }
    if (swatches.isEmpty) {
      final rawColors = ctx.section['colors'];
      if (rawColors is List) {
        for (final entry in rawColors) {
          if (entry is Map) {
            final map = coerceObjectMap(entry);
            final color = coerceColor(
              map['value'] ?? map['color'] ?? map['hex'] ?? map['token'],
            );
            if (color != null) swatches.add(color);
          }
        }
      }
    }
    if (swatches.isEmpty) {
      swatches.addAll(<Color>[
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.tertiary,
      ]);
    }

    final skinName =
        (ctx.section['skin'] ??
                ctx.section['active'] ??
                ctx.section['selected_skin'] ??
                'Preview')
            .toString();
    final preview = firstChild == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                skinName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                (ctx.section['label'] ?? 'Live skin preview').toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final color in swatches.take(8))
                    Container(
                      width: 40,
                      height: 22,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          )
        : ctx.buildChild(firstChild);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: previewBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(ctx.radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: preview,
    );
  }
}

class _TokenMapperWidget extends StatelessWidget {
  const _TokenMapperWidget({required this.ctx});
  final SkinsSubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final mapping = ctx.section['mapping'];
    if (mapping is! Map) return const SizedBox.shrink();
    final entries = coerceObjectMap(mapping).entries.toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('${entry.key}: ${entry.value}'),
          ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () {
            ctx.onEmit('token_map', {'mapping': mapping});
          },
          child: const Text('Emit Mapping'),
        ),
      ],
    );
  }
}
