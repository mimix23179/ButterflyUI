import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/display/empty_state.dart';
import 'package:butterflyui_runtime/src/core/controls/feedback/skeleton.dart';
import 'package:butterflyui_runtime/src/core/controls/inputs/search_bar.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGalleryFamilyControl(
  String controlType,
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  if (controlType != 'gallery') {
    return const SizedBox.shrink();
  }
  return _ButterflyUIGallery(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

Set<String> _configuredEvents(Map<String, Object?> props) {
  final raw = props['events'];
  final out = <String>{};
  if (raw is List) {
    for (final entry in raw) {
      final value = entry?.toString();
      if (value != null && value.isNotEmpty) {
        out.add(value);
      }
    }
  }
  return out;
}

void _emitEvent(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
  String event,
  Map<String, Object?> payload,
) {
  final events = _configuredEvents(props);
  if (events.isNotEmpty && !events.contains(event)) {
    return;
  }
  sendEvent(controlId, event, payload);
}

class _GalleryInvokeHost extends StatefulWidget {
  const _GalleryInvokeHost({
    required this.controlType,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    required this.child,
  });

  final String controlType;
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget child;

  @override
  State<_GalleryInvokeHost> createState() => _GalleryInvokeHostState();
}

class _GalleryInvokeHostState extends State<_GalleryInvokeHost> {
  late Map<String, Object?> _runtimeProps = Map<String, Object?>.from(widget.props);

  @override
  void initState() {
    super.initState();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _GalleryInvokeHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = Map<String, Object?>.from(widget.props);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return <String, Object?>{
          'control_type': widget.controlType,
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
          });
        }
        return _runtimeProps;
      case 'emit':
      case 'trigger':
        final event = (args['event'] ?? args['name'] ?? method).toString();
        final payload = args['payload'];
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          event,
          payload is Map ? coerceObjectMap(payload) : args,
        );
        return true;
      default:
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, method, args);
        return true;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _ButterflyUIGallery extends StatefulWidget {
  const _ButterflyUIGallery({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUIGallery> createState() => _ButterflyUIGalleryState();
}

class _ButterflyUIGalleryState extends State<_ButterflyUIGallery> {
  late Map<String, Object?> _runtimeProps;
  late List<Map<String, Object?>> _items;
  final Set<String> _selectedIds = <String>{};

  @override
  void initState() {
    super.initState();
    _runtimeProps = Map<String, Object?>.from(widget.props);
    _items = _coerceItems(_runtimeProps['items']);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = Map<String, Object?>.from(widget.props);
    _items = _coerceItems(_runtimeProps['items']);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return <String, Object?>{
          'count': _items.length,
          'selected_ids': _selectedIds.toList(growable: false),
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
            if (_runtimeProps.containsKey('items')) {
              _items = _coerceItems(_runtimeProps['items']);
            }
          });
        }
        return _runtimeProps;
      case 'emit':
      case 'trigger':
        final event = (args['event'] ?? args['name'] ?? method).toString();
        final payload = args['payload'];
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          event,
          payload is Map ? coerceObjectMap(payload) : args,
        );
        return true;
      case 'set_items':
        setState(() {
          _items = _coerceItems(args['items']);
          _runtimeProps['items'] = _items;
          _selectedIds.clear();
        });
        return _items.length;
      case 'apply':
      case 'gallery_apply':
      case 'gallery_action':
      case 'apply_font':
      case 'gallery_apply_font':
      case 'apply_image':
      case 'gallery_apply_image':
      case 'set_as_wallpaper':
      case 'gallery_set_as_wallpaper':
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, method, {
          'selected_ids': _selectedIds.toList(growable: false),
        });
        return true;
      case 'clear':
      case 'gallery_clear':
        setState(() {
          _selectedIds.clear();
        });
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'clear', {});
        return true;
      case 'select_all':
      case 'gallery_select_all':
        setState(() {
          _selectedIds
            ..clear()
            ..addAll(_items.map((item) => _itemId(item)));
        });
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'select_all', {
          'selected_ids': _selectedIds.toList(growable: false),
        });
        return _selectedIds.length;
      case 'deselect_all':
      case 'gallery_deselect_all':
        setState(() {
          _selectedIds.clear();
        });
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'deselect_all', {});
        return 0;
      default:
        throw UnsupportedError('Unknown gallery method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = coerceDouble(_runtimeProps['spacing']) ?? 12;
    final runSpacing = coerceDouble(_runtimeProps['run_spacing']) ?? spacing;
    final tileWidth = coerceDouble(_runtimeProps['tile_width']) ?? 180;
    final tileHeight = coerceDouble(_runtimeProps['tile_height']) ?? 120;
    final selectable = _runtimeProps['selectable'] == null
        ? true
      : (_runtimeProps['selectable'] == true);

    final childControls = widget.rawChildren
        .whereType<Map>()
        .map((child) => widget.buildChild(coerceObjectMap(child)))
        .toList(growable: false);

    final itemTiles = <Widget>[];
    for (final item in _items) {
      final id = _itemId(item);
      final title = (item['title'] ?? item['label'] ?? id).toString();
      final subtitle = (item['subtitle'] ?? '').toString();
      final selected = _selectedIds.contains(id);
      final color = selected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest;

      itemTiles.add(
        InkWell(
          onTap: selectable
              ? () {
                  setState(() {
                    if (selected) {
                      _selectedIds.remove(id);
                    } else {
                      _selectedIds.add(id);
                    }
                  });
                  _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'select', {
                    'id': id,
                    'selected': !selected,
                    'item': item,
                  });
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: tileWidth,
            height: tileHeight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final sectionWidgets = <Widget>[];
    final toolbar = _sectionProps(_runtimeProps, 'gallery_toolbar');
    if (toolbar != null) {
      sectionWidgets.add(_GalleryToolbar(controlId: widget.controlId, props: toolbar, sendEvent: widget.sendEvent));
    }
    final sectionHeader = _sectionProps(_runtimeProps, 'gallery_section_header');
    if (sectionHeader != null) {
      sectionWidgets.add(_GallerySectionHeader(controlId: widget.controlId, props: sectionHeader, sendEvent: widget.sendEvent));
    }
    final searchBar = _sectionProps(_runtimeProps, 'gallery_search_bar');
    if (searchBar != null) {
      sectionWidgets.add(buildSearchBarControl(widget.controlId, searchBar, widget.sendEvent));
    }
    final filterBar = _sectionProps(_runtimeProps, 'gallery_filter_bar');
    if (filterBar != null) {
      sectionWidgets.add(_GalleryFilterBar(controlId: widget.controlId, props: filterBar, sendEvent: widget.sendEvent));
    }
    final sortBar = _sectionProps(_runtimeProps, 'gallery_sort_bar');
    if (sortBar != null) {
      sectionWidgets.add(_GallerySortBar(controlId: widget.controlId, props: sortBar, sendEvent: widget.sendEvent));
    }
    final gridLayout = _sectionProps(_runtimeProps, 'gallery_grid_layout');
    if (gridLayout != null) {
      sectionWidgets.add(
        _GalleryGridLayout(
          props: gridLayout,
          rawChildren: widget.rawChildren,
          buildChild: widget.buildChild,
        ),
      );
    }

    final allTiles = <Widget>[...itemTiles, ...childControls];
    if (allTiles.isNotEmpty) {
      sectionWidgets.add(Wrap(spacing: spacing, runSpacing: runSpacing, children: allTiles));
    } else {
      final loading = _sectionProps(_runtimeProps, 'gallery_loading_skeleton');
      final empty = _sectionProps(_runtimeProps, 'gallery_empty_state');
      if (loading != null) {
        sectionWidgets.add(
          buildSkeletonLoaderControl(
            widget.controlId,
            loading,
            widget.registerInvokeHandler,
            widget.unregisterInvokeHandler,
          ),
        );
      }
      if (empty != null) {
        sectionWidgets.add(buildEmptyStateControl(widget.controlId, empty, widget.sendEvent));
      }
      if (loading == null && empty == null) {
        return const SizedBox.shrink();
      }
    }

    final footerWidgets = <Widget>[];
    final itemTile = _sectionProps(_runtimeProps, 'gallery_item_tile');
    if (itemTile != null) {
      footerWidgets.add(_GalleryItemTile(controlId: widget.controlId, props: itemTile, sendEvent: widget.sendEvent));
    }
    final itemActions = _sectionProps(_runtimeProps, 'gallery_item_actions');
    if (itemActions != null) {
      footerWidgets.add(_GalleryItemActions(controlId: widget.controlId, props: itemActions, sendEvent: widget.sendEvent));
    }
    final itemBadge = _sectionProps(_runtimeProps, 'gallery_item_badge');
    if (itemBadge != null) {
      footerWidgets.add(_GalleryItemBadge(props: itemBadge));
    }
    final itemMeta = _sectionProps(_runtimeProps, 'gallery_item_meta_row');
    if (itemMeta != null) {
      footerWidgets.add(_GalleryItemMetaRow(props: itemMeta));
    }
    final itemPreview = _sectionProps(_runtimeProps, 'gallery_item_preview');
    if (itemPreview != null) {
      footerWidgets.add(
        _GalleryItemPreview(
          props: itemPreview,
          rawChildren: widget.rawChildren,
          buildChild: widget.buildChild,
        ),
      );
    }
    final itemSelectable = _sectionProps(_runtimeProps, 'gallery_item_selectable');
    if (itemSelectable != null) {
      footerWidgets.add(_GalleryItemSelectable(controlId: widget.controlId, props: itemSelectable, sendEvent: widget.sendEvent));
    }
    final itemDrag = _sectionProps(_runtimeProps, 'gallery_item_drag_handle');
    if (itemDrag != null) {
      footerWidgets.add(
        _GalleryItemHandle(
          controlType: 'gallery_item_drag_handle',
          controlId: widget.controlId,
          props: itemDrag,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final itemDrop = _sectionProps(_runtimeProps, 'gallery_item_drop_target');
    if (itemDrop != null) {
      footerWidgets.add(_GalleryItemDropTarget(controlId: widget.controlId, props: itemDrop, sendEvent: widget.sendEvent));
    }
    final itemReorder = _sectionProps(_runtimeProps, 'gallery_item_reorder_handle');
    if (itemReorder != null) {
      footerWidgets.add(
        _GalleryItemHandle(
          controlType: 'gallery_item_reorder_handle',
          controlId: widget.controlId,
          props: itemReorder,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final selectCheckbox = _sectionProps(_runtimeProps, 'gallery_item_selection_checkbox');
    if (selectCheckbox != null) {
      footerWidgets.add(_GallerySelectionCheckbox(controlId: widget.controlId, props: selectCheckbox, sendEvent: widget.sendEvent));
    }
    final selectRadio = _sectionProps(_runtimeProps, 'gallery_item_selection_radio');
    if (selectRadio != null) {
      footerWidgets.add(_GallerySelectionRadio(controlId: widget.controlId, props: selectRadio, sendEvent: widget.sendEvent));
    }
    final selectSwitch = _sectionProps(_runtimeProps, 'gallery_item_selection_switch');
    if (selectSwitch != null) {
      footerWidgets.add(_GallerySelectionSwitch(controlId: widget.controlId, props: selectSwitch, sendEvent: widget.sendEvent));
    }
    final pagination = _sectionProps(_runtimeProps, 'gallery_pagination');
    if (pagination != null) {
      footerWidgets.add(_GalleryPagination(controlId: widget.controlId, props: pagination, sendEvent: widget.sendEvent));
    }
    final fontPicker = _sectionProps(_runtimeProps, 'gallery_font_picker');
    if (fontPicker != null) {
      footerWidgets.add(_GalleryFontPicker(controlId: widget.controlId, props: fontPicker, sendEvent: widget.sendEvent));
    }
    for (final key in const <String>['gallery_audio_picker', 'gallery_video_picker', 'gallery_image_picker']) {
      final section = _sectionProps(_runtimeProps, key);
      if (section != null) {
        footerWidgets.add(_GalleryAssetPicker(controlType: key, controlId: widget.controlId, props: section, sendEvent: widget.sendEvent));
      }
    }
    for (final key in const <String>[
      'gallery_action',
      'gallery_apply',
      'gallery_clear',
      'gallery_select_all',
      'gallery_deselect_all',
      'gallery_apply_font',
      'gallery_apply_image',
      'gallery_set_as_wallpaper',
    ]) {
      final section = _sectionProps(_runtimeProps, key);
      if (section != null) {
        footerWidgets.add(_GalleryActionButton(controlType: key, controlId: widget.controlId, props: section, sendEvent: widget.sendEvent));
      }
    }

    if (footerWidgets.isNotEmpty) {
      sectionWidgets.add(const SizedBox(height: 8));
      sectionWidgets.add(Wrap(spacing: 8, runSpacing: 8, children: footerWidgets));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < sectionWidgets.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          sectionWidgets[i],
        ],
      ],
    );
  }
}

Map<String, Object?>? _sectionProps(Map<String, Object?> props, String key) {
  final section = props[key];
  if (section is Map) {
    return <String, Object?>{...coerceObjectMap(section), 'events': props['events']};
  }
  if (section == true) {
    return <String, Object?>{'events': props['events']};
  }
  return null;
}

List<Map<String, Object?>> _coerceItems(Object? value) {
  final out = <Map<String, Object?>>[];
  if (value is List) {
    for (final item in value) {
      if (item is Map) {
        out.add(coerceObjectMap(item));
      } else if (item != null) {
        out.add({'id': item.toString(), 'title': item.toString()});
      }
    }
  }
  return out;
}

String _itemId(Map<String, Object?> item) {
  return (item['id'] ?? item['value'] ?? item['title'] ?? '').toString();
}

class _GalleryToolbar extends StatelessWidget {
  const _GalleryToolbar({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final title = (props['title'] ?? 'Gallery').toString();
    final subtitle = (props['subtitle'] ?? '').toString();
    final actions = props['actions'] is List ? (props['actions'] as List) : const <dynamic>[];

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
                _emitEvent(controlId, props, sendEvent, 'action', {
                  'id': (map['id'] ?? map['value'] ?? map['label'] ?? '').toString(),
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

class _GalleryFilterBar extends StatelessWidget {
  const _GalleryFilterBar({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final filters = props['filters'] is List ? (props['filters'] as List) : const <dynamic>[];
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
              _emitEvent(controlId, props, sendEvent, 'filter_change', {
                'filter': filter?.toString(),
                'selected': next,
              });
            },
          ),
      ],
    );
  }
}

class _GallerySortBar extends StatelessWidget {
  const _GallerySortBar({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final options = props['options'] is List
        ? (props['options'] as List).map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList(growable: false)
        : const <String>[];
    final selected = (props['value'] ?? props['selected'] ?? (options.isEmpty ? '' : options.first)).toString();

    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButton<String>(
      value: options.contains(selected) ? selected : options.first,
      items: options.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(growable: false),
      onChanged: (value) {
        if (value == null) return;
        _emitEvent(controlId, props, sendEvent, 'sort_change', {'value': value});
      },
    );
  }
}

class _GalleryGridLayout extends StatelessWidget {
  const _GalleryGridLayout({required this.props, required this.rawChildren, required this.buildChild});

  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;

  @override
  Widget build(BuildContext context) {
    final columns = (coerceOptionalInt(props['columns']) ?? 3).clamp(1, 8);
    final spacing = coerceDouble(props['spacing']) ?? 10;
    final childMaps = rawChildren.whereType<Map>().map((e) => coerceObjectMap(e)).toList(growable: false);

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: childMaps.isEmpty
          ? const <Widget>[]
          : childMaps.map(buildChild).toList(growable: false),
    );
  }
}

class _GalleryItemTile extends StatelessWidget {
  const _GalleryItemTile({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final title = (props['title'] ?? '').toString();
    final subtitle = (props['subtitle'] ?? '').toString();
    final id = (props['id'] ?? props['value'] ?? title).toString();
    return ListTile(
      title: Text(title),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      onTap: () => _emitEvent(controlId, props, sendEvent, 'select', {'id': id}),
    );
  }
}

class _GalleryItemActions extends StatelessWidget {
  const _GalleryItemActions({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final actions = props['actions'] is List ? (props['actions'] as List) : const <dynamic>[];
    return Wrap(
      spacing: 6,
      children: [
        for (final action in actions)
          FilledButton.tonal(
            onPressed: () => _emitEvent(controlId, props, sendEvent, 'action', {'action': action}),
            child: Text(action is Map ? (action['label'] ?? action['id'] ?? 'Action').toString() : action?.toString() ?? 'Action'),
          ),
      ],
    );
  }
}

class _GalleryItemBadge extends StatelessWidget {
  const _GalleryItemBadge({required this.props});

  final Map<String, Object?> props;

  @override
  Widget build(BuildContext context) {
    final text = (props['text'] ?? props['label'] ?? '').toString();
    return Chip(label: Text(text));
  }
}

class _GalleryItemMetaRow extends StatelessWidget {
  const _GalleryItemMetaRow({required this.props});

  final Map<String, Object?> props;

  @override
  Widget build(BuildContext context) {
    final items = props['items'] is List ? (props['items'] as List) : const <dynamic>[];
    return Wrap(
      spacing: 10,
      children: [
        for (final item in items)
          Text(item?.toString() ?? '', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _GalleryItemPreview extends StatelessWidget {
  const _GalleryItemPreview({required this.props, required this.rawChildren, required this.buildChild});

  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;

  @override
  Widget build(BuildContext context) {
    Map<String, Object?>? childMap;
    for (final raw in rawChildren) {
      if (raw is Map) {
        childMap = coerceObjectMap(raw);
        break;
      }
    }
    if (childMap != null) {
      return buildChild(childMap);
    }
    final label = (props['label'] ?? props['title'] ?? 'Preview').toString();
    return Container(
      height: coerceDouble(props['height']) ?? 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label),
    );
  }
}

class _GalleryItemSelectable extends StatelessWidget {
  const _GalleryItemSelectable({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final selected = props['selected'] == true;
    return CheckboxListTile(
      value: selected,
      title: Text((props['label'] ?? props['title'] ?? 'Selectable').toString()),
      onChanged: (value) => _emitEvent(controlId, props, sendEvent, 'select_change', {'selected': value == true}),
    );
  }
}

class _GalleryPagination extends StatelessWidget {
  const _GalleryPagination({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final page = (coerceOptionalInt(props['page']) ?? 1).clamp(1, 1000000);
    final pageCount = (coerceOptionalInt(props['page_count'] ?? props['pages']) ?? 1).clamp(1, 1000000);
    final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: enabled && page > 1
              ? () => _emitEvent(controlId, props, sendEvent, 'page_change', {'page': page - 1})
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text('$page / $pageCount'),
        IconButton(
          onPressed: enabled && page < pageCount
              ? () => _emitEvent(controlId, props, sendEvent, 'page_change', {'page': page + 1})
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _GallerySectionHeader extends StatelessWidget {
  const _GallerySectionHeader({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => _emitEvent(controlId, props, sendEvent, 'section_action', {'id': props['id']}),
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}

class _GalleryFontPicker extends StatelessWidget {
  const _GalleryFontPicker({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final options = props['options'] is List
        ? (props['options'] as List).map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList(growable: false)
        : const <String>['Inter', 'Roboto', 'JetBrains Mono'];
    final value = (props['value'] ?? options.first).toString();
    return DropdownButton<String>(
      value: options.contains(value) ? value : options.first,
      items: options.map((font) => DropdownMenuItem(value: font, child: Text(font))).toList(growable: false),
      onChanged: (next) {
        if (next == null) return;
        _emitEvent(controlId, props, sendEvent, 'font_change', {'font': next});
      },
    );
  }
}

class _GalleryAssetPicker extends StatelessWidget {
  const _GalleryAssetPicker({
    required this.controlType,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlType;
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final label = (props['label'] ?? controlType.replaceAll('_', ' ')).toString();
    return OutlinedButton.icon(
      onPressed: () => _emitEvent(controlId, props, sendEvent, 'pick', {'kind': controlType}),
      icon: const Icon(Icons.attach_file),
      label: Text(label),
    );
  }
}

class _GalleryItemHandle extends StatelessWidget {
  const _GalleryItemHandle({
    required this.controlType,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlType;
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _emitEvent(controlId, props, sendEvent, 'drag_handle', {'kind': controlType}),
      icon: const Icon(Icons.drag_indicator),
    );
  }
}

class _GalleryItemDropTarget extends StatelessWidget {
  const _GalleryItemDropTarget({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: coerceDouble(props['height']) ?? 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () => _emitEvent(controlId, props, sendEvent, 'drop_target', {}),
        child: Text((props['label'] ?? 'Drop Target').toString()),
      ),
    );
  }
}

class _GallerySelectionCheckbox extends StatelessWidget {
  const _GallerySelectionCheckbox({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final selected = props['selected'] == true;
    return Checkbox(
      value: selected,
      onChanged: (value) => _emitEvent(controlId, props, sendEvent, 'select_change', {'selected': value == true}),
    );
  }
}

class _GallerySelectionRadio extends StatelessWidget {
  const _GallerySelectionRadio({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final selected = props['selected'] == true;
    return Radio<bool>(
      value: true,
      groupValue: selected,
      onChanged: (value) => _emitEvent(controlId, props, sendEvent, 'select_change', {'selected': value == true}),
    );
  }
}

class _GallerySelectionSwitch extends StatelessWidget {
  const _GallerySelectionSwitch({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final selected = props['selected'] == true;
    return Switch(
      value: selected,
      onChanged: (value) => _emitEvent(controlId, props, sendEvent, 'select_change', {'selected': value}),
    );
  }
}

class _GalleryActionButton extends StatelessWidget {
  const _GalleryActionButton({
    required this.controlType,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlType;
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final label = (props['label'] ?? controlType.replaceAll('_', ' ')).toString();
    return FilledButton.tonal(
      onPressed: () => _emitEvent(controlId, props, sendEvent, controlType, {
        'value': props['value'],
        'payload': props['payload'],
      }),
      child: Text(label),
    );
  }
}
