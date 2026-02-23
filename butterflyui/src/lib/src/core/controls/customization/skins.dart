import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
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

const Set<String> _skinsStates = {'idle', 'loading', 'ready', 'editing', 'preview', 'disabled'};

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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    final normalizedMethod = _norm(method);
    switch (normalizedMethod) {
      case 'get_state':
        return {
          'schema_version': _runtimeProps['schema_version'],
          'module': _runtimeProps['module'],
          'state': _runtimeProps['state'],
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
            _skins = _coerceSkins(_runtimeProps['skins'] ?? _runtimeProps['presets']);
            _selectedSkin = _resolveSelected(_runtimeProps, _skins);
          });
        }
        return _runtimeProps;
      case 'set_module':
        {
          final module = _norm(args['module']?.toString() ?? '');
          if (!_skinsModules.contains(module)) {
            return {'ok': false, 'error': 'unknown module: $module'};
          }
          final payload = args['payload'];
          final payloadMap = payload is Map ? coerceObjectMap(payload) : <String, Object?>{};
          setState(() {
            _setModuleAndPayload(module, payloadMap);
          });
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'module_change', {
            'module': module,
            'payload': payloadMap,
          });
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
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'state_change', {'state': state});
          return {'ok': true, 'state': state};
        }
      case 'emit':
      case 'trigger':
        final fallback = method == 'trigger' ? 'change' : method;
        final event = _norm((args['event'] ?? args['name'] ?? fallback).toString());
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
        final skin = (args['skin'] ?? args['value'] ?? _selectedSkin)?.toString();
        if (skin != null && skin.isNotEmpty) {
          setState(() {
            _selectedSkin = skin;
            if (!_skins.contains(skin)) {
              _skins = <String>[..._skins, skin];
            }
            _runtimeProps['selected_skin'] = skin;
          });
        }
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'apply', {'skin': _selectedSkin});
        return _selectedSkin;
      case 'clear':
        setState(() {
          _selectedSkin = null;
          _runtimeProps.remove('selected_skin');
        });
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'clear', {});
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
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'create_skin', {
            'name': name,
            'payload': args['payload'],
          });
          return name;
        }
      case 'edit_skin':
        {
          final name = (args['name'] ?? args['skin'] ?? _selectedSkin ?? '').toString();
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'edit_skin', {
            'name': name,
            'payload': args['payload'],
          });
          return name;
        }
      case 'delete_skin':
        {
          final name = (args['name'] ?? args['skin'] ?? _selectedSkin ?? '').toString();
          setState(() {
            _skins = _skins.where((entry) => entry != name).toList(growable: false);
            if (_selectedSkin == name) {
              _selectedSkin = _skins.isEmpty ? null : _skins.first;
              _runtimeProps['selected_skin'] = _selectedSkin;
            }
          });
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'delete_skin', {'name': name});
          return true;
        }
      default:
        if (_skinsModules.contains(normalizedMethod)) {
          final payload = args['payload'];
          final payloadMap = payload is Map ? coerceObjectMap(payload) : <String, Object?>{...args};
          setState(() {
            _setModuleAndPayload(normalizedMethod, payloadMap);
          });
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'change', {
            'module': normalizedMethod,
            'payload': payloadMap,
          });
          return {'ok': true, 'module': normalizedMethod};
        }
        throw UnsupportedError('Unknown skins method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = (_runtimeProps['state'] ?? 'ready').toString();
    final currentModule = _norm(_runtimeProps['module']?.toString() ?? '');
    final availableModules = _availableModules(_runtimeProps, currentModule);
    final customChildren = widget.rawChildren
        .whereType<Map>()
        .map((child) => widget.buildChild(coerceObjectMap(child)))
        .toList(growable: false);
    final customLayout = _runtimeProps['custom_layout'] == true ||
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

    final sectionWidgets = <Widget>[];

    sectionWidgets.add(
      _Header(
        state: state,
        selectedSkin: _selectedSkin,
        skinCount: _skins.length,
      ),
    );

    sectionWidgets.add(
      _ModuleTabs(
        modules: availableModules,
        currentModule: currentModule,
        onSelected: (module) {
          setState(() {
            _runtimeProps['module'] = module;
          });
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'module_change', {
            'module': module,
          });
        },
      ),
    );

    for (final module in _skinsModuleOrder) {
      if (_actionModules.contains(module)) {
        continue;
      }
      final section = _sectionProps(_runtimeProps, module);
      if (section == null && module != currentModule) {
        continue;
      }
      final payload = section ?? <String, Object?>{'events': _runtimeProps['events']};
      final widgetForModule = _buildModuleWidget(module, payload);
      if (widgetForModule != null) {
        sectionWidgets.add(
          _ModulePanel(
            module: module,
            expanded: module == currentModule,
            child: widgetForModule,
          ),
        );
      }
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
          props: section ?? <String, Object?>{'events': _runtimeProps['events']},
          sendEvent: widget.sendEvent,
        ),
      );
    }
    if (actionWidgets.isNotEmpty) {
      sectionWidgets.add(Wrap(spacing: 8, runSpacing: 8, children: actionWidgets));
    }

    if (sectionWidgets.length <= 2 && _skins.isNotEmpty) {
      final selected = _selectedSkin ?? _skins.first;
      sectionWidgets.add(
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _skins.contains(selected) ? selected : _skins.first,
                items: _skins
                    .map((skin) => DropdownMenuItem<String>(value: skin, child: Text(skin)))
                    .toList(growable: false),
                onChanged: (next) {
                  if (next == null) return;
                  setState(() {
                    _selectedSkin = next;
                    _runtimeProps['selected_skin'] = next;
                  });
                  _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'select', {'skin': next});
                },
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {
                _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'apply', {
                  'skin': _selectedSkin,
                });
              },
              child: const Text('Apply'),
            ),
          ],
        ),
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

  Widget? _buildModuleWidget(String module, Map<String, Object?> section) {
    switch (module) {
      case 'selector':
        return _Selector(controlId: widget.controlId, props: section, sendEvent: widget.sendEvent);
      case 'preset':
        return _PresetList(controlId: widget.controlId, props: section, sendEvent: widget.sendEvent);
      case 'editor':
        return _Editor(controlId: widget.controlId, props: section, sendEvent: widget.sendEvent);
      case 'preview':
        return _Preview(
          props: section,
          rawChildren: widget.rawChildren,
          buildChild: widget.buildChild,
          radius: coerceDouble(section['radius'] ?? _runtimeProps['radius']) ?? 12,
        );
      case 'token_mapper':
        return _TokenMapper(controlId: widget.controlId, props: section, sendEvent: widget.sendEvent);
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
        return _CollectionModule(controlId: widget.controlId, module: module, props: section, sendEvent: widget.sendEvent);
    }
  }
}

