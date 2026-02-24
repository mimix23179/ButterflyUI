import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';
import 'package:butterflyui_runtime/src/core/controls/display/empty_state.dart';
import 'package:butterflyui_runtime/src/core/controls/feedback/skeleton.dart';
import 'package:butterflyui_runtime/src/core/controls/inputs/search_bar.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

const int _gallerySchemaVersion = 2;

const Set<String> _galleryModules = {
  'toolbar',
  'filter_bar',
  'grid_layout',
  'item_actions',
  'item_badge',
  'item_meta_row',
  'item_preview',
  'item_selectable',
  'item_tile',
  'pagination',
  'section_header',
  'sort_bar',
  'empty_state',
  'loading_skeleton',
  'search_bar',
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
  'item_drag_handle',
  'item_drop_target',
  'item_reorder_handle',
  'item_selection_checkbox',
  'item_selection_radio',
  'item_selection_switch',
  'apply',
  'clear',
  'select_all',
  'deselect_all',
  'apply_font',
  'apply_image',
  'set_as_wallpaper',
  'presets',
  'skins',
};

const Set<String> _galleryStates = {
  'idle',
  'loading',
  'empty',
  'ready',
  'disabled',
};

const Set<String> _galleryEvents = {
  'change',
  'select',
  'select_change',
  'page_change',
  'sort_change',
  'filter_change',
  'action',
  'apply',
  'clear',
  'select_all',
  'deselect_all',
  'apply_font',
  'apply_image',
  'set_as_wallpaper',
  'pick',
  'drag_handle',
  'drop_target',
  'section_action',
  'font_change',
};

const Map<String, String> _galleryRegistryRoleAliases = {
  'module': 'module_registry',
  'modules': 'module_registry',
  'source': 'source_registry',
  'sources': 'source_registry',
  'type': 'type_registry',
  'types': 'type_registry',
  'handler': 'type_registry',
  'view': 'view_registry',
  'views': 'view_registry',
  'panel': 'panel_registry',
  'panels': 'panel_registry',
  'apply': 'apply_registry',
  'adapter': 'apply_registry',
  'adapters': 'apply_registry',
  'command': 'command_registry',
  'commands': 'command_registry',
  'module_registry': 'module_registry',
  'source_registry': 'source_registry',
  'type_registry': 'type_registry',
  'view_registry': 'view_registry',
  'panel_registry': 'panel_registry',
  'apply_registry': 'apply_registry',
  'command_registry': 'command_registry',
};

const Map<String, String> _galleryRegistryManifestLists = {
  'module_registry': 'enabled_modules',
  'source_registry': 'enabled_sources',
  'type_registry': 'enabled_types',
  'view_registry': 'enabled_views',
  'panel_registry': 'enabled_panels',
  'apply_registry': 'enabled_adapters',
  'command_registry': 'enabled_commands',
};

const Map<String, List<String>> _galleryManifestDefaults = {
  'enabled_modules': <String>[
    'toolbar',
    'filter_bar',
    'search_bar',
    'sort_bar',
    'section_header',
    'grid_layout',
    'item_tile',
    'item_preview',
    'item_actions',
    'item_selectable',
    'pagination',
    'fonts',
    'image',
    'video',
    'audio',
    'document',
    'apply',
    'clear',
    'select_all',
    'deselect_all',
  ],
  'enabled_views': <String>['grid_layout', 'item_tile', 'item_preview'],
  'enabled_panels': <String>['toolbar', 'filter_bar', 'search_bar', 'sort_bar'],
  'enabled_sources': <String>['project_assets', 'local_folder'],
  'enabled_types': <String>['image', 'video', 'audio', 'document', 'fonts'],
  'enabled_adapters': <String>['apply_image', 'apply_font', 'set_as_wallpaper'],
  'enabled_commands': <String>['apply', 'clear', 'select_all', 'deselect_all'],
};

