import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

const int _studioSchemaVersion = 2;

const List<String> _studioModuleOrder = [
  'builder',
  'canvas',
  'block_palette',
  'component_palette',
  'inspector',
  'outline_tree',
  'project_panel',
  'properties_panel',
  'responsive_toolbar',
  'tokens_editor',
  'actions_editor',
  'bindings_editor',
  'asset_browser',
  'selection_tools',
  'transform_box',
  'transform_toolbar',
];

const Set<String> _studioModules = {
  'actions_editor',
  'asset_browser',
  'bindings_editor',
  'block_palette',
  'builder',
  'canvas',
  'component_palette',
  'inspector',
  'outline_tree',
  'project_panel',
  'properties_panel',
  'responsive_toolbar',
  'tokens_editor',
  'selection_tools',
  'transform_box',
  'transform_toolbar',
};

const Set<String> _studioStates = {
  'idle',
  'loading',
  'ready',
  'editing',
  'preview',
  'disabled',
};

const Set<String> _studioEvents = {
  'ready',
  'change',
  'submit',
  'select',
  'state_change',
  'module_change',
};

class ButterflyUIStudio extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> initialProps;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

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

  @override
  State<ButterflyUIStudio> createState() => _ButterflyUIStudioState();
}

class _ButterflyUIStudioState extends State<ButterflyUIStudio> {
  late Map<String, Object?> _runtimeProps;

