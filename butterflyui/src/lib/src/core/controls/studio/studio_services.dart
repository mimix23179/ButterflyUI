import 'dart:math';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'studio_contract.dart';

class StudioRuntimeStore {
  StudioRuntimeStore(Map<String, Object?> initialProps)
    : _props = normalizeStudioProps(initialProps);

  Map<String, Object?> _props;
  final List<Map<String, Object?>> _undoStack = <Map<String, Object?>>[];
  final List<Map<String, Object?>> _redoStack = <Map<String, Object?>>[];
  final List<Map<String, Object?>> _history = <Map<String, Object?>>[];
  int _nextCommandId = 1;

  Map<String, Object?> get props => _props;

  int get undoDepth => _undoStack.length;

  int get redoDepth => _redoStack.length;

  List<Map<String, Object?>> get history =>
      List<Map<String, Object?>>.unmodifiable(_history);

  Map<String, Object?> get manifest =>
      studioCoerceObjectMap(_props['manifest']);

  Map<String, Object?> get selection {
    final selectionSection =
        studioSectionProps(_props, 'selection_tools') ?? {};
    final selectedId = (selectionSection['selected_id'] ?? '').toString();
    final selectedIds = <String>[];
    final rawSelectedIds = selectionSection['selected_ids'];
    if (rawSelectedIds is List) {
      for (final entry in rawSelectedIds) {
        final id = entry?.toString().trim() ?? '';
        if (id.isNotEmpty && !selectedIds.contains(id)) {
          selectedIds.add(id);
        }
      }
    }
    if (selectedId.isNotEmpty && !selectedIds.contains(selectedId)) {
      selectedIds.insert(0, selectedId);
    }
    return <String, Object?>{
      'selected_id': selectedId,
      'selected_ids': selectedIds,
      'active_tool': (selectionSection['active_tool'] ?? '').toString(),
    };
  }

  void replaceProps(Map<String, Object?> next) {
    _props = normalizeStudioProps(next);
    _trimHistory();
  }

  Map<String, Object?> getStateSnapshot() {
    return <String, Object?>{
      'schema_version': _props['schema_version'] ?? studioSchemaVersion,
      'module': _props['module'],
      'state': _props['state'],
      'props': _props,
      'manifest': manifest,
      'selection': selection,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
      'history': history,
    };
  }

  Map<String, Object?> setProps(
    Map<String, Object?> incoming, {
    bool recordHistory = false,
    String source = 'set_props',
  }) {
    final before = _snapshot();
    _props.addAll(incoming);
    _props = normalizeStudioProps(_props);
    final after = _snapshot();
    if (recordHistory) {
      _recordMutation(
        kind: 'change',
        label: source,
        payload: incoming,
        before: before,
        after: after,
      );
    } else {
      _appendHistory(kind: 'change', label: source, payload: incoming);
    }
    return _props;
  }

