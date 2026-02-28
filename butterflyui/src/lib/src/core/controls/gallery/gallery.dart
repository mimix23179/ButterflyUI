// Unified Gallery umbrella control
// Using existing ButterflyUI controls from list.md
// This replaces the separate engine/host/registry/renderer files

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart'
    show coerceDouble, coerceOptionalInt, coerceObjectMap, coerceColor;
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
import 'package:butterflyui_runtime/src/core/controls/display/empty_state.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/badge.dart';
import 'package:butterflyui_runtime/src/core/controls/feedback/progress_indicator.dart'
    as bfi;
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
      metadata: json['metadata'] as Map<String, dynamic>?,
      isSelected: json['isSelected'] == true || json['is_selected'] == true,
      isLoading: json['isLoading'] == true || json['is_loading'] == true,
      subtitle: json['subtitle']?.toString(),
      description: json['description']?.toString(),
      authorName:
          json['authorName']?.toString() ?? json['author_name']?.toString(),
      authorAvatar:
          json['authorAvatar']?.toString() ?? json['author_avatar']?.toString(),
      likeCount: json['likeCount'] as int? ?? json['like_count'] as int?,
      viewCount: json['viewCount'] as int? ?? json['view_count'] as int?,
      createdAt:
          json['createdAt']?.toString() ?? json['created_at']?.toString(),
      aspectRatio:
          (json['aspectRatio'] as num?)?.toDouble() ??
          (json['aspect_ratio'] as num?)?.toDouble(),
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      status: json['status']?.toString(),
    );
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
    return const SizedBox.shrink();
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
  // Parse items from props
  final itemsData = props['items'];
  List<GalleryItem> items = [];

  if (itemsData is List) {
    items = itemsData
        .whereType<Map>()
        .map((item) => GalleryItem.fromJson(coerceObjectMap(item)))
        .toList();
  }

  final layout = parseGalleryLayout(props['layout']);
  final crossAxisCount =
      coerceOptionalInt(
        props['cross_axis_count'] ??
            props['crossAxisCount'] ??
            props['columns'],
      ) ??
      3;
  final mainAxisSpacing =
      coerceDouble(
        props['main_axis_spacing'] ??
            props['mainAxisSpacing'] ??
            props['spacing'],
      ) ??
      8.0;
  final crossAxisSpacing =
      coerceDouble(props['cross_axis_spacing'] ?? props['crossAxisSpacing']) ??
      8.0;
  final itemBorderRadius =
      coerceDouble(
        props['item_border_radius'] ??
            props['itemBorderRadius'] ??
            props['radius'],
      ) ??
      8.0;
  final showSelections = coerceBoolValue(
    props['show_selections'] ?? props['showSelections'],
    fallback: true,
  );
  final isLoading = coerceBoolValue(
    props['is_loading'] ?? props['isLoading'] ?? props['loading'],
    fallback: false,
  );
  final showActions = coerceBoolValue(
    props['show_actions'] ?? props['showActions'],
    fallback: true,
  );
  final showMeta = coerceBoolValue(
    props['show_meta'] ?? props['showMeta'],
    fallback: true,
  );
  final selectionMode =
      props['selection_mode']?.toString() ??
      props['selectionMode']?.toString() ??
      'none';
  final itemStyle =
      props['item_style']?.toString() ??
      props['itemStyle']?.toString() ??
      'card';
  final enableReorder = coerceBoolValue(
    props['enable_reorder'] ?? props['enableReorder'],
    fallback: false,
  );
  final enableDrag = coerceBoolValue(
    props['enable_drag'] ?? props['enableDrag'],
    fallback: false,
  );
  final shrinkWrap = coerceBoolValue(
    props['shrink_wrap'] ?? props['shrinkWrap'],
    fallback: false,
  );
  final physics = props['physics']?.toString();

  final useControlWidgets = coerceBoolValue(
    props['use_control_widgets'] ??
        props['use_control_layouts'] ??
        props['use_controls'],
    fallback: false,
  );
  final useControlLayouts = coerceBoolValue(
    props['use_control_layouts'] ?? props['use_control_widgets'],
    fallback: false,
  );
  final rawActions = props['actions'] ?? props['toolbar_actions'];
  final toolbarActions = rawActions is List
      ? rawActions
            .whereType<Map>()
            .map((action) => coerceObjectMap(action))
            .toList()
      : <Map<String, Object?>>[];

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
    showActions: showActions,
    showMeta: showMeta,
    selectionMode: selectionMode,
    itemStyle: itemStyle,
    enableReorder: enableReorder,
    enableDrag: enableDrag,
    useControlWidgets: useControlWidgets,
    useControlLayouts: useControlLayouts,
    shrinkWrap: shrinkWrap,
    physics: _parseScrollPhysics(physics),
  );
  final toolbarWidget = toolbarActions.isEmpty
      ? null
      : _buildGalleryToolbar(
          controlId: controlId,
          actions: toolbarActions,
          tokens: tokens,
          buildChild: buildChild,
          sendEvent: sendEvent,
        );
  final content = toolbarWidget == null
      ? layoutWidget
      : buildColumnControl(
          {'spacing': mainAxisSpacing},
          [
            {'type': '__gallery_toolbar', 'props': {}},
            {'type': '__gallery_layout', 'props': {}},
          ],
          tokens,
          (child) {
            final type = child['type']?.toString();
            if (type == '__gallery_toolbar') {
              return toolbarWidget;
            }
            if (type == '__gallery_layout') {
              return layoutWidget;
            }
            return buildChild(child);
          },
        );

  final containerChildren = rawChildren.isEmpty
      ? [
          {'type': '__gallery_content', 'props': {}},
        ]
      : rawChildren;

  return buildContainerControl(props, containerChildren, (childProps) {
    final childType = childProps['type']?.toString();
    if (childType != '__gallery_content') {
      return buildChild(childProps);
    }
    if (isLoading) {
      return bfi.buildProgressIndicatorControl(
        _galleryControlId(controlId, 'loading'),
        {'variant': 'circular'},
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    }
    if (items.isEmpty) {
      return buildEmptyStateControl(controlId, {
        'icon': 'photo_library',
        'title': 'No items in gallery',
        'message': 'Add some items to get started',
      }, sendEvent);
    }
    return content;
  });
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
      // Carousel typically requires fixed height or expands.
      // We wrap in AspectRatio or SizedBox if needed, but PageView expands.
      // If shrinkWrap is true, we might need a fixed height container.
      // For now, we assume user handles height if shrinkWrap is true.
      return PageView.builder(
        physics: physics,
        itemCount: items.length,
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
          );
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
          if (physics != null) 'scrollable': physics is! NeverScrollableScrollPhysics,
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
          if (physics != null) 'scrollable': physics is! NeverScrollableScrollPhysics,
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
            if (physics != null) 'scrollable': physics is! NeverScrollableScrollPhysics,
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
                        {'bgcolor': hoverColor},
                        const [],
                        buildChild,
                      );
                    }
                    if (stackType == '__gallery_card_selected') {
                      return buildContainerControl(
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
      'leading': item.thumbnailUrl ?? item.url,
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
                    sendEvent,
                  ),
                  buildIconButtonControl(
                    _galleryControlId(controlId, 'list_share_${item.id}'),
                    {'icon': 'share', 'size': 20},
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
                sendEvent,
              ),
              buildIconButtonControl(
                _galleryControlId(controlId, 'list_share_${item.id}'),
                {'icon': 'share', 'size': 20},
                sendEvent,
              ),
              buildIconButtonControl(
                _galleryControlId(controlId, 'list_more_${item.id}'),
                {'icon': 'more_vert', 'size': 20},
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
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
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
}) {
  return _buildGalleryCarouselTile(
    controlId: controlId,
    item: item,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    useControlWidgets: useControlWidgets,
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
  if (childType != 'gallery_item') {
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
  );
}

Widget _buildGalleryToolbar({
  required String controlId,
  required List<Map<String, Object?>> actions,
  required CandyTokens tokens,
  required Widget Function(Map<String, Object?> control) buildChild,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  final children = actions
      .map((action) => {'type': '__gallery_action', 'props': action})
      .toList();
  return buildRowControl({'spacing': 8, 'main_axis': 'end'}, children, tokens, (
    child,
  ) {
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
        sendEvent: sendEvent,
      );
    }
    return buildChild(child);
  });
}

