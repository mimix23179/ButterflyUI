import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

const int _skinsSchemaVersion = 2;

const List<String> _skinsModuleOrder = [
  'selector',
  'preset',
  'editor',
  'preview',
  'token_mapper',
  'effects',
  'particles',
  'shaders',
  'materials',
  'icons',
  'fonts',
  'colors',
  'background',
  'border',
  'shadow',
  'outline',
  'animation',
  'transition',
  'interaction',
  'layout',
  'responsive',
  'effect_editor',
  'particle_editor',
  'shader_editor',
  'material_editor',
  'icon_editor',
  'font_editor',
  'color_editor',
  'background_editor',
  'border_editor',
  'shadow_editor',
  'outline_editor',
  'apply',
  'clear',
  'create_skin',
  'edit_skin',
  'delete_skin',
];

const Set<String> _skinsModules = {
  'selector',
  'preset',
  'editor',
  'preview',
  'apply',
  'clear',
  'token_mapper',
  'create_skin',
  'edit_skin',
  'delete_skin',
  'effects',
  'particles',
  'shaders',
  'materials',
  'icons',
  'fonts',
  'colors',
  'background',
  'border',
  'shadow',
  'outline',
  'animation',
  'transition',
  'interaction',
  'layout',
  'responsive',
  'effect_editor',
  'particle_editor',
  'shader_editor',
  'material_editor',
  'icon_editor',
  'font_editor',
  'color_editor',
  'background_editor',
  'border_editor',
  'shadow_editor',
  'outline_editor',
};

const Set<String> _actionModules = {
  'apply',
  'clear',
  'create_skin',
  'edit_skin',
  'delete_skin',
};

const Set<String> _skinsStates = {
  'idle',
  'loading',
  'ready',
  'editing',
  'preview',
  'disabled',
};

const Set<String> _skinsEvents = {
  'change',
  'select',
  'apply',
  'clear',
  'create_skin',
  'edit_skin',
  'delete_skin',
  'state_change',
  'module_change',
  'token_map',
};

const Map<String, String> _skinsRegistryRoleAliases = {
  'module': 'module_registry',
  'modules': 'module_registry',
  'pipeline': 'pipeline_registry',
  'pipelines': 'pipeline_registry',
  'editor': 'editor_registry',
  'editors': 'editor_registry',
  'preview': 'preview_registry',
  'previews': 'preview_registry',
  'distribution': 'distribution_registry',
  'distributions': 'distribution_registry',
  'registry': 'distribution_registry',
  'provider': 'pipeline_registry',
  'providers': 'pipeline_registry',
  'panel': 'editor_registry',
  'panels': 'editor_registry',
  'command': 'command_registry',
  'commands': 'command_registry',
  'module_registry': 'module_registry',
  'pipeline_registry': 'pipeline_registry',
  'editor_registry': 'editor_registry',
  'preview_registry': 'preview_registry',
  'distribution_registry': 'distribution_registry',
  'command_registry': 'command_registry',
};

const Map<String, String> _skinsRegistryManifestLists = {
  'module_registry': 'enabled_modules',
  'pipeline_registry': 'enabled_pipelines',
  'editor_registry': 'enabled_editors',
  'preview_registry': 'enabled_previews',
  'distribution_registry': 'enabled_distribution',
  'command_registry': 'enabled_commands',
};

const Map<String, List<String>> _skinsManifestDefaults = {
  'enabled_modules': <String>[
    'selector',
    'preset',
    'preview',
    'editor',
    'token_mapper',
    'colors',
    'fonts',
    'effects',
    'materials',
    'icon_editor',
    'font_editor',
    'apply',
    'clear',
  ],
  'enabled_pipelines': <String>[
    'token_mapper',
    'colors',
    'fonts',
    'animation',
    'transition',
    'effects',
    'materials',
    'icons',
  ],
  'enabled_editors': <String>[
    'editor',
    'color_editor',
    'font_editor',
    'material_editor',
    'effect_editor',
    'icon_editor',
    'border_editor',
    'shadow_editor',
    'outline_editor',
  ],
  'enabled_previews': <String>['preview'],
  'enabled_distribution': <String>['preset', 'create_skin', 'edit_skin'],
  'enabled_commands': <String>['apply', 'clear', 'create_skin', 'edit_skin'],
};