  @override
  void initState() {
    super.initState();
    _runtimeProps = _normalizeProps(widget.initialProps);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant ButterflyUIStudio oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = _normalizeProps(widget.initialProps);
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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (_norm(method)) {
      case 'get_state':
        return {
          'schema_version': _runtimeProps['schema_version'] ?? _studioSchemaVersion,
          'module': _runtimeProps['module'],
          'state': _runtimeProps['state'],
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
            _runtimeProps = _normalizeProps(_runtimeProps);
          });
        }
        return _runtimeProps;
      case 'set_module':
        final module = _norm(args['module']?.toString() ?? '');
        if (!_studioModules.contains(module)) {
          return {'ok': false, 'error': 'unknown module: $module'};
        }
        final payload = args['payload'];
        final payloadMap = payload is Map ? coerceObjectMap(payload) : <String, Object?>{};
        setState(() {
          final modules = _coerceObjectMap(_runtimeProps['modules']);
          modules[module] = payloadMap;
          _runtimeProps['modules'] = modules;
          _runtimeProps['module'] = module;
          _runtimeProps[module] = payloadMap;
          _runtimeProps = _normalizeProps(_runtimeProps);
        });
        _emitConfiguredEvent('module_change', {'module': module, 'payload': payloadMap});
        return {'ok': true, 'module': module};
      case 'set_state':
        final state = _norm(args['state']?.toString() ?? '');
        if (!_studioStates.contains(state)) {
          return {'ok': false, 'error': 'unknown state: $state'};
        }
        setState(() {
          _runtimeProps['state'] = state;
        });
        _emitConfiguredEvent('state_change', {'state': state});
        return {'ok': true, 'state': state};
      case 'emit':
      case 'trigger':
        final fallback = method == 'trigger' ? 'change' : method;
        final event = _norm((args['event'] ?? args['name'] ?? fallback).toString());
        if (!_studioEvents.contains(event)) {
          return {'ok': false, 'error': 'unknown event: $event'};
        }
        final payload = args['payload'];
        _emitConfiguredEvent(event, payload is Map ? coerceObjectMap(payload) : args);
        return true;
      default:
        final normalized = _norm(method);
        if (_studioModules.contains(normalized)) {
          final payload = args['payload'];
          final payloadMap = payload is Map ? coerceObjectMap(payload) : <String, Object?>{...args};
          setState(() {
            final modules = _coerceObjectMap(_runtimeProps['modules']);
            modules[normalized] = payloadMap;
            _runtimeProps['modules'] = modules;
            _runtimeProps['module'] = normalized;
            _runtimeProps[normalized] = payloadMap;
            _runtimeProps = _normalizeProps(_runtimeProps);
          });
          _emitConfiguredEvent('module_change', {'module': normalized, 'payload': payloadMap});
          return {'ok': true, 'module': normalized};
        }
        return {'ok': false, 'error': 'unknown method: $method'};
    }
  }

  Set<String> _configuredEvents() {
    final raw = _runtimeProps['events'];
    final out = <String>{};
    if (raw is List) {
      for (final entry in raw) {
        final value = _norm(entry?.toString() ?? '');
        if (value.isNotEmpty && _studioEvents.contains(value)) {
          out.add(value);
        }
      }
    }
    return out;
  }

  void _emitConfiguredEvent(String event, Map<String, Object?> payload) {
    final normalized = _norm(event);
    final configured = _configuredEvents();
    if (configured.isNotEmpty && !configured.contains(normalized)) {
      return;
    }
    widget.sendEvent(widget.controlId, normalized, {
      'schema_version': _runtimeProps['schema_version'] ?? _studioSchemaVersion,
      'module': _runtimeProps['module'],
      'state': _runtimeProps['state'],
      ...payload,
    });
  }

  Widget _buildModuleSection(String module, Map<String, Object?> section) {
    switch (module) {
      case 'builder':
      case 'canvas':
        final selected = (section['selected_id'] ?? '').toString();
        final showGrid = section['show_grid'] == true;
        final snapToGrid = section['snap_to_grid'] == true;
        final gridSize = coerceDouble(section['grid_size']) ?? 8;
        final moduleRadius =
            coerceDouble(section['radius'] ?? _runtimeProps['radius']) ?? 10;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(moduleRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected: ${selected.isEmpty ? '-' : selected}'),
              const SizedBox(height: 6),
              Text('Grid: ${showGrid ? 'on' : 'off'} · Snap: ${snapToGrid ? 'on' : 'off'} · Size: $gridSize'),
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: () => _emitConfiguredEvent('select', {'module': module, 'selected_id': selected}),
                child: const Text('Emit Select'),
              ),
            ],
          ),
        );
      case 'block_palette':
      case 'component_palette':
        return _StudioSearchModule(module: module, props: section, onEmit: _emitConfiguredEvent);
      case 'asset_browser':
      case 'outline_tree':
      case 'project_panel':
      case 'selection_tools':
      case 'transform_toolbar':
      case 'responsive_toolbar':
        return _StudioListModule(module: module, props: section, onEmit: _emitConfiguredEvent);
      case 'transform_box':
        return _StudioTransformModule(props: section, onEmit: _emitConfiguredEvent);
      default:
        return _StudioGenericModule(module: module, props: section, onEmit: _emitConfiguredEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableModules = _availableModules(_runtimeProps);
    final activeModule = _norm(_runtimeProps['module']?.toString() ?? 'builder');
    final customChildren = widget.rawChildren
        .whereType<Map>()
        .map((child) => widget.buildChild(coerceObjectMap(child)))
        .toList(growable: false);
    final showChrome =
        _runtimeProps['show_modules'] == true || _runtimeProps['show_chrome'] == true;

    if ((_runtimeProps['state']?.toString() ?? '') == 'loading') {
      return const Center(child: CircularProgressIndicator());
    }

    if (customChildren.isNotEmpty && !showChrome) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StudioHeader(
          state: (_runtimeProps['state'] ?? 'ready').toString(),
          module: activeModule,
        ),
        const SizedBox(height: 8),
        _StudioModuleTabs(
          modules: availableModules,
          activeModule: activeModule,
          onSelect: (module) {
            setState(() {
              _runtimeProps['module'] = module;
            });
            _emitConfiguredEvent('module_change', {'module': module});
          },
        ),
        const SizedBox(height: 8),
        for (final module in availableModules) ...[
          ExpansionTile(
            key: ValueKey<String>('studio_module_$module'),
            initiallyExpanded: module == activeModule,
            title: Text(module.replaceAll('_', ' ')),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            children: [
              _buildModuleSection(
                module,
                _sectionProps(_runtimeProps, module) ?? <String, Object?>{'events': _runtimeProps['events']},
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

Map<String, Object?> _normalizeProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] = (coerceOptionalInt(out['schema_version']) ?? _studioSchemaVersion).clamp(1, 9999);

  final module = _norm(out['module']?.toString() ?? '');
  if (module.isNotEmpty && _studioModules.contains(module)) {
    out['module'] = module;
  } else if (module.isNotEmpty) {
    out.remove('module');
  }

  final state = _norm(out['state']?.toString() ?? '');
  if (state.isNotEmpty && _studioStates.contains(state)) {
    out['state'] = state;
  } else if (state.isNotEmpty) {
    out.remove('state');
  }

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((e) => _norm(e?.toString() ?? ''))
        .where((e) => e.isNotEmpty && _studioEvents.contains(e))
        .toSet()
        .toList(growable: false);
  }

  final modules = _coerceObjectMap(out['modules']);
  final normalizedModules = <String, Object?>{};
  for (final moduleKey in _studioModules) {
    final topLevel = out[moduleKey];
    if (topLevel is Map) {
      final value = coerceObjectMap(topLevel);
      normalizedModules[moduleKey] = value;
      out[moduleKey] = value;
    }
  }
  for (final entry in modules.entries) {
    final normalized = _norm(entry.key);
    if (!_studioModules.contains(normalized)) continue;
    final value = _coerceObjectMap(entry.value);
    normalizedModules[normalized] = value;
    out[normalized] = value;
  }
  out['modules'] = normalizedModules;

  return out;
}

List<String> _availableModules(Map<String, Object?> props) {
  final modules = <String>[];
  final moduleMap = _coerceObjectMap(props['modules']);
  for (final key in _studioModuleOrder) {
    if (props[key] is Map || moduleMap[key] is Map) {
      modules.add(key);
    }
  }
  if (modules.isEmpty) {
    modules.addAll(const ['builder', 'canvas', 'inspector']);
  }
  return modules;
}

Map<String, Object?>? _sectionProps(Map<String, Object?> props, String key) {
  final normalized = _norm(key);
  final section = props[normalized];
  if (section is Map) {
    return <String, Object?>{...coerceObjectMap(section), 'events': props['events']};
  }
  final modules = _coerceObjectMap(props['modules']);
  final fromModules = modules[normalized];
  if (fromModules is Map) {
    return <String, Object?>{...coerceObjectMap(fromModules), 'events': props['events']};
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

class _StudioHeader extends StatelessWidget {
  const _StudioHeader({required this.state, required this.module});

  final String state;
  final String module;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Studio', style: Theme.of(context).textTheme.titleMedium),
              Text('State: $state', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Text('Module: $module'),
      ],
    );
  }
}

class _StudioModuleTabs extends StatelessWidget {
  const _StudioModuleTabs({
    required this.modules,
    required this.activeModule,
    required this.onSelect,
  });

  final List<String> modules;
  final String activeModule;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final module in modules)
          ChoiceChip(
            selected: module == activeModule,
            label: Text(module.replaceAll('_', ' ')),
            onSelected: (_) => onSelect(module),
          ),
      ],
    );
  }
}