  Map<String, Object?> setModule(
    String module, {
    Map<String, Object?> payload = const <String, Object?>{},
    bool recordHistory = true,
  }) {
    final normalized = normalizeStudioModuleToken(module);
    if (!studioModules.contains(normalized)) {
      return <String, Object?>{'ok': false, 'error': 'unknown module: $module'};
    }

    final before = _snapshot();
    final modules = studioCoerceObjectMap(_props['modules']);
    modules[normalized] = payload;
    _props['modules'] = modules;
    _props['module'] = normalized;
    _props[normalized] = payload;
    _props = normalizeStudioProps(_props);
    final after = _snapshot();

    if (recordHistory) {
      _recordMutation(
        kind: 'module_change',
        label: 'set_module:$normalized',
        payload: <String, Object?>{'module': normalized, 'payload': payload},
        before: before,
        after: after,
      );
    } else {
      _appendHistory(
        kind: 'module_change',
        label: 'set_module:$normalized',
        payload: <String, Object?>{'module': normalized, 'payload': payload},
      );
    }

    return <String, Object?>{
      'ok': true,
      'module': normalized,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> setState(String state, {bool recordHistory = true}) {
    final normalized = studioNorm(state);
    if (!studioStates.contains(normalized)) {
      return <String, Object?>{'ok': false, 'error': 'unknown state: $state'};
    }

    final before = _snapshot();
    _props['state'] = normalized;
    _props = normalizeStudioProps(_props);
    final after = _snapshot();

    if (recordHistory) {
      _recordMutation(
        kind: 'state_change',
        label: 'set_state:$normalized',
        payload: <String, Object?>{'state': normalized},
        before: before,
        after: after,
      );
    } else {
      _appendHistory(
        kind: 'state_change',
        label: 'set_state:$normalized',
        payload: <String, Object?>{'state': normalized},
      );
    }

    return <String, Object?>{
      'ok': true,
      'state': normalized,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> setManifest(
    Map<String, Object?> manifestData, {
    bool recordHistory = true,
  }) {
    final before = _snapshot();
    final merged = <String, Object?>{...manifest, ...manifestData};
    _props['manifest'] = merged;
    _props = normalizeStudioProps(_props);
    final normalizedManifest = studioCoerceObjectMap(_props['manifest']);

    _props['enabled_surfaces'] = normalizedManifest['enabled_surfaces'];
    _props['enabled_panels'] = normalizedManifest['enabled_panels'];
    _props['enabled_tools'] = normalizedManifest['enabled_tools'];
    _props['importers'] = normalizedManifest['importers'];
    _props['exporters'] = normalizedManifest['exporters'];
    _props['compute'] = normalizedManifest['compute'];

    final after = _snapshot();
    if (recordHistory) {
      _recordMutation(
        kind: 'change',
        label: 'set_manifest',
        payload: <String, Object?>{'manifest': normalizedManifest},
        before: before,
        after: after,
      );
    } else {
      _appendHistory(
        kind: 'change',
        label: 'set_manifest',
        payload: <String, Object?>{'manifest': normalizedManifest},
      );
    }

    return <String, Object?>{
      'ok': true,
      'manifest': normalizedManifest,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> registerModule(
    String role,
    String moduleId, {
    Map<String, Object?> definition = const <String, Object?>{},
    bool recordHistory = true,
  }) {
    final normalizedRole = studioNorm(role);
    final normalizedId = studioNorm(moduleId);
    if (normalizedRole.isEmpty || normalizedId.isEmpty) {
      return <String, Object?>{
        'ok': false,
        'error': 'role and module_id are required',
      };
    }

    final before = _snapshot();
    final registries = studioCoerceObjectMap(_props['registries']);
    final roleRegistry = studioCoerceObjectMap(registries[normalizedRole]);
    roleRegistry[normalizedId] = definition;
    registries[normalizedRole] = roleRegistry;
    _props['registries'] = registries;

    final manifestMap = studioCoerceObjectMap(_props['manifest']);
    final candidates = <String>{
      'surfaces',
      'panels',
      'tools',
      'importers',
      'exporters',
      'compute',
      'surface_registry',
      'panel_registry',
      'tool_registry',
      'importer_registry',
      'exporter_registry',
    };
    if (candidates.contains(normalizedRole)) {
      final key = normalizedRole.endsWith('_registry')
          ? normalizedRole.replaceFirst('_registry', '')
          : normalizedRole;
      final listKey = key == 'surface'
          ? 'enabled_surfaces'
          : key == 'panel'
          ? 'enabled_panels'
          : key == 'tool'
          ? 'enabled_tools'
          : key;
      final values = studioCoerceStringList(manifestMap[listKey]).toList();
      if (!values.contains(normalizedId)) {
        values.add(normalizedId);
      }
      manifestMap[listKey] = values;
      _props['manifest'] = manifestMap;
    }

    _props = normalizeStudioProps(_props);
    final after = _snapshot();

    if (recordHistory) {
      _recordMutation(
        kind: 'change',
        label: 'register_module:$normalizedRole/$normalizedId',
        payload: <String, Object?>{
          'role': normalizedRole,
          'module_id': normalizedId,
          'definition': definition,
        },
        before: before,
        after: after,
      );
    } else {
      _appendHistory(
        kind: 'change',
        label: 'register_module:$normalizedRole/$normalizedId',
        payload: <String, Object?>{
          'role': normalizedRole,
          'module_id': normalizedId,
          'definition': definition,
        },
      );
    }

    return <String, Object?>{
      'ok': true,
      'role': normalizedRole,
      'module_id': normalizedId,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> setSelection(
    Map<String, Object?> payload, {
    bool recordHistory = true,
  }) {
    final before = _snapshot();
    final selectedIds = <String>[];
    final selectedIdCandidates = <Object?>[
      payload['selected_id'],
      payload['entity_id'],
      payload['node_id'],
      payload['id'],
    ];
    for (final candidate in selectedIdCandidates) {
      final id = candidate?.toString().trim() ?? '';
      if (id.isNotEmpty) {
        selectedIds.add(id);
        break;
      }
    }
    final incomingSelected = payload['selected_ids'];
    if (incomingSelected is List) {
      for (final entry in incomingSelected) {
        final id = entry?.toString().trim() ?? '';
        if (id.isNotEmpty && !selectedIds.contains(id)) {
          selectedIds.add(id);
        }
      }
    }

    final selectedId = selectedIds.isEmpty ? '' : selectedIds.first;
    final selectionTools = studioSectionProps(_props, 'selection_tools') ?? {};
    selectionTools['selected_id'] = selectedId;
    selectionTools['selected_ids'] = selectedIds;
    if (payload['active_tool'] != null) {
      selectionTools['active_tool'] = payload['active_tool'];
    }

    final modules = studioCoerceObjectMap(_props['modules']);
    modules['selection_tools'] = selectionTools;
    _props['modules'] = modules;
    _props['selection_tools'] = selectionTools;
    _props['selected_id'] = selectedId;
    _props['selected_ids'] = selectedIds;
    _props = normalizeStudioProps(_props);
    final after = _snapshot();

    if (recordHistory) {
      _recordMutation(
        kind: 'select',
        label: 'set_selection',
        payload: <String, Object?>{
          'selected_id': selectedId,
          'selected_ids': selectedIds,
        },
        before: before,
        after: after,
      );
    } else {
      _appendHistory(
        kind: 'select',
        label: 'set_selection',
        payload: <String, Object?>{
          'selected_id': selectedId,
          'selected_ids': selectedIds,
        },
      );
    }

    return <String, Object?>{
      'ok': true,
      'selected_id': selectedId,
      'selected_ids': selectedIds,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> setTool(
    String tool, {
    Map<String, Object?> payload = const <String, Object?>{},
    bool recordHistory = true,
  }) {
    final normalizedTool = studioNorm(tool);
    if (normalizedTool.isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'tool is required'};
    }

    final before = _snapshot();
    final selectionTools = studioSectionProps(_props, 'selection_tools') ?? {};
    selectionTools['active_tool'] = normalizedTool;
    for (final entry in payload.entries) {
      if (entry.key == 'tool') continue;
      selectionTools[entry.key] = entry.value;
    }

    final modules = studioCoerceObjectMap(_props['modules']);
    modules['selection_tools'] = selectionTools;
    _props['modules'] = modules;
    _props['selection_tools'] = selectionTools;
    _props['active_tool'] = normalizedTool;
    _props = normalizeStudioProps(_props);
    final after = _snapshot();

    if (recordHistory) {
      _recordMutation(
        kind: 'change',
        label: 'set_tool:$normalizedTool',
        payload: <String, Object?>{'tool': normalizedTool, ...payload},
        before: before,
        after: after,
      );
    } else {
      _appendHistory(
        kind: 'change',
        label: 'set_tool:$normalizedTool',
        payload: <String, Object?>{'tool': normalizedTool, ...payload},
      );
    }

    return <String, Object?>{
      'ok': true,
      'tool': normalizedTool,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> executeCommand(Map<String, Object?> args) {
    final payload = args['payload'] is Map
        ? coerceObjectMap(args['payload'] as Map)
        : <String, Object?>{...args};
    final commandType = studioNorm(
      (args['type'] ?? args['command'] ?? payload['type'] ?? '').toString(),
    );
    final type = commandType.isEmpty ? 'update_module' : commandType;
    final label = (args['label'] ?? payload['label'] ?? type).toString();

    final before = _snapshot();
    var result = <String, Object?>{'ok': true, 'type': type};
    switch (type) {
      case 'set_state':
        result = setState(
          (payload['state'] ?? '').toString(),
          recordHistory: false,
        );
        break;
      case 'set_module':
        result = setModule(
          (payload['module'] ?? '').toString(),
          payload: studioCoerceObjectMap(
            payload['module_payload'] ?? payload['payload'],
          ),
          recordHistory: false,
        );
        break;
      case 'set_selection':
        result = setSelection(payload, recordHistory: false);
        break;
      case 'set_tool':
      case 'activate_tool':
        result = setTool(
          (payload['tool'] ?? payload['active_tool'] ?? '').toString(),
          payload: payload,
          recordHistory: false,
        );
        break;
      case 'set_manifest':
        result = setManifest(
          studioCoerceObjectMap(payload['manifest']),
          recordHistory: false,
        );
        break;
      case 'set_zoom':
        _setResponsiveValue('zoom', coerceDouble(payload['zoom']) ?? 1.0);
        break;
      case 'set_viewport':
        _setResponsiveValue(
          'width',
          coerceDouble(payload['width']) ?? coerceDouble(payload['w']) ?? 1280,
        );
        _setResponsiveValue(
          'height',
          coerceDouble(payload['height']) ?? coerceDouble(payload['h']) ?? 720,
        );
        if (payload['device'] != null) {
          _setResponsiveValue('device', payload['device']?.toString() ?? '');
        }
        if (payload['portrait'] != null) {
          _setResponsiveValue('portrait', payload['portrait'] == true);
        }
        break;
      case 'set_prop':
        final key = (payload['key'] ?? payload['path'] ?? '').toString();
        if (key.trim().isNotEmpty) {
          _props[key] = payload['value'];
          _props = normalizeStudioProps(_props);
        }
        break;
      case 'update_module':
      default:
        final moduleName = (payload['module'] ?? payload['surface'] ?? '')
            .toString();
        final modulePayload = studioCoerceObjectMap(
          payload['module_payload'] ?? payload['payload'] ?? payload['patch'],
        );
        if (moduleName.trim().isNotEmpty &&
            studioModules.contains(normalizeStudioModuleToken(moduleName))) {
          result = setModule(
            moduleName,
            payload: modulePayload,
            recordHistory: false,
          );
        } else {
          _props.addAll(payload);
          _props = normalizeStudioProps(_props);
        }
        break;
    }

    if (result['ok'] == false) {
      _appendHistory(
        kind: 'change',
        label: 'command_failed:$label',
        payload: result,
      );
      return result;
    }

    final after = _snapshot();
    _recordMutation(
      kind: 'change',
      label: 'command:$label',
      payload: <String, Object?>{'type': type, ...payload},
      before: before,
      after: after,
    );
    return <String, Object?>{
      'ok': true,
      'type': type,
      'label': label,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    };
  }

  Map<String, Object?> undo() {
    if (_undoStack.isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'nothing to undo'};
    }
    final entry = _undoStack.removeLast();
    final before = entry['before'];
    if (before is! Map) {
      return <String, Object?>{'ok': false, 'error': 'undo entry is invalid'};
    }
    _redoStack.add(entry);
    _props = normalizeStudioProps(deepCopyStudioMap(coerceObjectMap(before)));
    _appendHistory(
      kind: 'change',
      label: 'undo',
      payload: <String, Object?>{
        'command_id': entry['command_id'],
        'label': entry['label'],
      },
    );
    return <String, Object?>{
      'ok': true,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
      'label': entry['label'],
    };
  }

  Map<String, Object?> redo() {
    if (_redoStack.isEmpty) {
      return <String, Object?>{'ok': false, 'error': 'nothing to redo'};
    }
    final entry = _redoStack.removeLast();
    final after = entry['after'];
    if (after is! Map) {
      return <String, Object?>{'ok': false, 'error': 'redo entry is invalid'};
    }
    _undoStack.add(entry);
    _props = normalizeStudioProps(deepCopyStudioMap(coerceObjectMap(after)));
    _appendHistory(
      kind: 'change',
      label: 'redo',
      payload: <String, Object?>{
        'command_id': entry['command_id'],
        'label': entry['label'],
      },
    );
    return <String, Object?>{
      'ok': true,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
      'label': entry['label'],
    };
  }

  void _setResponsiveValue(String key, Object? value) {
    final responsive = studioSectionProps(_props, 'responsive_toolbar') ?? {};
    responsive[key] = value;
    final modules = studioCoerceObjectMap(_props['modules']);
    modules['responsive_toolbar'] = responsive;
    _props['modules'] = modules;
    _props['responsive_toolbar'] = responsive;
    _props = normalizeStudioProps(_props);
  }

  Map<String, Object?> _snapshot() => deepCopyStudioMap(_props);

  void _recordMutation({
    required String kind,
    required String label,
    required Map<String, Object?> payload,
    required Map<String, Object?> before,
    required Map<String, Object?> after,
  }) {
    final entry = <String, Object?>{
      'command_id': _nextCommandId,
      'timestamp_ms': DateTime.now().millisecondsSinceEpoch,
      'kind': kind,
      'label': label,
      'payload': payload,
      'before': before,
      'after': after,
    };
    _nextCommandId += 1;
    _undoStack.add(entry);
    _redoStack.clear();
    _trimCommandDepth();
    _appendHistory(kind: kind, label: label, payload: payload);
  }

  void _appendHistory({
    required String kind,
    required String label,
    required Map<String, Object?> payload,
  }) {
    final entry = <String, Object?>{
      'timestamp_ms': DateTime.now().millisecondsSinceEpoch,
      'kind': kind,
      'label': label,
      'payload': payload,
    };
    _history.add(entry);
    _trimHistory();
  }

  void _trimCommandDepth() {
    final historyLimit = max(
      20,
      coerceOptionalInt(_props['history_limit']) ?? 200,
    );
    while (_undoStack.length > historyLimit) {
      _undoStack.removeAt(0);
    }
    while (_redoStack.length > historyLimit) {
      _redoStack.removeAt(0);
    }
  }

  void _trimHistory() {
    final historyLimit = max(
      40,
      coerceOptionalInt(_props['history_limit']) ?? 240,
    );
    while (_history.length > historyLimit) {
      _history.removeAt(0);
    }
  }
}