const List<String> _defaultSkinNames = <String>[
  'Obsidian Neon',
  'Linen Paper',
  'Matrix Terminal',
];

const List<String> _defaultSkinPresets = <String>[
  'Dark',
  'Light',
  'Glass',
  'Neon',
];

Widget buildSkinsFamilyControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _SkinsControl(
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
      if (value.isNotEmpty && _skinsEvents.contains(value)) {
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
  if (!_skinsEvents.contains(eventName)) {
    return;
  }
  final events = _configuredEvents(props);
  if (events.isNotEmpty && !events.contains(eventName)) {
    return;
  }
  sendEvent(controlId, eventName, {
    'schema_version': props['schema_version'] ?? _skinsSchemaVersion,
    'module': props['module'],
    'state': props['state'],
    ...payload,
  });
}

class _SkinsControl extends StatefulWidget {
  const _SkinsControl({
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
  State<_SkinsControl> createState() => _SkinsControlState();
}

class _SkinsControlState extends State<_SkinsControl> {
  late Map<String, Object?> _runtimeProps;
  late List<String> _skins;
  String? _selectedSkin;

  @override
  void initState() {
    super.initState();
    _runtimeProps = _normalizeProps(widget.props);
    _skins = _coerceSkins(_runtimeProps['skins'] ?? _runtimeProps['presets']);
    _selectedSkin = _resolveSelected(_runtimeProps, _skins);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _SkinsControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = _normalizeProps(widget.props);
    _skins = _coerceSkins(_runtimeProps['skins'] ?? _runtimeProps['presets']);
    _selectedSkin = _resolveSelected(_runtimeProps, _skins);
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

  void _setModuleAndPayload(String module, Map<String, Object?> payload) {
    final modules = _coerceObjectMap(_runtimeProps['modules']);
    modules[module] = payload;
    _runtimeProps['modules'] = modules;
    _runtimeProps[module] = payload;
    _runtimeProps['module'] = module;
    _runtimeProps = _normalizeProps(_runtimeProps);
  }

  void _mergeModulePayload(String module, Map<String, Object?> patch) {
    final modules = _coerceObjectMap(_runtimeProps['modules']);
    final existing = _coerceObjectMap(modules[module]);
    final merged = <String, Object?>{...existing, ...patch};
    modules[module] = merged;
    _runtimeProps['modules'] = modules;
    _runtimeProps[module] = merged;
  }

  void _selectSkinLocal(String skin) {
    final selected = skin.trim();
    if (selected.isEmpty) return;
    setState(() {
      _selectedSkin = selected;
      if (!_skins.contains(selected)) {
        _skins = <String>[..._skins, selected];
      }
      _runtimeProps['skins'] = _skins;
      _runtimeProps['selected_skin'] = selected;
      _runtimeProps['skin'] = selected;
      _mergeModulePayload('selector', <String, Object?>{
        'skins': _skins,
        'selected_skin': selected,
      });
      _mergeModulePayload('preset', <String, Object?>{
        'presets': _runtimeProps['presets'] ?? _defaultSkinPresets,
      });
      _mergeModulePayload('preview', <String, Object?>{
        'skin': selected,
        'label': 'Skin preview surface',
      });
      _mergeModulePayload('editor', <String, Object?>{'name': 'active_skin'});
      _runtimeProps = _normalizeProps(_runtimeProps);
    });
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final normalizedMethod = _norm(method);
    switch (normalizedMethod) {
      case 'get_state':
        return {
          'schema_version': _runtimeProps['schema_version'],
          'module': _runtimeProps['module'],
          'state': _runtimeProps['state'],
          'manifest': _runtimeProps['manifest'],
          'registries': _runtimeProps['registries'],
          'skins': _skins,
          'selected_skin': _selectedSkin,
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
            _runtimeProps = _normalizeProps(_runtimeProps);
            _skins = _coerceSkins(
              _runtimeProps['skins'] ?? _runtimeProps['presets'],
            );
            _selectedSkin = _resolveSelected(_runtimeProps, _skins);
          });
        }
        return _runtimeProps;
      case 'set_manifest':
        {
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
              'module': _runtimeProps['module'],
              'intent': 'set_manifest',
              'manifest': _runtimeProps['manifest'],
            },
          );
          return {'ok': true, 'manifest': _runtimeProps['manifest']};
        }
      case 'set_module':
        {
          final module = _norm(args['module']?.toString() ?? '');
          if (!_skinsModules.contains(module)) {
            return {'ok': false, 'error': 'unknown module: $module'};
          }
          final payload = args['payload'];
          final payloadMap = payload is Map
              ? coerceObjectMap(payload)
              : <String, Object?>{};
          setState(() {
            _setModuleAndPayload(module, payloadMap);
          });
          _emitEvent(
            widget.controlId,
            _runtimeProps,
            widget.sendEvent,
            'module_change',
            {'module': module, 'payload': payloadMap},
          );
          return {'ok': true, 'module': module};
        }
      case 'set_state':
        {
          final state = _norm(args['state']?.toString() ?? '');
          if (!_skinsStates.contains(state)) {
            return {'ok': false, 'error': 'unknown state: $state'};
          }
          setState(() {
            _runtimeProps['state'] = state;
          });
          _emitEvent(
            widget.controlId,
            _runtimeProps,
            widget.sendEvent,
            'state_change',
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
        if (!_skinsEvents.contains(event)) {
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
      case 'apply':
        final skin = (args['skin'] ?? args['value'] ?? _selectedSkin)
            ?.toString();
        if (skin != null && skin.isNotEmpty) {
          setState(() {
            _selectedSkin = skin;
            if (!_skins.contains(skin)) {
              _skins = <String>[..._skins, skin];
            }
            _runtimeProps['selected_skin'] = skin;
          });
        }
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'apply', {
          'skin': _selectedSkin,
        });
        return _selectedSkin;
      case 'clear':
        setState(() {
          _selectedSkin = null;
          _runtimeProps.remove('selected_skin');
        });
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          'clear',
          {},
        );
        return true;
      case 'create_skin':
        {
          final name = (args['name'] ?? args['skin'] ?? '').toString();
          if (name.isNotEmpty) {
            setState(() {
              if (!_skins.contains(name)) {
                _skins = <String>[..._skins, name];
              }
              _selectedSkin = name;
              _runtimeProps['selected_skin'] = name;
            });
          }
          _emitEvent(
            widget.controlId,
            _runtimeProps,
            widget.sendEvent,
            'create_skin',
            {'name': name, 'payload': args['payload']},
          );
          return name;
        }
      case 'edit_skin':
        {
          final name = (args['name'] ?? args['skin'] ?? _selectedSkin ?? '')
              .toString();
          _emitEvent(
            widget.controlId,
            _runtimeProps,
            widget.sendEvent,
            'edit_skin',
            {'name': name, 'payload': args['payload']},
          );
          return name;
        }
      case 'delete_skin':
        {
          final name = (args['name'] ?? args['skin'] ?? _selectedSkin ?? '')
              .toString();
          setState(() {
            _skins = _skins
                .where((entry) => entry != name)
                .toList(growable: false);
            if (_selectedSkin == name) {
              _selectedSkin = _skins.isEmpty ? null : _skins.first;
              _runtimeProps['selected_skin'] = _selectedSkin;
            }
          });
          _emitEvent(
            widget.controlId,
            _runtimeProps,
            widget.sendEvent,
            'delete_skin',
            {'name': name},
          );
          return true;
        }
      default:
        if (normalizedMethod.startsWith('register_')) {
          final role = normalizedMethod == 'register_module'
              ? (args['role'] ?? 'module').toString()
              : normalizedMethod.replaceFirst('register_', '');
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
              modules: _skinsModules,
              roleAliases: _skinsRegistryRoleAliases,
              roleManifestLists: _skinsRegistryManifestLists,
              manifestDefaults: _skinsManifestDefaults,
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
                'module': _runtimeProps['module'],
                'intent': normalizedMethod,
                'role': result['role'],
                'module_id': result['module_id'],
              },
            );
          }
          return result;
        }
        if (_skinsModules.contains(normalizedMethod)) {
          final payload = args['payload'];
          final payloadMap = payload is Map
              ? coerceObjectMap(payload)
              : <String, Object?>{...args};
          setState(() {
            _setModuleAndPayload(normalizedMethod, payloadMap);
          });
          _emitEvent(
            widget.controlId,
            _runtimeProps,
            widget.sendEvent,
            'change',
            {'module': normalizedMethod, 'payload': payloadMap},
          );
          return {'ok': true, 'module': normalizedMethod};
        }
        throw UnsupportedError('Unknown skins method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = (_runtimeProps['state'] ?? 'ready').toString();
    final requestedModule = _norm(_runtimeProps['module']?.toString() ?? '');
    final availableModules = _availableModules(_runtimeProps, requestedModule);
    final fallbackModule = availableModules.contains('preview')
        ? 'preview'
        : (availableModules.isEmpty ? 'selector' : availableModules.first);
    final currentModule = availableModules.contains(requestedModule)
        ? requestedModule
        : fallbackModule;
    final customChildren = widget.rawChildren
        .whereType<Map>()
        .map((child) => widget.buildChild(coerceObjectMap(child)))
        .toList(growable: false);
    final customLayout =
        _runtimeProps['custom_layout'] == true ||
        _norm((_runtimeProps['layout'] ?? '').toString()) == 'custom';

    if (state == 'loading') {
      return const Center(child: CircularProgressIndicator());
    }

    if (customLayout && customChildren.isNotEmpty) {
      if (customChildren.length == 1) {
        return customChildren.first;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < customChildren.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            customChildren[i],
          ],
        ],
      );
    }

    final actionWidgets = <Widget>[];
    for (final module in _skinsModuleOrder) {
      if (!_actionModules.contains(module)) {
        continue;
      }
      final section = _sectionProps(_runtimeProps, module);
      if (section == null && module != currentModule) {
        continue;
      }
      actionWidgets.add(
        _ActionButton(
          controlType: module,
          controlId: widget.controlId,
          props:
              section ?? <String, Object?>{'events': _runtimeProps['events']},
          sendEvent: widget.sendEvent,
        ),
      );
    }

    final currentSection =
        _sectionProps(_runtimeProps, currentModule) ??
        <String, Object?>{'events': _runtimeProps['events']};
    final activeModuleWidget =
        _buildModuleWidget(
          currentModule,
          currentSection,
          onSelectSkin: _selectSkinLocal,
        ) ??
        _CollectionModule(
          controlId: widget.controlId,
          module: currentModule,
          props: currentSection,
          sendEvent: widget.sendEvent,
        );
    final selectorSection =
        _sectionProps(_runtimeProps, 'selector') ??
        <String, Object?>{
          'events': _runtimeProps['events'],
          'skins': _skins,
          'selected_skin': _selectedSkin,
        };
    final presetSection =
        _sectionProps(_runtimeProps, 'preset') ??
        <String, Object?>{
          'events': _runtimeProps['events'],
          'presets': _runtimeProps['presets'] ?? const <Object?>[],
        };
    final previewSection =
        _sectionProps(_runtimeProps, 'preview') ??
        <String, Object?>{
          'events': _runtimeProps['events'],
          'skin': _selectedSkin,
          'label': 'Skin preview surface',
        };
    final selectorWidget = _buildModuleWidget(
      'selector',
      selectorSection,
      onSelectSkin: _selectSkinLocal,
    );
    final presetWidget = _buildModuleWidget(
      'preset',
      presetSection,
      onSelectSkin: _selectSkinLocal,
    );
    final previewWidget =
        _buildModuleWidget(
          'preview',
          previewSection,
          onSelectSkin: _selectSkinLocal,
        ) ??
        const SizedBox.shrink();
    final workbenchHeight = (coerceDouble(_runtimeProps['height']) ?? 640)
        .clamp(360, 2200)
        .toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          state: state,
          selectedSkin: _selectedSkin,
          skinCount: _skins.length,
        ),
        const SizedBox(height: 8),
        _ModuleTabs(
          modules: availableModules,
          currentModule: currentModule,
          onSelected: (module) {
            setState(() {
              _runtimeProps['module'] = module;
            });
            _emitEvent(
              widget.controlId,
              _runtimeProps,
              widget.sendEvent,
              'module_change',
              {'module': module},
            );
          },
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: workbenchHeight,
          child: Row(
            children: [
              SizedBox(
                width: 300,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Skin Library',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (selectorWidget
                                  case final selectedWidget?) ...[
                                selectedWidget,
                                const SizedBox(height: 8),
                              ],
                              if (presetWidget
                                  case final presetPanelWidget?) ...[
                                presetPanelWidget,
                                const SizedBox(height: 10),
                              ],
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilledButton.tonal(
                                    onPressed: () {
                                      if (_selectedSkin != null) {
                                        _selectSkinLocal(_selectedSkin!);
                                      }
                                      _emitEvent(
                                        widget.controlId,
                                        _runtimeProps,
                                        widget.sendEvent,
                                        'apply',
                                        {'skin': _selectedSkin},
                                      );
                                    },
                                    child: const Text('Apply'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _runtimeProps.remove('selected_skin');
                                        _selectedSkin = _skins.isEmpty
                                            ? null
                                            : _skins.first;
                                        if (_selectedSkin != null) {
                                          _runtimeProps['selected_skin'] =
                                              _selectedSkin;
                                          _mergeModulePayload(
                                            'selector',
                                            <String, Object?>{
                                              'selected_skin': _selectedSkin,
                                            },
                                          );
                                          _mergeModulePayload(
                                            'preview',
                                            <String, Object?>{
                                              'skin': _selectedSkin,
                                            },
                                          );
                                        }
                                        _runtimeProps = _normalizeProps(
                                          _runtimeProps,
                                        );
                                      });
                                      _emitEvent(
                                        widget.controlId,
                                        _runtimeProps,
                                        widget.sendEvent,
                                        'clear',
                                        const <String, Object?>{},
                                      );
                                    },
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Module: ${currentModule.replaceAll('_', ' ')}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Expanded(child: activeModuleWidget),
                      if (currentModule != 'preview') ...[
                        const SizedBox(height: 8),
                        Text(
                          'Live preview',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 6),
                        SizedBox(height: 220, child: previewWidget),
                      ],
                      if (actionWidgets.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: actionWidgets,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_skins.isEmpty && selectorWidget == null) ...[
          const SizedBox(height: 8),
          const Text('No skins configured yet.'),
        ],
      ],
    );
  }

  Widget? _buildModuleWidget(
    String module,
    Map<String, Object?> section, {
    ValueChanged<String>? onSelectSkin,
  }) {
    switch (module) {
      case 'selector':
        return _Selector(
          controlId: widget.controlId,
          props: section,
          sendEvent: widget.sendEvent,
          onSelectSkin: onSelectSkin,
        );
      case 'preset':
        return _PresetList(
          controlId: widget.controlId,
          props: section,
          sendEvent: widget.sendEvent,
          onSelectSkin: onSelectSkin,
        );
      case 'editor':
        return _Editor(
          controlId: widget.controlId,
          props: section,
          sendEvent: widget.sendEvent,
        );
      case 'preview':
        return _Preview(
          props: section,
          rawChildren: widget.rawChildren,
          buildChild: widget.buildChild,
          radius:
              coerceDouble(section['radius'] ?? _runtimeProps['radius']) ?? 12,
        );
      case 'token_mapper':
        return _TokenMapper(
          controlId: widget.controlId,
          props: section,
          sendEvent: widget.sendEvent,
        );
      case 'effect_editor':
      case 'particle_editor':
      case 'shader_editor':
      case 'material_editor':
      case 'icon_editor':
      case 'font_editor':
      case 'color_editor':
      case 'background_editor':
      case 'border_editor':
      case 'shadow_editor':
      case 'outline_editor':
        return _NamedEditor(
          controlId: widget.controlId,
          module: module,
          props: section,
          sendEvent: widget.sendEvent,
        );
      default:
        return _CollectionModule(
          controlId: widget.controlId,
          module: module,
          props: section,
          sendEvent: widget.sendEvent,
        );
    }
  }
}

