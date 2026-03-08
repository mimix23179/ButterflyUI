// Unified Gallery browser and showcase system
// Gallery presents collections of media, presets, skins, demos, and assets
// through the shared ButterflyUI runtime pipeline.

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart'
    show
        coerceDouble,
        coerceOptionalInt,
        coerceObjectMap,
        coerceColor,
        resolveImageProvider;
import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/card.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/column.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/row.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/grid.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/stack.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/scroll_view.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/aspect_ratio.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/clip.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/elevated_button.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/icon_button.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/filled_button.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/outlined_button.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/text_button.dart';
import 'package:butterflyui_runtime/src/core/controls/display/icon.dart';
import 'package:butterflyui_runtime/src/core/controls/display/avatar.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/badge.dart';
import 'package:butterflyui_runtime/src/core/controls/media/image.dart';
import 'package:butterflyui_runtime/src/core/controls/media/video.dart';
import 'package:butterflyui_runtime/src/core/controls/media/audio.dart';
import 'package:butterflyui_runtime/src/core/controls/lists/list_tile.dart';
import 'package:butterflyui_runtime/src/core/controls/lists/virtual_grid.dart';
import 'package:butterflyui_runtime/src/core/controls/lists/virtual_list.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

// ============================================================================
// Gallery Layout Types
// ============================================================================

enum GalleryLayoutType {
  grid,
  masonry,
  list,
  carousel,
  virtualGrid,
  virtualList,
}

GalleryLayoutType parseGalleryLayout(Object? value) {
  final v = value?.toString().toLowerCase() ?? 'grid';
  return switch (v) {
    'masonry' => GalleryLayoutType.masonry,
    'list' => GalleryLayoutType.list,
    'carousel' => GalleryLayoutType.carousel,
    'virtual_grid' || 'virtualgrid' => GalleryLayoutType.virtualGrid,
    'virtual_list' || 'virtuallist' => GalleryLayoutType.virtualList,
    _ => GalleryLayoutType.grid,
  };
}

String _normalizeGalleryModule(Object? value) {
  if (value == null) return '';
  return value
      .toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
}

GalleryLayoutType _resolveGalleryLayoutFromModule(
  String module,
  GalleryLayoutType fallback,
) {
  return switch (module) {
    'grid_layout' => GalleryLayoutType.grid,
    'virtual_grid' => GalleryLayoutType.virtualGrid,
    'virtual_list' => GalleryLayoutType.virtualList,
    'list' => GalleryLayoutType.list,
    'carousel' => GalleryLayoutType.carousel,
    _ => fallback,
  };
}

String? _resolveGalleryTypeFilterFromModule(String module) {
  return switch (module) {
    'fonts' || 'font_picker' || 'font_renderer' => 'font',
    'audio' || 'audio_picker' || 'audio_renderer' => 'audio',
    'video' || 'video_picker' || 'video_renderer' => 'video',
    'image' || 'image_picker' || 'image_renderer' => 'image',
    'document' || 'document_picker' || 'document_renderer' => 'document',
    'skins' => 'skins',
    _ => null,
  };
}

Map<String, Object?> _bridgeGalleryModuleProps(
  String module,
  Map<String, Object?> rawProps,
) {
  final bridged = Map<String, Object?>.from(rawProps);

  List<Map<String, Object?>> actionsFrom(Object? value) {
    if (value is! List) return <Map<String, Object?>>[];
    return value
        .whereType<Map>()
        .map((entry) => coerceObjectMap(entry))
        .toList();
  }

  void ensureAction({
    required String id,
    required String label,
    String? icon,
    String variant = 'text',
  }) {
    final current = actionsFrom(
      bridged['actions'] ?? bridged['toolbar_actions'],
    );
    final exists = current.any((action) {
      final actionId = action['id']?.toString();
      if (actionId != null && actionId == id) return true;
      final actionLabel =
          action['label']?.toString() ?? action['text']?.toString();
      return actionLabel == label;
    });
    if (exists) {
      bridged['actions'] = current;
      return;
    }
    current.add(<String, Object?>{
      'id': id,
      'label': label,
      'variant': variant,
      if (icon != null) 'icon': icon,
    });
    bridged['actions'] = current;
  }

  switch (module) {
    case 'grid_layout':
      bridged.putIfAbsent('layout', () => 'grid');
      break;
    case 'item_tile':
      bridged.putIfAbsent('layout', () => 'grid');
      bridged.putIfAbsent('item_style', () => 'card');
      break;
    case 'item_preview':
      bridged.putIfAbsent('show_meta', () => false);
      bridged.putIfAbsent('show_actions', () => false);
      break;
    case 'item_actions':
      bridged.putIfAbsent('show_actions', () => true);
      break;
    case 'item_meta_row':
      bridged.putIfAbsent('show_meta', () => true);
      break;
    case 'item_badge':
      bridged.putIfAbsent('show_meta', () => true);
      break;
    case 'section_header':
      bridged.putIfAbsent('show_meta', () => true);
      break;
    case 'item_selectable':
      bridged.putIfAbsent('show_selections', () => true);
      bridged.putIfAbsent('selection_mode', () => 'single');
      break;
    case 'item_selection_checkbox':
      bridged.putIfAbsent('show_selections', () => true);
      bridged.putIfAbsent('selection_mode', () => 'multi');
      break;
    case 'item_selection_radio':
    case 'item_selection_switch':
      bridged.putIfAbsent('show_selections', () => true);
      bridged.putIfAbsent('selection_mode', () => 'single');
      break;
    case 'loading_skeleton':
      bridged.putIfAbsent('is_loading', () => true);
      break;
    case 'empty_state':
      bridged.putIfAbsent('layout', () => 'grid');
      break;
    case 'toolbar':
      bridged.putIfAbsent('show_actions', () => true);
      break;
    case 'search_bar':
      ensureAction(id: 'search', label: 'Search', icon: 'search');
      break;
    case 'filter_bar':
      {
        final filters = bridged['filters'];
        if (filters is List) {
          for (final raw in filters.whereType<Object?>()) {
            final label = raw is Map
                ? (raw['label']?.toString() ?? raw['value']?.toString())
                : raw?.toString();
            if (label == null || label.isEmpty) continue;
            ensureAction(
              id: 'filter_${label.toLowerCase().replaceAll(' ', '_')}',
              label: label,
              icon: 'filter_alt',
              variant: 'outlined',
            );
          }
        } else {
          ensureAction(
            id: 'filter',
            label: 'Filter',
            icon: 'filter_alt',
            variant: 'outlined',
          );
        }
      }
      break;
    case 'sort_bar':
      {
        final options = bridged['options'];
        if (options is List) {
          for (final option in options.whereType<Object?>()) {
            final label = option?.toString();
            if (label == null || label.isEmpty) continue;
            ensureAction(
              id: 'sort_${label.toLowerCase().replaceAll(' ', '_')}',
              label: label,
              icon: 'swap_vert',
            );
          }
        } else {
          ensureAction(id: 'sort', label: 'Sort', icon: 'swap_vert');
        }
      }
      break;
    case 'pagination':
      bridged.putIfAbsent('layout', () => 'list');
      ensureAction(id: 'prev', label: 'Prev', icon: 'chevron_left');
      ensureAction(id: 'next', label: 'Next', icon: 'chevron_right');
      break;
    case 'item_drag_handle':
    case 'item_drop_target':
    case 'item_reorder_handle':
      bridged.putIfAbsent('enable_drag', () => true);
      bridged.putIfAbsent('enable_reorder', () => true);
      break;
    case 'apply':
      ensureAction(
        id: 'apply',
        label: 'Apply',
        icon: 'check',
        variant: 'filled',
      );
      break;
    case 'clear':
      ensureAction(id: 'clear', label: 'Clear', icon: 'clear');
      break;
    case 'select_all':
      ensureAction(id: 'select_all', label: 'Select All', icon: 'done_all');
      bridged.putIfAbsent('selection_mode', () => 'multi');
      break;
    case 'deselect_all':
      ensureAction(id: 'deselect_all', label: 'Deselect', icon: 'remove_done');
      break;
    case 'apply_font':
      ensureAction(
        id: 'apply_font',
        label: 'Apply Font',
        icon: 'font_download',
      );
      break;
    case 'apply_image':
      ensureAction(id: 'apply_image', label: 'Apply Image', icon: 'image');
      break;
    case 'set_as_wallpaper':
      ensureAction(
        id: 'set_as_wallpaper',
        label: 'Set Wallpaper',
        icon: 'wallpaper',
      );
      break;
    case 'font_picker':
      ensureAction(id: 'pick_font', label: 'Pick Font', icon: 'font_download');
      break;
    case 'fonts':
      bridged.putIfAbsent('layout', () => 'list');
      break;
    case 'audio':
    case 'video':
    case 'image':
    case 'document':
      bridged.putIfAbsent('layout', () => 'grid');
      break;
    case 'audio_picker':
      ensureAction(id: 'pick_audio', label: 'Pick Audio', icon: 'audiotrack');
      break;
    case 'video_picker':
      ensureAction(id: 'pick_video', label: 'Pick Video', icon: 'videocam');
      break;
    case 'image_picker':
      ensureAction(id: 'pick_image', label: 'Pick Image', icon: 'image');
      break;
    case 'document_picker':
      ensureAction(
        id: 'pick_document',
        label: 'Pick Document',
        icon: 'description',
      );
      break;
    case 'font_renderer':
    case 'audio_renderer':
    case 'video_renderer':
    case 'image_renderer':
    case 'document_renderer':
      bridged.putIfAbsent('use_control_widgets', () => true);
      break;
    case 'presets':
      bridged.putIfAbsent('layout', () => 'grid');
      break;
    case 'skins':
      bridged.putIfAbsent('layout', () => 'grid');
      break;
    default:
      break;
  }

  return bridged;
}

// ============================================================================
// Gallery Item Model
// ============================================================================

class GalleryItem {
  final String id;
  final String? name;
  final String? path;
  final String? url;
  final String? thumbnailUrl;
  final String type;
  final Map<String, dynamic>? metadata;
  final bool isSelected;
  final bool isLoading;
  final String? subtitle;
  final String? description;
  final String? authorName;
  final String? authorAvatar;
  final int? likeCount;
  final int? viewCount;
  final String? createdAt;
  final double? aspectRatio;
  final List<String>? tags;
  final String? status;