Widget buildGalleryFamilyControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _GalleryControl(
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
      final value = _norm(entry?.toString() ?? '');
      if (value.isNotEmpty && _galleryEvents.contains(value)) {
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
  final eventName = _norm(event);
  if (!_galleryEvents.contains(eventName)) {
    return;
  }
  final events = _configuredEvents(props);
  if (events.isNotEmpty && !events.contains(eventName)) {
    return;
  }
  sendEvent(controlId, eventName, {
    'schema_version': props['schema_version'] ?? _gallerySchemaVersion,
    'module': props['module'],
    'state': props['state'],
    ...payload,
  });
}

class _InvokeHost extends StatefulWidget {
  const _InvokeHost({
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
  State<_InvokeHost> createState() => _InvokeHostState();
}

class _InvokeHostState extends State<_InvokeHost> {
  late Map<String, Object?> _runtimeProps = Map<String, Object?>.from(
    widget.props,
  );

  @override
  void initState() {
    super.initState();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _InvokeHost oldWidget) {
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

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
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
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          method,
          args,
        );
        return true;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _GalleryControl extends StatefulWidget {
  const _GalleryControl({
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
  State<_GalleryControl> createState() => _GalleryControlState();
}

class _GalleryControlState extends State<_GalleryControl> {
  late Map<String, Object?> _runtimeProps;
  late List<Map<String, Object?>> _items;
  final Set<String> _selectedIds = <String>{};

  @override
  void initState() {
    super.initState();
    _runtimeProps = _normalizeProps(widget.props);
    _items = _coerceItems(_runtimeProps['items']);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _GalleryControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = _normalizeProps(widget.props);
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

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (_norm(method)) {
      case 'get_state':
        return <String, Object?>{
          'schema_version': _runtimeProps['schema_version'],
          'module': _runtimeProps['module'],
          'state': _runtimeProps['state'],
          'manifest': _runtimeProps['manifest'],
          'registries': _runtimeProps['registries'],
          'count': _items.length,
          'selected_ids': _selectedIds.toList(growable: false),
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
            _runtimeProps = _normalizeProps(_runtimeProps);
            if (_runtimeProps.containsKey('items')) {
              _items = _coerceItems(_runtimeProps['items']);
            }
          });
        }
        return _runtimeProps;
      case 'set_manifest':
        final manifestPayload = _coerceObjectMap(args['manifest']);
        setState(() {
          final manifest = _coerceObjectMap(_runtimeProps['manifest']);
          manifest.addAll(manifestPayload);
          _runtimeProps['manifest'] = manifest;
          _runtimeProps = _normalizeProps(_runtimeProps);
        });
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          'change',
          {
            'module': 'toolbar',
            'intent': 'set_manifest',
            'manifest': _runtimeProps['manifest'],
          },
        );
        return {'ok': true, 'manifest': _runtimeProps['manifest']};
      case 'set_module':
        {
          final module = _norm(args['module']?.toString() ?? '');
          if (!_galleryModules.contains(module)) {
            return {'ok': false, 'error': 'unknown module: $module'};
          }
          final payload = args['payload'];
          final payloadMap = payload is Map
              ? coerceObjectMap(payload)
              : <String, Object?>{};
          setState(() {
            _runtimeProps['module'] = module;
            _runtimeProps[module] = payloadMap;
            final modules = _coerceObjectMap(_runtimeProps['modules']);
            modules[module] = payloadMap;
            _runtimeProps['modules'] = modules;
          });
          _emitEvent(
            widget.controlId,
            _runtimeProps,
            widget.sendEvent,
            'change',
            {'module': module},
          );
          return {'ok': true, 'module': module};
        }
      case 'set_state':
        {
          final state = _norm(args['state']?.toString() ?? '');
          if (!_galleryStates.contains(state)) {
            return {'ok': false, 'error': 'unknown state: $state'};
          }
          setState(() {
            _runtimeProps['state'] = state;
          });
          _emitEvent(
            widget.controlId,
            _runtimeProps,
            widget.sendEvent,
            'change',
            {'state': state},
          );
          return {'ok': true, 'state': state};
        }
      case 'emit':
      case 'trigger':
        final fallback = method == 'trigger' ? 'change' : method;
        final event = _norm(
          (args['event'] ?? args['name'] ?? fallback).toString(),
        );
        if (!_galleryEvents.contains(event)) {
          return {'ok': false, 'error': 'unknown event: $event'};
        }
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
      case 'apply_font':
      case 'apply_image':
      case 'set_as_wallpaper':
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          _norm(method),
          {'selected_ids': _selectedIds.toList(growable: false)},
        );
        return true;
      case 'clear':
        setState(() {
          _selectedIds.clear();
        });
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          'clear',
          {},
        );
        return true;
      case 'select_all':
        setState(() {
          _selectedIds
            ..clear()
            ..addAll(_items.map((item) => _itemId(item)));
        });
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          'select_all',
          {'selected_ids': _selectedIds.toList(growable: false)},
        );
        return _selectedIds.length;
      case 'deselect_all':
        setState(() {
          _selectedIds.clear();
        });
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          'deselect_all',
          {},
        );
        return 0;
      default:
        final normalized = _norm(method);
        if (normalized.startsWith('register_')) {
          final role = normalized == 'register_module'
              ? (args['role'] ?? 'module').toString()
              : normalized.replaceFirst('register_', '');
          final moduleId =
              (args['module_id'] ??
                      args['id'] ??
                      args['name'] ??
                      args['module'] ??
                      '')
                  .toString();
          final definition = _coerceObjectMap(args['definition']);
          late Map<String, Object?> result;
          setState(() {
            result = registerUmbrellaModule(
              props: _runtimeProps,
              role: role,
              moduleId: moduleId,
              definition: definition,
              modules: _galleryModules,
              roleAliases: _galleryRegistryRoleAliases,
              roleManifestLists: _galleryRegistryManifestLists,
              manifestDefaults: _galleryManifestDefaults,
            );
            _runtimeProps = _normalizeProps(_runtimeProps);
          });
          if (result['ok'] == true) {
            _emitEvent(
              widget.controlId,
              _runtimeProps,
              widget.sendEvent,
              'change',
              {
                'module': 'toolbar',
                'intent': normalized,
                'role': result['role'],
                'module_id': result['module_id'],
              },
            );
          }
          return result;
        }
        throw UnsupportedError('Unknown gallery method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = coerceDouble(_runtimeProps['spacing']) ?? 12;
    final runSpacing = coerceDouble(_runtimeProps['run_spacing']) ?? spacing;
    final tileWidth = coerceDouble(_runtimeProps['tile_width']) ?? 180;
    final tileHeight = coerceDouble(_runtimeProps['tile_height']) ?? 120;
    final tileRadius = _resolveRadius(_runtimeProps, fallback: 12);
    final selectable = _runtimeProps['selectable'] == null
        ? true
        : (_runtimeProps['selectable'] == true);

    final childControls = widget.rawChildren
        .whereType<Map>()
        .map((child) => widget.buildChild(coerceObjectMap(child)))
        .toList(growable: false);
    final customLayout =
        _runtimeProps['custom_layout'] == true ||
        _norm((_runtimeProps['layout'] ?? '').toString()) == 'custom';
    final hasBuiltInData =
        _items.isNotEmpty ||
        _runtimeProps['module'] != null ||
        _coerceObjectMap(_runtimeProps['modules']).isNotEmpty;

    if (childControls.isNotEmpty && (customLayout || !hasBuiltInData)) {
      if (childControls.length == 1) {
        return childControls.first;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < childControls.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            childControls[i],
          ],
        ],
      );
    }

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
                  _emitEvent(
                    widget.controlId,
                    _runtimeProps,
                    widget.sendEvent,
                    'select',
                    {'id': id, 'selected': !selected, 'item': item},
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(tileRadius),
          child: Container(
            width: tileWidth,
            height: tileHeight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(tileRadius),
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
    final toolbar = _sectionProps(_runtimeProps, 'toolbar');
    if (toolbar != null) {
      sectionWidgets.add(
        _Toolbar(
          controlId: widget.controlId,
          props: toolbar,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final sectionHeader = _sectionProps(_runtimeProps, 'section_header');
    if (sectionHeader != null) {
      sectionWidgets.add(
        _SectionHeader(
          controlId: widget.controlId,
          props: sectionHeader,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final searchBar = _sectionProps(_runtimeProps, 'search_bar');
    if (searchBar != null) {
      sectionWidgets.add(
        buildSearchBarControl(widget.controlId, searchBar, widget.sendEvent),
      );
    }
    final filterBar = _sectionProps(_runtimeProps, 'filter_bar');
    if (filterBar != null) {
      sectionWidgets.add(
        _FilterBar(
          controlId: widget.controlId,
          props: filterBar,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final sortBar = _sectionProps(_runtimeProps, 'sort_bar');
    if (sortBar != null) {
      sectionWidgets.add(
        _SortBar(
          controlId: widget.controlId,
          props: sortBar,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final gridLayout = _sectionProps(_runtimeProps, 'grid_layout');
    if (gridLayout != null) {
      sectionWidgets.add(
        _GridLayout(
          props: gridLayout,
          rawChildren: widget.rawChildren,
          buildChild: widget.buildChild,
        ),
      );
    }

    final allTiles = <Widget>[...itemTiles, ...childControls];
    if (allTiles.isNotEmpty) {
      sectionWidgets.add(
        Wrap(spacing: spacing, runSpacing: runSpacing, children: allTiles),
      );
    } else {
      final loading = _sectionProps(_runtimeProps, 'loading_skeleton');
      final empty = _sectionProps(_runtimeProps, 'empty_state');
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
        sectionWidgets.add(
          buildEmptyStateControl(widget.controlId, empty, widget.sendEvent),
        );
      }
      if (loading == null && empty == null) {
        return const SizedBox.shrink();
      }
    }

    final footerWidgets = <Widget>[];
    final itemTile = _sectionProps(_runtimeProps, 'item_tile');
    if (itemTile != null) {
      footerWidgets.add(
        _ItemTile(
          controlId: widget.controlId,
          props: itemTile,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final itemActions = _sectionProps(_runtimeProps, 'item_actions');
    if (itemActions != null) {
      footerWidgets.add(
        _ItemActions(
          controlId: widget.controlId,
          props: itemActions,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final itemBadge = _sectionProps(_runtimeProps, 'item_badge');
    if (itemBadge != null) {
      footerWidgets.add(_ItemBadge(props: itemBadge));
    }
    final itemMeta = _sectionProps(_runtimeProps, 'item_meta_row');
    if (itemMeta != null) {
      footerWidgets.add(_ItemMetaRow(props: itemMeta));
    }
    final itemPreview = _sectionProps(_runtimeProps, 'item_preview');
    if (itemPreview != null) {
      footerWidgets.add(
        _ItemPreview(
          props: itemPreview,
          rawChildren: widget.rawChildren,
          buildChild: widget.buildChild,
          radius: _resolveRadius(
            itemPreview,
            parent: _runtimeProps,
            fallback: 10,
          ),
        ),
      );
    }
    final itemSelectable = _sectionProps(_runtimeProps, 'item_selectable');
    if (itemSelectable != null) {
      footerWidgets.add(
        _ItemSelectable(
          controlId: widget.controlId,
          props: itemSelectable,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final itemDrag = _sectionProps(_runtimeProps, 'item_drag_handle');
    if (itemDrag != null) {
      footerWidgets.add(
        _ItemHandle(
          controlType: 'item_drag_handle',
          controlId: widget.controlId,
          props: itemDrag,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final itemDrop = _sectionProps(_runtimeProps, 'item_drop_target');
    if (itemDrop != null) {
      footerWidgets.add(
        _ItemDropTarget(
          controlId: widget.controlId,
          props: itemDrop,
          radius: _resolveRadius(itemDrop, parent: _runtimeProps, fallback: 8),
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final itemReorder = _sectionProps(_runtimeProps, 'item_reorder_handle');
    if (itemReorder != null) {
      footerWidgets.add(
        _ItemHandle(
          controlType: 'item_reorder_handle',
          controlId: widget.controlId,
          props: itemReorder,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final selectCheckbox = _sectionProps(
      _runtimeProps,
      'item_selection_checkbox',
    );
    if (selectCheckbox != null) {
      footerWidgets.add(
        _SelectionCheckbox(
          controlId: widget.controlId,
          props: selectCheckbox,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final selectRadio = _sectionProps(_runtimeProps, 'item_selection_radio');
    if (selectRadio != null) {
      footerWidgets.add(
        _SelectionRadio(
          controlId: widget.controlId,
          props: selectRadio,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final selectSwitch = _sectionProps(_runtimeProps, 'item_selection_switch');
    if (selectSwitch != null) {
      footerWidgets.add(
        _SelectionSwitch(
          controlId: widget.controlId,
          props: selectSwitch,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final pagination = _sectionProps(_runtimeProps, 'pagination');
    if (pagination != null) {
      footerWidgets.add(
        _Pagination(
          controlId: widget.controlId,
          props: pagination,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    final fontPicker = _sectionProps(_runtimeProps, 'font_picker');
    if (fontPicker != null) {
      footerWidgets.add(
        _FontPicker(
          controlId: widget.controlId,
          props: fontPicker,
          sendEvent: widget.sendEvent,
        ),
      );
    }
    for (final key in const <String>[
      'fonts',
      'audio',
      'video',
      'image',
      'document',
      'presets',
      'skins',
    ]) {
      final section = _sectionProps(_runtimeProps, key);
      if (section != null) {
        footerWidgets.add(
          _CollectionModule(
            controlType: key,
            controlId: widget.controlId,
            props: section,
            sendEvent: widget.sendEvent,
          ),
        );
      }
    }
    for (final key in const <String>[
      'font_renderer',
      'audio_renderer',
      'video_renderer',
      'image_renderer',
      'document_renderer',
    ]) {
      final section = _sectionProps(_runtimeProps, key);
      if (section != null) {
        footerWidgets.add(
          _RendererModule(
            controlType: key,
            controlId: widget.controlId,
            props: section,
            sendEvent: widget.sendEvent,
          ),
        );
      }
    }
    for (final key in const <String>[
      'audio_picker',
      'video_picker',
      'image_picker',
      'document_picker',
    ]) {
      final section = _sectionProps(_runtimeProps, key);
      if (section != null) {
        footerWidgets.add(
          _AssetPicker(
            controlType: key,
            controlId: widget.controlId,
            props: section,
            sendEvent: widget.sendEvent,
          ),
        );
      }
    }
    for (final key in const <String>[
      'apply',
      'clear',
      'select_all',
      'deselect_all',
      'apply_font',
      'apply_image',
      'set_as_wallpaper',
    ]) {
      final section = _sectionProps(_runtimeProps, key);
      if (section != null) {
        footerWidgets.add(
          _ActionButton(
            controlType: key,
            controlId: widget.controlId,
            props: section,
            sendEvent: widget.sendEvent,
          ),
        );
      }
    }

    if (footerWidgets.isNotEmpty) {
      sectionWidgets.add(const SizedBox(height: 8));
      sectionWidgets.add(
        Wrap(spacing: 8, runSpacing: 8, children: footerWidgets),
      );
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

Map<String, Object?> _normalizeProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] =
      (coerceOptionalInt(out['schema_version']) ?? _gallerySchemaVersion).clamp(
        1,
        9999,
      );

  final module = _norm(out['module']?.toString() ?? '');
  if (module.isNotEmpty && _galleryModules.contains(module)) {
    out['module'] = module;
  } else if (module.isNotEmpty) {
    out.remove('module');
  }

  final state = _norm(out['state']?.toString() ?? '');
  if (state.isNotEmpty && _galleryStates.contains(state)) {
    out['state'] = state;
  } else if (state.isNotEmpty) {
    out.remove('state');
  }

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((e) => _norm(e?.toString() ?? ''))
        .where((e) => e.isNotEmpty && _galleryEvents.contains(e))
        .toSet()
        .toList(growable: false);
  }

  final modules = _coerceObjectMap(out['modules']);
  if (modules.isNotEmpty) {
    final normalizedModules = <String, Object?>{};
    for (final entry in modules.entries) {
      final normalizedModule = _norm(entry.key);
      if (!_galleryModules.contains(normalizedModule)) continue;
      if (entry.value == true) {
        normalizedModules[normalizedModule] = <String, Object?>{};
        continue;
      }
      final payload = _coerceObjectMap(entry.value);
      if (payload.isEmpty && entry.value is! Map) continue;
      normalizedModules[normalizedModule] = payload;
    }
    out['modules'] = normalizedModules;
  }
  final umbrella = normalizeUmbrellaHostProps(
    props: out,
    modules: _galleryModules,
    roleAliases: _galleryRegistryRoleAliases,
    manifestDefaults: _galleryManifestDefaults,
  );
  out['manifest'] = umbrella['manifest'];
  out['registries'] = umbrella['registries'];
  return out;
}

Map<String, Object?>? _sectionProps(Map<String, Object?> props, String key) {
  final normalized = _norm(key);
  final manifest = _coerceObjectMap(props['manifest']);
  final enabled = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _galleryModules,
  );
  if (enabled.isNotEmpty && !enabled.contains(normalized)) {
    return null;
  }
  final section = props[normalized];
  if (section is Map) {
    return <String, Object?>{
      ...coerceObjectMap(section),
      'events': props['events'],
    };
  }
  if (section == true) {
    return <String, Object?>{'events': props['events']};
  }
  final modules = _coerceObjectMap(props['modules']);
  final fromModules = modules[normalized];
  if (fromModules is Map) {
    return <String, Object?>{
      ...coerceObjectMap(fromModules),
      'events': props['events'],
    };
  }
  if (fromModules == true) {
    return <String, Object?>{'events': props['events']};
  }
  return null;
}

Map<String, Object?> _coerceObjectMap(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

String _norm(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

double _resolveRadius(
  Map<String, Object?> props, {
  Map<String, Object?>? parent,
  double fallback = 10,
}) {
  return coerceDouble(props['radius'] ?? parent?['radius']) ?? fallback;
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

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
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
                _emitEvent(controlId, props, sendEvent, 'action', {
                  'id': (map['id'] ?? map['value'] ?? map['label'] ?? '')
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
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

class _SortBar extends StatelessWidget {
  const _SortBar({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
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

    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButton<String>(
      value: options.contains(selected) ? selected : options.first,
      items: options
          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
          .toList(growable: false),
      onChanged: (value) {
        if (value == null) return;
        _emitEvent(controlId, props, sendEvent, 'sort_change', {
          'value': value,
        });
      },
    );
  }
}

class _GridLayout extends StatelessWidget {
  const _GridLayout({
    required this.props,
    required this.rawChildren,
    required this.buildChild,
  });

  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;

  @override
  Widget build(BuildContext context) {
    final columns = (coerceOptionalInt(props['columns']) ?? 3).clamp(1, 8);
    final spacing = coerceDouble(props['spacing']) ?? 10;
    final childMaps = rawChildren
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
          : childMaps.map(buildChild).toList(growable: false),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

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
      onTap: () =>
          _emitEvent(controlId, props, sendEvent, 'select', {'id': id}),
    );
  }
}

class _ItemActions extends StatelessWidget {
  const _ItemActions({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final actions = props['actions'] is List
        ? (props['actions'] as List)
        : const <dynamic>[];
    return Wrap(
      spacing: 6,
      children: [
        for (final action in actions)
          FilledButton.tonal(
            onPressed: () => _emitEvent(controlId, props, sendEvent, 'action', {
              'action': action,
            }),
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

class _ItemBadge extends StatelessWidget {
  const _ItemBadge({required this.props});

  final Map<String, Object?> props;

  @override
  Widget build(BuildContext context) {
    final text = (props['text'] ?? props['label'] ?? '').toString();
    return Chip(label: Text(text));
  }
}

class _ItemMetaRow extends StatelessWidget {
  const _ItemMetaRow({required this.props});

  final Map<String, Object?> props;

  @override
  Widget build(BuildContext context) {
    final items = props['items'] is List
        ? (props['items'] as List)
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

class _ItemPreview extends StatelessWidget {
  const _ItemPreview({
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.radius,
  });

  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final double radius;

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
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Text(label),
    );
  }
}

class _ItemSelectable extends StatelessWidget {
  const _ItemSelectable({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final selected = props['selected'] == true;
    return CheckboxListTile(
      value: selected,
      title: Text(
        (props['label'] ?? props['title'] ?? 'Selectable').toString(),
      ),
      onChanged: (value) => _emitEvent(
        controlId,
        props,
        sendEvent,
        'select_change',
        {'selected': value == true},
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final page = (coerceOptionalInt(props['page']) ?? 1).clamp(1, 1000000);
    final pageCount =
        (coerceOptionalInt(props['page_count'] ?? props['pages']) ?? 1).clamp(
          1,
          1000000,
        );
    final enabled = props['enabled'] == null
        ? true
        : (props['enabled'] == true);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: enabled && page > 1
              ? () => _emitEvent(controlId, props, sendEvent, 'page_change', {
                  'page': page - 1,
                })
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text('$page / $pageCount'),
        IconButton(
          onPressed: enabled && page < pageCount
              ? () => _emitEvent(controlId, props, sendEvent, 'page_change', {
                  'page': page + 1,
                })
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

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
          onPressed: () => _emitEvent(
            controlId,
            props,
            sendEvent,
            'section_action',
            {'id': props['id']},
          ),
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}

class _FontPicker extends StatelessWidget {
  const _FontPicker({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
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
        _emitEvent(controlId, props, sendEvent, 'font_change', {'font': next});
      },
    );
  }
}

class _AssetPicker extends StatelessWidget {
  const _AssetPicker({
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
    final label = (props['label'] ?? controlType.replaceAll('_', ' '))
        .toString();
    return OutlinedButton.icon(
      onPressed: () => _emitEvent(controlId, props, sendEvent, 'pick', {
        'kind': controlType,
      }),
      icon: const Icon(Icons.attach_file),
      label: Text(label),
    );
  }
}

class _ItemHandle extends StatelessWidget {
  const _ItemHandle({
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
      onPressed: () => _emitEvent(controlId, props, sendEvent, 'drag_handle', {
        'kind': controlType,
      }),
      icon: const Icon(Icons.drag_indicator),
    );
  }
}

class _ItemDropTarget extends StatelessWidget {
  const _ItemDropTarget({
    required this.controlId,
    required this.props,
    required this.radius,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final double radius;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: coerceDouble(props['height']) ?? 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextButton(
        onPressed: () =>
            _emitEvent(controlId, props, sendEvent, 'drop_target', {}),
        child: Text((props['label'] ?? 'Drop Target').toString()),
      ),
    );
  }
}

class _SelectionCheckbox extends StatelessWidget {
  const _SelectionCheckbox({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final selected = props['selected'] == true;
    return Checkbox(
      value: selected,
      onChanged: (value) => _emitEvent(
        controlId,
        props,
        sendEvent,
        'select_change',
        {'selected': value == true},
      ),
    );
  }
}

class _SelectionRadio extends StatelessWidget {
  const _SelectionRadio({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final selected = props['selected'] == true;
    return Radio<bool>(
      value: true,
      groupValue: selected,
      onChanged: (value) => _emitEvent(
        controlId,
        props,
        sendEvent,
        'select_change',
        {'selected': value == true},
      ),
    );
  }
}

class _SelectionSwitch extends StatelessWidget {
  const _SelectionSwitch({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final selected = props['selected'] == true;
    return Switch(
      value: selected,
      onChanged: (value) => _emitEvent(
        controlId,
        props,
        sendEvent,
        'select_change',
        {'selected': value},
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
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
    final label = (props['label'] ?? controlType.replaceAll('_', ' '))
        .toString();
    return FilledButton.tonal(
      onPressed: () => _emitEvent(controlId, props, sendEvent, controlType, {
        'value': props['value'],
        'payload': props['payload'],
      }),
      child: Text(label),
    );
  }
}

class _CollectionModule extends StatelessWidget {
  const _CollectionModule({
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
    final items = props['items'] is List
        ? (props['items'] as List)
        : const <dynamic>[];
    if (items.isEmpty) {
      return Text(
        '${controlType.replaceAll('_', ' ')}: empty',
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
            onPressed: () => _emitEvent(controlId, props, sendEvent, 'select', {
              'module': controlType,
              'item': item,
            }),
          ),
      ],
    );
  }
}

class _RendererModule extends StatelessWidget {
  const _RendererModule({
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
    final label =
        (props['label'] ?? props['title'] ?? controlType.replaceAll('_', ' '))
            .toString();
    final value = (props['text'] ?? props['src'] ?? props['font'] ?? '')
        .toString();
    return Container(
      width: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(_resolveRadius(props, fallback: 8)),
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
            onPressed: () => _emitEvent(controlId, props, sendEvent, 'select', {
              'module': controlType,
              'value': value,
            }),
            child: const Text('Use'),
          ),
        ],
      ),
    );
  }
}
