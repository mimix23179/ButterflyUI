import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

import 'submodules/commands.dart';
import 'submodules/customization.dart';
import 'submodules/gallery_submodule_context.dart';
import 'submodules/items.dart';
import 'submodules/layout.dart';
import 'submodules/media.dart';

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
    'section_header',
    'search_bar',
    'filter_bar',
    'sort_bar',
    'grid_layout',
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
    'pagination',
    'fonts',
    'font_picker',
    'font_renderer',
    'image',
    'image_picker',
    'image_renderer',
    'video',
    'video_picker',
    'video_renderer',
    'audio',
    'audio_picker',
    'audio_renderer',
    'document',
    'document_picker',
    'document_renderer',
    'presets',
    'skins',
    'apply_font',
    'apply_image',
    'set_as_wallpaper',
    'apply',
    'clear',
    'select_all',
    'deselect_all',
    'empty_state',
    'loading_skeleton',
  ],
  'enabled_views': <String>[
    'grid_layout',
    'item_tile',
    'item_preview',
    'item_meta_row',
    'section_header',
  ],
  'enabled_panels': <String>[
    'toolbar',
    'section_header',
    'search_bar',
    'filter_bar',
    'sort_bar',
  ],
  'enabled_sources': <String>['project_assets', 'local_folder', 'remote_http'],
  'enabled_types': <String>[
    'image',
    'video',
    'audio',
    'document',
    'fonts',
    'skins',
  ],
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

    Widget? buildSection(String module) {
      final sec = _sectionProps(_runtimeProps, module);
      if (sec == null) return null;
      final ctx = GallerySubmoduleContext(
        controlId: widget.controlId,
        module: module,
        section: sec,
        onEmit: (event, payload) =>
            _emitEvent(widget.controlId, sec, widget.sendEvent, event, payload),
        sendEvent: widget.sendEvent,
        rawChildren: widget.rawChildren,
        buildChild: widget.buildChild,
        radius: _resolveRadius(sec, parent: _runtimeProps, fallback: tileRadius),
        registerInvokeHandler: widget.registerInvokeHandler,
        unregisterInvokeHandler: widget.unregisterInvokeHandler,
      );
      return buildGalleryLayoutSection(module, ctx) ??
          buildGalleryItemsSection(module, ctx) ??
          buildGalleryMediaSection(module, ctx) ??
          buildGalleryCommandsSection(module, ctx) ??
          buildGalleryCustomizationSection(module, ctx);
    }

    void addSection(List<Widget> list, String module) {
      final w = buildSection(module);
      if (w != null) list.add(w);
    }

    final sectionWidgets = <Widget>[];
    addSection(sectionWidgets, 'toolbar');
    addSection(sectionWidgets, 'section_header');
    addSection(sectionWidgets, 'search_bar');
    addSection(sectionWidgets, 'filter_bar');
    addSection(sectionWidgets, 'sort_bar');
    addSection(sectionWidgets, 'grid_layout');

    final allTiles = <Widget>[...itemTiles, ...childControls];
    if (allTiles.isNotEmpty) {
      sectionWidgets.add(
        Wrap(spacing: spacing, runSpacing: runSpacing, children: allTiles),
      );
    } else {
      final loading = buildSection('loading_skeleton');
      final empty = buildSection('empty_state');
      if (loading != null) sectionWidgets.add(loading);
      if (empty != null) sectionWidgets.add(empty);
      if (loading == null && empty == null) return const SizedBox.shrink();
    }

    final footerWidgets = <Widget>[];
    for (final module in const <String>[
      'item_tile',
      'item_actions',
      'item_badge',
      'item_meta_row',
      'item_preview',
      'item_selectable',
      'item_drag_handle',
      'item_drop_target',
      'item_reorder_handle',
      'item_selection_checkbox',
      'item_selection_radio',
      'item_selection_switch',
      'pagination',
      'font_picker',
      'fonts',
      'audio',
      'video',
      'image',
      'document',
      'presets',
      'skins',
      'font_renderer',
      'audio_renderer',
      'video_renderer',
      'image_renderer',
      'document_renderer',
      'audio_picker',
      'video_picker',
      'image_picker',
      'document_picker',
      'apply',
      'clear',
      'select_all',
      'deselect_all',
      'apply_font',
      'apply_image',
      'set_as_wallpaper',
    ]) {
      addSection(footerWidgets, module);
    }

    if (footerWidgets.isNotEmpty) {
      sectionWidgets.add(const SizedBox(height: 8));
      sectionWidgets.add(
        Wrap(spacing: 8, runSpacing: 8, children: footerWidgets),
      );
    }

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < sectionWidgets.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          sectionWidgets[i],
        ],
      ],
    );
    return ensureUmbrellaLayoutBounds(
      props: _runtimeProps,
      child: body,
      defaultHeight: 860,
      minHeight: 320,
      maxHeight: 3200,
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
  _seedGalleryDefaults(out);
  return out;
}