  GalleryItem({
    required this.id,
    this.name,
    this.path,
    this.url,
    this.thumbnailUrl,
    this.type = 'image',
    this.metadata,
    this.isSelected = false,
    this.isLoading = false,
    this.subtitle,
    this.description,
    this.authorName,
    this.authorAvatar,
    this.likeCount,
    this.viewCount,
    this.createdAt,
    this.aspectRatio,
    this.tags,
    this.status,
  });

  GalleryItem copyWith({
    String? id,
    String? name,
    String? path,
    String? url,
    String? thumbnailUrl,
    String? type,
    Map<String, dynamic>? metadata,
    bool? isSelected,
    bool? isLoading,
    String? subtitle,
    String? description,
    String? authorName,
    String? authorAvatar,
    int? likeCount,
    int? viewCount,
    String? createdAt,
    double? aspectRatio,
    List<String>? tags,
    String? status,
  }) {
    return GalleryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      isSelected: isSelected ?? this.isSelected,
      isLoading: isLoading ?? this.isLoading,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      likeCount: likeCount ?? this.likeCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      tags: tags ?? this.tags,
      status: status ?? this.status,
    );
  }

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      path: json['path']?.toString(),
      url: json['url']?.toString(),
      thumbnailUrl:
          json['thumbnailUrl']?.toString() ?? json['thumbnail_url']?.toString(),
      type: json['type']?.toString() ?? 'image',
      metadata: _asMap(json['metadata']),
      isSelected: json['isSelected'] == true || json['is_selected'] == true,
      isLoading: json['isLoading'] == true || json['is_loading'] == true,
      subtitle: json['subtitle']?.toString(),
      description: json['description']?.toString(),
      authorName:
          json['authorName']?.toString() ?? json['author_name']?.toString(),
      authorAvatar:
          json['authorAvatar']?.toString() ?? json['author_avatar']?.toString(),
      likeCount: _asInt(json['likeCount'] ?? json['like_count']),
      viewCount: _asInt(json['viewCount'] ?? json['view_count']),
      createdAt:
          json['createdAt']?.toString() ?? json['created_at']?.toString(),
      aspectRatio: _asDouble(json['aspectRatio'] ?? json['aspect_ratio']),
      tags: _asStringList(json['tags']),
      status: json['status']?.toString(),
    );
  }

  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  static double? _asDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }
    return null;
  }

  static List<String>? _asStringList(Object? value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.isNotEmpty) {
      return value
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'type': type,
      'metadata': metadata,
      'isSelected': isSelected,
      'isLoading': isLoading,
      'subtitle': subtitle,
      'description': description,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'likeCount': likeCount,
      'viewCount': viewCount,
      'createdAt': createdAt,
      'aspectRatio': aspectRatio,
      'tags': tags,
      'status': status,
    };
  }
}

ScrollPhysics? _parseScrollPhysics(String? value) {
  final v = value?.toLowerCase();
  return switch (v) {
    'bouncing' => const BouncingScrollPhysics(),
    'clamping' => const ClampingScrollPhysics(),
    'never' => const NeverScrollableScrollPhysics(),
    'always' => const AlwaysScrollableScrollPhysics(),
    _ => null,
  };
}

// ============================================================================
// Helper functions
// ============================================================================

int? coerceInt(Object? value) {
  return coerceOptionalInt(value);
}

bool coerceBoolValue(Object? value, {bool fallback = false}) {
  if (value == null) return fallback;
  if (value is bool) return value;
  return value.toString().toLowerCase() == 'true';
}

List<String> _coerceGalleryStringList(Object? value) {
  if (value == null) return const <String>[];
  if (value is String) return <String>[value];
  if (value is List) {
    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
  }
  return <String>[value.toString()];
}

Widget _buildGalleryHeader({
  required String title,
  String? subtitle,
  required int itemCount,
  required bool showcase,
}) {
  return Container(
    padding: EdgeInsets.fromLTRB(16, showcase ? 18 : 8, 16, 8),
    decoration: showcase
        ? BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          )
        : null,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Colors.white70)),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$itemCount items',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class _GalleryRuntimeConfig {
  const _GalleryRuntimeConfig({
    required this.lazyPreview,
    required this.visibilityThreshold,
    required this.autoplayVisibleMedia,
    required this.paletteAccents,
    required this.paletteStrength,
  });

  final bool lazyPreview;
  final double visibilityThreshold;
  final bool autoplayVisibleMedia;
  final bool paletteAccents;
  final double paletteStrength;
}

class _GalleryConfigScope extends InheritedWidget {
  const _GalleryConfigScope({required this.config, required super.child});

  final _GalleryRuntimeConfig config;

  static _GalleryRuntimeConfig of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<_GalleryConfigScope>()
            ?.config ??
        const _GalleryRuntimeConfig(
          lazyPreview: true,
          visibilityThreshold: 0.18,
          autoplayVisibleMedia: true,
          paletteAccents: false,
          paletteStrength: 0.85,
        );
  }

  @override
  bool updateShouldNotify(_GalleryConfigScope oldWidget) {
    return config != oldWidget.config;
  }
}

class _GalleryPaletteAccent {
  const _GalleryPaletteAccent({
    required this.accent,
    required this.accentAlt,
    required this.border,
    required this.glow,
    required this.tint,
  });

  final Color accent;
  final Color accentAlt;
  final Color border;
  final Color glow;
  final Color tint;
}

ImageProvider? _resolveGalleryPaletteProvider(
  Object? explicitSource,
  List<GalleryItem> items,
) {
  if (explicitSource is String) {
    return resolveImageProvider(explicitSource);
  }
  if (explicitSource is Map) {
    final source = coerceObjectMap(explicitSource);
    for (final key in const <String>[
      'src',
      'url',
      'thumbnail',
      'thumbnail_url',
      'image',
      'asset',
    ]) {
      final value = source[key]?.toString();
      if (value != null && value.trim().isNotEmpty) {
        final provider = resolveImageProvider(value);
        if (provider != null) return provider;
      }
    }
  }

  for (final item in items) {
    final imageSource = item.thumbnailUrl ?? item.url ?? item.path;
    if (imageSource == null || imageSource.isEmpty) continue;
    final provider = resolveImageProvider(imageSource);
    if (provider != null) return provider;
  }
  return null;
}

_GalleryPaletteAccent _buildGalleryPaletteAccent(
  PaletteGeneratorMaster palette,
  double strength,
) {
  final dominant =
      palette.dominantColor?.color ??
      palette.vibrantColor?.color ??
      const Color(0xFF39C6FF);
  final accent =
      palette.vibrantColor?.color ??
      palette.lightVibrantColor?.color ??
      dominant;
  final accentAlt =
      palette.darkVibrantColor?.color ??
      palette.mutedColor?.color ??
      Color.lerp(accent, dominant, 0.40)!;
  final tint = Color.lerp(
    const Color(0xFF091326),
    dominant,
    (0.14 * strength).clamp(0.0, 1.0),
  )!.withValues(alpha: 0.92);
  return _GalleryPaletteAccent(
    accent: accent,
    accentAlt: accentAlt,
    border: Color.lerp(accent, accentAlt, 0.35)!.withValues(alpha: 0.58),
    glow: accent.withValues(alpha: 0.22),
    tint: tint,
  );
}

class _GalleryShowcasePaletteFrame extends StatefulWidget {
  const _GalleryShowcasePaletteFrame({
    required this.controlId,
    required this.child,
    required this.items,
    required this.explicitSource,
    required this.enabled,
    required this.paletteStrength,
    required this.sendEvent,
  });

  final String controlId;
  final Widget child;
  final List<GalleryItem> items;
  final Object? explicitSource;
  final bool enabled;
  final double paletteStrength;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_GalleryShowcasePaletteFrame> createState() =>
      _GalleryShowcasePaletteFrameState();
}