Map<String, Object?> _normalizeProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] =
      (coerceOptionalInt(out['schema_version']) ?? _skinsSchemaVersion).clamp(
        1,
        9999,
      );

  final module = _norm(out['module']?.toString() ?? '');
  if (module.isNotEmpty && _skinsModules.contains(module)) {
    out['module'] = module;
  } else if (module.isNotEmpty) {
    out.remove('module');
  }

  final state = _norm(out['state']?.toString() ?? '');
  if (state.isNotEmpty && _skinsStates.contains(state)) {
    out['state'] = state;
  } else if (state.isNotEmpty) {
    out.remove('state');
  }

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((e) => _norm(e?.toString() ?? ''))
        .where((e) => e.isNotEmpty && _skinsEvents.contains(e))
        .toSet()
        .toList(growable: false);
  }

  final modules = _coerceObjectMap(out['modules']);
  final normalizedModules = <String, Object?>{};
  for (final module in _skinsModules) {
    final topLevel = out[module];
    if (topLevel is Map) {
      normalizedModules[module] = coerceObjectMap(topLevel);
      out[module] = coerceObjectMap(topLevel);
      continue;
    }
    if (topLevel == true) {
      normalizedModules[module] = <String, Object?>{};
      out[module] = <String, Object?>{};
    }
  }
  for (final entry in modules.entries) {
    final normalizedModule = _norm(entry.key);
    if (!_skinsModules.contains(normalizedModule)) continue;
    if (entry.value == true) {
      normalizedModules[normalizedModule] = <String, Object?>{};
      out[normalizedModule] = <String, Object?>{};
      continue;
    }
    final payload = _coerceObjectMap(entry.value);
    if (payload.isEmpty && entry.value is! Map) continue;
    normalizedModules[normalizedModule] = payload;
    out[normalizedModule] = payload;
  }
  out['modules'] = normalizedModules;
  final umbrella = normalizeUmbrellaHostProps(
    props: out,
    modules: _skinsModules,
    roleAliases: _skinsRegistryRoleAliases,
    manifestDefaults: _skinsManifestDefaults,
  );
  out['manifest'] = umbrella['manifest'];
  out['registries'] = umbrella['registries'];
  _seedSkinsDefaults(out);
  return out;
}

