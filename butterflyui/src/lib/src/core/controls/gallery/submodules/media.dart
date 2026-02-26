library gallery_submodule_media;

import 'package:flutter/material.dart';

import 'gallery_submodule_context.dart';

const Set<String> _mediaModules = {
  'fonts',
  'font_picker',
  'font_renderer',
  'audio',
  'audio_picker',
  'audio_renderer',
  'video',
  'video_picker',
  'video_renderer',
  'image',
  'image_picker',
  'image_renderer',
  'document',
  'document_picker',
  'document_renderer',
};

const Set<String> _collectionModules = {
  'fonts',
  'audio',
  'video',
  'image',
  'document',
};

const Set<String> _rendererModules = {
  'font_renderer',
  'audio_renderer',
  'video_renderer',
  'image_renderer',
  'document_renderer',
};

const Set<String> _pickerModules = {
  'audio_picker',
  'video_picker',
  'image_picker',
  'document_picker',
};

/// Dispatch entry point for media-asset modules.
Widget? buildGalleryMediaSection(
  String module,
  GallerySubmoduleContext ctx,
) {
  if (!_mediaModules.contains(module)) return null;
  if (_collectionModules.contains(module)) {
    return _AssetCollectionWidget(ctx: ctx);
  }
  if (module == 'font_picker') return _FontPickerWidget(ctx: ctx);
  if (_rendererModules.contains(module)) return _AssetRendererWidget(ctx: ctx);
  if (_pickerModules.contains(module)) return _AssetPickerWidget(ctx: ctx);
  return null;
}

// ---------------------------------------------------------------------------
// _AssetCollectionWidget — fonts, audio, video, image, document
// ---------------------------------------------------------------------------

class _AssetCollectionWidget extends StatelessWidget {
  const _AssetCollectionWidget({required this.ctx});

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

// ---------------------------------------------------------------------------
// _FontPickerWidget — font_picker
// ---------------------------------------------------------------------------

class _FontPickerWidget extends StatelessWidget {
  const _FontPickerWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final options = props['options'] is List
        ? (props['options'] as List)
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList(growable: false)
        : const <String>['Inter', 'Roboto', 'JetBrains Mono'];
    final value = (props['value'] ?? options.first).toString();

    return DropdownButton<String>(
      value: options.contains(value) ? value : options.first,
      items: options
          .map((font) => DropdownMenuItem(value: font, child: Text(font)))
          .toList(growable: false),
      onChanged: (next) {
        if (next == null) return;
        ctx.onEmit('font_change', {'font': next});
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _AssetRendererWidget — font_renderer, audio_renderer, etc.
// ---------------------------------------------------------------------------

class _AssetRendererWidget extends StatelessWidget {
  const _AssetRendererWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final props = ctx.section;
    final label =
        (props['label'] ??
                props['title'] ??
                ctx.module.replaceAll('_', ' '))
            .toString();
    final value =
        (props['text'] ?? props['src'] ?? props['font'] ?? '').toString();

    return Container(
      width: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(ctx.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(
            value.isEmpty ? '(no value)' : value,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () =>
                ctx.onEmit('select', {'module': ctx.module, 'value': value}),
            child: const Text('Use'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AssetPickerWidget — audio_picker, video_picker, image_picker, document_picker
// ---------------------------------------------------------------------------

class _AssetPickerWidget extends StatelessWidget {
  const _AssetPickerWidget({required this.ctx});

  final GallerySubmoduleContext ctx;

  @override
  Widget build(BuildContext context) {
    final label =
        (ctx.section['label'] ?? ctx.module.replaceAll('_', ' ')).toString();

    return OutlinedButton.icon(
      onPressed: () => ctx.onEmit('pick', {'kind': ctx.module}),
      icon: const Icon(Icons.attach_file),
      label: Text(label),
    );
  }
}
