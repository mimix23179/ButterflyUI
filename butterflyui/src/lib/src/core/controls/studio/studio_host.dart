import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'studio_contract.dart';
import 'studio_core/cache/studio_cache_service.dart';
import 'studio_core/commands/studio_command_service.dart';
import 'studio_core/panels/studio_panel_service.dart';
import 'studio_core/project/studio_asset_service.dart';
import 'studio_core/project/studio_project_service.dart';
import 'studio_core/render/studio_render_service.dart';
import 'studio_core/selection/studio_selection_service.dart';
import 'studio_core/shortcuts/studio_shortcut_service.dart';
import 'studio_core/tool/studio_tool_service.dart';
import 'studio_core/transform/studio_transform_service.dart';
import 'studio_integrations/studio_candy_bridge.dart';
import 'studio_integrations/studio_plugin_api.dart';
import 'studio_integrations/studio_registry_bus.dart';
import 'studio_manifest.dart';
import 'studio_media/ffmpeg_bridge/studio_ffmpeg_bridge.dart';
import 'studio_media/playback/studio_playback_service.dart';
import 'studio_media/recording/studio_recording_bridge.dart';
import 'studio_media/waveforms/studio_waveform_service.dart';

class StudioHostEngine implements StudioPluginHost {
  StudioHostEngine(Map<String, Object?> initialProps)
    : _props = normalizeStudioProps(initialProps),
      commandService = StudioCommandService() {
    _seedStudioDefaults();
    _hydrateServices();
    _writeServiceProps();
  }

  Map<String, Object?> _props;

  final StudioProjectService projectService = StudioProjectService();
  final StudioAssetService assetService = StudioAssetService();
  final StudioCommandService commandService;
  final StudioSelectionService selectionService = StudioSelectionService();
  final StudioToolService toolService = StudioToolService();
  final StudioShortcutService shortcutService = StudioShortcutService();
  final StudioPanelService panelService = StudioPanelService();
  final StudioTransformService transformService = StudioTransformService();
  final StudioRenderService renderService = StudioRenderService();
  final StudioCacheService cacheService = StudioCacheService();
  final StudioRegistryBus registryBus = StudioRegistryBus();
  final StudioCandyBridge candyBridge = StudioCandyBridge();

  final StudioFfmpegBridge ffmpegBridge = StudioFfmpegBridge();
  final StudioPlaybackService playbackService = StudioPlaybackService();
  final StudioWaveformService waveformService = StudioWaveformService();
  final StudioRecordingBridge recordingBridge = StudioRecordingBridge();

  late StudioManifest _manifest;

  Map<String, Object?> get props => _props;

  StudioManifest get manifest => _manifest;

  int get undoDepth => commandService.undoDepth;

  int get redoDepth => commandService.redoDepth;

  List<Map<String, Object?>> get history => commandService.history;

  void replaceProps(Map<String, Object?> nextProps) {
    _props = normalizeStudioProps(nextProps);
    _seedStudioDefaults();
    _hydrateServices();
    _writeServiceProps();
  }

  Map<String, Object?> stateSnapshot() {
    return <String, Object?>{
      'schema_version': _props['schema_version'] ?? studioSchemaVersion,
      'module': _props['module'],
      'state': _props['state'],
      'props': _props,
      'manifest': _manifest.toMap(),
      'selection': selectionService.toMap(),
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
      'history': history,
    };
  }

  Map<String, Object?> setProps(
    Map<String, Object?> incoming, {
    bool recordHistory = false,
  }) {
    final before = deepCopyStudioMap(_props);
    _props.addAll(incoming);
    _props = normalizeStudioProps(_props);
    _seedStudioDefaults();
    _hydrateServices();
    _writeServiceProps();
    final after = deepCopyStudioMap(_props);
    if (recordHistory) {
      commandService.push(
        label: 'set_props',
        kind: 'change',
        payload: incoming,
        before: before,
        after: after,
      );
    } else {
      commandService.appendAudit(
        kind: 'change',
        label: 'set_props',
        payload: incoming,
      );
    }
    return _props;
  }

  Map<String, Object?> setModule(
    String module,
    Map<String, Object?> payload, {
    bool recordHistory = true,
  }) {
    final normalized = normalizeStudioModuleToken(module);
    if (!studioModules.contains(normalized)) {
      return <String, Object?>{'ok': false, 'error': 'unknown module: $module'};
    }
    return _mutate(
      label: 'set_module:$normalized',
      kind: 'module_change',
      payload: <String, Object?>{'module': normalized, 'payload': payload},
      recordHistory: recordHistory,
      mutate: () {
        final modules = studioCoerceObjectMap(_props['modules']);
        modules[normalized] = payload;
        _props['modules'] = modules;
        _props[normalized] = payload;
        _props['module'] = normalized;
        if (studioSurfaceModules.contains(normalized)) {
          selectionService.setActiveSurface(normalized);
        }
      },
      result: <String, Object?>{'ok': true, 'module': normalized},
    );
  }