void _seedSkinsDefaults(Map<String, Object?> out) {
  final resolvedSkins = _coerceSkins(out['skins']);
  final skins = resolvedSkins.isEmpty
      ? _defaultSkinNames.toList(growable: false)
      : resolvedSkins;
  out['skins'] = skins;

  final resolvedPresets = _coerceSkins(out['presets']);
  final presets = resolvedPresets.isEmpty
      ? _defaultSkinPresets.toList(growable: false)
      : resolvedPresets;
  out['presets'] = presets;

  final selectedRaw =
      (out['selected_skin'] ?? out['skin'] ?? out['value'] ?? '')
          .toString()
          .trim();
  final selectedSkin = selectedRaw.isEmpty ? skins.first : selectedRaw;
  out['selected_skin'] = selectedSkin;

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

  ensureModule('selector', <String, Object?>{
    'skins': skins,
    'selected_skin': selectedSkin,
  });
  ensureModule('preset', <String, Object?>{'presets': presets});
  ensureModule('preview', <String, Object?>{'label': 'Skin preview surface'});
  ensureModule('editor', <String, Object?>{
    'name': 'active_skin',
    'text':
        '{"skin":"$selectedSkin","primary":"#22d3ee","surface":"#0f172a","radius":"md"}',
  });
  ensureModule('token_mapper', <String, Object?>{
    'mapping': <String, Object?>{
      'color.primary': '#22d3ee',
      'color.surface': '#0f172a',
      'typography.family.body': 'JetBrains Mono',
      'material.surface': 'glass',
    },
  });

  ensureModule('colors', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'id': 'primary', 'value': '#22d3ee'},
      <String, Object?>{'id': 'surface', 'value': '#0f172a'},
      <String, Object?>{'id': 'text', 'value': '#e2e8f0'},
      <String, Object?>{'id': 'accent', 'value': '#8b5cf6'},
    ],
  });
  ensureModule('fonts', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'JetBrains Mono'},
      <String, Object?>{'name': 'IBM Plex Sans'},
      <String, Object?>{'name': 'Inter Tight'},
    ],
  });
  ensureModule('effects', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'Glow'},
      <String, Object?>{'name': 'Grain'},
      <String, Object?>{'name': 'Bloom'},
    ],
  });
  ensureModule('materials', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'name': 'Glass'},
      <String, Object?>{'name': 'Matte'},
      <String, Object?>{'name': 'Neon'},
    ],
  });

  ensureModule('color_editor', <String, Object?>{
    'title': 'Color Editor',
    'text': 'Edit semantic palettes and states.',
  });
  ensureModule('font_editor', <String, Object?>{
    'title': 'Font Editor',
    'text': 'Adjust families, scales, and line height.',
  });
  ensureModule('material_editor', <String, Object?>{
    'title': 'Material Editor',
    'text': 'Tune blur, noise, and reflectance.',
  });

  ensureModule('apply', <String, Object?>{'label': 'Apply'});
  ensureModule('clear', <String, Object?>{'label': 'Clear'});
  ensureModule('create_skin', <String, Object?>{'label': 'Create Skin'});
  ensureModule('edit_skin', <String, Object?>{'label': 'Edit Skin'});
  ensureModule('delete_skin', <String, Object?>{'label': 'Delete Skin'});

  out['modules'] = modules;
}