class _GalleryShowcasePaletteFrameState
    extends State<_GalleryShowcasePaletteFrame> {
  _GalleryPaletteAccent? _accent;

  @override
  void initState() {
    super.initState();
    _refreshPalette();
  }

  @override
  void didUpdateWidget(covariant _GalleryShowcasePaletteFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.explicitSource != widget.explicitSource ||
        oldWidget.items != widget.items ||
        oldWidget.paletteStrength != widget.paletteStrength) {
      _refreshPalette();
    }
  }

  Future<void> _refreshPalette() async {
    if (!widget.enabled) {
      if (mounted) setState(() => _accent = null);
      return;
    }
    final provider = _resolveGalleryPaletteProvider(
      widget.explicitSource,
      widget.items,
    );
    if (provider == null) {
      if (mounted) setState(() => _accent = null);
      return;
    }
    try {
      widget.sendEvent(
        widget.controlId,
        'palette_sync_started',
        <String, Object?>{'strength': widget.paletteStrength},
      );
      final palette = await PaletteGeneratorMaster.fromImageProvider(
        provider,
        maximumColorCount: 12,
      );
      if (!mounted) return;
      final accent = _buildGalleryPaletteAccent(
        palette,
        widget.paletteStrength,
      );
      setState(() => _accent = accent);
      widget.sendEvent(widget.controlId, 'palette_ready', <String, Object?>{
        'accent': accent.accent.toARGB32(),
        'accent_alt': accent.accentAlt.toARGB32(),
        'border': accent.border.toARGB32(),
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _accent = null);
      widget.sendEvent(widget.controlId, 'palette_error', <String, Object?>{
        'message': error.toString(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent;
    if (accent == null) return widget.child;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.tint,
            Color.lerp(
              accent.tint,
              accent.accentAlt,
              0.22,
            )!.withValues(alpha: 0.90),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: accent.glow,
            blurRadius: 26,
            spreadRadius: 1.2,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}

class _GalleryVisibilityPreview extends StatefulWidget {
  const _GalleryVisibilityPreview({
    required this.controlId,
    required this.item,
    required this.sendEvent,
    required this.builder,
    required this.placeholder,
  });

  final String controlId;
  final GalleryItem item;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget Function(bool autoplay) builder;
  final Widget placeholder;

  @override
  State<_GalleryVisibilityPreview> createState() =>
      _GalleryVisibilityPreviewState();
}

class _GalleryVisibilityPreviewState extends State<_GalleryVisibilityPreview> {
  double _visibleFraction = 0.0;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.sendEvent(
        widget.controlId,
        'preview_visibility',
        <String, Object?>{
          'item_id': widget.item.id,
          'visible_fraction': 0.0,
          'revealed': false,
        },
      );
    });
  }

  void _handleVisibility(VisibilityInfo info) {
    if (!mounted) return;
    final config = _GalleryConfigScope.of(context);
    final nextFraction = info.visibleFraction.clamp(0.0, 1.0);
    final shouldReveal =
        _revealed || nextFraction >= config.visibilityThreshold;
    if (nextFraction == _visibleFraction && shouldReveal == _revealed) {
      return;
    }
    setState(() {
      _visibleFraction = nextFraction;
      _revealed = shouldReveal;
    });
    widget.sendEvent(widget.controlId, 'preview_visibility', <String, Object?>{
      'item_id': widget.item.id,
      'visible_fraction': nextFraction,
      'revealed': shouldReveal,
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = _GalleryConfigScope.of(context);
    final autoplay =
        config.autoplayVisibleMedia &&
        _visibleFraction >= config.visibilityThreshold;
    final content = !_revealed && config.lazyPreview
        ? widget.placeholder
        : widget.builder(autoplay);

    return VisibilityDetector(
      key: ValueKey('gallery_visibility_${widget.controlId}_${widget.item.id}'),
      onVisibilityChanged: _handleVisibility,
      child: content,
    );
  }
}

class _GalleryCarouselPager extends StatefulWidget {
  const _GalleryCarouselPager({
    required this.itemCount,
    required this.itemBuilder,
    required this.viewportFraction,
    required this.initialPage,
    required this.padEnds,
    required this.pageSnapping,
    this.physics,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double viewportFraction;
  final int initialPage;
  final bool padEnds;
  final bool pageSnapping;
  final ScrollPhysics? physics;

  @override
  State<_GalleryCarouselPager> createState() => _GalleryCarouselPagerState();
}

class _GalleryCarouselPagerState extends State<_GalleryCarouselPager> {
  late PageController _controller;

  int _clampPage(int value) {
    if (widget.itemCount <= 0) return 0;
    if (value < 0) return 0;
    final maxPage = widget.itemCount - 1;
    if (value > maxPage) return maxPage;
    return value;
  }

  PageController _buildController({required int initialPage}) {
    final viewport = widget.viewportFraction.clamp(0.2, 1.0).toDouble();
    return PageController(
      initialPage: _clampPage(initialPage),
      viewportFraction: viewport,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = _buildController(initialPage: widget.initialPage);
  }

  @override
  void didUpdateWidget(covariant _GalleryCarouselPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed =
        oldWidget.viewportFraction != widget.viewportFraction ||
        oldWidget.initialPage != widget.initialPage ||
        oldWidget.itemCount != widget.itemCount;
    if (!changed) return;
    final previous = _controller;
    _controller = _buildController(initialPage: widget.initialPage);
    previous.dispose();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      physics: widget.physics,
      padEnds: widget.padEnds,
      pageSnapping: widget.pageSnapping,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
    );
  }
}

Widget buildGalleryScopeControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> control) buildChild,
) {
  final child = rawChildren.isNotEmpty && rawChildren.first is Map
      ? coerceObjectMap(rawChildren.first as Map)
      : null;
  if (child == null) {
    final hasGalleryPayload =
        props.containsKey('items') ||
        props.containsKey('layout') ||
        props.containsKey('module');
    if (!hasGalleryPayload) {
      return const SizedBox.shrink();
    }
    return buildChild({
      'id': controlId,
      'type': 'gallery',
      'props': Map<String, Object?>.from(props),
      'children': const [],
    });
  }
  if (child['type']?.toString() == 'gallery') {
    final childProps = child['props'] is Map
        ? coerceObjectMap(child['props'] as Map)
        : <String, Object?>{};
    final mergedProps = {...props, ...childProps};
    return buildChild({
      'id': child['id']?.toString() ?? controlId,
      'type': 'gallery',
      'props': mergedProps,
      'children': child['children'] is List ? child['children'] : const [],
    });
  }
  return buildChild(child);
}

// ============================================================================
// Gallery Builder Function - Uses existing ButterflyUI controls
// ============================================================================

Widget buildGalleryControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?> control) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final initialModule = _normalizeGalleryModule(props['module']);
  final effectiveProps = _bridgeGalleryModuleProps(initialModule, props);
  // Parse items from props
  final itemsData = effectiveProps['items'];
  List<GalleryItem> items = [];
  final module = _normalizeGalleryModule(effectiveProps['module']);

  if (itemsData is List) {
    items = itemsData
        .whereType<Map>()
        .map((item) => GalleryItem.fromJson(coerceObjectMap(item)))
        .toList();
  }

  var layout = parseGalleryLayout(effectiveProps['layout']);
  layout = _resolveGalleryLayoutFromModule(module, layout);
  final typeFilter = _resolveGalleryTypeFilterFromModule(module);
  if (typeFilter != null) {
    items = items
        .where((item) => item.type.toLowerCase() == typeFilter)
        .toList();
  }
  final filterTags = _coerceGalleryStringList(effectiveProps['filter_tags']);
  if (filterTags.isNotEmpty) {
    final normalizedTags = filterTags
        .map((tag) => tag.trim().toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .toSet();
    items = items.where((item) {
      final tags = item.tags;
      if (tags == null || tags.isEmpty) return false;
      return tags.any(
        (tag) => normalizedTags.contains(tag.trim().toLowerCase()),
      );
    }).toList();
  }
  final collectionName =
      effectiveProps['collection_name']?.toString() ??
      effectiveProps['title']?.toString();
  final collectionSubtitle =
      effectiveProps['collection_subtitle']?.toString() ??
      effectiveProps['subtitle']?.toString();
  final showcase = coerceBoolValue(
    effectiveProps['showcase'],
    fallback:
        (collectionName != null && collectionName.trim().isNotEmpty) ||
        (collectionSubtitle != null && collectionSubtitle.trim().isNotEmpty),
  );
  final previewMode = effectiveProps['preview_mode']
      ?.toString()
      .trim()
      .toLowerCase();
  final lazyPreview = coerceBoolValue(
    effectiveProps['lazy_preview'] ?? effectiveProps['defer_preview'],
    fallback: true,
  );
  final visibilityThreshold =
      (coerceDouble(
                effectiveProps['preview_visibility_threshold'] ??
                    effectiveProps['visibility_threshold'],
              ) ??
              0.18)
          .clamp(0.0, 1.0);
  final crossAxisCount =
      coerceOptionalInt(
        effectiveProps['cross_axis_count'] ??
            effectiveProps['crossAxisCount'] ??
            effectiveProps['columns'],
      ) ??
      3;
  final mainAxisSpacing =
      coerceDouble(
        effectiveProps['main_axis_spacing'] ??
            effectiveProps['mainAxisSpacing'] ??
            effectiveProps['spacing'],
      ) ??
      8.0;
  final crossAxisSpacing =
      coerceDouble(
        effectiveProps['cross_axis_spacing'] ??
            effectiveProps['crossAxisSpacing'],
      ) ??
      8.0;
  final itemBorderRadius =
      coerceDouble(
        effectiveProps['item_border_radius'] ??
            effectiveProps['itemBorderRadius'] ??
            effectiveProps['radius'],
      ) ??
      8.0;
  final showSelections = coerceBoolValue(
    effectiveProps['show_selections'] ??
        effectiveProps['showSelections'] ??
        effectiveProps['showSelection'],
    fallback: true,
  );
  final isLoading = coerceBoolValue(
    effectiveProps['is_loading'] ??
        effectiveProps['isLoading'] ??
        effectiveProps['loading'],
    fallback: false,
  );
  final showActions = coerceBoolValue(
    effectiveProps['show_actions'] ?? effectiveProps['showActions'],
    fallback: true,
  );
  final showMeta = coerceBoolValue(
    effectiveProps['show_meta'] ?? effectiveProps['showMeta'],
    fallback: true,
  );
  final selectionMode =
      effectiveProps['selection_mode']?.toString() ??
      effectiveProps['selectionMode']?.toString() ??
      (effectiveProps['multiSelect'] == true ? 'multi' : 'none');
  final itemStyle =
      effectiveProps['item_style']?.toString() ??
      effectiveProps['itemStyle']?.toString() ??
      'card';
  final enableReorder = coerceBoolValue(
    effectiveProps['enable_reorder'] ?? effectiveProps['enableReorder'],
    fallback: false,
  );
  final enableDrag = coerceBoolValue(
    effectiveProps['enable_drag'] ?? effectiveProps['enableDrag'],
    fallback: false,
  );
  final shrinkWrap = coerceBoolValue(
    effectiveProps['shrink_wrap'] ?? effectiveProps['shrinkWrap'],
    fallback: false,
  );
  final physics = effectiveProps['physics']?.toString();
  final carouselHeight = coerceDouble(
    effectiveProps['carousel_height'] ??
        effectiveProps['carouselHeight'] ??
        (layout == GalleryLayoutType.carousel
            ? effectiveProps['height']
            : null),
  );
  final carouselAspectRatio =
      coerceDouble(
        effectiveProps['carousel_aspect_ratio'] ??
            effectiveProps['carouselAspectRatio'] ??
            effectiveProps['item_aspect_ratio'] ??
            effectiveProps['itemAspectRatio'],
      ) ??
      (16 / 9);
  final carouselViewportFraction =
      (coerceDouble(
                effectiveProps['carousel_viewport_fraction'] ??
                    effectiveProps['carouselViewportFraction'] ??
                    effectiveProps['viewport_fraction'] ??
                    effectiveProps['viewportFraction'],
              ) ??
              1.0)
          .clamp(0.2, 1.0)
          .toDouble();
  final carouselPadEnds = coerceBoolValue(
    effectiveProps['carousel_pad_ends'] ?? effectiveProps['carouselPadEnds'],
    fallback: true,
  );
  final carouselPageSnapping = coerceBoolValue(
    effectiveProps['carousel_page_snapping'] ??
        effectiveProps['carouselPageSnapping'],
    fallback: true,
  );
  final carouselInitialPage =
      coerceOptionalInt(
        effectiveProps['carousel_initial_page'] ??
            effectiveProps['carouselInitialPage'],
      ) ??
      0;
  final carouselOverlayOpacity =
      (coerceDouble(
                effectiveProps['carousel_overlay_opacity'] ??
                    effectiveProps['carouselOverlayOpacity'],
              ) ??
              0.7)
          .clamp(0.0, 1.0)
          .toDouble();
  final carouselHorizontalInset =
      coerceDouble(
        effectiveProps['carousel_horizontal_inset'] ??
            effectiveProps['carouselHorizontalInset'],
      ) ??
      16.0;
  final carouselVerticalInset =
      coerceDouble(
        effectiveProps['carousel_vertical_inset'] ??
            effectiveProps['carouselVerticalInset'],
      ) ??
      8.0;

  final useControlWidgets = coerceBoolValue(
    effectiveProps['use_control_widgets'] ??
        effectiveProps['use_control_layouts'] ??
        effectiveProps['use_controls'],
    fallback: false,
  );
  final useControlLayouts = coerceBoolValue(
    effectiveProps['use_control_layouts'] ??
        effectiveProps['use_control_widgets'],
    fallback: false,
  );
  final autoplayVisibleMedia = coerceBoolValue(
    effectiveProps['autoplay_visible_media'] ??
        effectiveProps['autoplay_preview_media'],
    fallback: layout == GalleryLayoutType.carousel || previewMode == 'detail',
  );
  final rawActions =
      effectiveProps['actions'] ?? effectiveProps['toolbar_actions'];
  final toolbarActions = rawActions is List
      ? rawActions
            .whereType<Map>()
            .map((action) => coerceObjectMap(action))
            .toList()
      : <Map<String, Object?>>[];

  final effectiveShowMeta = switch (previewMode) {
    'minimal' || 'media_only' => false,
    'detail' || 'detail_pane' => true,
    _ => showMeta,
  };
  final effectiveShowActions = switch (previewMode) {
    'minimal' || 'media_only' => false,
    'picker' => true,
    _ => showActions,
  };
  final emptyTitle =
      effectiveProps['empty_title']?.toString() ??
      (filterTags.isNotEmpty ? 'No matching items' : 'No items in gallery');
  final emptyMessage =
      effectiveProps['empty_message']?.toString() ??
      (filterTags.isNotEmpty
          ? 'Try different tags or remove the current filter.'
          : 'Add some items to get started');
  final paletteAccents = coerceBoolValue(
    effectiveProps['palette_accents'] ?? effectiveProps['extract_palette'],
    fallback: showcase,
  );
  final paletteStrength =
      (coerceDouble(effectiveProps['palette_strength']) ?? 0.85).clamp(
        0.0,
        1.0,
      );
  final runtimeConfig = _GalleryRuntimeConfig(
    lazyPreview: lazyPreview,
    visibilityThreshold: visibilityThreshold,
    autoplayVisibleMedia: autoplayVisibleMedia,
    paletteAccents: paletteAccents,
    paletteStrength: paletteStrength,
  );

  final layoutWidget = _buildGalleryLayout(
    controlId: controlId,
    tokens: tokens,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    layout: layout,
    items: items,
    crossAxisCount: crossAxisCount,
    mainAxisSpacing: mainAxisSpacing,
    crossAxisSpacing: crossAxisSpacing,
    itemBorderRadius: itemBorderRadius,
    showSelections: showSelections,
    showActions: effectiveShowActions,
    showMeta: effectiveShowMeta,
    selectionMode: selectionMode,
    itemStyle: itemStyle,
    enableReorder: enableReorder,
    enableDrag: enableDrag,
    useControlWidgets: useControlWidgets,
    useControlLayouts: useControlLayouts,
    shrinkWrap: shrinkWrap,
    physics: _parseScrollPhysics(physics),
    carouselHeight: carouselHeight,
    carouselAspectRatio: carouselAspectRatio,
    carouselViewportFraction: carouselViewportFraction,
    carouselPadEnds: carouselPadEnds,
    carouselPageSnapping: carouselPageSnapping,
    carouselInitialPage: carouselInitialPage,
    carouselOverlayOpacity: carouselOverlayOpacity,
    carouselHorizontalInset: carouselHorizontalInset,
    carouselVerticalInset: carouselVerticalInset,
  );
  final toolbarWidget = toolbarActions.isEmpty
      ? null
      : _buildGalleryToolbar(
          controlId: controlId,
          actions: toolbarActions,
          tokens: tokens,
          buildChild: buildChild,
          registerInvokeHandler: registerInvokeHandler,
          unregisterInvokeHandler: unregisterInvokeHandler,
          sendEvent: sendEvent,
        );
  final contentChildren = <Map<String, Object?>>[];
  final hasHeader =
      (collectionName != null && collectionName.trim().isNotEmpty) ||
      (collectionSubtitle != null && collectionSubtitle.trim().isNotEmpty);
  if (hasHeader) {
    contentChildren.add({'type': '__gallery_header', 'props': {}});
  }
  if (toolbarWidget != null) {
    contentChildren.add({'type': '__gallery_toolbar', 'props': {}});
  }
  contentChildren.add({'type': '__gallery_layout', 'props': {}});

  final content = buildColumnControl(
    _galleryControlId(controlId, 'content_column'),
    {'spacing': mainAxisSpacing},
    contentChildren,
    tokens,
    (child) {
      final type = child['type']?.toString();
      if (type == '__gallery_header') {
        return _buildGalleryHeader(
          title: collectionName ?? 'Gallery',
          subtitle: collectionSubtitle,
          itemCount: items.length,
          showcase: showcase,
        );
      }
      if (type == '__gallery_toolbar') {
        return toolbarWidget ?? const SizedBox.shrink();
      }
      if (type == '__gallery_layout') {
        return layoutWidget;
      }
      return buildChild(child);
    },
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );

  final containerChildren = rawChildren.isEmpty
      ? [
          {'type': '__gallery_content', 'props': {}},
        ]
      : rawChildren;

  final galleryContainer = buildContainerControl(
    controlId,
    effectiveProps,
    containerChildren,
    (childProps) {
      final childType = childProps['type']?.toString();
      if (childType != '__gallery_content') {
        return buildChild(childProps);
      }
      if (isLoading) {
        return _buildGalleryProgressIndicator();
      }
      if (items.isEmpty) {
        return _buildGalleryEmptyState(
          icon: 'photo_library',
          title: emptyTitle,
          message: emptyMessage,
        );
      }
      return content;
    },
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
  return _GalleryConfigScope(
    config: runtimeConfig,
    child: _GalleryShowcasePaletteFrame(
      controlId: controlId,
      items: items,
      explicitSource: effectiveProps['palette_source'],
      enabled: paletteAccents,
      paletteStrength: paletteStrength,
      sendEvent: sendEvent,
      child: galleryContainer,
    ),
  );
}

Widget _buildGalleryLayout({
  required String controlId,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required GalleryLayoutType layout,
  required List<GalleryItem> items,
  required int crossAxisCount,
  required double mainAxisSpacing,
  required double crossAxisSpacing,
  required double itemBorderRadius,
  required bool showSelections,
  required bool showActions,
  required bool showMeta,
  required String selectionMode,
  required String itemStyle,
  required bool enableReorder,
  required bool enableDrag,
  required bool useControlWidgets,
  required bool useControlLayouts,
  required bool shrinkWrap,
  required double? carouselHeight,
  required double carouselAspectRatio,
  required double carouselViewportFraction,
  required bool carouselPadEnds,
  required bool carouselPageSnapping,
  required int carouselInitialPage,
  required double carouselOverlayOpacity,
  required double carouselHorizontalInset,
  required double carouselVerticalInset,
  ScrollPhysics? physics,
}) {
  switch (layout) {
    case GalleryLayoutType.masonry:
      return MasonryGridView.count(
        shrinkWrap: shrinkWrap,
        physics: physics,
        padding: EdgeInsets.all(mainAxisSpacing),
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildGalleryItem(
            controlId: controlId,
            item: item,
            borderRadius: itemBorderRadius,
            showSelection: showSelections,
            showActions: showActions,
            showMeta: showMeta,
            selectionMode: selectionMode,
            itemStyle: itemStyle,
            enableDrag: enableDrag,
            tokens: tokens,
            buildChild: buildChild,
            registerInvokeHandler: registerInvokeHandler,
            unregisterInvokeHandler: unregisterInvokeHandler,
            sendEvent: sendEvent,
            useControlWidgets: useControlWidgets,
          );
        },
      );
    case GalleryLayoutType.list:
      if (useControlLayouts) {
        final listChildren = items
            .map(
              (item) => {'type': '__gallery_list_item', 'props': item.toJson()},
            )
            .toList();
        return buildScrollViewControl(
          _galleryControlId(controlId, 'list_scroll'),
          {
            'direction': 'vertical',
            'content_padding': EdgeInsets.all(mainAxisSpacing),
          },
          [
            {
              'type': '__gallery_list_column',
              'props': {'spacing': mainAxisSpacing},
              'children': listChildren,
            },
          ],
          (child) {
            final type = child['type']?.toString();
            if (type == '__gallery_list_column') {
              final raw = child['children'];
              final childMaps = raw is List
                  ? raw.whereType<Map>().map(coerceObjectMap).toList()
                  : <Map<String, Object?>>[];
              return buildColumnControl(
                _galleryControlId(controlId, 'list_column'),
                {'spacing': mainAxisSpacing},
                childMaps,
                tokens,
                (columnChild) => _buildGalleryListItemFromControl(
                  controlId: controlId,
                  child: columnChild,
                  tokens: tokens,
                  buildChild: buildChild,
                  registerInvokeHandler: registerInvokeHandler,
                  unregisterInvokeHandler: unregisterInvokeHandler,
                  sendEvent: sendEvent,
                  showSelections: showSelections,
                  showActions: showActions,
                  showMeta: showMeta,
                  selectionMode: selectionMode,
                  itemStyle: itemStyle,
                  itemBorderRadius: itemBorderRadius,
                  useControlWidgets: useControlWidgets,
                ),
                registerInvokeHandler,
                unregisterInvokeHandler,
                sendEvent,
              );
            }
            return buildChild(child);
          },
          registerInvokeHandler,
          unregisterInvokeHandler,
          sendEvent,
        );
      }
      return ListView.separated(
        shrinkWrap: shrinkWrap,
        physics: physics,
        padding: EdgeInsets.all(mainAxisSpacing),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: mainAxisSpacing),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildGalleryListItem(
            controlId: controlId,
            item: item,
            showSelection: showSelections,
            showActions: showActions,
            showMeta: showMeta,
            selectionMode: selectionMode,
            itemStyle: itemStyle,
            itemBorderRadius: itemBorderRadius,
            tokens: tokens,
            buildChild: buildChild,
            registerInvokeHandler: registerInvokeHandler,
            unregisterInvokeHandler: unregisterInvokeHandler,
            sendEvent: sendEvent,
            useControlWidgets: useControlWidgets,
          );
        },
      );
    case GalleryLayoutType.carousel:
      final carousel = _GalleryCarouselPager(
        physics: physics,
        itemCount: items.length,
        viewportFraction: carouselViewportFraction,
        initialPage: carouselInitialPage,
        padEnds: carouselPadEnds,
        pageSnapping: carouselPageSnapping,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildGalleryCarouselItem(
            controlId: controlId,
            item: item,
            buildChild: buildChild,
            registerInvokeHandler: registerInvokeHandler,
            unregisterInvokeHandler: unregisterInvokeHandler,
            sendEvent: sendEvent,
            useControlWidgets: useControlWidgets,
            showMeta: showMeta,
            showActions: showActions,
            itemBorderRadius: itemBorderRadius,
            overlayOpacity: carouselOverlayOpacity,
            horizontalInset: carouselHorizontalInset,
            verticalInset: carouselVerticalInset,
          );
        },
      );
      if (carouselHeight != null && carouselHeight > 0) {
        return SizedBox(height: carouselHeight, child: carousel);
      }
      final resolvedAspectRatio = carouselAspectRatio <= 0
          ? (16 / 9)
          : carouselAspectRatio;
      if (shrinkWrap) {
        return AspectRatio(aspectRatio: resolvedAspectRatio, child: carousel);
      }
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.hasBoundedHeight &&
              constraints.maxHeight.isFinite &&
              constraints.maxHeight > 0) {
            return carousel;
          }
          final fallbackWidth =
              constraints.maxWidth.isFinite && constraints.maxWidth > 0
              ? constraints.maxWidth
              : 960.0;
          final fallbackHeight = (fallbackWidth / resolvedAspectRatio).clamp(
            220.0,
            560.0,
          );
          return SizedBox(height: fallbackHeight, child: carousel);
        },
      );
    case GalleryLayoutType.virtualGrid:
      return buildVirtualGridControl(
        _galleryControlId(controlId, 'virtual_grid'),
        {
          'columns': crossAxisCount,
          'spacing': mainAxisSpacing,
          'child_aspect_ratio': 1.0,
          'shrink_wrap': shrinkWrap,
          if (physics != null)
            'scrollable': physics is! NeverScrollableScrollPhysics,
        },
        items
            .map(
              (item) => {
                'id': item.id,
                'type': 'gallery_item',
                'props': item.toJson(),
              },
            )
            .toList(),
        (child) => _buildGalleryItemFromControl(
          controlId: controlId,
          child: child,
          tokens: tokens,
          buildChild: buildChild,
          registerInvokeHandler: registerInvokeHandler,
          unregisterInvokeHandler: unregisterInvokeHandler,
          sendEvent: sendEvent,
          itemBorderRadius: itemBorderRadius,
          showSelections: showSelections,
          showActions: showActions,
          showMeta: showMeta,
          selectionMode: selectionMode,
          itemStyle: itemStyle,
          enableDrag: enableDrag,
          useControlWidgets: useControlWidgets,
        ),
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    case GalleryLayoutType.virtualList:
      return buildVirtualListControl(
        _galleryControlId(controlId, 'virtual_list'),
        {
          'spacing': mainAxisSpacing,
          'item_extent': 80.0,
          'shrink_wrap': shrinkWrap,
          if (physics != null)
            'scrollable': physics is! NeverScrollableScrollPhysics,
        },
        items
            .map(
              (item) => {
                'id': item.id,
                'type': 'gallery_item',
                'props': item.toJson(),
              },
            )
            .toList(),
        (child) => _buildGalleryItemFromControl(
          controlId: controlId,
          child: child,
          tokens: tokens,
          buildChild: buildChild,
          registerInvokeHandler: registerInvokeHandler,
          unregisterInvokeHandler: unregisterInvokeHandler,
          sendEvent: sendEvent,
          itemBorderRadius: itemBorderRadius,
          showSelections: showSelections,
          showActions: showActions,
          showMeta: showMeta,
          selectionMode: selectionMode,
          itemStyle: itemStyle,
          enableDrag: enableDrag,
          useControlWidgets: useControlWidgets,
        ),
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    case GalleryLayoutType.grid:
      if (useControlLayouts) {
        final gridChildren = items
            .map(
              (item) => {'type': '__gallery_grid_item', 'props': item.toJson()},
            )
            .toList();
        return buildGridControl(
          _galleryControlId(controlId, 'grid'),
          {
            'columns': crossAxisCount,
            'spacing': mainAxisSpacing,
            'run_spacing': crossAxisSpacing,
            'child_aspect_ratio': 1.0,
            'content_padding': EdgeInsets.all(mainAxisSpacing),
            'shrink_wrap': shrinkWrap,
            if (physics != null)
              'scrollable': physics is! NeverScrollableScrollPhysics,
          },
          gridChildren,
          (child) => _buildGalleryItemFromControl(
            controlId: controlId,
            child: child,
            tokens: tokens,
            buildChild: buildChild,
            registerInvokeHandler: registerInvokeHandler,
            unregisterInvokeHandler: unregisterInvokeHandler,
            sendEvent: sendEvent,
            itemBorderRadius: itemBorderRadius,
            showSelections: showSelections,
            showActions: showActions,
            showMeta: showMeta,
            selectionMode: selectionMode,
            itemStyle: itemStyle,
            enableDrag: enableDrag,
            useControlWidgets: useControlWidgets,
          ),
          registerInvokeHandler,
          unregisterInvokeHandler,
          sendEvent,
        );
      }
      return GridView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics,
        padding: EdgeInsets.all(mainAxisSpacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildGalleryItem(
            controlId: controlId,
            item: item,
            borderRadius: itemBorderRadius,
            showSelection: showSelections,
            showActions: showActions,
            showMeta: showMeta,
            selectionMode: selectionMode,
            itemStyle: itemStyle,
            enableDrag: enableDrag,
            tokens: tokens,
            buildChild: buildChild,
            registerInvokeHandler: registerInvokeHandler,
            unregisterInvokeHandler: unregisterInvokeHandler,
            sendEvent: sendEvent,
            useControlWidgets: useControlWidgets,
          );
        },
      );
  }
}

