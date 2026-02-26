import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/studio/studio_engine.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUIStudio extends StatefulWidget {
  const ButterflyUIStudio({
    super.key,
    required this.controlId,
    required this.initialProps,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> initialProps;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUIStudio> createState() => _ButterflyUIStudioState();
}

class _ButterflyUIStudioState extends State<ButterflyUIStudio> {
  late final StudioHostEngine _engine = StudioHostEngine(widget.initialProps);
  bool _readyEmitted = false;

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _readyEmitted) return;
      _readyEmitted = true;
      _emitConfiguredEvent('ready', const <String, Object?>{
        'module': 'builder',
        'source': 'studio_host',
      });
    });
  }

  @override
  void didUpdateWidget(covariant ButterflyUIStudio oldWidget) {
    super.didUpdateWidget(oldWidget);
    _engine.replaceProps(widget.initialProps);
    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final normalized = studioNorm(method);
    switch (normalized) {
      case 'get_state':
        return _engine.stateSnapshot();
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _engine.setProps(coerceObjectMap(incoming), recordHistory: false);
          });
        }
        return _engine.props;
      case 'set_module':
        return _withState(() {
          final module = (args['module'] ?? '').toString();
          final payload = studioCoerceObjectMap(args['payload']);
          final result = _engine.setModule(
            module,
            payload,
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('module_change', <String, Object?>{
              'module': result['module'],
              'payload': payload,
            });
          }
          return result;
        });
      case 'set_state':
        return _withState(() {
          final result = _engine.setState(
            (args['state'] ?? '').toString(),
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('state_change', <String, Object?>{
              'state': result['state'],
            });
          }
          return result;
        });
      case 'set_manifest':
        return _withState(() {
          final result = _engine.setManifest(
            studioCoerceObjectMap(args['manifest']),
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'builder',
              'intent': 'set_manifest',
              'manifest': result['manifest'],
            });
          }
          return result;
        });
      case 'register_module':
        return _withState(() {
          final role = (args['role'] ?? '').toString();
          final moduleId = (args['module_id'] ?? args['id'] ?? '').toString();
          final definition = studioCoerceObjectMap(args['definition']);
          final result = _engine.registerModule(
            role: role,
            moduleId: moduleId,
            definition: definition,
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'builder',
              'intent': 'register_module',
              'role': result['role'],
              'module_id': result['module_id'],
            });
          }
          return result;
        });
      case 'register_surface':
      case 'register_tool':
      case 'register_panel':
      case 'register_importer':
      case 'register_exporter':
        return _withState(() {
          final role = normalized.replaceFirst('register_', '');
          final moduleId =
              (args['module_id'] ??
                      args['id'] ??
                      args['name'] ??
                      args['surface'] ??
                      args['tool'] ??
                      args['panel'] ??
                      '')
                  .toString();
          final definition = studioCoerceObjectMap(args['definition']);
          final result = _engine.registerModule(
            role: role,
            moduleId: moduleId,
            definition: definition,
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'builder',
              'intent': normalized,
              'role': result['role'],
              'module_id': result['module_id'],
            });
          }
          return result;
        });
      case 'set_selection':
        return _withState(() {
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{...args};
          final result = _engine.setSelection(payload, recordHistory: true);
          if (result['ok'] == true) {
            _emitConfiguredEvent('select', <String, Object?>{
              'module': 'canvas',
              'selected_id': result['selected_id'],
              'selected_ids': result['selected_ids'],
            });
          }
          return result;
        });
      case 'set_active_surface':
        return _withState(() {
          final result = _engine.setActiveSurface(
            (args['surface'] ?? args['active_surface'] ?? '').toString(),
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('module_change', <String, Object?>{
              'module': result['active_surface'],
            });
          }
          return result;
        });
      case 'set_tool':
        return _withState(() {
          final result = _engine.setTool(
            (args['tool'] ?? args['active_tool'] ?? '').toString(),
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'selection_tools',
              'tool': result['tool'],
            });
          }
          return result;
        });
      case 'focus_panel':
        return _withState(() {
          final result = _engine.focusPanel(
            (args['panel'] ?? args['panel_id'] ?? '').toString(),
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': result['focused_panel'],
              'intent': 'focus_panel',
            });
          }
          return result;
        });
      case 'register_shortcut':
        return _withState(() {
          final result = _engine.registerShortcut(
            context: (args['context'] ?? args['scope'] ?? 'global').toString(),
            chord: (args['chord'] ?? args['keys'] ?? '').toString(),
            command: (args['shortcut_command'] ?? args['command'] ?? '')
                .toString(),
            payload: studioCoerceObjectMap(args['payload']),
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'builder',
              'intent': 'register_shortcut',
              'result': result,
            });
          }
          return result;
        });
      case 'set_dock_layout':
        return _withState(() {
          final result = _engine.setDockLayout(
            studioCoerceObjectMap(args['layout']),
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'builder',
              'intent': 'set_dock_layout',
            });
          }
          return result;
        });
      case 'import_asset':
        return _withState(() {
          final result = _engine.importAsset(
            (args['path'] ?? args['asset_path'] ?? '').toString(),
            mode: (args['mode'] ?? 'copy').toString(),
            metadata: studioCoerceObjectMap(args['metadata']),
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'asset_browser',
              'intent': 'import_asset',
              'asset': result['asset'],
            });
          }
          return result;
        });
      case 'enqueue_export':
      case 'export':
        return _withState(() {
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{...args};
          final result = _engine.enqueueExport(
            format: (args['format'] ?? payload['format'] ?? 'png').toString(),
            payload: payload,
            recordHistory: true,
          );
          if (result['ok'] == true) {
            _emitConfiguredEvent('submit', <String, Object?>{
              'module': 'builder',
              'intent': 'enqueue_export',
              'job': result['job'],
            });
          }
          return result;
        });
      case 'render_start_next':
      case 'start_next_render':
      case 'render_update_progress':
      case 'render_progress':
      case 'render_complete':
      case 'complete_render':
      case 'render_fail':
      case 'fail_render':
      case 'ffmpeg_enqueue':
      case 'ffmpeg_start_next':
      case 'start_next_ffmpeg':
      case 'ffmpeg_update_status':
      case 'ffmpeg_status':
      case 'ffmpeg_complete':
      case 'complete_ffmpeg':
      case 'ffmpeg_fail':
      case 'fail_ffmpeg':
      case 'recording_start':
      case 'start_recording':
      case 'recording_stop':
      case 'stop_recording':
      case 'recording_set_supported':
      case 'set_recording_supported':
      case 'recording_clear_sessions':
      case 'clear_recording_sessions':
        return _withState(() {
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{...args};
          final result = _engine.executeCommand(<String, Object?>{
            'type': normalized,
            'payload': payload,
          });
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'builder',
              'intent': normalized,
              'result': result,
            });
          }
          return result;
        });
      case 'execute_command':
      case 'command':
      case 'route_command':
        return _withState(() {
          final result = _engine.executeCommand(args);
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': _engine.props['module'],
              'intent': 'execute_command',
              'result': result,
            });
          }
          return result;
        });
      case 'undo':
        return _withState(() {
          final result = _engine.undo();
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'actions_editor',
              'intent': 'undo',
              'result': result,
            });
          }
          return result;
        });
      case 'redo':
        return _withState(() {
          final result = _engine.redo();
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', <String, Object?>{
              'module': 'actions_editor',
              'intent': 'redo',
              'result': result,
            });
          }
          return result;
        });
      case 'emit':
      case 'trigger':
        final fallback = normalized == 'trigger' ? 'change' : normalized;
        final event = studioNorm(
          (args['event'] ?? args['name'] ?? fallback).toString(),
        );
        if (!studioEvents.contains(event)) {
          return <String, Object?>{
            'ok': false,
            'error': 'unknown event: $event',
          };
        }
        final payload = args['payload'];
        _emitConfiguredEvent(
          event,
          payload is Map ? coerceObjectMap(payload) : args,
        );
        return true;
      default:
        if (studioModules.contains(normalized)) {
          return _withState(() {
            final payload = args['payload'];
            final payloadMap = payload is Map
                ? coerceObjectMap(payload)
                : <String, Object?>{...args};
            final result = _engine.setModule(
              normalized,
              payloadMap,
              recordHistory: true,
            );
            if (result['ok'] == true) {
              _emitConfiguredEvent('module_change', <String, Object?>{
                'module': normalized,
                'payload': payloadMap,
              });
            }
            return result;
          });
        }
        return <String, Object?>{
          'ok': false,
          'error': 'unknown method: $method',
        };
    }
  }

  Object _withState(Object Function() action) {
    late Object result;
    setState(() {
      result = action();
    });
    return result;
  }

  Set<String> _configuredEvents() {
    final raw = _engine.props['events'];
    final out = <String>{};
    if (raw is List) {
      for (final entry in raw) {
        final value = studioNorm(entry?.toString() ?? '');
        if (value.isNotEmpty && studioEvents.contains(value)) {
          out.add(value);
        }
      }
    }
    if (out.isEmpty) return defaultStudioEvents;
    return out;
  }

  void _emitConfiguredEvent(String event, Map<String, Object?> payload) {
    final normalized = studioNorm(event);
    final configured = _configuredEvents();
    if (configured.isNotEmpty && !configured.contains(normalized)) {
      return;
    }
    widget.sendEvent(widget.controlId, normalized, <String, Object?>{
      'schema_version': _engine.props['schema_version'] ?? studioSchemaVersion,
      'module': _engine.props['module'],
      'state': _engine.props['state'],
      ...payload,
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableModules = availableStudioModules(_engine.props);
    final activeModule = normalizeStudioModuleToken(
      (_engine.props['module'] ?? 'builder').toString(),
    );

    final customChildren = widget.rawChildren
        .whereType<Map>()
        .map((child) => widget.buildChild(coerceObjectMap(child)))
        .toList(growable: false);

    return StudioWorkbench(
      controlId: widget.controlId,
      runtimeProps: _engine.props,
      availableModules: availableModules,
      activeModule: activeModule,
      history: _engine.history,
      undoDepth: _engine.undoDepth,
      redoDepth: _engine.redoDepth,
      rawChildren: widget.rawChildren,
      customChildren: customChildren,
      sendEvent: widget.sendEvent,
      buildChild: widget.buildChild,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      onSelectModule: (module) {
        setState(() {
          final normalizedModule = normalizeStudioModuleToken(module);
          if (studioSurfaceModules.contains(normalizedModule)) {
            _engine.setActiveSurface(module, recordHistory: false);
          } else {
            _engine.setModule(
              module,
              studioSectionProps(_engine.props, module) ?? <String, Object?>{},
              recordHistory: false,
            );
          }
        });
        _emitConfiguredEvent('module_change', <String, Object?>{
          'module': module,
        });
      },
      onEmit: (event, payload) {
        final action = studioNorm((payload['action'] ?? '').toString());
        if (event == 'change' && action == 'undo') {
          final result = _withState(() => _engine.undo());
          _emitConfiguredEvent('change', <String, Object?>{
            'intent': 'undo',
            'result': result,
          });
          return;
        }
        if (event == 'change' && action == 'redo') {
          final result = _withState(() => _engine.redo());
          _emitConfiguredEvent('change', <String, Object?>{
            'intent': 'redo',
            'result': result,
          });
          return;
        }
        if (event == 'select') {
          _withState(() => _engine.setSelection(payload, recordHistory: true));
        } else if (event == 'change') {
          final module = normalizeStudioModuleToken(
            (payload['module'] ?? '').toString(),
          );
          final modulePayload = studioCoerceObjectMap(payload['payload']);
          if (module == 'selection_tools' &&
              modulePayload['active_tool'] != null) {
            _withState(
              () => _engine.setTool(
                modulePayload['active_tool'].toString(),
                recordHistory: true,
              ),
            );
          } else if (module == 'responsive_toolbar' &&
              modulePayload['zoom'] != null) {
            _withState(
              () => _engine.executeCommand(<String, Object?>{
                'type': 'set_zoom',
                'payload': <String, Object?>{'zoom': modulePayload['zoom']},
              }),
            );
          } else if (module.isNotEmpty && modulePayload.isNotEmpty) {
            _withState(
              () =>
                  _engine.setModule(module, modulePayload, recordHistory: true),
            );
          }
        }
        _emitConfiguredEvent(event, payload);
      },
    );
  }
}

Widget buildStudioControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIStudio(
    controlId: controlId,
    initialProps: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