Widget _buildGalleryActionButton({
  required String controlId,
  required Map<String, Object?> action,
  required CandyTokens tokens,
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
    return buildIconButtonControl(actionId, {
      'icon': icon,
      if (color != null) 'color': color,
    }, sendEvent);
  }
  switch (variant) {
    case 'filled':
      return buildFilledButtonControl(actionId, props, tokens, sendEvent);
    case 'outlined':
      return buildOutlinedButtonControl(actionId, props, tokens, sendEvent);
    case 'text':
      return buildTextButtonControl(actionId, props, tokens, sendEvent);
    case 'elevated':
      return buildElevatedButtonControl(actionId, props, tokens, sendEvent);
    default:
      return buildButtonControl(actionId, props, tokens, sendEvent);
  }
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
  if (item.isLoading) {
    return bfi.buildProgressIndicatorControl(
      _galleryControlId(controlId, 'item_loading_${item.id}'),
      {'variant': 'circular'},
      registerInvokeHandler,
      unregisterInvokeHandler,
      sendEvent,
    );
  }

  final imageUrl = item.thumbnailUrl ?? item.url;
  final itemType = item.type.toLowerCase();

  if (useControlWidgets) {
    if (itemType == 'video' && item.url != null) {
      return buildVideoControl(
        _galleryControlId(controlId, 'video_${item.id}'),
        {
          'source': item.url,
          'autoplay': false,
          'controls': true,
          'fit': 'cover',
        },
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    }

    if (itemType == 'audio' && item.url != null) {
      return buildAudioControl(
        _galleryControlId(controlId, 'audio_${item.id}'),
        {
          'src': item.url,
          'autoplay': false,
          'controls': true,
          'title': item.name,
          'artist': item.authorName,
        },
        registerInvokeHandler,
        unregisterInvokeHandler,
        sendEvent,
      );
    }

    if (itemType == 'font' || itemType == 'document') {
      return _buildFallback(item, useControlWidgets);
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return buildImageControl(
        {'src': imageUrl, 'fit': 'cover'},
        const [],
        buildChild,
      );
    }
  }

  if (imageUrl != null && imageUrl.startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, __, ___) => _buildFallback(item, useControlWidgets),
    );
  }

  return _buildFallback(item, useControlWidgets);
}

Widget _buildFallback(GalleryItem item, bool useControlWidgets) {
  if (useControlWidgets) {
    return buildContainerControl(
      {'bgcolor': Colors.grey[300]},
      [
        {'type': '__gallery_fallback_icon', 'props': {}},
      ],
      (child) {
        if (child['type']?.toString() == '__gallery_fallback_icon') {
          return Center(
            child: buildIconControl(_getIconForType(item.type), {
              'size': 48,
              'color': Colors.grey[600],
            }),
          );
        }
        return const SizedBox.shrink();
      },
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