// ============================================================================
// Gallery Item Builder - Uses existing controls
// ============================================================================

Widget _buildGalleryItem({
  required String controlId,
  required GalleryItem item,
  required double borderRadius,
  required bool showSelection,
  required bool showActions,
  required bool showMeta,
  required String selectionMode,
  required String itemStyle,
  required bool enableDrag,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
}) {
  switch (itemStyle) {
    case 'tile':
      return _buildTileItem(
        controlId: controlId,
        item: item,
        borderRadius: borderRadius,
        showSelection: showSelection,
        showActions: showActions,
        showMeta: showMeta,
        selectionMode: selectionMode,
        tokens: tokens,
        buildChild: buildChild,
        registerInvokeHandler: registerInvokeHandler,
        unregisterInvokeHandler: unregisterInvokeHandler,
        sendEvent: sendEvent,
        useControlWidgets: useControlWidgets,
      );
    case 'compact':
      return _buildCompactItem(
        controlId: controlId,
        item: item,
        showSelection: showSelection,
        selectionMode: selectionMode,
        registerInvokeHandler: registerInvokeHandler,
        unregisterInvokeHandler: unregisterInvokeHandler,
        sendEvent: sendEvent,
      );
    case 'list':
      return _buildListItem(
        controlId: controlId,
        item: item,
        showSelection: showSelection,
        showActions: showActions,
        showMeta: showMeta,
        selectionMode: selectionMode,
        itemBorderRadius: borderRadius,
        tokens: tokens,
        buildChild: buildChild,
        registerInvokeHandler: registerInvokeHandler,
        unregisterInvokeHandler: unregisterInvokeHandler,
        sendEvent: sendEvent,
        useControlWidgets: useControlWidgets,
      );
    case 'card':
    default:
      return _buildCardItem(
        controlId: controlId,
        item: item,
        borderRadius: borderRadius,
        showSelection: showSelection,
        showActions: showActions,
        showMeta: showMeta,
        selectionMode: selectionMode,
        enableDrag: enableDrag,
        tokens: tokens,
        buildChild: buildChild,
        registerInvokeHandler: registerInvokeHandler,
        unregisterInvokeHandler: unregisterInvokeHandler,
        sendEvent: sendEvent,
        useControlWidgets: useControlWidgets,
      );
  }
}