void _seedGalleryDefaults(Map<String, Object?> out) {
  final modules = _coerceObjectMap(out['modules']);

  Map<String, Object?> ensureModule(
    String module,
    Map<String, Object?> defaults,
  ) {
    final fromTopLevel = _coerceObjectMap(out[module]);
    final fromModules = _coerceObjectMap(modules[module]);
    final merged = <String, Object?>{
      ...defaults,
      ...fromModules,
      ...fromTopLevel,
    };
    modules[module] = merged;
    out[module] = merged;
    return merged;
  }

  if (out['items'] is! List || (out['items'] as List).isEmpty) {
    out['items'] = <Map<String, Object?>>[
      <String, Object?>{
        'id': 'font_jetbrains',
        'name': 'JetBrains Mono',
        'label': 'JetBrains Mono',
        'type': 'font',
      },
      <String, Object?>{
        'id': 'img_hero_grid',
        'name': 'Hero Grid',
        'label': 'Hero Grid',
        'type': 'image',
      },
      <String, Object?>{
        'id': 'video_showreel',
        'name': 'Showreel',
        'label': 'Showreel',
        'type': 'video',
      },
      <String, Object?>{
        'id': 'audio_startup',
        'name': 'Startup Chime',
        'label': 'Startup Chime',
        'type': 'audio',
      },
      <String, Object?>{
        'id': 'skin_obsidian',
        'name': 'Obsidian Neon',
        'label': 'Obsidian Neon',
        'type': 'skin',
      },
    ];
  }

  ensureModule('toolbar', <String, Object?>{
    'title': 'Gallery',
    'subtitle': 'Asset workbench',
    'actions': <Map<String, Object?>>[
      <String, Object?>{'id': 'import', 'label': 'Import'},
      <String, Object?>{'id': 'refresh', 'label': 'Refresh'},
      <String, Object?>{'id': 'batch_apply', 'label': 'Batch Apply'},
    ],
  });
  ensureModule('section_header', <String, Object?>{
    'id': 'featured',
    'title': 'Featured',
    'count': (out['items'] as List).length,
  });
  ensureModule('search_bar', <String, Object?>{
    'query': '',
    'placeholder': 'Search assets, tags, metadata...',
  });
  ensureModule('filter_bar', <String, Object?>{
    'filters': <String>['type:image', 'tag:hero', 'source:local'],
  });
  ensureModule('sort_bar', <String, Object?>{
    'options': <String>['name', 'date_added', 'type'],
    'selected': 'name',
  });
  ensureModule('grid_layout', <String, Object?>{
    'columns': 3,
    'spacing': coerceDouble(out['spacing']) ?? 12,
  });
  ensureModule('item_tile', <String, Object?>{
    'title': 'Item tile',
    'subtitle': 'Primary asset card',
  });
  ensureModule('item_badge', <String, Object?>{
    'label': 'Featured',
    'tone': 'accent',
  });
  ensureModule('item_meta_row', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'key': 'type', 'value': 'image'},
      <String, Object?>{'key': 'source', 'value': 'local'},
    ],
  });
  ensureModule('item_preview', <String, Object?>{
    'height': 96,
    'label': 'Preview',
  });
  ensureModule('item_actions', <String, Object?>{
    'actions': <Map<String, Object?>>[
      <String, Object?>{'id': 'preview', 'label': 'Preview'},
      <String, Object?>{'id': 'apply', 'label': 'Apply'},
      <String, Object?>{'id': 'delete', 'label': 'Delete'},
    ],
  });
  ensureModule('item_selectable', <String, Object?>{'selected': false});
  ensureModule('item_drag_handle', <String, Object?>{'label': 'drag'});
  ensureModule('item_drop_target', <String, Object?>{'label': 'drop target'});
  ensureModule('item_reorder_handle', <String, Object?>{'label': 'reorder'});
  ensureModule('item_selection_checkbox', <String, Object?>{
    'label': 'Checkbox select',
    'value': false,
  });
  ensureModule('item_selection_radio', <String, Object?>{
    'label': 'Radio select',
    'value': false,
  });
  ensureModule('item_selection_switch', <String, Object?>{
    'label': 'Switch select',
    'value': false,
  });
  ensureModule('pagination', <String, Object?>{'page': 1, 'page_count': 3});
  ensureModule('fonts', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'JetBrains Mono'},
      <String, Object?>{'name': 'IBM Plex Sans'},
    ],
  });
  ensureModule('font_picker', <String, Object?>{
    'items': <String>['JetBrains Mono', 'IBM Plex Sans'],
  });
  ensureModule('font_renderer', <String, Object?>{
    'sample': 'ButterflyUI',
    'font': 'JetBrains Mono',
  });
  ensureModule('image', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'hero_grid.png'},
      <String, Object?>{'name': 'terminal_bg.jpg'},
    ],
  });
  ensureModule('image_picker', <String, Object?>{
    'items': <String>['hero_grid.png', 'terminal_bg.jpg'],
  });
  ensureModule('image_renderer', <String, Object?>{'label': 'Image renderer'});
  ensureModule('video', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'showreel.mp4'},
    ],
  });
  ensureModule('video_picker', <String, Object?>{
    'items': <String>['showreel.mp4'],
  });
  ensureModule('video_renderer', <String, Object?>{'label': 'Video renderer'});
  ensureModule('audio', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'startup_chime.wav'},
    ],
  });
  ensureModule('audio_picker', <String, Object?>{
    'items': <String>['startup_chime.wav'],
  });
  ensureModule('audio_renderer', <String, Object?>{'label': 'Audio renderer'});
  ensureModule('document', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'design_spec.pdf'},
    ],
  });
  ensureModule('document_picker', <String, Object?>{
    'items': <String>['design_spec.pdf'],
  });
  ensureModule('document_renderer', <String, Object?>{
    'label': 'Document renderer',
  });
  ensureModule('presets', <String, Object?>{
    'items': <String>['featured', 'recent', 'favorites'],
  });
  ensureModule('skins', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'Obsidian Neon'},
      <String, Object?>{'name': 'Linen Paper'},
    ],
  });
  ensureModule('apply', <String, Object?>{'label': 'Apply'});
  ensureModule('clear', <String, Object?>{'label': 'Clear'});
  ensureModule('select_all', <String, Object?>{'label': 'Select all'});
  ensureModule('deselect_all', <String, Object?>{'label': 'Deselect all'});
  ensureModule('apply_font', <String, Object?>{'label': 'Apply font'});
  ensureModule('apply_image', <String, Object?>{'label': 'Apply image'});
  ensureModule('set_as_wallpaper', <String, Object?>{'label': 'Set wallpaper'});
  ensureModule('loading_skeleton', <String, Object?>{'lines': 3, 'height': 72});
  ensureModule('empty_state', <String, Object?>{
    'title': 'No assets found',
    'message': 'Import assets or change your filters.',
  });

  final manifest = _coerceObjectMap(out['manifest']);
  final enabledModules = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _galleryModules,
  ).toList(growable: true);
  if (enabledModules.isEmpty) {
    enabledModules.addAll(
      _galleryManifestDefaults['enabled_modules'] ?? const <String>[],
    );
  } else {
    for (final module in modules.keys) {
      final normalized = _norm(module);
      if (_galleryModules.contains(normalized) &&
          !enabledModules.contains(normalized)) {
        enabledModules.add(normalized);
      }
    }
  }
  manifest['enabled_modules'] = enabledModules;
  out['manifest'] = manifest;
  out['modules'] = modules;
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