  Map<String, Object?> setState(String state, {bool recordHistory = true}) {
    final normalized = studioNorm(state);
    if (!studioStates.contains(normalized)) {
      return <String, Object?>{'ok': false, 'error': 'unknown state: $state'};
    }
    return _mutate(
      label: 'set_state:$normalized',
      kind: 'state_change',
      payload: <String, Object?>{'state': normalized},
      recordHistory: recordHistory,
      mutate: () {
        _props['state'] = normalized;
      },
      result: <String, Object?>{'ok': true, 'state': normalized},
    );
  }

  Map<String, Object?> setManifest(
    Map<String, Object?> manifestPayload, {
    bool recordHistory = true,
  }) {
    final merged = <String, Object?>{..._manifest.toMap(), ...manifestPayload};
    return _mutate(
      label: 'set_manifest',
      kind: 'change',
      payload: <String, Object?>{'manifest': merged},
      recordHistory: recordHistory,
      mutate: () {
        _props['manifest'] = merged;
        _manifest = StudioManifest.fromProps(_props);
      },
      result: <String, Object?>{'ok': true, 'manifest': merged},
    );
  }

  @override
  Map<String, Object?> registerModule({
    required String role,
    required String moduleId,
    Map<String, Object?> definition = const <String, Object?>{},
    bool recordHistory = true,
  }) {
    final registration = registryBus.register(role, moduleId, definition);
    if (registration['ok'] != true) {
      return registration;
    }
    final normalizedRole = normalizeStudioRegistryRole(role);
    final normalizedId = normalizeStudioModuleToken(moduleId);

    return _mutate(
      label: 'register_module:$normalizedRole/$normalizedId',
      kind: 'change',
      payload: <String, Object?>{
        'role': normalizedRole,
        'module_id': normalizedId,
        'definition': definition,
      },
      recordHistory: recordHistory,
      mutate: () {
        final nextManifest = _manifest.toMap();
        final listKey = studioManifestListForRole(normalizedRole);
        if (listKey != null) {
          final values = studioCoerceStringList(nextManifest[listKey]).toList();
          final manifestValue = listKey == 'enabled_surfaces'
              ? normalizeStudioSurfaceToken(normalizedId)
              : normalizedId;
          if (manifestValue.isNotEmpty && !values.contains(manifestValue)) {
            values.add(manifestValue);
          }
          nextManifest[listKey] = values;
        }

        switch (normalizedRole) {
          case 'module_registry':
            if (studioModules.contains(normalizedId)) {
              final modules = studioCoerceObjectMap(_props['modules']);
              modules.putIfAbsent(normalizedId, () => <String, Object?>{});
              _props['modules'] = modules;
            }
            break;
          case 'tool_registry':
            toolService.registerTool(normalizedId, definition);
            break;
          case 'panel_registry':
            panelService.registerPanel(normalizedId, definition);
            break;
          case 'surface_registry':
            if (studioSurfaceModules.contains(normalizedId)) {
              final modules = studioCoerceObjectMap(_props['modules']);
              modules.putIfAbsent(normalizedId, () => <String, Object?>{});
              _props['modules'] = modules;
            }
            break;
        }

        _props['manifest'] = nextManifest;
        _props['registries'] = registryBus.toMap();
        _manifest = StudioManifest.fromProps(_props);
      },
      result: <String, Object?>{
        'ok': true,
        'role': normalizedRole,
        'module_id': normalizedId,
      },
    );
  }

  Map<String, Object?> setSelection(
    Map<String, Object?> payload, {
    bool recordHistory = true,
  }) {
    final ids = studioCoerceStringList(payload['selected_ids']).toList();
    final selectedId =
        (payload['selected_id'] ??
                payload['entity_id'] ??
                payload['node_id'] ??
                payload['id'] ??
                '')
            .toString()
            .trim();
    if (selectedId.isNotEmpty && !ids.contains(selectedId)) {
      ids.insert(0, selectedId);
    }
    final activeSurface = normalizeStudioSurfaceToken(
      (payload['active_surface'] ?? payload['surface'] ?? '').toString(),
    );
    final focusedPanel = normalizeStudioModuleToken(
      (payload['focused_panel'] ?? payload['panel'] ?? '').toString(),
    );

    return _mutate(
      label: 'set_selection',
      kind: 'select',
      payload: <String, Object?>{
        'selected_id': selectedId,
        'selected_ids': ids,
        if (activeSurface.isNotEmpty) 'active_surface': activeSurface,
        if (focusedPanel.isNotEmpty) 'focused_panel': focusedPanel,
      },
      recordHistory: recordHistory,
      mutate: () {
        if (ids.isEmpty && selectedId.isEmpty) {
          selectionService.clear();
        } else if (ids.isNotEmpty) {
          selectionService.selectMany(ids);
        } else {
          selectionService.selectOne(selectedId);
        }
        if (activeSurface.isNotEmpty) {
          selectionService.setActiveSurface(activeSurface);
          _props['module'] = activeSurface;
        }
        if (focusedPanel.isNotEmpty) {
          selectionService.setFocusedPanel(focusedPanel);
          panelService.focus(focusedPanel);
        }
      },
      result: <String, Object?>{
        'ok': true,
        'selected_id': selectionService.selectedId,
        'selected_ids': selectionService.selectedIds.toList(growable: false),
        'active_surface': selectionService.activeSurface,
        'focused_panel': selectionService.focusedPanel,
      },
    );
  }