// ============================================================================
// Card Style Item - Uses Card, Stack, Column, Row controls
// ============================================================================

Widget _buildCardItem({
  required String controlId,
  required GalleryItem item,
  required double borderRadius,
  required bool showSelection,
  required bool showActions,
  required bool showMeta,
  required String selectionMode,
  required bool enableDrag,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
}) {
  const selectedColor = Color(0xFF2196F3);
  const hoverColor = Color(0x1A000000);
  const selectionColor = Color(0x332196F3);

  bool isHovered = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: () {},
          child: buildCardControl(
            _galleryControlId(controlId, 'card_${item.id}'),
            {
              'radius': borderRadius,
              'elevation': isHovered ? 4 : 1,
              'bgcolor': showSelection && item.isSelected
                  ? selectionColor
                  : null,
              'border_color': showSelection && item.isSelected
                  ? selectedColor
                  : null,
              'border_width': showSelection && item.isSelected ? 2 : 0,
            },
            [
              {'type': '__gallery_card_stack', 'props': {}},
              if (showMeta) {'type': '__gallery_card_meta', 'props': {}},
            ],
            tokens,
            (child) {
              final type = child['type']?.toString();
              if (type == '__gallery_card_stack') {
                return buildStackControl(
                  {},
                  [
                    {'type': '__gallery_card_preview', 'props': {}},
                    if (isHovered)
                      {
                        'type': '__gallery_card_hover',
                        'frame': {'top': 0, 'left': 0, 'right': 0, 'bottom': 0},
                      },
                    if (showSelection && item.isSelected)
                      {
                        'type': '__gallery_card_selected',
                        'frame': {'top': 8, 'left': 8},
                      },
                    if (item.status != null)
                      {
                        'type': '__gallery_card_status',
                        'props': {'label': item.status},
                        'frame': {'top': 8, 'right': 8},
                      },
                    if (isHovered && showActions)
                      {
                        'type': '__gallery_card_actions',
                        'frame': {'bottom': 8, 'left': 8, 'right': 8},
                      },
                  ],
                  (stackChild) {
                    final stackType = stackChild['type']?.toString();
                    if (stackType == '__gallery_card_preview') {
                      return _buildGalleryPreviewWrapper(
                        controlId: controlId,
                        item: item,
                        borderRadius: borderRadius,
                        buildChild: buildChild,
                        registerInvokeHandler: registerInvokeHandler,
                        unregisterInvokeHandler: unregisterInvokeHandler,
                        sendEvent: sendEvent,
                        useControlWidgets: useControlWidgets,
                      );
                    }
                    if (stackType == '__gallery_card_hover') {
                      return buildContainerControl(
                        _galleryControlId(controlId, 'card_hover_${item.id}'),
                        {'bgcolor': hoverColor},
                        const [],
                        buildChild,
                        registerInvokeHandler,
                        unregisterInvokeHandler,
                        sendEvent,
                      );
                    }
                    if (stackType == '__gallery_card_selected') {
                      return buildContainerControl(
                        _galleryControlId(
                          controlId,
                          'card_selected_${item.id}',
                        ),
                        {'bgcolor': selectedColor, 'radius': 12, 'padding': 4},
                        [
                          {'type': '__gallery_check_icon', 'props': {}},
                        ],
                        (iconChild) {
                          final iconType = iconChild['type']?.toString();
                          if (iconType == '__gallery_check_icon') {
                            return buildIconControl(Icons.check, {
                              'color': Colors.white,
                              'size': 16,
                            });
                          }
                          return buildChild(iconChild);
                        },
                        registerInvokeHandler,
                        unregisterInvokeHandler,
                        sendEvent,
                      );
                    }
                    if (stackType == '__gallery_card_status') {
                      final rawProps = stackChild['props'];
                      final props = rawProps is Map
                          ? coerceObjectMap(rawProps)
                          : <String, Object?>{};
                      final label = props['label']?.toString();
                      return buildBadgeControl(
                        _galleryControlId(controlId, 'status_${item.id}'),
                        {'label': label, 'color': _getStatusColor(label ?? '')},
                        const [],
                        buildChild,
                        registerInvokeHandler,
                        unregisterInvokeHandler,
                        sendEvent,
                      );
                    }
                    if (stackType == '__gallery_card_actions') {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildIconButtonControl(
                            _galleryControlId(controlId, 'favorite_${item.id}'),
                            {
                              'icon': 'favorite_border',
                              'size': 32,
                              'bgcolor': Colors.black54,
                            },
                            registerInvokeHandler,
                            unregisterInvokeHandler,
                            tokens,
                            sendEvent,
                          ),
                          const SizedBox(width: 8),
                          buildIconButtonControl(
                            _galleryControlId(controlId, 'share_${item.id}'),
                            {
                              'icon': 'share',
                              'size': 32,
                              'bgcolor': Colors.black54,
                            },
                            registerInvokeHandler,
                            unregisterInvokeHandler,
                            tokens,
                            sendEvent,
                          ),
                          const SizedBox(width: 8),
                          buildIconButtonControl(
                            _galleryControlId(controlId, 'more_${item.id}'),
                            {
                              'icon': 'more_vert',
                              'size': 32,
                              'bgcolor': Colors.black54,
                            },
                            registerInvokeHandler,
                            unregisterInvokeHandler,
                            tokens,
                            sendEvent,
                          ),
                        ],
                      );
                    }
                    return buildChild(stackChild);
                  },
                );
              }
              if (type == '__gallery_card_meta') {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? 'Untitled',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (item.subtitle != null)
                        Text(
                          item.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (item.authorName != null)
                            Row(
                              children: [
                                buildAvatarControl(
                                  _galleryControlId(
                                    controlId,
                                    'avatar_${item.id}',
                                  ),
                                  {'src': item.authorAvatar, 'size': 16},
                                  sendEvent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.authorName!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          if (item.viewCount != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  buildIconControl(Icons.visibility, {
                                    'size': 14,
                                    'color': Colors.grey,
                                  }),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatCount(item.viewCount!),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return buildChild(child);
            },
            registerInvokeHandler,
            unregisterInvokeHandler,
            sendEvent,
          ),
        ),
      );
    },
  );
}

