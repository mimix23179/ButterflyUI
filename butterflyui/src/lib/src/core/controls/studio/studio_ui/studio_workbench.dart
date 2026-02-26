import 'dart:math' as math;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:flutter/material.dart';

import '../studio_contract.dart';
import '../studio_surfaces/studio_surface_router.dart';
import '../submodules/studio_submodule_context.dart';
import '../submodules/surfaces.dart';
import '../submodules/panels.dart';
import '../submodules/tools.dart';

typedef StudioEmitCallback =
    void Function(String event, Map<String, Object?> payload);
typedef StudioModuleSelectCallback = void Function(String module);

class StudioWorkbench extends StatefulWidget {
  const StudioWorkbench({
    super.key,
    required this.controlId,
    required this.runtimeProps,
    required this.availableModules,
    required this.activeModule,
    required this.history,
    required this.undoDepth,
    required this.redoDepth,
    required this.rawChildren,
    required this.customChildren,
    required this.onSelectModule,
    required this.onEmit,
    required this.sendEvent,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> runtimeProps;
  final List<String> availableModules;
  final String activeModule;
  final List<Map<String, Object?>> history;
  final int undoDepth;
  final int redoDepth;
  final List<dynamic> rawChildren;
  final List<Widget> customChildren;
  final StudioModuleSelectCallback onSelectModule;
  final StudioEmitCallback onEmit;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<StudioWorkbench> createState() => _StudioWorkbenchState();
}

class _StudioWorkbenchState extends State<StudioWorkbench> {
  static const _fallbackLeftTabs = <String>[
    'project_panel',
    'outline_tree',
    'component_palette',
    'block_palette',
    'asset_browser',
  ];

  static const _fallbackRightTabs = <String>[
    'inspector',
    'properties_panel',
    'actions_editor',
    'bindings_editor',
    'tokens_editor',
    'selection_tools',
    'transform_toolbar',
    'transform_box',
  ];

  String _left = 'project_panel';
  String _right = 'inspector';
  String _bottom = 'history';
  String _activeSurface = 'canvas';

  double _leftRatio = 0.22;
  double _rightRatio = 0.26;
  double _bottomHeight = 196;
  double _zoom = 1;

  String _selectedId = '';
  final Set<String> _selectedIds = <String>{};
  String _tool = 'select';

  @override
  void initState() {
    super.initState();
    _syncFromProps();
  }

  @override
  void didUpdateWidget(covariant StudioWorkbench oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncFromProps();
  }

  void _syncFromProps() {
    final selection =
        studioSectionProps(widget.runtimeProps, 'selection_tools') ?? {};
    _selectedId = (selection['selected_id'] ?? '').toString();
    _selectedIds
      ..clear()
      ..addAll(studioCoerceStringList(selection['selected_ids']));
    if (_selectedId.isNotEmpty) _selectedIds.add(_selectedId);

    _tool = studioNorm((selection['active_tool'] ?? 'select').toString());
    if (_tool.isEmpty) _tool = 'select';

    final responsive =
        studioSectionProps(widget.runtimeProps, 'responsive_toolbar') ?? {};
    _zoom = (coerceDouble(responsive['zoom']) ?? _zoom).clamp(0.25, 4.0);

    _leftRatio =
        (coerceDouble(widget.runtimeProps['left_pane_ratio']) ?? _leftRatio)
            .clamp(0.12, 0.4);
    _rightRatio =
        (coerceDouble(widget.runtimeProps['right_pane_ratio']) ?? _rightRatio)
            .clamp(0.16, 0.42);
    _bottomHeight =
        (coerceDouble(widget.runtimeProps['bottom_panel_height']) ??
                _bottomHeight)
            .clamp(120, 420);

    final manifest = studioCoerceObjectMap(widget.runtimeProps['manifest']);
    final surfaces = studioCoerceStringList(manifest['enabled_surfaces'])
        .map(normalizeStudioSurfaceToken)
        .where(studioSurfaceModules.contains)
        .toList(growable: false);
    final preferredSurface = normalizeStudioSurfaceToken(
      (selection['active_surface'] ?? widget.activeModule).toString(),
    );
    if (preferredSurface.isNotEmpty &&
        (surfaces.isEmpty || surfaces.contains(preferredSurface))) {
      _activeSurface = preferredSurface;
    } else if (surfaces.isNotEmpty) {
      _activeSurface = surfaces.first;
    } else {
      _activeSurface = 'canvas';
    }

    final leftTabs = _leftTabs();
    final rightTabs = _rightTabs();
    if (!leftTabs.contains(_left)) {
      _left = leftTabs.isEmpty ? 'project_panel' : leftTabs.first;
    }
    if (!rightTabs.contains(_right)) {
      _right = rightTabs.isEmpty ? 'inspector' : rightTabs.first;
    }
  }

  List<String> _leftTabs() {
    final layout = studioCoerceObjectMap(
      studioCoerceObjectMap(widget.runtimeProps['panels'])['layout'],
    );
    final configured = studioCoerceStringList(layout['left'])
        .map(normalizeStudioModuleToken)
        .where((module) => studioModules.contains(module))
        .where(widget.availableModules.contains)
        .toList(growable: false);
    if (configured.isNotEmpty) return configured;
    return _fallbackLeftTabs
        .where(widget.availableModules.contains)
        .toList(growable: false);
  }

  List<String> _rightTabs() {
    final layout = studioCoerceObjectMap(
      studioCoerceObjectMap(widget.runtimeProps['panels'])['layout'],
    );
    final configured = studioCoerceStringList(layout['right'])
        .map(normalizeStudioModuleToken)
        .where((module) => studioModules.contains(module))
        .where(widget.availableModules.contains)
        .toList(growable: false);
    if (configured.isNotEmpty) return configured;
    return _fallbackRightTabs
        .where(widget.availableModules.contains)
        .toList(growable: false);
  }

  List<String> _surfaceTabs() {
    final manifest = studioCoerceObjectMap(widget.runtimeProps['manifest']);
    final configured = studioCoerceStringList(manifest['enabled_surfaces'])
        .map(normalizeStudioSurfaceToken)
        .where(studioSurfaceModules.contains)
        .toList(growable: false);
    if (configured.isNotEmpty) return configured;
    return const <String>['canvas'];
  }

  Map<String, Object?> _section(String key) =>
      studioSectionProps(widget.runtimeProps, key) ?? <String, Object?>{};

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);
    return ensureUmbrellaLayoutBounds(
      props: widget.runtimeProps,
      child: body,
      defaultHeight: 1080,
      minHeight: 520,
      maxHeight: 3600,
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = (widget.runtimeProps['state'] ?? 'ready').toString();
    final layoutMode = studioNorm(
      (widget.runtimeProps['layout'] ?? '').toString(),
    );
    final customLayoutRequested =
        widget.runtimeProps['custom_layout'] == true && layoutMode == 'custom';
    final customLayoutMode = studioNorm(
      (widget.runtimeProps['custom_layout_mode'] ?? '').toString(),
    );
    final useCustomChildrenAsSurface =
        customLayoutRequested &&
        widget.customChildren.isNotEmpty &&
        (widget.runtimeProps['use_custom_children'] == true ||
            customLayoutMode == 'replace');
    final showChrome = widget.runtimeProps['show_chrome'] != false;
    final showModules = widget.runtimeProps['show_modules'] != false;

    if (state == 'loading') {
      return const Center(child: CircularProgressIndicator());
    }
    if (useCustomChildrenAsSurface) {
      return widget.customChildren.length == 1
          ? widget.customChildren.first
          : Column(children: widget.customChildren);
    }
    if (!showChrome) {
      return _center(context);
    }
    if (!showModules) {
      return Column(
        children: [
          _header(context),
          const SizedBox(height: 8),
          Expanded(child: _center(context)),
        ],
      );
    }

    return Column(
      children: [
        _header(context),
        const SizedBox(height: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bottom = _bottomHeight
                  .clamp(120, math.max(120, constraints.maxHeight * 0.45))
                  .toDouble();
              return Column(
                children: [
                  Expanded(child: _mainSplit(context)),
                  _HHandle(
                    onDelta: (delta) => setState(
                      () => _bottomHeight = (_bottomHeight - delta).clamp(
                        120,
                        420,
                      ),
                    ),
                  ),
                  SizedBox(height: bottom, child: _bottomDock(context)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final manifest = studioCoerceObjectMap(widget.runtimeProps['manifest']);
    final kit = (manifest['starter_kit'] ?? '').toString();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          const Text('Studio'),
          Chip(
            label: Text('State ${(widget.runtimeProps['state'] ?? 'ready')}'),
          ),
          Chip(label: Text('Surface $_activeSurface')),
          if (kit.isNotEmpty) Chip(label: Text('Kit $kit')),
          for (final surface in _surfaceTabs())
            FilterChip(
              selected: surface == _activeSurface,
              label: Text(surface.replaceAll('_', ' ')),
              onSelected: (_) {
                setState(() => _activeSurface = surface);
                widget.onSelectModule(surface);
                widget.onEmit('change', {
                  'module': surface,
                  'payload': {'active_surface': surface},
                });
              },
            ),
          FilledButton.tonal(
            onPressed: widget.undoDepth > 0
                ? () => widget.onEmit('change', {'action': 'undo'})
                : null,
            child: Text('Undo ${widget.undoDepth}'),
          ),
          FilledButton.tonal(
            onPressed: widget.redoDepth > 0
                ? () => widget.onEmit('change', {'action': 'redo'})
                : null,
            child: Text('Redo ${widget.redoDepth}'),
          ),
          FilledButton.tonal(
            onPressed: () => widget.onEmit('submit', {
              'module': 'project_panel',
              'intent': 'save_project',
            }),
            child: const Text('Save'),
          ),
          FilledButton.tonal(
            onPressed: () => widget.onEmit('submit', {
              'module': 'project_panel',
              'intent': 'export_project',
            }),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _mainSplit(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final total = constraints.maxWidth;
        final leftWidth = (total * _leftRatio).clamp(180, 460).toDouble();
        final rightWidth = (total * _rightRatio).clamp(220, 560).toDouble();
        final leftTabs = _leftTabs();
        final rightTabs = _rightTabs();

        return Row(
          children: [
            SizedBox(
              width: leftWidth,
              child: _dock(
                context,
                'Explorer',
                leftTabs,
                _left,
                (value) => setState(() => _left = value),
              ),
            ),
            _VHandle(
              onDelta: (delta) => setState(
                () =>
                    _leftRatio = (_leftRatio + delta / total).clamp(0.12, 0.4),
              ),
            ),
            Expanded(child: _center(context)),
            _VHandle(
              onDelta: (delta) => setState(
                () => _rightRatio = (_rightRatio - delta / total).clamp(
                  0.16,
                  0.42,
                ),
              ),
            ),
            SizedBox(
              width: rightWidth,
              child: _dock(
                context,
                'Inspector',
                rightTabs,
                _right,
                (value) => setState(() => _right = value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dock(
    BuildContext context,
    String title,
    List<String> tabs,
    String active,
    ValueChanged<String> onSelect,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tab in tabs)
                ChoiceChip(
                  selected: tab == active,
                  label: Text(tab.replaceAll('_', ' ')),
                  onSelected: (_) {
                    onSelect(tab);
                    widget.onSelectModule(tab);
                    widget.onEmit('change', {
                      'module': tab,
                      'payload': {'focused_panel': tab},
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: _modulePanel(context, active)),
        ],
      ),
    );
  }

  Widget _center(BuildContext context) {
    final responsive = _section('responsive_toolbar');
    final centerBackground =
        coerceColor(
          widget.runtimeProps['workspace_bg'] ??
              widget.runtimeProps['background'] ??
              _section('canvas')['background'] ??
              _section('canvas')['bgcolor'],
        ) ??
        const Color(0xff0b1220);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: centerBackground,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Responsive'),
              Chip(
                label: Text(
                  'Viewport ${(coerceDouble(responsive['width']) ?? 1280).toInt()}x${(coerceDouble(responsive['height']) ?? 720).toInt()}',
                ),
              ),
              SizedBox(
                width: 240,
                child: Row(
                  children: [
                    const Text('Zoom'),
                    Expanded(
                      child: Slider(
                        value: _zoom,
                        min: 0.25,
                        max: 3,
                        onChanged: (value) => setState(() => _zoom = value),
                        onChangeEnd: (value) => widget.onEmit('change', {
                          'module': 'responsive_toolbar',
                          'payload': {'zoom': value},
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              for (final tool in ['select', 'move', 'resize', 'rotate', 'trim'])
                FilterChip(
                  selected: _tool == tool,
                  label: Text(tool),
                  onSelected: (_) => _setTool(tool),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StudioSurfaceRouter(
              runtimeProps: widget.runtimeProps,
              activeSurface: _activeSurface,
              selectedIds: _selectedIds,
              zoom: _zoom,
              onSelectEntity: _pick,
            ),
          ),
        ],
      ),
    );
  }

  void _pick(String id, {bool additive = false}) {
    setState(() {
      if (!additive) _selectedIds.clear();
      if (_selectedIds.contains(id) && additive) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
      _selectedId = _selectedIds.isEmpty ? '' : _selectedIds.first;
    });
    widget.onEmit('select', {
      'module': _activeSurface,
      'selected_id': _selectedId,
      'selected_ids': _selectedIds.toList(growable: false),
      'active_surface': _activeSurface,
    });
  }

  void _setTool(String tool) {
    setState(() => _tool = tool);
    widget.onEmit('change', {
      'module': 'selection_tools',
      'payload': {'active_tool': tool},
    });
  }

  StudioSubmoduleContext _makeCtx(String module) {
    return StudioSubmoduleContext(
      controlId: widget.controlId,
      module: module,
      section: _section(module),
      runtimeProps: widget.runtimeProps,
      activeSurface: _activeSurface,
      selectedIds: _selectedIds,
      zoom: _zoom,
      onEmit: widget.onEmit,
      onSelectEntity: _pick,
      sendEvent: widget.sendEvent,
      rawChildren: widget.rawChildren,
      buildChild: widget.buildChild,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
  }

  Widget _modulePanel(BuildContext context, String module) {
    final ctx = _makeCtx(module);
    return buildStudioSurfacesSection(ctx) ??
        buildStudioPanelsSection(ctx) ??
        buildStudioToolsSection(ctx) ??
        _fallbackModulePanel(context, module);
  }

  Widget _fallbackModulePanel(BuildContext context, String module) {
    final section = _section(module);
    final list = studioCoerceMapList(
      section['items'] ??
          section['nodes'] ??
          section['assets'] ??
          section['actions'] ??
          section['tools'],
    );
    if (list.isEmpty) {
      return Center(child: Text('No data for ${module.replaceAll('_', ' ')}'));
    }
    return ListView(
      children: [
        for (final item in list.take(120))
          ListTile(
            dense: true,
            title: Text(
              (item['label'] ?? item['name'] ?? item['id'] ?? '').toString(),
            ),
            subtitle: Text(item.toString()),
            onTap: () =>
                widget.onEmit('select', {'module': module, 'item': item}),
          ),
      ],
    );
  }

  Widget _bottomDock(BuildContext context) {
    final manifest = studioCoerceObjectMap(widget.runtimeProps['manifest']);
    final registries = studioCoerceObjectMap(widget.runtimeProps['registries']);
    final panels = studioCoerceObjectMap(widget.runtimeProps['panels']);
    final shortcuts = studioCoerceObjectMap(widget.runtimeProps['shortcuts']);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tab in [
                'history',
                'manifest',
                'registries',
                'panels',
                'shortcuts',
              ])
                ChoiceChip(
                  selected: _bottom == tab,
                  label: Text(tab),
                  onSelected: (_) => setState(() => _bottom = tab),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: switch (_bottom) {
              'manifest' => _objectList(manifest),
              'registries' => _objectList(registries),
              'panels' => _objectList(panels),
              'shortcuts' => _objectList(shortcuts),
              _ =>
                widget.history.isEmpty
                    ? const Center(child: Text('No history'))
                    : ListView(
                        children: [
                          for (final item in widget.history.reversed.take(160))
                            ListTile(
                              dense: true,
                              title: Text((item['label'] ?? '').toString()),
                              subtitle: Text((item['kind'] ?? '').toString()),
                            ),
                        ],
                      ),
            },
          ),
        ],
      ),
    );
  }

  Widget _objectList(Map<String, Object?> map) {
    if (map.isEmpty) return const Center(child: Text('No data'));
    return ListView(
      children: [
        for (final entry in map.entries)
          ListTile(
            dense: true,
            title: Text(entry.key),
            subtitle: Text(entry.value.toString()),
          ),
      ],
    );
  }
}

class _VHandle extends StatelessWidget {
  const _VHandle({required this.onDelta});

  final ValueChanged<double> onDelta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) => onDelta(details.delta.dx),
      child: const SizedBox(width: 8),
    );
  }
}

class _HHandle extends StatelessWidget {
  const _HHandle({required this.onDelta});

  final ValueChanged<double> onDelta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) => onDelta(details.delta.dy),
      child: const SizedBox(height: 8),
    );
  }
}