class _StudioSearchModule extends StatefulWidget {
  const _StudioSearchModule({
    required this.module,
    required this.props,
    required this.onEmit,
  });

  final String module;
  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  State<_StudioSearchModule> createState() => _StudioSearchModuleState();
}

class _StudioSearchModuleState extends State<_StudioSearchModule> {
  late final TextEditingController _controller = TextEditingController(
    text: (widget.props['query'] ?? '').toString(),
  );

  @override
  void didUpdateWidget(covariant _StudioSearchModule oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextQuery = (widget.props['query'] ?? '').toString();
    if (nextQuery != _controller.text) {
      _controller.text = nextQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocks = widget.props['blocks'] is List
        ? (widget.props['blocks'] as List)
        : const <dynamic>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: () {
                widget.onEmit('change', {
                  'module': widget.module,
                  'query': _controller.text,
                });
              },
              child: const Text('Apply'),
            ),
          ],
        ),
        if (blocks.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final block in blocks.take(24))
                ActionChip(
                  label: Text(block is Map
                      ? (block['label'] ?? block['title'] ?? block['id'] ?? '').toString()
                      : block.toString()),
                  onPressed: () => widget.onEmit('select', {
                    'module': widget.module,
                    'item': block,
                  }),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _StudioListModule extends StatelessWidget {
  const _StudioListModule({
    required this.module,
    required this.props,
    required this.onEmit,
  });

  final String module;
  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  Widget build(BuildContext context) {
    final candidates = [
      props['items'],
      props['nodes'],
      props['assets'],
      props['breakpoints'],
      props['tools'],
      props['actions'],
    ];
    List<dynamic> values = const <dynamic>[];
    for (final candidate in candidates) {
      if (candidate is List) {
        values = candidate;
        break;
      }
    }

    if (values.isEmpty) {
      return Text('No items for ${module.replaceAll('_', ' ')}');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final value in values.take(30))
          ListTile(
            dense: true,
            title: Text(value is Map
                ? (value['label'] ?? value['name'] ?? value['id'] ?? value.toString()).toString()
                : value.toString()),
            onTap: () => onEmit('select', {'module': module, 'item': value}),
          ),
      ],
    );
  }
}

class _StudioTransformModule extends StatelessWidget {
  const _StudioTransformModule({required this.props, required this.onEmit});

  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  Widget build(BuildContext context) {
    final x = coerceDouble(props['x']) ?? 0;
    final y = coerceDouble(props['y']) ?? 0;
    final w = coerceDouble(props['width']) ?? 0;
    final h = coerceDouble(props['height']) ?? 0;
    final rotation = coerceDouble(props['rotation']) ?? 0;

    return Row(
      children: [
        Expanded(child: Text('x: $x, y: $y')),
        Expanded(child: Text('w: $w, h: $h')),
        Expanded(child: Text('rot: $rotation')),
        FilledButton.tonal(
          onPressed: () => onEmit('change', {
            'module': 'transform_box',
            'x': x,
            'y': y,
            'width': w,
            'height': h,
            'rotation': rotation,
          }),
          child: const Text('Emit'),
        ),
      ],
    );
  }
}

class _StudioGenericModule extends StatelessWidget {
  const _StudioGenericModule({
    required this.module,
    required this.props,
    required this.onEmit,
  });

  final String module;
  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  Widget build(BuildContext context) {
    final entries = props.entries.where((e) => e.key != 'events').toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (entries.isEmpty)
          Text('No payload for ${module.replaceAll('_', ' ')}')
        else
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('${entry.key}: ${entry.value}'),
            ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () => onEmit('select', {'module': module, 'payload': props}),
          child: const Text('Emit Select'),
        ),
      ],
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