// ============================================================================
// Tile Style Item
// ============================================================================

Widget _buildTileItem({
  required String controlId,
  required GalleryItem item,
  required double borderRadius,
  required bool showSelection,
  required bool showActions,
  required bool showMeta,
  required String selectionMode,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
}) {
  const selectedColor = Color(0xFF2196F3);
  final resolvedSelectedColor = tokens.color('primary') ?? selectedColor;
  final resolvedRadius = borderRadius <= 0 ? 6.0 : borderRadius;

  if (useControlWidgets) {
    return GestureDetector(
      child: buildStackControl(
        {},
        [
          {'type': '__gallery_tile_preview', 'props': {}},
          if (showSelection && item.isSelected)
            {
              'type': '__gallery_tile_selected',
              'frame': {'top': 0, 'left': 0, 'right': 0, 'bottom': 0},
            },
          if (showMeta)
            {
              'type': '__gallery_tile_meta',
              'frame': {'left': 0, 'right': 0, 'bottom': 0},
            },
          if (showActions)
            {
              'type': '__gallery_tile_actions',
              'frame': {'top': 8, 'right': 8},
            },
        ],
        (child) {
          final type = child['type']?.toString();
          if (type == '__gallery_tile_preview') {
            return buildClipControl(
              {'radius': resolvedRadius},
              [
                {'type': '__gallery_preview', 'props': item.toJson()},
              ],
              (previewChild) => _buildGalleryPreviewFromControl(
                controlId: controlId,
                child: previewChild,
                buildChild: buildChild,
                registerInvokeHandler: registerInvokeHandler,
                unregisterInvokeHandler: unregisterInvokeHandler,
                sendEvent: sendEvent,
                useControlWidgets: useControlWidgets,
              ),
            );
          }
          if (type == '__gallery_tile_selected') {
            return buildContainerControl(
              _galleryControlId(controlId, 'tile_selected_${item.id}'),
              {
                'bgcolor': resolvedSelectedColor.withOpacity(0.3),
                'radius': resolvedRadius,
                'border_color': resolvedSelectedColor,
                'border_width': 3,
              },
              [
                {'type': '__gallery_tile_check', 'props': {}},
              ],
              (iconChild) {
                if (iconChild['type']?.toString() == '__gallery_tile_check') {
                  return Center(
                    child: buildIconControl(Icons.check_circle, {
                      'color': Colors.white,
                      'size': 32,
                    }),
                  );
                }
                return buildChild(iconChild);
              },
              registerInvokeHandler,
              unregisterInvokeHandler,
              sendEvent,
            );
          }
          if (type == '__gallery_tile_meta') {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.name != null)
                    Text(
                      item.name!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            );
          }
          if (type == '__gallery_tile_actions') {
            if (item.likeCount == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildIconControl(Icons.favorite, {
                    'color': Colors.white,
                    'size': 14,
                  }),
                  const SizedBox(width: 4),
                  Text(
                    _formatCount(item.likeCount!),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            );
          }
          return buildChild(child);
        },
      ),
    );
  }

  return GestureDetector(
    child: Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(resolvedRadius),
            child: _buildPreview(
              controlId: controlId,
              item: item,
              buildChild: buildChild,
              registerInvokeHandler: registerInvokeHandler,
              unregisterInvokeHandler: unregisterInvokeHandler,
              sendEvent: sendEvent,
              useControlWidgets: useControlWidgets,
            ),
          ),
        ),
        if (showSelection && item.isSelected)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(resolvedRadius),
                color: resolvedSelectedColor.withOpacity(0.3),
                border: Border.all(color: resolvedSelectedColor, width: 3),
              ),
              child: const Center(
                child: Icon(Icons.check_circle, color: Colors.white, size: 32),
              ),
            ),
          ),
        if (showMeta)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.name != null)
                    Text(
                      item.name!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        if (showActions)
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.likeCount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatCount(item.likeCount!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );
}

// ============================================================================
// Compact Style Item - Uses ListTile control
// ============================================================================