Map<String, Object?> _normalizeProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] = (coerceOptionalInt(out['schema_version']) ?? _skinsSchemaVersion).clamp(1, 9999);

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
    final payload = _coerceObjectMap(entry.value);
    normalizedModules[normalizedModule] = payload;
    out[normalizedModule] = payload;
  }
  out['modules'] = normalizedModules;

  return out;
}

Map<String, Object?>? _sectionProps(Map<String, Object?> props, String key) {
  final normalized = _norm(key);
  final section = props[normalized];
  if (section is Map) {
    return <String, Object?>{...coerceObjectMap(section), 'events': props['events']};
  }
  if (section == true) {
    return <String, Object?>{'events': props['events']};
  }
  final modules = _coerceObjectMap(props['modules']);
  final fromModules = modules[normalized];
  if (fromModules is Map) {
    return <String, Object?>{...coerceObjectMap(fromModules), 'events': props['events']};
  }
  return null;
}

List<String> _availableModules(Map<String, Object?> props, String currentModule) {
  final out = <String>[];
  for (final module in _skinsModuleOrder) {
    if (props[module] is Map || props[module] == true) {
      out.add(module);
      continue;
    }
    final modules = _coerceObjectMap(props['modules']);
    if (modules[module] is Map) {
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
  final selected = (props['selected_skin'] ?? props['skin'] ?? props['value'])?.toString();
  if (selected != null && selected.isNotEmpty) {
    return selected;
  }
  if (skins.isNotEmpty) {
    return skins.first;
  }
  return null;
}

class _Header extends StatelessWidget {
  const _Header({required this.state, required this.selectedSkin, required this.skinCount});

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
              Text('State: $state', style: Theme.of(context).textTheme.bodySmall),
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
  const _ModuleTabs({required this.modules, required this.currentModule, required this.onSelected});

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

class _ModulePanel extends StatelessWidget {
  const _ModulePanel({required this.module, required this.expanded, required this.child});

  final String module;
  final bool expanded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: ValueKey<String>('skins_module_$module'),
      initiallyExpanded: expanded,
      title: Text(module.replaceAll('_', ' ')),
      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      children: [child],
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final options = _coerceSkins(props['skins'] ?? props['options'] ?? props['items']);
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    final selected = _resolveSelected(props, options) ?? options.first;
    return DropdownButton<String>(
      value: options.contains(selected) ? selected : options.first,
      items: options
          .map((skin) => DropdownMenuItem<String>(value: skin, child: Text(skin)))
          .toList(growable: false),
      onChanged: (next) {
        if (next == null) return;
        _emitEvent(controlId, props, sendEvent, 'select', {'skin': next});
      },
    );
  }
}

class _PresetList extends StatelessWidget {
  const _PresetList({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final presets = _coerceSkins(props['presets'] ?? props['items'] ?? props['options']);
    if (presets.isEmpty) {
      final label = (props['label'] ?? props['name'] ?? 'Preset').toString();
      return OutlinedButton(
        onPressed: () => _emitEvent(controlId, props, sendEvent, 'select', {'skin': label}),
        child: Text(label),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final preset in presets)
          OutlinedButton(
            onPressed: () => _emitEvent(controlId, props, sendEvent, 'select', {'skin': preset}),
            child: Text(preset),
          ),
      ],
    );
  }
}

class _Editor extends StatefulWidget {
  const _Editor({required this.controlId, required this.props, required this.sendEvent});

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
            _emitEvent(widget.controlId, widget.props, widget.sendEvent, 'edit_skin', {
              'name': widget.props['name']?.toString(),
              'value': _controller.text,
            });
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
    final title = (widget.props['title'] ?? widget.module.replaceAll('_', ' ')).toString();
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
            _emitEvent(widget.controlId, widget.props, widget.sendEvent, 'change', {
              'module': widget.module,
              'name': widget.props['name']?.toString(),
              'value': _controller.text,
            });
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
  const _TokenMapper({required this.controlId, required this.props, required this.sendEvent});

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
        : (props['options'] is List ? (props['options'] as List) : const <dynamic>[]);

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
            label: Text(item is Map ? (item['label'] ?? item['name'] ?? item['id'] ?? '').toString() : item.toString()),
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
    final label = (props['label'] ?? controlType.replaceAll('_', ' ')).toString();
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