  Map<String, Object?> setTool(String tool, {bool recordHistory = true}) {
    final normalized = studioNorm(tool);
    if (normalized.isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'tool is required'};
    }
    return _mutate(
      label: 'set_tool:$normalized',
      kind: 'change',
      payload: <String, Object?>{'tool': normalized},
      recordHistory: recordHistory,
      mutate: () {
        toolService.activate(normalized);
        selectionService.setTool(toolService.activeTool);
      },
      result: <String, Object?>{'ok': true, 'tool': toolService.activeTool},
    );
  }

  Map<String, Object?> setActiveSurface(
    String surface, {
    bool recordHistory = true,
  }) {
    final normalized = normalizeStudioSurfaceToken(surface);
    if (!studioSurfaceModules.contains(normalized)) {
      return <String, Object?>{
        'ok': false,
        'error': 'unknown surface: $surface',
      };
    }
    return _mutate(
      label: 'set_active_surface:$normalized',
      kind: 'change',
      payload: <String, Object?>{'active_surface': normalized},
      recordHistory: recordHistory,
      mutate: () {
        selectionService.setActiveSurface(normalized);
        _props['module'] = normalized;
      },
      result: <String, Object?>{'ok': true, 'active_surface': normalized},
    );
  }

  Map<String, Object?> focusPanel(String panelId, {bool recordHistory = true}) {
    final normalized = normalizeStudioModuleToken(panelId);
    if (normalized.isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'panel_id is required'};
    }
    return _mutate(
      label: 'focus_panel:$normalized',
      kind: 'change',
      payload: <String, Object?>{'focused_panel': normalized},
      recordHistory: recordHistory,
      mutate: () {
        panelService.focus(normalized);
        selectionService.setFocusedPanel(panelService.focusedPanel);
      },
      result: <String, Object?>{
        'ok': true,
        'focused_panel': panelService.focusedPanel,
      },
    );
  }

  Map<String, Object?> registerShortcut({
    required String context,
    required String chord,
    required String command,
    Map<String, Object?> payload = const <String, Object?>{},
    bool recordHistory = true,
  }) {
    final registration = shortcutService.register(
      context: context,
      chord: chord,
      command: command,
      payload: payload,
    );
    if (registration['ok'] != true) {
      return registration;
    }
    return _mutate(
      label: 'register_shortcut:$context/$chord',
      kind: 'change',
      payload: registration,
      recordHistory: recordHistory,
      mutate: () {},
      result: registration,
    );
  }

  Map<String, Object?> setDockLayout(
    Map<String, Object?> layout, {
    bool recordHistory = true,
  }) {
    return _mutate(
      label: 'set_dock_layout',
      kind: 'change',
      payload: <String, Object?>{'layout': layout},
      recordHistory: recordHistory,
      mutate: () {
        panelService.setLayout(layout);
      },
      result: <String, Object?>{'ok': true, 'layout': layout},
    );
  }

  Map<String, Object?> importAsset(
    String path, {
    String mode = 'copy',
    Map<String, Object?> metadata = const <String, Object?>{},
    bool recordHistory = true,
  }) {
    if (path.trim().isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'path is required'};
    }
    Map<String, Object?>? asset;
    return _mutate(
      label: 'import_asset',
      kind: 'change',
      payload: <String, Object?>{
        'path': path,
        'mode': mode,
        'metadata': metadata,
      },
      recordHistory: recordHistory,
      mutate: () {
        asset = assetService.importAsset(
          path: path,
          mode: mode,
          metadata: metadata,
        );
        projectService.registerAsset(
          path: path,
          metadata: asset ?? <String, Object?>{},
        );
      },
      result: <String, Object?>{
        'ok': true,
        'asset': asset ?? <String, Object?>{},
      },
    );
  }

  Map<String, Object?> enqueueExport({
    required String format,
    required Map<String, Object?> payload,
    bool recordHistory = true,
  }) {
    if (studioNorm(format).isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'format is required'};
    }
    Map<String, Object?>? job;
    return _mutate(
      label: 'enqueue_export',
      kind: 'change',
      payload: <String, Object?>{'format': format, 'payload': payload},
      recordHistory: recordHistory,
      mutate: () {
        job = renderService.enqueueExport(
          format: studioNorm(format),
          payload: payload,
        );
        final ffmpegCommand = (payload['ffmpeg_command'] ?? '')
            .toString()
            .trim();
        if (ffmpegCommand.isNotEmpty) {
          ffmpegBridge.enqueue(
            command: ffmpegCommand,
            args: studioCoerceStringList(payload['ffmpeg_args']),
            payload: payload,
          );
        }
      },
      result: <String, Object?>{'ok': true, 'job': job ?? <String, Object?>{}},
    );
  }

  Map<String, Object?> executeCommand(Map<String, Object?> args) {
    final payload = args['payload'] is Map
        ? coerceObjectMap(args['payload'] as Map)
        : <String, Object?>{...args};
    final commandType = studioNorm(
      (args['type'] ?? args['command'] ?? payload['type'] ?? 'update_module')
          .toString(),
    );
    final label = (args['label'] ?? payload['label'] ?? commandType).toString();

    switch (commandType) {
      case 'set_state':
        return setState(
          (payload['state'] ?? '').toString(),
          recordHistory: true,
        );
      case 'set_module':
        return setModule(
          (payload['module'] ?? '').toString(),
          studioCoerceObjectMap(
            payload['module_payload'] ?? payload['payload'],
          ),
          recordHistory: true,
        );
      case 'set_selection':
        return setSelection(payload, recordHistory: true);
      case 'set_tool':
      case 'activate_tool':
        return setTool(
          (payload['tool'] ?? payload['active_tool'] ?? '').toString(),
          recordHistory: true,
        );
      case 'set_manifest':
        return setManifest(
          studioCoerceObjectMap(payload['manifest']),
          recordHistory: true,
        );
      case 'register_module':
        return registerModule(
          role: (payload['role'] ?? '').toString(),
          moduleId: (payload['module_id'] ?? payload['id'] ?? '').toString(),
          definition: studioCoerceObjectMap(payload['definition']),
          recordHistory: true,
        );
      case 'register_shortcut':
        return registerShortcut(
          context: (payload['context'] ?? payload['scope'] ?? 'global')
              .toString(),
          chord: (payload['chord'] ?? payload['keys'] ?? '').toString(),
          command: (payload['shortcut_command'] ?? payload['command'] ?? '')
              .toString(),
          payload: studioCoerceObjectMap(payload['shortcut_payload']),
          recordHistory: true,
        );
      case 'set_dock_layout':
        return setDockLayout(studioCoerceObjectMap(payload['layout']));
      case 'focus_panel':
        return focusPanel(
          (payload['panel'] ?? payload['panel_id'] ?? '').toString(),
          recordHistory: true,
        );
      case 'set_active_surface':
        return setActiveSurface(
          (payload['surface'] ?? payload['active_surface'] ?? '').toString(),
          recordHistory: true,
        );
      case 'import_asset':
        return importAsset(
          (payload['path'] ?? payload['asset_path'] ?? '').toString(),
          mode: (payload['mode'] ?? 'copy').toString(),
          metadata: studioCoerceObjectMap(payload['metadata']),
          recordHistory: true,
        );
      case 'enqueue_export':
      case 'export':
        return enqueueExport(
          format: (payload['format'] ?? 'png').toString(),
          payload: payload,
          recordHistory: true,
        );
      case 'set_zoom':
        return _mutate(
          label: 'set_zoom',
          kind: 'change',
          payload: payload,
          recordHistory: true,
          mutate: () {
            final responsive =
                studioSectionProps(_props, 'responsive_toolbar') ?? {};
            responsive['zoom'] = coerceDouble(payload['zoom']) ?? 1.0;
            _props['responsive_toolbar'] = responsive;
            final modules = studioCoerceObjectMap(_props['modules']);
            modules['responsive_toolbar'] = responsive;
            _props['modules'] = modules;
          },
          result: <String, Object?>{'ok': true},
        );
      case 'set_viewport':
        return _mutate(
          label: 'set_viewport',
          kind: 'change',
          payload: payload,
          recordHistory: true,
          mutate: () {
            final responsive =
                studioSectionProps(_props, 'responsive_toolbar') ?? {};
            responsive['width'] =
                coerceDouble(payload['width'] ?? payload['w']) ?? 1280;
            responsive['height'] =
                coerceDouble(payload['height'] ?? payload['h']) ?? 720;
            if (payload['device'] != null) {
              responsive['device'] = payload['device'];
            }
            if (payload['portrait'] != null) {
              responsive['portrait'] = payload['portrait'] == true;
            }
            _props['responsive_toolbar'] = responsive;
            final modules = studioCoerceObjectMap(_props['modules']);
            modules['responsive_toolbar'] = responsive;
            _props['modules'] = modules;
          },
          result: <String, Object?>{'ok': true},
        );
      case 'begin_transaction':
        commandService.beginTransaction(label);
        return <String, Object?>{'ok': true, 'transaction': 'begun'};
      case 'end_transaction':
        commandService.endTransaction();
        return <String, Object?>{'ok': true, 'transaction': 'ended'};
      case 'set_playback':
        return _mutate(
          label: 'set_playback',
          kind: 'change',
          payload: payload,
          recordHistory: true,
          mutate: () {
            playbackService.loadFrom(payload);
          },
          result: <String, Object?>{'ok': true},
        );
      case 'ffmpeg_enqueue':
        return _mutate(
          label: 'ffmpeg_enqueue',
          kind: 'change',
          payload: payload,
          recordHistory: true,
          mutate: () {
            ffmpegBridge.enqueue(
              command: (payload['command'] ?? '').toString(),
              args: studioCoerceStringList(payload['args']),
              payload: payload,
            );
          },
          result: <String, Object?>{'ok': true},
        );
      case 'update_module':
      default:
        final module = (payload['module'] ?? '').toString();
        if (module.trim().isEmpty) {
          return setProps(payload, recordHistory: true);
        }
        return setModule(
          module,
          studioCoerceObjectMap(
            payload['module_payload'] ?? payload['payload'] ?? payload['patch'],
          ),
          recordHistory: true,
        );
    }
  }

  Map<String, Object?> undo() {
    final entry = commandService.undo();
    if (entry == null) {
      return <String, Object?>{'ok': false, 'error': 'nothing to undo'};
    }
    _props = normalizeStudioProps(entry.before);
    _hydrateServices();
    _writeServiceProps();
    return <String, Object?>{
      'ok': true,
      'label': entry.label,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> redo() {
    final entry = commandService.redo();
    if (entry == null) {
      return <String, Object?>{'ok': false, 'error': 'nothing to redo'};
    }
    _props = normalizeStudioProps(entry.after);
    _seedStudioDefaults();
    _hydrateServices();
    _writeServiceProps();
    return <String, Object?>{
      'ok': true,
      'label': entry.label,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> _mutate({
    required String label,
    required String kind,
    required Map<String, Object?> payload,
    required bool recordHistory,
    required void Function() mutate,
    required Map<String, Object?> result,
  }) {
    final before = deepCopyStudioMap(_props);
    mutate();
    _props = normalizeStudioProps(_props);
    _seedStudioDefaults();
    _hydrateServices();
    _writeServiceProps();
    final after = deepCopyStudioMap(_props);
    if (recordHistory) {
      commandService.push(
        label: label,
        kind: kind,
        payload: payload,
        before: before,
        after: after,
      );
    } else {
      commandService.appendAudit(kind: kind, label: label, payload: payload);
    }
    return <String, Object?>{
      ...result,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  void _seedStudioDefaults() {
    final modules = studioCoerceObjectMap(_props['modules']);

    Map<String, Object?> ensureModule(
      String module,
      Map<String, Object?> defaults,
    ) {
      final fromTopLevel = studioCoerceObjectMap(_props[module]);
      final fromModules = studioCoerceObjectMap(modules[module]);
      final merged = <String, Object?>{
        ...defaults,
        ...fromModules,
        ...fromTopLevel,
      };
      modules[module] = merged;
      _props[module] = merged;
      return merged;
    }

    ensureModule('builder', <String, Object?>{
      'title': 'Studio Builder',
      'subtitle': 'Manifest-driven visual workbench',
    });
    ensureModule('canvas', <String, Object?>{
      'background': '#0b1220',
      'grid_size': 24,
      'world_width': 2200,
      'world_height': 1400,
      'entities': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'hero_card',
          'label': 'Hero Card',
          'x': 120,
          'y': 120,
          'width': 360,
          'height': 220,
          'color': '#1f2937',
        },
        <String, Object?>{
          'id': 'headline',
          'label': 'Headline',
          'x': 560,
          'y': 140,
          'width': 300,
          'height': 76,
          'color': '#115e59',
        },
      ],
    });
    ensureModule('timeline_surface', <String, Object?>{
      'tracks': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'intro',
          'label': 'Intro Fade',
          'start': 0.0,
          'duration': 1.2,
        },
        <String, Object?>{
          'id': 'cta',
          'label': 'CTA Pulse',
          'start': 1.3,
          'duration': 0.8,
        },
      ],
      'playhead_seconds': 0.6,
      'duration_seconds': 8.0,
      'pixels_per_second': 120.0,
    });
    ensureModule('node_surface', <String, Object?>{
      'nodes': <Map<String, Object?>>[
        <String, Object?>{'id': 'start', 'label': 'Start'},
        <String, Object?>{'id': 'transform', 'label': 'Transform'},
        <String, Object?>{'id': 'output', 'label': 'Output'},
      ],
      'edges': <Map<String, Object?>>[
        <String, Object?>{'from': 'start', 'to': 'transform'},
        <String, Object?>{'from': 'transform', 'to': 'output'},
      ],
      'world_width': 2800,
      'world_height': 1600,
    });
    ensureModule('preview_surface', <String, Object?>{
      'title': 'Preview',
      'subtitle': 'Live render surface',
      'status': 'ready',
    });
    ensureModule('project_panel', <String, Object?>{
      'project': <String, Object?>{
        'name': 'ButterflyUI Studio',
        'target': 'desktop',
      },
    });
    ensureModule('outline_tree', <String, Object?>{
      'nodes': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'root',
          'label': 'root',
          'children': <Map<String, Object?>>[
            <String, Object?>{'id': 'hero_card', 'label': 'hero_card'},
          ],
        },
      ],
    });
    ensureModule('component_palette', <String, Object?>{
      'blocks': <Map<String, Object?>>[
        <String, Object?>{'id': 'row', 'label': 'Row'},
        <String, Object?>{'id': 'column', 'label': 'Column'},
        <String, Object?>{'id': 'surface', 'label': 'Surface'},
        <String, Object?>{'id': 'button', 'label': 'Button'},
      ],
    });
    ensureModule('block_palette', <String, Object?>{
      'blocks': <Map<String, Object?>>[
        <String, Object?>{'id': 'if', 'label': 'If'},
        <String, Object?>{'id': 'for_each', 'label': 'For Each'},
        <String, Object?>{'id': 'switch', 'label': 'Switch'},
      ],
      'query': '',
    });
    ensureModule('asset_browser', <String, Object?>{
      'assets': <Map<String, Object?>>[
        <String, Object?>{'id': 'hero_grid', 'label': 'hero_grid.png'},
        <String, Object?>{'id': 'font_jetbrains', 'label': 'JetBrains Mono'},
      ],
    });
    ensureModule('inspector', <String, Object?>{
      'node': <String, Object?>{
        'id': 'hero_card',
        'x': 120,
        'y': 120,
        'width': 360,
        'height': 220,
      },
    });
    ensureModule('properties_panel', <String, Object?>{
      'schema': <String, Object?>{'padding': 'number', 'radius': 'number'},
      'value': <String, Object?>{'padding': 20, 'radius': 16},
    });
    ensureModule('actions_editor', <String, Object?>{
      'actions': <String, Object?>{
        'onTap': <String, Object?>{'intent': 'navigate', 'target': '/home'},
      },
    });
    ensureModule('bindings_editor', <String, Object?>{
      'bindings': <String, Object?>{
        'text.value': 'state.headline',
        'button.enabled': 'state.can_submit',
      },
    });
    ensureModule('tokens_editor', <String, Object?>{
      'tokens': <String, Object?>{'color.primary': '#22d3ee'},
      'json': '{"color.primary":"#22d3ee"}',
    });
    ensureModule('selection_tools', <String, Object?>{
      'items': <Map<String, Object?>>[
        <String, Object?>{'id': 'select', 'label': 'Select'},
        <String, Object?>{'id': 'move', 'label': 'Move'},
        <String, Object?>{'id': 'resize', 'label': 'Resize'},
      ],
      'active_tool': 'select',
    });
    ensureModule('transform_toolbar', <String, Object?>{
      'items': <Map<String, Object?>>[
        <String, Object?>{'id': 'align_left', 'label': 'Align Left'},
        <String, Object?>{'id': 'align_center', 'label': 'Align Center'},
      ],
    });
    ensureModule('transform_box', <String, Object?>{
      'x': 120,
      'y': 120,
      'width': 360,
      'height': 220,
      'rotation': 0,
    });
    ensureModule('responsive_toolbar', <String, Object?>{
      'breakpoints': <Map<String, Object?>>[
        <String, Object?>{'id': 'desktop', 'width': 1440},
        <String, Object?>{'id': 'tablet', 'width': 1024},
        <String, Object?>{'id': 'mobile', 'width': 430},
      ],
      'current_id': 'desktop',
      'zoom': 1.0,
      'width': 1280.0,
      'height': 720.0,
    });

    final panels = studioCoerceObjectMap(_props['panels']);
    final layout = studioCoerceObjectMap(panels['layout']);
    if (studioCoerceStringList(layout['left']).isEmpty) {
      layout['left'] = <String>[
        'project_panel',
        'outline_tree',
        'asset_browser',
      ];
    }
    if (studioCoerceStringList(layout['right']).isEmpty) {
      layout['right'] = <String>[
        'inspector',
        'properties_panel',
        'tokens_editor',
        'actions_editor',
        'bindings_editor',
      ];
    }
    panels['layout'] = layout;
    _props['panels'] = panels;

    final manifest = studioCoerceObjectMap(_props['manifest']);
    final builtManifest = studioBuildManifest(_props);
    for (final key in const <String>[
      'enabled_modules',
      'enabled_surfaces',
      'enabled_panels',
      'enabled_tools',
    ]) {
      final values = studioCoerceStringList(
        manifest[key],
      ).toList(growable: true);
      if (values.isEmpty) {
        values.addAll(studioCoerceStringList(builtManifest[key]));
      }
      for (final module in modules.keys) {
        final normalized = normalizeStudioModuleToken(module);
        if (!studioModules.contains(normalized)) continue;
        if (key == 'enabled_surfaces' &&
            !studioSurfaceModules.contains(normalized)) {
          continue;
        }
        if (key == 'enabled_panels' &&
            !studioPanelModules.contains(normalized)) {
          continue;
        }
        if (!values.contains(normalized)) values.add(normalized);
      }
      manifest[key] = values;
    }
    _props['manifest'] = manifest;
    _props['modules'] = modules;
  }

  void _hydrateServices() {
    _manifest = StudioManifest.fromProps(_props);
    registryBus.loadFrom(studioCoerceObjectMap(_props['registries']));
    candyBridge.loadFrom(studioCoerceObjectMap(_props['candy_hooks']));

    final projectPanel = studioSectionProps(_props, 'project_panel') ?? {};
    final projectPayload = studioCoerceObjectMap(projectPanel['project']);
    final projectData = <String, Object?>{
      ...projectPayload,
      'documents': projectPanel['documents'] ?? _props['documents'],
      'assets': projectPanel['assets'] ?? _props['assets'],
    };
    projectService.loadFrom(projectData);

    final assetPayload = <String, Object?>{
      ...studioSectionProps(_props, 'asset_browser') ?? {},
      'assets':
          studioSectionProps(_props, 'asset_browser')?['assets'] ??
          _props['assets'] ??
          projectService.assets,
    };
    assetService.loadFrom(assetPayload);
    if (assetService.assets.isNotEmpty) {
      projectService.assets
        ..clear()
        ..addAll(assetService.assets);
    } else if (projectService.assets.isNotEmpty) {
      assetService.loadFrom(<String, Object?>{'assets': projectService.assets});
    }

    final selectionPayload =
        studioSectionProps(_props, 'selection_tools') ?? {};
    final moduleToken = normalizeStudioModuleToken(
      (_props['module'] ?? '').toString(),
    );
    selectionService.loadFrom(<String, Object?>{
      ...selectionPayload,
      'selected_id': _props['selected_id'] ?? selectionPayload['selected_id'],
      'selected_ids':
          _props['selected_ids'] ?? selectionPayload['selected_ids'],
      'active_tool': _props['active_tool'] ?? selectionPayload['active_tool'],
      'active_surface': studioSurfaceModules.contains(moduleToken)
          ? moduleToken
          : (selectionPayload['active_surface'] ?? 'canvas'),
      'focused_panel':
          _props['focused_panel'] ?? selectionPayload['focused_panel'],
    });

    toolService.loadFrom(<String, Object?>{
      ...(studioCoerceObjectMap(_props['tools'])),
      ...studioCoerceObjectMap(selectionPayload['tool_service']),
      'active_tool': selectionService.activeTool,
    });
    toolService.ensureTools(
      _manifest.enabledTools.isEmpty
          ? const <String>['select', 'move', 'resize', 'text']
          : _manifest.enabledTools,
    );
    if (selectionService.activeTool.isNotEmpty) {
      toolService.activate(selectionService.activeTool);
    }
    selectionService.setTool(toolService.activeTool);

    panelService.loadFrom(<String, Object?>{
      ...studioCoerceObjectMap(_props['panels']),
      'focused_panel': selectionService.focusedPanel,
    });
    panelService.ensurePanels(
      _manifest.enabledPanels.isEmpty
          ? studioPanelModules
          : _manifest.enabledPanels.map(normalizeStudioModuleToken),
    );
    selectionService.setFocusedPanel(panelService.focusedPanel);

    shortcutService.loadFrom(studioCoerceObjectMap(_props['shortcuts']));

    final selectedSurface = normalizeStudioSurfaceToken(
      selectionService.activeSurface,
    );
    if (!studioSurfaceModules.contains(selectedSurface)) {
      selectionService.setActiveSurface(
        _manifest.enabledSurfaces.isEmpty
            ? 'canvas'
            : _manifest.enabledSurfaces.first,
      );
    }

    transformService.loadFrom(
      studioSectionProps(_props, 'transform_box') ?? {},
    );
    renderService.loadFrom(studioCoerceObjectMap(_props['render']));
    cacheService.loadFrom(studioCoerceObjectMap(_props['cache']));

    final media = studioCoerceObjectMap(_props['media']);
    ffmpegBridge.loadFrom(studioCoerceObjectMap(media['ffmpeg_bridge']));
    playbackService.loadFrom(studioCoerceObjectMap(media['playback']));
    waveformService.loadFrom(studioCoerceObjectMap(media['waveforms']));
    recordingBridge.loadFrom(studioCoerceObjectMap(media['recording']));

    _ensureRegistryDefaultsFromManifest();
  }

  void _writeServiceProps() {
    _props['manifest'] = _manifest.toMap();
    _props['registries'] = registryBus.toMap();
    _props['candy_hooks'] = candyBridge.toMap();
    _props['shortcuts'] = shortcutService.toMap();
    _props['panels'] = panelService.toMap();

    final modules = studioCoerceObjectMap(_props['modules']);

    final projectPanel = studioSectionProps(_props, 'project_panel') ?? {};
    projectPanel['project'] = projectService.toMap();
    projectPanel['documents'] = projectService.documents;
    projectPanel['assets'] = projectService.assets;
    projectPanel['archive_preview'] = projectService.buildArchivePreview();
    modules['project_panel'] = projectPanel;
    _props['project_panel'] = projectPanel;
    _props['documents'] = projectService.documents;
    _props['assets'] = projectService.assets;

    final assetBrowser = studioSectionProps(_props, 'asset_browser') ?? {};
    assetBrowser['assets'] = assetService.assets;
    modules['asset_browser'] = assetBrowser;
    _props['asset_browser'] = assetBrowser;

    final selectionTools = studioSectionProps(_props, 'selection_tools') ?? {};
    selectionTools.addAll(selectionService.toMap());
    selectionTools['tool_service'] = toolService.toMap();
    selectionTools['items'] = toolService.registry.values.toList(
      growable: false,
    );
    modules['selection_tools'] = selectionTools;
    _props['selection_tools'] = selectionTools;
    _props['selected_id'] = selectionService.selectedId;
    _props['selected_ids'] = selectionService.selectedIds.toList(
      growable: false,
    );
    _props['active_tool'] = toolService.activeTool;
    _props['focused_panel'] = panelService.focusedPanel;

    final transformBox = studioSectionProps(_props, 'transform_box') ?? {};
    transformBox['entities'] = transformService.toMap()['entities'];
    modules['transform_box'] = transformBox;
    _props['transform_box'] = transformBox;

    final transformToolbar =
        studioSectionProps(_props, 'transform_toolbar') ?? {};
    transformToolbar['items'] = toolService.registry.values.toList(
      growable: false,
    );
    transformToolbar['active'] = toolService.activeTool;
    modules['transform_toolbar'] = transformToolbar;
    _props['transform_toolbar'] = transformToolbar;

    _props['render'] = renderService.toMap();
    _props['cache'] = cacheService.toMap();
    _props['media'] = <String, Object?>{
      'ffmpeg_bridge': ffmpegBridge.toMap(),
      'playback': playbackService.toMap(),
      'waveforms': waveformService.toMap(),
      'recording': recordingBridge.toMap(),
    };

    final builder = studioSectionProps(_props, 'builder') ?? {};
    final services = studioCoerceObjectMap(builder['services']);
    services['project'] = projectService.toMap();
    services['assets'] = assetService.toMap();
    services['selection'] = selectionService.toMap();
    services['tools'] = toolService.toMap();
    services['shortcuts'] = shortcutService.toMap();
    services['panels'] = panelService.toMap();
    services['transform'] = transformService.toMap();
    services['render'] = renderService.toMap();
    services['cache'] = cacheService.toMap();
    services['media'] = _props['media'];
    services['candy_hooks'] = candyBridge.toMap();
    services['commands'] = <String, Object?>{
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
      'history': history,
    };
    builder['services'] = services;
    builder['manifest'] = _manifest.toMap();
    builder['registries'] = registryBus.toMap();
    modules['builder'] = builder;
    _props['builder'] = builder;

    final actions = studioSectionProps(_props, 'actions_editor') ?? {};
    actions['history'] = history;
    actions['undo_depth'] = undoDepth;
    actions['redo_depth'] = redoDepth;
    modules['actions_editor'] = actions;
    _props['actions_editor'] = actions;

    final responsive = studioSectionProps(_props, 'responsive_toolbar') ?? {};
    responsive['zoom'] = coerceDouble(responsive['zoom']) ?? 1.0;
    responsive['width'] = coerceDouble(responsive['width']) ?? 1280.0;
    responsive['height'] = coerceDouble(responsive['height']) ?? 720.0;
    modules['responsive_toolbar'] = responsive;
    _props['responsive_toolbar'] = responsive;

    for (final surface in studioSurfaceModules) {
      final section = studioSectionProps(_props, surface) ?? {};
      modules[surface] = section;
      _props[surface] = section;
    }

    final currentModule = normalizeStudioModuleToken(
      (_props['module'] ?? '').toString(),
    );
    if (!studioModules.contains(currentModule)) {
      _props['module'] = selectionService.activeSurface;
    }
    _props['modules'] = modules;
  }

  void _ensureRegistryDefaultsFromManifest() {
    for (final surface in _manifest.enabledSurfaces) {
      registryBus.registerSurface(surface, <String, Object?>{
        'id': surface,
        'builtin': true,
      });
    }
    for (final panel in _manifest.enabledPanels) {
      registryBus.registerPanel(panel, <String, Object?>{
        'id': panel,
        'builtin': true,
      });
    }
    for (final tool in _manifest.enabledTools) {
      registryBus.registerTool(tool, <String, Object?>{
        'id': tool,
        'builtin': true,
      });
    }
    for (final importer in _manifest.importers) {
      registryBus.registerImporter(importer, <String, Object?>{
        'id': importer,
        'builtin': true,
      });
    }
    for (final exporter in _manifest.exporters) {
      registryBus.registerExporter(exporter, <String, Object?>{
        'id': exporter,
        'builtin': true,
      });
    }
  }
}