Widget _buildCompactItem({
  required String controlId,
  required GalleryItem item,
  required bool showSelection,
  required String selectionMode,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  return buildListTileControl(
    _galleryControlId(controlId, 'list_tile_${item.id}'),
    {
      'leading': item.thumbnailUrl ?? item.url ?? item.path,
      'title': item.name ?? 'Untitled',
      'subtitle': item.subtitle ?? item.type,
      'selected': item.isSelected,
      'dense': true,
    },
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}

// ============================================================================
// List Style Item
// ============================================================================

Widget _buildListItem({
  required String controlId,
  required GalleryItem item,
  required bool showSelection,
  required bool showActions,
  required bool showMeta,
  required String selectionMode,
  required double itemBorderRadius,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
}) {
  const selectedColor = Color(0xFF2196F3);
  final resolvedSelectedColor = tokens.color('primary') ?? selectedColor;
  final resolvedRadius = itemBorderRadius <= 0 ? 6.0 : itemBorderRadius;

  if (useControlWidgets) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: showSelection && item.isSelected
            ? Border.all(color: resolvedSelectedColor, width: 2)
            : null,
        color: showSelection && item.isSelected
            ? resolvedSelectedColor.withOpacity(0.1)
            : Colors.grey[100],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: buildClipControl(
                {'radius': resolvedRadius},
                [
                  {'type': '__gallery_preview', 'props': item.toJson()},
                ],
                (previewChild) => _buildGalleryPreviewFromControl(
                  controlId: controlId,
                  child: previewChild,
                  buildChild: buildChild,
                  registerInvokeHandler: registerInvokeHandler,
                  unregisterInvokeHandler: unregisterInvokeHandler,
                  sendEvent: sendEvent,
                  useControlWidgets: useControlWidgets,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? 'Untitled',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  if (showMeta)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          if (item.authorName != null)
                            Text(
                              item.authorName!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          if (item.createdAt != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                item.createdAt!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (showActions)
              Column(
                children: [
                  buildIconButtonControl(
                    _galleryControlId(controlId, 'list_like_${item.id}'),
                    {'icon': 'favorite_border', 'size': 20},
                    registerInvokeHandler,
                    unregisterInvokeHandler,
                    tokens,
                    sendEvent,
                  ),
                  buildIconButtonControl(
                    _galleryControlId(controlId, 'list_share_${item.id}'),
                    {'icon': 'share', 'size': 20},
                    registerInvokeHandler,
                    unregisterInvokeHandler,
                    tokens,
                    sendEvent,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: showSelection && item.isSelected
          ? Border.all(color: selectedColor, width: 2)
          : null,
      color: showSelection && item.isSelected
          ? selectedColor.withOpacity(0.1)
          : Colors.grey[100],
    ),
    child: buildRowControl(
      _galleryControlId(controlId, 'list_row_${item.id}'),
      {'spacing': 12, 'padding': 12},
      [
        {
          'type': 'clip',
          'props': {'radius': resolvedRadius},
          'children': [
            {
              'type': 'container',
              'props': {'width': 80, 'height': 80},
              'children': [
                _buildPreview(
                  controlId: controlId,
                  item: item,
                  buildChild: buildChild,
                  registerInvokeHandler: registerInvokeHandler,
                  unregisterInvokeHandler: unregisterInvokeHandler,
                  sendEvent: sendEvent,
                  useControlWidgets: useControlWidgets,
                ),
              ],
            },
          ],
        },
        {
          'type': 'column',
          'props': {'spacing': 4, 'main_axis': 'center'},
          'children': [
            {
              'type': 'text',
              'props': {
                'value': item.name ?? 'Untitled',
                'font_weight': 'w600',
                'max_lines': 1,
                'overflow': 'ellipsis',
              },
            },
            if (item.subtitle != null)
              {
                'type': 'text',
                'props': {
                  'value': item.subtitle,
                  'max_lines': 1,
                  'overflow': 'ellipsis',
                  'color': Colors.grey,
                },
              },
            if (showMeta)
              {
                'type': 'row',
                'props': {'spacing': 12},
                'children': [
                  if (item.authorName != null)
                    {
                      'type': 'text',
                      'props': {
                        'value': item.authorName,
                        'font_size': 12,
                        'color': Colors.grey,
                      },
                    },
                  if (item.createdAt != null)
                    {
                      'type': 'text',
                      'props': {
                        'value': item.createdAt,
                        'font_size': 12,
                        'color': Colors.grey,
                      },
                    },
                ],
              },
          ],
        },
        if (showActions)
          {
            'type': 'column',
            'props': {'spacing': 4},
            'children': [
              {
                'type': 'icon_button',
                'props': {'icon': 'favorite_border', 'size': 20},
              },
              {
                'type': 'icon_button',
                'props': {'icon': 'share', 'size': 20},
              },
            ],
          },
      ],
      tokens,
      buildChild,
      registerInvokeHandler,
      unregisterInvokeHandler,
      sendEvent,
    ),
  );
}

// ============================================================================
// Gallery List Item (for list view)
// ============================================================================

Widget _buildGalleryListItem({
  required String controlId,
  required GalleryItem item,
  required bool showSelection,
  required bool showActions,
  required bool showMeta,
  required String selectionMode,
  required String itemStyle,
  required double itemBorderRadius,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
}) {
  const selectedColor = Color(0xFF2196F3);

  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: showSelection && item.isSelected
          ? Border.all(color: selectedColor, width: 2)
          : null,
      color: showSelection && item.isSelected
          ? selectedColor.withOpacity(0.1)
          : Colors.grey[100],
    ),
    child: Row(
      children: [
        if (showSelection && selectionMode != 'none')
          Checkbox(value: item.isSelected, onChanged: (_) {}),
        SizedBox(
          width: 64,
          height: 64,
          child: buildClipControl(
            {'radius': itemBorderRadius <= 0 ? 6.0 : itemBorderRadius},
            [
              {'type': '__gallery_preview', 'props': item.toJson()},
            ],
            (previewChild) => _buildGalleryPreviewFromControl(
              controlId: controlId,
              child: previewChild,
              buildChild: buildChild,
              registerInvokeHandler: registerInvokeHandler,
              unregisterInvokeHandler: unregisterInvokeHandler,
              sendEvent: sendEvent,
              useControlWidgets: useControlWidgets,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? 'Untitled',
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.subtitle != null)
                Text(
                  item.subtitle!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (showMeta)
                Row(
                  children: [
                    if (item.authorName != null) ...[
                      Text(
                        item.authorName!,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (item.viewCount != null) ...[
                      buildIconControl(Icons.visibility, {
                        'size': 12,
                        'color': Colors.grey[600],
                      }),
                      const SizedBox(width: 2),
                      Text(
                        _formatCount(item.viewCount!),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
        if (showActions)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildIconButtonControl(
                _galleryControlId(controlId, 'list_like_${item.id}'),
                {'icon': 'favorite_border', 'size': 20},
                registerInvokeHandler,
                unregisterInvokeHandler,
                tokens,
                sendEvent,
              ),
              buildIconButtonControl(
                _galleryControlId(controlId, 'list_share_${item.id}'),
                {'icon': 'share', 'size': 20},
                registerInvokeHandler,
                unregisterInvokeHandler,
                tokens,
                sendEvent,
              ),
              buildIconButtonControl(
                _galleryControlId(controlId, 'list_more_${item.id}'),
                {'icon': 'more_vert', 'size': 20},
                registerInvokeHandler,
                unregisterInvokeHandler,
                tokens,
                sendEvent,
              ),
            ],
          ),
      ],
    ),
  );
}

// ============================================================================
// Carousel Tile
// ============================================================================

Widget _buildGalleryCarouselTile({
  required String controlId,
  required GalleryItem item,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
  required bool showMeta,
  required bool showActions,
  required double itemBorderRadius,
  required double overlayOpacity,
  required double horizontalInset,
  required double verticalInset,
}) {
  final resolvedRadius = itemBorderRadius <= 0 ? 16.0 : itemBorderRadius;
  final resolvedHorizontalInset = horizontalInset < 0 ? 0.0 : horizontalInset;
  final resolvedVerticalInset = verticalInset < 0 ? 0.0 : verticalInset;
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: resolvedHorizontalInset,
      vertical: resolvedVerticalInset,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(resolvedRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildPreview(
            controlId: controlId,
            item: item,
            buildChild: buildChild,
            registerInvokeHandler: registerInvokeHandler,
            unregisterInvokeHandler: unregisterInvokeHandler,
            sendEvent: sendEvent,
            useControlWidgets: useControlWidgets,
          ),
          if (showMeta)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(overlayOpacity),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.name != null)
                      Text(
                        item.name!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    if (item.subtitle != null)
                      Text(
                        item.subtitle!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
            ),
          if (showActions && item.likeCount != null)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      _formatCount(item.likeCount!),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildGalleryCarouselItem({
  required String controlId,
  required GalleryItem item,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
  required bool showMeta,
  required bool showActions,
  required double itemBorderRadius,
  required double overlayOpacity,
  required double horizontalInset,
  required double verticalInset,
}) {
  return _buildGalleryCarouselTile(
    controlId: controlId,
    item: item,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    useControlWidgets: useControlWidgets,
    showMeta: showMeta,
    showActions: showActions,
    itemBorderRadius: itemBorderRadius,
    overlayOpacity: overlayOpacity,
    horizontalInset: horizontalInset,
    verticalInset: verticalInset,
  );
}

String _galleryControlId(String base, String suffix) {
  if (base.isEmpty) return '';
  return '$base::$suffix';
}

Widget _buildGalleryItemFromControl({
  required String controlId,
  required Map<String, Object?> child,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required double itemBorderRadius,
  required bool showSelections,
  required bool showActions,
  required bool showMeta,
  required String selectionMode,
  required String itemStyle,
  required bool enableDrag,
  required bool useControlWidgets,
}) {
  final childType = child['type']?.toString();
  const galleryItemTypes = <String>{
    'gallery_item',
    '__gallery_grid_item',
    '__gallery_virtual_item',
  };
  if (!galleryItemTypes.contains(childType)) {
    return buildChild(child);
  }
  final rawProps = child['props'];
  final props = rawProps is Map
      ? coerceObjectMap(rawProps)
      : <String, Object?>{};
  final item = GalleryItem.fromJson(Map<String, dynamic>.from(props));
  return _buildGalleryItem(
    controlId: controlId,
    item: item,
    borderRadius: itemBorderRadius,
    showSelection: showSelections,
    showActions: showActions,
    showMeta: showMeta,
    selectionMode: selectionMode,
    itemStyle: itemStyle,
    enableDrag: enableDrag,
    tokens: tokens,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    useControlWidgets: useControlWidgets,
  );
}

Widget _buildGalleryListItemFromControl({
  required String controlId,
  required Map<String, Object?> child,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool showSelections,
  required bool showActions,
  required bool showMeta,
  required String selectionMode,
  required String itemStyle,
  required double itemBorderRadius,
  required bool useControlWidgets,
}) {
  final childType = child['type']?.toString();
  if (childType != '__gallery_list_item') {
    return buildChild(child);
  }
  final rawProps = child['props'];
  final props = rawProps is Map
      ? coerceObjectMap(rawProps)
      : <String, Object?>{};
  final item = GalleryItem.fromJson(Map<String, dynamic>.from(props));
  return _buildGalleryListItem(
    controlId: controlId,
    item: item,
    showSelection: showSelections,
    showActions: showActions,
    showMeta: showMeta,
    selectionMode: selectionMode,
    itemStyle: itemStyle,
    itemBorderRadius: itemBorderRadius,
    tokens: tokens,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    useControlWidgets: useControlWidgets,
  );
}

Widget _buildGalleryPreviewFromControl({
  required String controlId,
  required Map<String, Object?> child,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
}) {
  final type = child['type']?.toString();
  if (type != '__gallery_preview') {
    return buildChild(child);
  }
  final rawProps = child['props'];
  final props = rawProps is Map
      ? coerceObjectMap(rawProps)
      : <String, Object?>{};
  final item = GalleryItem.fromJson(Map<String, dynamic>.from(props));
  return _buildPreview(
    controlId: controlId,
    item: item,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    useControlWidgets: useControlWidgets,
  );
}

Widget _buildGalleryPreviewWrapper({
  required String controlId,
  required GalleryItem item,
  required double borderRadius,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
}) {
  return buildAspectRatioControl(
    _galleryControlId(controlId, 'preview_ratio_${item.id}'),
    {'ratio': item.aspectRatio ?? 1.0},
    [
      {
        'type': '__gallery_clip',
        'props': {'radius': borderRadius},
        'children': [
          {'type': '__gallery_preview', 'props': item.toJson()},
        ],
      },
    ],
    (child) {
      final type = child['type']?.toString();
      if (type == '__gallery_clip') {
        final rawChildren = child['children'];
        final children = rawChildren is List
            ? rawChildren.whereType<Map>().map(coerceObjectMap).toList()
            : <Map<String, Object?>>[];
        return buildClipControl(
          {'radius': borderRadius},
          children,
          (clipChild) => _buildGalleryPreviewFromControl(
            controlId: controlId,
            child: clipChild,
            buildChild: buildChild,
            registerInvokeHandler: registerInvokeHandler,
            unregisterInvokeHandler: unregisterInvokeHandler,
            sendEvent: sendEvent,
            useControlWidgets: useControlWidgets,
          ),
        );
      }
      return buildChild(child);
    },
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}

Widget _buildGalleryToolbar({
  required String controlId,
  required List<Map<String, Object?>> actions,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  final children = actions
      .map((action) => {'type': '__gallery_action', 'props': action})
      .toList();
  return buildRowControl(
    _galleryControlId(controlId, 'toolbar'),
    {'spacing': 8, 'main_axis': 'end'},
    children,
    tokens,
    (child) {
      final type = child['type']?.toString();
      if (type == '__gallery_action') {
        final rawProps = child['props'];
        final props = rawProps is Map
            ? coerceObjectMap(rawProps)
            : <String, Object?>{};
        return _buildGalleryActionButton(
          controlId: controlId,
          action: props,
          tokens: tokens,
          registerInvokeHandler: registerInvokeHandler,
          unregisterInvokeHandler: unregisterInvokeHandler,
          sendEvent: sendEvent,
        );
      }
      return buildChild(child);
    },
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}

Widget _buildGalleryActionButton({
  required String controlId,
  required Map<String, Object?> action,
  required CandyTokens tokens,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  final variant = (action['variant'] ?? action['style'] ?? 'text')
      .toString()
      .toLowerCase();
  final label = action['label']?.toString() ?? action['text']?.toString();
  final icon = action['icon']?.toString();
  final actionId = _galleryControlId(
    controlId,
    'toolbar_${action['id'] ?? label ?? icon ?? 'action'}',
  );
  final color = coerceColor(action['color'] ?? action['bgcolor']);
  final props = <String, Object?>{
    if (label != null && label.isNotEmpty) 'label': label,
    if (action['value'] != null) 'value': action['value'],
    if (action['enabled'] != null) 'enabled': action['enabled'],
    if (color != null) 'color': color,
  };
  if (icon != null && (label == null || label.isEmpty)) {
    return buildIconButtonControl(
      actionId,
      {'icon': icon, if (color != null) 'color': color},
      registerInvokeHandler,
      unregisterInvokeHandler,
      tokens,
      sendEvent,
    );
  }
  switch (variant) {
    case 'filled':
      return buildFilledButtonControl(
        actionId,
        props,
        tokens,
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    case 'outlined':
      return buildOutlinedButtonControl(
        actionId,
        props,
        tokens,
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    case 'text':
      return buildTextButtonControl(
        actionId,
        props,
        tokens,
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    case 'elevated':
      return buildElevatedButtonControl(
        actionId,
        props,
        tokens,
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    default:
      return buildButtonControl(
        actionId,
        props,
        tokens,
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
  }
}

// ============================================================================
// Local utility surfaces
// ============================================================================

Widget _buildGalleryProgressIndicator({double size = 40}) {
  return Center(
    child: SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(strokeWidth: 3),
    ),
  );
}

Widget _buildGalleryEmptyState({
  required String icon,
  required String title,
  required String message,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_galleryEmptyStateIcon(icon), size: 40, color: Colors.white70),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

IconData _galleryEmptyStateIcon(String icon) {
  final normalized = icon.trim().toLowerCase();
  return switch (normalized) {
    'search' => Icons.search_off_rounded,
    'folder' => Icons.folder_off_outlined,
    'photo_library' || 'gallery' || 'image' => Icons.photo_library_outlined,
    'video' => Icons.video_library_outlined,
    'audio' => Icons.library_music_outlined,
    'document' || 'doc' => Icons.description_outlined,
    _ => Icons.photo_library_outlined,
  };
}

// ============================================================================
// Preview Builder - Uses Image control
// ============================================================================

Widget _buildPreview({
  required String controlId,
  required GalleryItem item,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
}) {
  return _GalleryVisibilityPreview(
    controlId: controlId,
    item: item,
    sendEvent: sendEvent,
    placeholder: _buildGalleryDeferredPlaceholder(item),
    builder: (autoplay) => _buildPreviewBody(
      controlId: controlId,
      item: item,
      buildChild: buildChild,
      registerInvokeHandler: registerInvokeHandler,
      unregisterInvokeHandler: unregisterInvokeHandler,
      sendEvent: sendEvent,
      useControlWidgets: useControlWidgets,
      autoplayVisibleMedia: autoplay,
    ),
  );
}

Widget _buildPreviewBody({
  required String controlId,
  required GalleryItem item,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
  required bool useControlWidgets,
  required bool autoplayVisibleMedia,
}) {
  if (item.isLoading) {
    return _buildGalleryProgressIndicator(size: 28);
  }

  final mediaSource = item.url ?? item.path;
  final imageSource = item.thumbnailUrl ?? item.url ?? item.path;
  final itemType = item.type.toLowerCase();

  if (itemType == 'video' && mediaSource != null && mediaSource.isNotEmpty) {
    return buildVideoControl(
      _galleryControlId(controlId, 'video_${item.id}'),
      {
        'source': mediaSource,
        'autoplay': autoplayVisibleMedia,
        'controls': true,
        'fit': 'cover',
      },
      registerInvokeHandler,
      unregisterInvokeHandler,
      sendEvent,
    );
  }

  if (itemType == 'audio' && mediaSource != null && mediaSource.isNotEmpty) {
    return buildAudioControl(
      _galleryControlId(controlId, 'audio_${item.id}'),
      {
        'src': mediaSource,
        'autoplay': autoplayVisibleMedia,
        'controls': true,
        'title': item.name,
        'artist': item.authorName,
      },
      registerInvokeHandler,
      unregisterInvokeHandler,
      sendEvent,
    );
  }

  if (itemType == 'font') {
    return _buildFontPreview(item);
  }

  if (itemType == 'document') {
    if (imageSource != null && imageSource.isNotEmpty) {
      return buildImageControl(
        {'src': imageSource, 'fit': 'cover'},
        const [],
        buildChild,
      );
    }
    return _buildDocumentPreview(item);
  }

  if (imageSource != null && imageSource.isNotEmpty) {
    if (useControlWidgets) {
      return buildImageControl(
        {'src': imageSource, 'fit': 'cover'},
        const [],
        buildChild,
      );
    }
    if (imageSource.startsWith('http://') ||
        imageSource.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imageSource,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, __, ___) => _buildFallback(item, useControlWidgets),
      );
    }
    return buildImageControl(
      {'src': imageSource, 'fit': 'cover'},
      const [],
      buildChild,
    );
  }

  return _buildFallback(item, useControlWidgets);
}

Widget _buildGalleryDeferredPlaceholder(GalleryItem item) {
  final icon = _getIconForType(item.type);
  final label = item.name ?? item.subtitle ?? 'Preview';
  return Container(
    color: const Color(0x12000000),
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget _buildFontPreview(GalleryItem item) {
  final metadata = item.metadata ?? const <String, dynamic>{};
  final fontFamily =
      metadata['font_family']?.toString() ?? metadata['fontFamily']?.toString();
  final sample =
      metadata['sample']?.toString() ??
      'The quick brown fox jumps over 0123456789';
  return Container(
    color: Colors.grey[100],
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.font_download, color: Colors.grey[700], size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.name ?? 'Font',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Text(
            sample,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              color: Colors.grey[900],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDocumentPreview(GalleryItem item) {
  final ext = _extractExtension(item.path ?? item.url);
  return Container(
    color: Colors.grey[100],
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description, color: Colors.blueGrey[700], size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.name ?? 'Document',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            ext.isEmpty ? 'DOC' : ext.toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

String _extractExtension(String? source) {
  if (source == null || source.isEmpty) return '';
  final normalized = source.replaceAll('\\', '/');
  final name = normalized.split('/').last;
  final dot = name.lastIndexOf('.');
  if (dot < 0 || dot >= name.length - 1) return '';
  return name.substring(dot + 1);
}

Widget _buildFallback(GalleryItem item, bool useControlWidgets) {
  if (useControlWidgets) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: buildIconControl(_getIconForType(item.type), {
          'size': 48,
          'color': Colors.grey[600],
        }),
      ),
    );
  }
  return Container(
    color: Colors.grey[300],
    child: Center(
      child: Icon(
        _getIconForType(item.type),
        size: 48,
        color: Colors.grey[600],
      ),
    ),
  );
}

// ============================================================================
// Helper Functions
// ============================================================================

IconData _getIconForType(String type) {
  return switch (type.toLowerCase()) {
    'video' || 'mp4' || 'mov' || 'avi' => Icons.video_file,
    'audio' || 'mp3' || 'wav' || 'aac' => Icons.audio_file,
    'document' || 'pdf' || 'doc' || 'docx' => Icons.description,
    'font' || 'ttf' || 'otf' || 'woff' => Icons.font_download,
    'archive' || 'zip' || 'rar' || '7z' => Icons.folder_zip,
    'folder' || 'directory' => Icons.folder,
    _ => Icons.image,
  };
}

Color _getStatusColor(String status) {
  return switch (status.toLowerCase()) {
    'new' => Colors.blue,
    'featured' => Colors.purple,
    'popular' => Colors.orange,
    'trending' => Colors.red,
    'archived' => Colors.grey,
    _ => Colors.green,
  };
}

String _formatCount(int count) {
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K';
  }
  return count.toString();
}

// ============================================================================
// Gallery File Picker - Uses FilePicker
// ============================================================================

class GalleryFilePicker {
  static Future<List<GalleryItem>> pickFiles({
    List<String>? allowedExtensions,
    bool allowMultiple = true,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );

      if (result == null || result.files.isEmpty) return [];

      return result.files.map((file) {
        final mimeType = lookupMimeType(file.path ?? '');
        String type = 'document';

        if (mimeType != null) {
          if (mimeType.startsWith('image/')) {
            type = 'image';
          } else if (mimeType.startsWith('video/')) {
            type = 'video';
          } else if (mimeType.startsWith('audio/')) {
            type = 'audio';
          }
        }

        return GalleryItem(
          id: file.path ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: file.name,
          path: file.path,
          type: type,
          metadata: {'size': file.size, 'extension': file.extension},
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<GalleryItem>> pickImages({
    bool allowMultiple = true,
  }) async {
    return pickFiles(
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'],
      allowMultiple: allowMultiple,
    );
  }

  static Future<List<GalleryItem>> pickVideos({
    bool allowMultiple = true,
  }) async {
    return pickFiles(
      allowedExtensions: ['mp4', 'mov', 'avi', 'mkv', 'webm'],
      allowMultiple: allowMultiple,
    );
  }

  static Future<List<GalleryItem>> pickAudio({
    bool allowMultiple = true,
  }) async {
    return pickFiles(
      allowedExtensions: ['mp3', 'wav', 'aac', 'flac', 'ogg'],
      allowMultiple: allowMultiple,
    );
  }
}