Map<String, Object?>? _sectionProps(Map<String, Object?> props, String key) {
  final normalized = _norm(key);
  final manifest = _coerceObjectMap(props['manifest']);
  final enabled = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _skinsModules,
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

List<String> _availableModules(
  Map<String, Object?> props,
  String currentModule,
) {
  final manifest = _coerceObjectMap(props['manifest']);
  final manifestModules = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _skinsModules,
  );
  if (manifestModules.isNotEmpty) {
    return manifestModules;
  }

  final out = <String>[];
  for (final module in _skinsModuleOrder) {
    if (props[module] is Map || props[module] == true) {
      out.add(module);
      continue;
    }
    final modules = _coerceObjectMap(props['modules']);
    if (modules[module] is Map || modules[module] == true) {
      out.add(module);
      continue;
    }
    if (module == currentModule) {
      out.add(module);
    }
  }
  if (out.isEmpty) {
    out.addAll(const ['selector', 'preview', 'editor', 'apply']);
  }
  return out;
}

Map<String, Object?> _coerceObjectMap(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

String _norm(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

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
  final selected = (props['selected_skin'] ?? props['skin'] ?? props['value'])
      ?.toString();
  if (selected != null && selected.isNotEmpty) {
    return selected;
  }
  if (skins.isNotEmpty) {
    return skins.first;
  }
  return null;
}

class _Header extends StatelessWidget {
  const _Header({
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

class _ModuleTabs extends StatelessWidget {
  const _ModuleTabs({
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

class _Selector extends StatelessWidget {
  const _Selector({
    required this.controlId,
    required this.props,
    required this.sendEvent,
    this.onSelectSkin,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ValueChanged<String>? onSelectSkin;

  @override
  Widget build(BuildContext context) {
    final options = _coerceSkins(
      props['skins'] ?? props['options'] ?? props['items'],
    );
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    final selected = _resolveSelected(props, options) ?? options.first;
    return DropdownButton<String>(
      value: options.contains(selected) ? selected : options.first,
      items: options
          .map(
            (skin) => DropdownMenuItem<String>(value: skin, child: Text(skin)),
          )
          .toList(growable: false),
      onChanged: (next) {
        if (next == null) return;
        onSelectSkin?.call(next);
        _emitEvent(controlId, props, sendEvent, 'select', {'skin': next});
      },
    );
  }
}

class _PresetList extends StatelessWidget {
  const _PresetList({
    required this.controlId,
    required this.props,
    required this.sendEvent,
    this.onSelectSkin,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ValueChanged<String>? onSelectSkin;

  @override
  Widget build(BuildContext context) {
    final presets = _coerceSkins(
      props['presets'] ?? props['items'] ?? props['options'],
    );
    if (presets.isEmpty) {
      final label = (props['label'] ?? props['name'] ?? 'Preset').toString();
      return OutlinedButton(
        onPressed: () {
          onSelectSkin?.call(label);
          _emitEvent(controlId, props, sendEvent, 'select', {'skin': label});
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
              onSelectSkin?.call(preset);
              _emitEvent(controlId, props, sendEvent, 'select', {
                'skin': preset,
              });
            },
            child: Text(preset),
          ),
      ],
    );
  }
}

class _Editor extends StatefulWidget {
  const _Editor({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  late final TextEditingController _controller = TextEditingController(
    text: (widget.props['value'] ?? widget.props['text'] ?? '').toString(),
  );

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
            _emitEvent(
              widget.controlId,
              widget.props,
              widget.sendEvent,
              'edit_skin',
              {
                'name': widget.props['name']?.toString(),
                'value': _controller.text,
              },
            );
          },
          child: const Text('Save Skin'),
        ),
      ],
    );
  }
}

class _NamedEditor extends StatefulWidget {
  const _NamedEditor({
    required this.controlId,
    required this.module,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final String module;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_NamedEditor> createState() => _NamedEditorState();
}

class _NamedEditorState extends State<_NamedEditor> {
  late final TextEditingController _controller = TextEditingController(
    text: (widget.props['value'] ?? widget.props['text'] ?? '').toString(),
  );

  @override
  Widget build(BuildContext context) {
    final title = (widget.props['title'] ?? widget.module.replaceAll('_', ' '))
        .toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          minLines: 3,
          maxLines: 10,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () {
            _emitEvent(
              widget.controlId,
              widget.props,
              widget.sendEvent,
              'change',
              {
                'module': widget.module,
                'name': widget.props['name']?.toString(),
                'value': _controller.text,
              },
            );
          },
          child: const Text('Save Module'),
        ),
      ],
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
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
    Map<String, Object?>? firstChild;
    for (final raw in rawChildren) {
      if (raw is Map) {
        firstChild = coerceObjectMap(raw);
        break;
      }
    }
    final preview = firstChild == null
        ? Center(child: Text((props['label'] ?? 'Skin Preview').toString()))
        : buildChild(firstChild);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: preview,
    );
  }
}

class _TokenMapper extends StatelessWidget {
  const _TokenMapper({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final mapping = props['mapping'];
    if (mapping is! Map) {
      return const SizedBox.shrink();
    }
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
            _emitEvent(controlId, props, sendEvent, 'token_map', {
              'mapping': mapping,
            });
          },
          child: const Text('Emit Mapping'),
        ),
      ],
    );
  }
}

class _CollectionModule extends StatelessWidget {
  const _CollectionModule({
    required this.controlId,
    required this.module,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final String module;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final items = props['items'] is List
        ? (props['items'] as List)
        : (props['options'] is List
              ? (props['options'] as List)
              : const <dynamic>[]);

    if (items.isEmpty) {
      return FilledButton.tonal(
        onPressed: () {
          _emitEvent(controlId, props, sendEvent, 'change', {
            'module': module,
            'action': 'touch',
          });
        },
        child: Text('Update ${module.replaceAll('_', ' ')}'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          FilterChip(
            selected: false,
            label: Text(
              item is Map
                  ? (item['label'] ?? item['name'] ?? item['id'] ?? '')
                        .toString()
                  : item.toString(),
            ),
            onSelected: (selected) {
              _emitEvent(controlId, props, sendEvent, 'change', {
                'module': module,
                'selected': selected,
                'value': item,
              });
            },
          ),
      ],
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
      onPressed: () {
        _emitEvent(controlId, props, sendEvent, controlType, {
          'name': props['name'],
          'skin': props['skin'] ?? props['value'],
          'payload': props['payload'],
        });
      },
      child: Text(label),
    );
  }
}
