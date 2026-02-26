import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart' as xterm;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

import 'submodules/terminal_submodule_context.dart';
import 'submodules/views.dart';
import 'submodules/inputs.dart';
import 'submodules/providers.dart';

const int _terminalSchemaVersion = 2;

const List<String> _terminalModuleOrder = [
  'workbench',
  'view',
  'tabs',
  'session',
  'stream',
  'stream_view',
  'raw_view',
  'prompt',
  'stdin',
  'stdin_injector',
  'command_builder',
  'flow_gate',
  'capabilities',
  'output_mapper',
  'presets',
  'progress',
  'progress_view',
  'timeline',
  'replay',
  'execution_lane',
  'process_bridge',
  'log_viewer',
  'log_panel',
];

const Set<String> _terminalModules = {
  'capabilities',
  'command_builder',
  'flow_gate',
  'output_mapper',
  'presets',
  'progress',
  'progress_view',
  'prompt',
  'raw_view',
  'replay',
  'session',
  'stdin',
  'stdin_injector',
  'stream',
  'stream_view',
  'tabs',
  'timeline',
  'view',
  'workbench',
  'process_bridge',
  'execution_lane',
  'log_viewer',
  'log_panel',
};

const Set<String> _terminalStates = {
  'idle',
  'loading',
  'ready',
  'running',
  'paused',
  'disabled',
};

const Set<String> _terminalEvents = {
  'ready',
  'change',
  'submit',
  'input',
  'output',
  'state_change',
  'module_change',
};

const Map<String, String> _terminalRegistryRoleAliases = {
  'module': 'module_registry',
  'modules': 'module_registry',
  'view': 'view_registry',
  'views': 'view_registry',
  'panel': 'panel_registry',
  'panels': 'panel_registry',
  'tool': 'tool_registry',
  'tools': 'tool_registry',
  'provider': 'provider_registry',
  'providers': 'provider_registry',
  'backend': 'provider_registry',
  'backends': 'provider_registry',
  'bridge': 'provider_registry',
  'bridges': 'provider_registry',
  'command': 'command_registry',
  'commands': 'command_registry',
  'module_registry': 'module_registry',
  'view_registry': 'view_registry',
  'panel_registry': 'panel_registry',
  'tool_registry': 'tool_registry',
  'provider_registry': 'provider_registry',
  'command_registry': 'command_registry',
};

const Map<String, String> _terminalRegistryManifestLists = {
  'module_registry': 'enabled_modules',
  'view_registry': 'enabled_views',
  'panel_registry': 'enabled_panels',
  'tool_registry': 'enabled_tools',
  'provider_registry': 'enabled_providers',
  'command_registry': 'enabled_commands',
};

const Map<String, List<String>> _terminalManifestDefaults = {
  'enabled_modules': _terminalModuleOrder,
  'enabled_views': <String>[
    'workbench',
    'view',
    'stream_view',
    'raw_view',
    'timeline',
    'progress_view',
    'log_viewer',
  ],
  'enabled_panels': <String>['tabs', 'progress_view', 'timeline', 'log_panel'],
  'enabled_tools': <String>[
    'command_builder',
    'flow_gate',
    'execution_lane',
    'stdin_injector',
  ],
  'enabled_providers': <String>[
    'process_bridge',
    'output_mapper',
    'capabilities',
  ],
  'enabled_commands': <String>[
    'command_builder',
    'presets',
    'execution_lane',
    'stdin_injector',
  ],
};

final RegExp _ansiRegex = RegExp(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])');

class ButterflyUITerminal extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> initialProps;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITerminal({
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
  State<ButterflyUITerminal> createState() => _ButterflyUITerminalState();
}

class _ButterflyUITerminalState extends State<ButterflyUITerminal> {
  late Map<String, Object?> _runtimeProps;
  late xterm.Terminal _terminal;
  _TerminalBackendAdapter _backend = const _LocalTerminalBackendAdapter();
  String _backendId = 'local';
  int _terminalMaxLines = 1200;
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final List<_TerminalLine> _buffer = <_TerminalLine>[];
  final List<String> _history = <String>[];
  final List<_QueuedTerminalCommand> _pendingExecutions =
      <_QueuedTerminalCommand>[];
  final Map<String, _QueuedTerminalCommand> _runningExecutions =
      <String, _QueuedTerminalCommand>{};
  int _executionSerial = 0;
  int _historyCursor = 0;
  String _activeSessionId = 'default';
  Timer? _inputDebounce;

  @override
  void initState() {
    super.initState();
    _runtimeProps = _normalizeProps(widget.initialProps);
    _terminalMaxLines = _resolvedMaxLines(_runtimeProps);
    _terminal = xterm.Terminal(maxLines: _terminalMaxLines);
    _ingestProps(resetBuffer: true);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _emitConfiguredEvent('ready', {
        'buffer_size': _buffer.length,
        'active_session': _activeSessionId,
      });
    });
  }

  @override
  void didUpdateWidget(covariant ButterflyUITerminal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = _normalizeProps(widget.initialProps);
    _ingestProps(resetBuffer: false);
    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _inputDebounce?.cancel();
    _inputFocusNode.dispose();
    _inputController.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final normalized = _norm(method);
    switch (normalized) {
      case 'get_state':
        return {
          'schema_version':
              _runtimeProps['schema_version'] ?? _terminalSchemaVersion,
          'module': _runtimeProps['module'],
          'state': _runtimeProps['state'],
          'manifest': _runtimeProps['manifest'],
          'registries': _runtimeProps['registries'],
          'active_session': _activeSessionId,
          'input': _inputController.text,
          'buffer': _buffer.map((line) => line.toMap()).toList(growable: false),
          'history': _history.toList(growable: false),
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
            _runtimeProps = _normalizeProps(_runtimeProps);
            _ingestProps(resetBuffer: false);
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
        _emitConfiguredEvent('change', {
          'module': 'workbench',
          'intent': 'set_manifest',
          'manifest': _runtimeProps['manifest'],
        });
        return {'ok': true, 'manifest': _runtimeProps['manifest']};
      case 'set_module':
        final module = _norm(args['module']?.toString() ?? '');
        if (!_terminalModules.contains(module)) {
          return {'ok': false, 'error': 'unknown module: $module'};
        }
        final payload = args['payload'];
        final payloadMap = payload is Map
            ? coerceObjectMap(payload)
            : <String, Object?>{};
        setState(() {
          final modules = _coerceObjectMap(_runtimeProps['modules']);
          modules[module] = payloadMap;
          _runtimeProps['modules'] = modules;
          _runtimeProps['module'] = module;
          _runtimeProps[module] = payloadMap;
          _runtimeProps = _normalizeProps(_runtimeProps);
        });
        _emitConfiguredEvent('module_change', {
          'module': module,
          'payload': payloadMap,
        });
        return {'ok': true, 'module': module};
      case 'set_state':
        final state = _norm(args['state']?.toString() ?? '');
        if (!_terminalStates.contains(state)) {
          return {'ok': false, 'error': 'unknown state: $state'};
        }
        setState(() {
          _runtimeProps['state'] = state;
        });
        _emitConfiguredEvent('state_change', {'state': state});
        return {'ok': true, 'state': state};
      case 'emit':
      case 'trigger':
        final event = _norm(
          (args['event'] ?? args['name'] ?? 'change').toString(),
        );
        if (!_terminalEvents.contains(event)) {
          return {'ok': false, 'error': 'unknown event: $event'};
        }
        final payload = args['payload'];
        _emitConfiguredEvent(
          event,
          payload is Map ? coerceObjectMap(payload) : args,
        );
        return true;
      case 'clear':
        setState(() {
          _buffer.clear();
          _resetTerminalSurface();
        });
        _emitConfiguredEvent('change', {'action': 'clear'});
        return {'ok': true, 'buffer_size': 0};
      case 'write':
      case 'append':
        final text = (args['value'] ?? args['text'] ?? '').toString();
        if (text.isNotEmpty) _appendText(text, level: _lineLevelFromArgs(args));
        return {'ok': true, 'buffer_size': _buffer.length};
      case 'append_lines':
        final lines = args['lines'];
        if (lines is List) _appendLines(_coerceLines(lines));
        return {'ok': true, 'buffer_size': _buffer.length};
      case 'focus':
        _inputFocusNode.requestFocus();
        return null;
      case 'blur':
        _inputFocusNode.unfocus();
        return null;
      case 'set_input':
      case 'set_value':
        final value = args['value']?.toString() ?? '';
        setState(() {
          _setInputText(value);
          _runtimeProps['input'] = value;
        });
        return {'ok': true, 'value': value};
      case 'get_input':
        return _inputController.text;
      case 'set_read_only':
        final value = _readBool(args['value'], fallback: false);
        setState(() {
          _runtimeProps['read_only'] = value;
        });
        return {'ok': true, 'read_only': value};
      case 'submit':
        return _submitInput(
          explicitValue: args['value']?.toString(),
          submitArgs: args,
        );
      case 'get_buffer':
      case 'get_value':
        return _buffer.map((line) => line.text).join('\n');
    }

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
          modules: _terminalModules,
          roleAliases: _terminalRegistryRoleAliases,
          roleManifestLists: _terminalRegistryManifestLists,
          manifestDefaults: _terminalManifestDefaults,
        );
        _runtimeProps = _normalizeProps(_runtimeProps);
      });
      if (result['ok'] == true) {
        _emitConfiguredEvent('change', {
          'module': 'workbench',
          'intent': normalized,
          'role': result['role'],
          'module_id': result['module_id'],
        });
      }
      return result;
    }

    if (_terminalModules.contains(normalized)) {
      final payload = args['payload'];
      final payloadMap = payload is Map
          ? coerceObjectMap(payload)
          : <String, Object?>{...args};
      setState(() {
        final modules = _coerceObjectMap(_runtimeProps['modules']);
        modules[normalized] = payloadMap;
        _runtimeProps['modules'] = modules;
        _runtimeProps['module'] = normalized;
        _runtimeProps[normalized] = payloadMap;
        _runtimeProps = _normalizeProps(_runtimeProps);
      });
      _emitConfiguredEvent('module_change', {
        'module': normalized,
        'payload': payloadMap,
      });
      return {'ok': true, 'module': normalized};
    }

    return {'ok': false, 'error': 'unknown method: $method'};
  }

  void _ingestProps({required bool resetBuffer}) {
    _ensureTerminalBackend();
    final promptSection = _sectionProps(_runtimeProps, 'prompt');
    final stdinSection = _sectionProps(_runtimeProps, 'stdin');
    final sessionSection = _sectionProps(_runtimeProps, 'session');

    final nextInput =
        _runtimeProps['input']?.toString() ??
        _runtimeProps['value']?.toString() ??
        promptSection?['value']?.toString() ??
        stdinSection?['value']?.toString();
    if (nextInput != null && nextInput != _inputController.text) {
      _setInputText(nextInput);
    }

    final nextSession =
        _runtimeProps['active_session']?.toString() ??
        _runtimeProps['session_id']?.toString() ??
        sessionSection?['session_id']?.toString();
    if (nextSession != null && nextSession.trim().isNotEmpty) {
      _activeSessionId = nextSession.trim();
    }

    final historyRaw =
        _runtimeProps['history'] ?? _runtimeProps['history_items'];
    if (historyRaw is List) {
      _history
        ..clear()
        ..addAll(
          historyRaw
              .map((entry) => entry?.toString() ?? '')
              .where((entry) => entry.trim().isNotEmpty),
        );
      _historyCursor = _history.length;
    }

    final externalLines = _extractExternalLines(_runtimeProps);
    if (externalLines.isNotEmpty) {
      _replaceBuffer(externalLines);
      return;
    }

    final output = _extractOutputText(_runtimeProps);
    if (output.trim().isNotEmpty) {
      _replaceBuffer(_linesFromText(output, level: 'output'));
      return;
    }

    if (resetBuffer) {
      _replaceBuffer(const <_TerminalLine>[]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final modules = _availableModules(_runtimeProps);
    final activeModule = _norm(
      _runtimeProps['module']?.toString() ??
          (modules.contains('workbench') ? 'workbench' : modules.first),
    );
    final section = _sectionProps(_runtimeProps, activeModule) ?? const {};

    final bg =
        coerceColor(_runtimeProps['bgcolor'] ?? _runtimeProps['background']) ??
        const Color(0xff070d0a);
    final fg =
        coerceColor(_runtimeProps['text_color']) ?? const Color(0xffd9fbe0);
    final border =
        coerceColor(_runtimeProps['border_color']) ??
        fg.withValues(alpha: 0.22);
    final height = (coerceDouble(_runtimeProps['height']) ?? 420).clamp(
      220.0,
      5000.0,
    );
    final radius = coerceDouble(_runtimeProps['radius']) ?? 12.0;

    final body = SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(
            color: border,
            width: coerceDouble(_runtimeProps['border_width']) ?? 1,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(fg, activeModule),
              const SizedBox(height: 8),
              _buildModuleChips(fg, modules, activeModule),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildOutput(fg, border)),
                    const SizedBox(width: 8),
                    SizedBox(width: 300, child: _buildModulePanel(fg, activeModule, section)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildPrompt(fg, border),
            ],
          ),
        ),
      ),
    );
    return ensureUmbrellaLayoutBounds(
      props: _runtimeProps,
      child: body,
      defaultHeight: height.toDouble(),
      minHeight: 220,
      maxHeight: 5000,
    );
  }

  Widget _buildHeader(Color fg, String module) {
    final state = (_runtimeProps['state'] ?? 'ready').toString();
    return Row(
      children: [
        Expanded(
          child: Text(
            'Terminal - $state',
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w600,
              fontFamily:
                  _runtimeProps['font_family']?.toString() ?? 'JetBrains Mono',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: fg.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            module.replaceAll('_', ' '),
            style: TextStyle(color: fg, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleChips(Color fg, List<String> modules, String active) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final module = modules[index];
          final selected = module == active;
          return ChoiceChip(
            selected: selected,
            label: Text(
              module.replaceAll('_', ' '),
              style: TextStyle(
                color: selected ? Colors.black : fg,
                fontSize: 11,
              ),
            ),
            selectedColor: fg.withValues(alpha: 0.85),
            backgroundColor: fg.withValues(alpha: 0.1),
            onSelected: (_) {
              setState(() {
                _runtimeProps['module'] = module;
              });
              _emitConfiguredEvent('module_change', {'module': module});
            },
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemCount: modules.length,
      ),
    );
  }

  Widget _buildOutput(Color fg, Color border) {
    final fontSize = coerceDouble(_runtimeProps['font_size']) ?? 12;
    final lineHeight = coerceDouble(_runtimeProps['line_height']) ?? 1.35;
    final outputBackground = Colors.black.withValues(alpha: 0.18);
    final terminalTheme = _buildTerminalTheme(outputBackground, fg);
    final emptyText =
        (_runtimeProps['empty_text'] ?? 'Terminal output will appear here.')
            .toString();

    return Container(
      decoration: BoxDecoration(
        color: outputBackground,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          children: [
            Positioned.fill(
              child: xterm.TerminalView(
                _terminal,
                theme: terminalTheme,
                textStyle: xterm.TerminalStyle(
                  fontFamily:
                      _runtimeProps['font_family']?.toString() ??
                      'JetBrains Mono',
                  fontSize: fontSize,
                  height: lineHeight,
                ),
              ),
            ),
            if (_buffer.isEmpty)
              IgnorePointer(
                child: Center(
                  child: Text(
                    emptyText,
                    style: TextStyle(color: fg.withValues(alpha: 0.7)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrompt(Color fg, Color border) {
    final showInput = _runtimeProps['show_input'] == null
        ? true
        : (_runtimeProps['show_input'] == true);
    if (!showInput) return const SizedBox.shrink();
    final readOnly = _runtimeProps['read_only'] == true;
    final prompt = (_runtimeProps['prompt'] ?? r'$').toString();
    final placeholder = (_runtimeProps['placeholder'] ?? 'Type a command...')
        .toString();
    final submitLabel = (_runtimeProps['submit_label'] ?? 'Run').toString();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Text(
            prompt,
            style: TextStyle(
              color: fg.withValues(alpha: 0.9),
              fontFamily:
                  _runtimeProps['font_family']?.toString() ?? 'JetBrains Mono',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              focusNode: _inputFocusNode,
              controller: _inputController,
              readOnly: readOnly,
              style: TextStyle(
                color: fg,
                fontSize: coerceDouble(_runtimeProps['font_size']) ?? 12,
                fontFamily:
                    _runtimeProps['font_family']?.toString() ??
                    'JetBrains Mono',
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: placeholder,
                hintStyle: TextStyle(color: fg.withValues(alpha: 0.45)),
                border: InputBorder.none,
              ),
              onChanged: _onInputChanged,
              onSubmitted: (_) {
                _submitInput();
              },
            ),
          ),
          IconButton(
            tooltip: 'History up',
            onPressed: readOnly ? null : () => _moveHistory(-1),
            icon: const Icon(Icons.arrow_upward, size: 16),
            color: fg.withValues(alpha: 0.9),
          ),
          IconButton(
            tooltip: 'History down',
            onPressed: readOnly ? null : () => _moveHistory(1),
            icon: const Icon(Icons.arrow_downward, size: 16),
            color: fg.withValues(alpha: 0.9),
          ),
          FilledButton.tonal(
            onPressed: readOnly
                ? null
                : () {
                    _submitInput();
                  },
            child: Text(submitLabel),
          ),
        ],
      ),
    );
  }

  TerminalSubmoduleContext _makeCtx(
    Color fg,
    String module,
    Map<String, Object?> section,
  ) {
    final bg =
        coerceColor(_runtimeProps['bgcolor'] ?? _runtimeProps['background']) ??
        const Color(0xff070d0a);
    return TerminalSubmoduleContext(
      controlId: widget.controlId,
      module: module,
      section: section,
      runtimeProps: _runtimeProps,
      activeSessionId: _activeSessionId,
      fg: fg,
      bg: bg,
      sendEvent: widget.sendEvent,
      rawChildren: widget.rawChildren,
      buildChild: widget.buildChild,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
  }

  Widget _buildModulePanel(
    Color fg,
    String module,
    Map<String, Object?> section,
  ) {
    final ctx = _makeCtx(fg, module, section);
    final inner = buildTerminalViewsSection(ctx) ??
        buildTerminalInputsSection(ctx) ??
        buildTerminalProvidersSection(ctx) ??
        _fallbackModulePanel(ctx);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: fg.withValues(alpha: 0.16)),
      ),
      child: inner,
    );
  }

  Widget _fallbackModulePanel(TerminalSubmoduleContext ctx) {
    final fg = ctx.fg;
    final entries = ctx.section.entries
        .where((entry) => entry.key != 'events')
        .toList(growable: false);
    final listItems = _extractList(ctx.section);
    if (entries.isEmpty && listItems.isEmpty) {
      return Text(
        'No module payload.',
        style: TextStyle(color: fg.withValues(alpha: 0.7)),
      );
    }
    return ListView(
      children: [
        for (final entry in entries.take(24))
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${entry.key}: ${entry.value}',
              style: TextStyle(
                color: fg.withValues(alpha: 0.9),
                fontSize: 12,
              ),
            ),
          ),
        for (final item in listItems.take(40))
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              _labelFromItem(item),
              style: TextStyle(
                color: fg.withValues(alpha: 0.85),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  List<dynamic> _extractList(Map<String, Object?> section) {
    for (final key in const ['items', 'events', 'entries', 'logs', 'steps']) {
      final value = section[key];
      if (value is List) return value;
    }
    return const [];
  }

  List<_TerminalLine> _extractExternalLines(Map<String, Object?> props) {
    final direct = props['lines'];
    if (direct is List) return _coerceLines(direct);
    for (final module in const [
      'stream',
      'stream_view',
      'raw_view',
      'log_viewer',
      'log_panel',
      'timeline',
      'replay',
      'execution_lane',
    ]) {
      final section = _sectionProps(props, module);
      if (section == null) continue;
      for (final key in const ['lines', 'items', 'events', 'entries', 'logs']) {
        final candidate = section[key];
        if (candidate is List) {
          final parsed = _coerceLines(candidate);
          if (parsed.isNotEmpty) return parsed;
        }
      }
    }
    return const <_TerminalLine>[];
  }

  String _extractOutputText(Map<String, Object?> props) {
    final direct =
        props['output']?.toString() ??
        props['raw_text']?.toString() ??
        props['text']?.toString();
    if (direct != null && direct.isNotEmpty) return direct;
    final rawView = _sectionProps(props, 'raw_view');
    final streamView = _sectionProps(props, 'stream_view');
    final stream = _sectionProps(props, 'stream');
    return (rawView?['raw_text'] ??
            rawView?['text'] ??
            streamView?['text'] ??
            stream?['text'] ??
            '')
        .toString();
  }

  void _replaceBuffer(List<_TerminalLine> lines) {
    _buffer
      ..clear()
      ..addAll(lines);
    _trimBuffer();
    _syncTerminalWithBuffer();
  }

  void _appendLines(List<_TerminalLine> lines) {
    if (lines.isEmpty) return;
    final shouldSyncAfterAppend =
        _runtimeProps['auto_scroll'] == false || _trimmedByAppend(lines.length);
    setState(() {
      _buffer.addAll(lines);
      _trimBuffer();
      if (shouldSyncAfterAppend) {
        _syncTerminalWithBuffer();
      } else {
        for (final line in lines) {
          _writeLineToTerminal(line);
        }
      }
    });
    _emitConfiguredEvent('output', {
      'lines': lines.map((line) => line.toMap()).toList(growable: false),
      'buffer_size': _buffer.length,
    });
  }

  void _appendText(String text, {required String level}) {
    _appendLines(_linesFromText(text, level: level));
  }

  List<_TerminalLine> _coerceLines(List<dynamic> source) {
    final now = DateTime.now();
    final out = <_TerminalLine>[];
    for (final entry in source) {
      if (entry is Map) {
        final map = coerceObjectMap(entry);
        final text = (map['text'] ?? map['value'] ?? '').toString();
        if (text.isEmpty) continue;
        final level = _norm(map['level']?.toString() ?? '');
        out.add(
          _TerminalLine(
            text: _sanitize(text),
            level: level.isEmpty ? 'output' : level,
            timestamp:
                DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? now,
          ),
        );
      } else if (entry != null) {
        out.add(
          _TerminalLine(
            text: _sanitize(entry.toString()),
            level: 'output',
            timestamp: now,
          ),
        );
      }
    }
    return out;
  }

  List<_TerminalLine> _linesFromText(String source, {required String level}) {
    final normalized = source.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final now = DateTime.now();
    return normalized
        .split('\n')
        .map((line) {
          return _TerminalLine(
            text: _sanitize(line),
            level: level,
            timestamp: now,
          );
        })
        .toList(growable: false);
  }

  String _sanitize(String value) {
    if (_runtimeProps['strip_ansi'] == true) {
      return value.replaceAll(_ansiRegex, '');
    }
    return value;
  }

  void _ensureTerminalBackend() {
    final nextMaxLines = _resolvedMaxLines(_runtimeProps);
    if (nextMaxLines != _terminalMaxLines) {
      _terminalMaxLines = nextMaxLines;
      _terminal = xterm.Terminal(maxLines: _terminalMaxLines);
      _syncTerminalWithBuffer();
    }

    final nextBackendId = _resolveBackendId(_runtimeProps);
    if (nextBackendId != _backendId) {
      _backendId = nextBackendId;
      switch (_backendId) {
        case 'pty':
          _backend = const _BridgedTerminalBackendAdapter('pty');
          break;
        case 'remote':
          _backend = const _BridgedTerminalBackendAdapter('remote');
          break;
        default:
          _backend = const _LocalTerminalBackendAdapter();
      }
    }

    final modules = _coerceObjectMap(_runtimeProps['modules']);
    final capabilities = <String, Object?>{
      ..._coerceObjectMap(modules['capabilities']),
      ..._backend.capabilities(),
      'backend': _backend.id,
    };
    modules['capabilities'] = capabilities;
    _runtimeProps['modules'] = modules;
    _runtimeProps['capabilities'] = capabilities;
    _syncExecutionLanePayload();
  }

  String _resolveBackendId(Map<String, Object?> props) {
    final processBridge = _sectionProps(props, 'process_bridge') ?? const {};
    final raw =
        processBridge['backend'] ??
        processBridge['bridge'] ??
        props['backend'] ??
        props['bridge'];
    final normalized = _norm(raw?.toString() ?? '');
    if (normalized == 'pty' ||
        normalized == 'flutter_pty' ||
        normalized == 'pty_bridge') {
      return 'pty';
    }
    if (normalized == 'remote' ||
        normalized == 'ssh' ||
        normalized == 'ws' ||
        normalized == 'websocket') {
      return 'remote';
    }
    return 'local';
  }

  String _resolvedLane(Map<String, Object?> payload) {
    final executionLane =
        _sectionProps(_runtimeProps, 'execution_lane') ?? const {};
    final lane = _norm(
      (payload['lane'] ?? executionLane['lane'] ?? _runtimeProps['lane'] ?? '')
          .toString(),
    );
    return lane.isEmpty ? 'default' : lane;
  }

  int _resolvedMaxConcurrency() {
    final executionLane =
        _sectionProps(_runtimeProps, 'execution_lane') ?? const {};
    final flowGate = _sectionProps(_runtimeProps, 'flow_gate') ?? const {};
    return (coerceOptionalInt(
              executionLane['max_concurrency'] ?? flowGate['max_concurrency'],
            ) ??
            1)
        .clamp(1, 8);
  }

  bool _lockLaneWhileRunning() {
    final flowGate = _sectionProps(_runtimeProps, 'flow_gate') ?? const {};
    final lock = flowGate['lock_while_running'];
    if (lock is bool) return lock;
    return true;
  }

  Map<String, Object?> _queueExecution({
    required String command,
    required Map<String, Object?> payload,
  }) {
    final lane = _resolvedLane(payload);
    final queued = _QueuedTerminalCommand(
      id: 'exec_${++_executionSerial}',
      lane: lane,
      sessionId: _activeSessionId,
      command: command,
      payload: payload,
      enqueuedAt: DateTime.now(),
    );
    setState(() {
      _pendingExecutions.add(queued);
      _syncExecutionLanePayload();
    });
    _emitConfiguredEvent('change', {
      'module': 'execution_lane',
      'intent': 'queued',
      'job': queued.toMap(),
    });
    _drainExecutionQueue();
    return {'ok': true, 'queued': queued.toMap()};
  }

  void _drainExecutionQueue() {
    final maxConcurrency = _resolvedMaxConcurrency();
    final lockLane = _lockLaneWhileRunning();
    while (_runningExecutions.length < maxConcurrency &&
        _pendingExecutions.isNotEmpty) {
      var nextIndex = -1;
      for (var i = 0; i < _pendingExecutions.length; i += 1) {
        final lane = _pendingExecutions[i].lane;
        if (lockLane &&
            _runningExecutions.values.any((entry) => entry.lane == lane)) {
          continue;
        }
        nextIndex = i;
        break;
      }
      if (nextIndex < 0) {
        break;
      }
      final next = _pendingExecutions.removeAt(nextIndex);
      _runningExecutions[next.id] = next;
      if (mounted) {
        setState(_syncExecutionLanePayload);
      } else {
        _syncExecutionLanePayload();
      }
      unawaited(_runQueuedExecution(next));
    }
  }

  Future<void> _runQueuedExecution(_QueuedTerminalCommand queued) async {
    try {
      final prompt = (_runtimeProps['prompt'] ?? r'$').toString();
      _appendText('$prompt ${queued.command}', level: 'command');
      _emitConfiguredEvent('submit', {
        'value': queued.command,
        'active_session': queued.sessionId,
        'execution_id': queued.id,
        'lane': queued.lane,
        'backend': _backend.id,
      });

      final result = await _backend.execute(
        _TerminalBackendRequest(
          executionId: queued.id,
          lane: queued.lane,
          sessionId: queued.sessionId,
          command: queued.command,
          payload: queued.payload,
        ),
      );
      if (result.lines.isNotEmpty) {
        _appendLines(result.lines);
      }
      if (mounted) {
        setState(() {
          _runtimeProps['status'] = result.status;
          _runtimeProps['exit_code'] = result.exitCode;
        });
      } else {
        _runtimeProps['status'] = result.status;
        _runtimeProps['exit_code'] = result.exitCode;
      }
      _emitConfiguredEvent('change', {
        'module': 'execution_lane',
        'intent': 'completed',
        'job_id': queued.id,
        'lane': queued.lane,
        'status': result.status,
        'exit_code': result.exitCode,
      });
    } catch (error) {
      _appendText(error.toString(), level: 'error');
      _emitConfiguredEvent('change', {
        'module': 'execution_lane',
        'intent': 'failed',
        'job_id': queued.id,
        'lane': queued.lane,
        'error': error.toString(),
      });
    } finally {
      _runningExecutions.remove(queued.id);
      if (mounted) {
        setState(_syncExecutionLanePayload);
      } else {
        _syncExecutionLanePayload();
      }
      _drainExecutionQueue();
    }
  }

  void _syncExecutionLanePayload() {
    final modules = _coerceObjectMap(_runtimeProps['modules']);
    final lane = _coerceObjectMap(modules['execution_lane']);
    lane['queue'] = _pendingExecutions
        .map((entry) => entry.toMap())
        .toList(growable: false);
    lane['running'] = _runningExecutions.values
        .map((entry) => entry.toMap())
        .toList(growable: false);
    lane['active_jobs'] = _runningExecutions.length;
    lane['queued_jobs'] = _pendingExecutions.length;
    lane['max_concurrency'] = _resolvedMaxConcurrency();
    lane['lock_while_running'] = _lockLaneWhileRunning();
    modules['execution_lane'] = lane;
    _runtimeProps['modules'] = modules;
    _runtimeProps['execution_lane'] = lane;
  }

  int _resolvedMaxLines(Map<String, Object?> props) {
    return (coerceOptionalInt(props['max_lines']) ?? 1200).clamp(10, 100000);
  }

  bool _trimmedByAppend(int appendCount) {
    final maxLines = _resolvedMaxLines(_runtimeProps);
    return _buffer.length + appendCount > maxLines;
  }

  void _trimBuffer() {
    final maxLines = _resolvedMaxLines(_runtimeProps);
    final overflow = _buffer.length - maxLines;
    if (overflow > 0) _buffer.removeRange(0, overflow);
  }

  void _resetTerminalSurface() {
    _terminal.write('\x1b[2J\x1b[H');
  }

  void _syncTerminalWithBuffer() {
    _resetTerminalSurface();
    for (final line in _buffer) {
      _writeLineToTerminal(line);
    }
  }

  void _writeLineToTerminal(_TerminalLine line) {
    final prefix = _ansiPrefixForLevel(line.level);
    final suffix = prefix.isEmpty ? '' : '\x1b[0m';
    final withTimestamp = _runtimeProps['show_timestamps'] == true
        ? '[${_two(line.timestamp.hour)}:${_two(line.timestamp.minute)}:${_two(line.timestamp.second)}] ${line.text}'
        : line.text;
    _terminal.write('$prefix$withTimestamp$suffix\r\n');
  }

  String _ansiPrefixForLevel(String level) {
    switch (level) {
      case 'command':
        return '\x1b[32m';
      case 'warn':
      case 'stderr':
        return '\x1b[33m';
      case 'error':
        return '\x1b[31m';
      default:
        return '';
    }
  }

  void _setInputText(String value) {
    _inputController.value = _inputController.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  Map<String, Object?> _submitInput({
    String? explicitValue,
    Map<String, Object?> submitArgs = const <String, Object?>{},
  }) {
    final raw = explicitValue ?? _inputController.text;
    final command = raw.trim();
    if (command.isEmpty) {
      return {'ok': false, 'error': 'command is empty'};
    }
    if (_runtimeProps['read_only'] == true) {
      return {'ok': false, 'error': 'terminal is read-only'};
    }
    setState(() {
      _history.add(command);
      _historyCursor = _history.length;
      if (_runtimeProps['clear_on_submit'] == true) {
        _setInputText('');
        _runtimeProps['input'] = '';
      } else {
        _runtimeProps['input'] = command;
      }
    });
    final payload = <String, Object?>{
      ...submitArgs,
      'source': submitArgs['source'] ?? 'prompt',
    };
    return _queueExecution(command: command, payload: payload);
  }

  void _moveHistory(int delta) {
    if (_history.isEmpty) return;
    final target = (_historyCursor + delta).clamp(0, _history.length);
    if (target == _historyCursor) return;
    _historyCursor = target;
    final value = target == _history.length ? '' : _history[target];
    setState(() {
      _setInputText(value);
      _runtimeProps['input'] = value;
    });
  }

  void _onInputChanged(String value) {
    _runtimeProps['input'] = value;
    final emitOnChange =
        _runtimeProps['emit_on_change'] == true ||
        _runtimeProps['emit_input_on_change'] == true;
    if (!emitOnChange) return;
    final debounceMs = (coerceOptionalInt(_runtimeProps['debounce_ms']) ?? 120)
        .clamp(0, 2000);
    _inputDebounce?.cancel();
    if (debounceMs == 0) {
      _emitConfiguredEvent('input', {
        'value': value,
        'active_session': _activeSessionId,
      });
      return;
    }
    _inputDebounce = Timer(Duration(milliseconds: debounceMs), () {
      if (!mounted) return;
      _emitConfiguredEvent('input', {
        'value': value,
        'active_session': _activeSessionId,
      });
    });
  }

  Set<String> _configuredEvents() {
    final raw = _runtimeProps['events'];
    final out = <String>{};
    if (raw is List) {
      for (final entry in raw) {
        final normalized = _norm(entry?.toString() ?? '');
        if (normalized.isNotEmpty && _terminalEvents.contains(normalized)) {
          out.add(normalized);
        }
      }
    }
    return out;
  }

  void _emitConfiguredEvent(String event, Map<String, Object?> payload) {
    final normalized = _norm(event);
    if (!_terminalEvents.contains(normalized)) return;
    final configured = _configuredEvents();
    if (configured.isNotEmpty && !configured.contains(normalized)) return;
    widget.sendEvent(widget.controlId, normalized, {
      'schema_version':
          _runtimeProps['schema_version'] ?? _terminalSchemaVersion,
      'module': _runtimeProps['module'],
      'state': _runtimeProps['state'],
      ...payload,
    });
  }
}

class _QueuedTerminalCommand {
  final String id;
  final String lane;
  final String sessionId;
  final String command;
  final Map<String, Object?> payload;
  final DateTime enqueuedAt;

  const _QueuedTerminalCommand({
    required this.id,
    required this.lane,
    required this.sessionId,
    required this.command,
    required this.payload,
    required this.enqueuedAt,
  });

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'lane': lane,
      'session_id': sessionId,
      'command': command,
      'payload': payload,
      'enqueued_at': enqueuedAt.toIso8601String(),
    };
  }
}

class _TerminalBackendRequest {
  final String executionId;
  final String lane;
  final String sessionId;
  final String command;
  final Map<String, Object?> payload;

  const _TerminalBackendRequest({
    required this.executionId,
    required this.lane,
    required this.sessionId,
    required this.command,
    required this.payload,
  });
}

class _TerminalBackendResult {
  final String status;
  final int exitCode;
  final List<_TerminalLine> lines;

  const _TerminalBackendResult({
    required this.status,
    required this.exitCode,
    required this.lines,
  });
}

abstract class _TerminalBackendAdapter {
  const _TerminalBackendAdapter();

  String get id;

  Map<String, Object?> capabilities();

  Future<_TerminalBackendResult> execute(_TerminalBackendRequest request);
}

class _LocalTerminalBackendAdapter implements _TerminalBackendAdapter {
  const _LocalTerminalBackendAdapter();

  @override
  String get id => 'local';

  @override
  Map<String, Object?> capabilities() {
    return const <String, Object?>{
      'interactive_stdin': true,
      'streaming': true,
      'ansi': true,
      'links': true,
      'backend': 'local',
    };
  }

  @override
  Future<_TerminalBackendResult> execute(
    _TerminalBackendRequest request,
  ) async {
    final now = DateTime.now();
    final command = request.command.trim();
    if (command.isEmpty) {
      return const _TerminalBackendResult(
        status: 'idle',
        exitCode: 0,
        lines: <_TerminalLine>[],
      );
    }

    if (command == 'help' || command == '?') {
      return _TerminalBackendResult(
        status: 'completed',
        exitCode: 0,
        lines: <_TerminalLine>[
          _TerminalLine(
            text: 'Available commands: help, echo <text>, fail, status',
            level: 'output',
            timestamp: now,
          ),
          _TerminalLine(
            text: 'Execution lane: ${request.lane} (${request.executionId})',
            level: 'output',
            timestamp: now,
          ),
        ],
      );
    }

    if (command.startsWith('echo ')) {
      return _TerminalBackendResult(
        status: 'completed',
        exitCode: 0,
        lines: <_TerminalLine>[
          _TerminalLine(
            text: command.substring(5),
            level: 'output',
            timestamp: now,
          ),
        ],
      );
    }

    if (command == 'status') {
      return _TerminalBackendResult(
        status: 'completed',
        exitCode: 0,
        lines: <_TerminalLine>[
          _TerminalLine(
            text:
                'Backend=$id lane=${request.lane} session=${request.sessionId}',
            level: 'output',
            timestamp: now,
          ),
        ],
      );
    }

    if (command.contains('fail')) {
      return _TerminalBackendResult(
        status: 'failed',
        exitCode: 1,
        lines: <_TerminalLine>[
          _TerminalLine(
            text: 'Simulated failure for command: $command',
            level: 'error',
            timestamp: now,
          ),
        ],
      );
    }

    return _TerminalBackendResult(
      status: 'completed',
      exitCode: 0,
      lines: <_TerminalLine>[
        _TerminalLine(
          text: 'Executing on local backend: $command',
          level: 'output',
          timestamp: now,
        ),
        _TerminalLine(
          text: 'Done (execution_id=${request.executionId})',
          level: 'output',
          timestamp: now,
        ),
      ],
    );
  }
}

class _BridgedTerminalBackendAdapter implements _TerminalBackendAdapter {
  final String backendId;

  const _BridgedTerminalBackendAdapter(this.backendId);

  @override
  String get id => backendId;

  @override
  Map<String, Object?> capabilities() {
    return <String, Object?>{
      'interactive_stdin': true,
      'streaming': true,
      'ansi': true,
      'links': true,
      'backend': backendId,
      'bridge': true,
    };
  }

  @override
  Future<_TerminalBackendResult> execute(
    _TerminalBackendRequest request,
  ) async {
    final now = DateTime.now();
    return _TerminalBackendResult(
      status: 'queued',
      exitCode: 0,
      lines: <_TerminalLine>[
        _TerminalLine(
          text: 'Command forwarded to $backendId bridge: ${request.command}',
          level: 'output',
          timestamp: now,
        ),
      ],
    );
  }
}

class _TerminalLine {
  final String text;
  final String level;
  final DateTime timestamp;

  const _TerminalLine({
    required this.text,
    required this.level,
    required this.timestamp,
  });

  Map<String, Object?> toMap() {
    return {
      'text': text,
      'level': level,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

Map<String, Object?> _normalizeProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] =
      (coerceOptionalInt(out['schema_version']) ?? _terminalSchemaVersion)
          .clamp(1, 9999);

  final module = _norm(out['module']?.toString() ?? '');
  if (module.isNotEmpty && _terminalModules.contains(module)) {
    out['module'] = module;
  } else if (module.isNotEmpty) {
    out.remove('module');
  }

  final state = _norm(out['state']?.toString() ?? '');
  if (state.isNotEmpty && _terminalStates.contains(state)) {
    out['state'] = state;
  } else if (state.isNotEmpty) {
    out.remove('state');
  }

  final engine = _norm(out['engine']?.toString() ?? '');
  if (engine.isEmpty) {
    out['engine'] = 'xterm';
  } else if (engine == 'terminal_xterm' || engine == 'xterm_terminal') {
    out['engine'] = 'xterm';
  } else {
    out['engine'] = engine;
  }

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((entry) => _norm(entry?.toString() ?? ''))
        .where((entry) => entry.isNotEmpty && _terminalEvents.contains(entry))
        .toSet()
        .toList(growable: false);
  }

  final modules = _coerceObjectMap(out['modules']);
  final normalizedModules = <String, Object?>{};
  for (final moduleKey in _terminalModules) {
    final topLevel = out[moduleKey];
    if (topLevel is Map) {
      final value = coerceObjectMap(topLevel);
      normalizedModules[moduleKey] = value;
      out[moduleKey] = value;
    } else if (topLevel == true) {
      normalizedModules[moduleKey] = <String, Object?>{};
      out[moduleKey] = <String, Object?>{};
    }
  }
  for (final entry in modules.entries) {
    final normalized = _norm(entry.key);
    if (!_terminalModules.contains(normalized)) continue;
    if (entry.value == true) {
      normalizedModules[normalized] = <String, Object?>{};
      out[normalized] = <String, Object?>{};
      continue;
    }
    final value = _coerceObjectMap(entry.value);
    if (value.isEmpty && entry.value is! Map) continue;
    normalizedModules[normalized] = value;
    out[normalized] = value;
  }
  out['modules'] = normalizedModules;
  final umbrella = normalizeUmbrellaHostProps(
    props: out,
    modules: _terminalModules,
    roleAliases: _terminalRegistryRoleAliases,
    manifestDefaults: _terminalManifestDefaults,
  );
  out['manifest'] = umbrella['manifest'];
  out['registries'] = umbrella['registries'];
  _seedTerminalDefaults(out);
  return out;
}

void _seedTerminalDefaults(Map<String, Object?> out) {
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

  final now = DateTime.now();
  final hh = now.hour.toString().padLeft(2, '0');
  final mm = now.minute.toString().padLeft(2, '0');

  final lines = <Object?>[
    '[$hh:$mm:01] Terminal host initialized.',
    '[$hh:$mm:03] Capabilities negotiated: stream/stdin/progress.',
    '[$hh:$mm:06] Ready for command execution.',
  ];
  if (out['lines'] is List && (out['lines'] as List).isNotEmpty) {
    out['lines'] = (out['lines'] as List).toList(growable: false);
  } else {
    out['lines'] = lines;
  }
  final seededLineCount = out['lines'] is List
      ? (out['lines'] as List).length
      : 0;

  ensureModule('workbench', <String, Object?>{
    'title': 'Terminal workbench',
    'status': 'ready',
  });
  ensureModule('view', <String, Object?>{
    'layout': 'prompt_stream_panel',
    'active': true,
  });
  ensureModule('tabs', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'id': 'session-1', 'label': 'Session'},
      <String, Object?>{'id': 'session-2', 'label': 'Build'},
    ],
  });
  ensureModule('session', <String, Object?>{
    'id': 'session-1',
    'label': 'Session',
    'cwd': '.',
    'state': 'idle',
  });
  ensureModule('stream_view', <String, Object?>{
    'mode': 'rich',
    'auto_scroll': out['auto_scroll'] == null
        ? true
        : out['auto_scroll'] == true,
  });
  ensureModule('stream', <String, Object?>{
    'status': 'connected',
    'buffer_lines': seededLineCount,
  });
  ensureModule('prompt', <String, Object?>{
    'value': out['prompt'] ?? 'butterfly@studio',
    'placeholder': out['placeholder'] ?? 'run build --target windows',
  });
  ensureModule('command_builder', <String, Object?>{
    'cwd': '.',
    'mode': 'shell',
    'env': <String, Object?>{'BUTTERFLY_ENV': 'dev'},
  });
  ensureModule('flow_gate', <String, Object?>{
    'policy': 'queue',
    'max_concurrency': 2,
    'lock_while_running': true,
  });
  ensureModule('output_mapper', <String, Object?>{
    'mode': 'structured',
    'ansi': out['strip_ansi'] == true ? 'stripped' : 'enabled',
  });
  ensureModule('presets', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'id': 'tests', 'label': 'Run tests'},
      <String, Object?>{'id': 'build', 'label': 'Build desktop'},
      <String, Object?>{'id': 'lint', 'label': 'Lint workspace'},
    ],
  });
  ensureModule('progress', <String, Object?>{
    'value': 0.72,
    'stage': 'compile',
    'status': 'running',
  });
  ensureModule('progress_view', <String, Object?>{
    'value': 0.72,
    'label': 'Build graph',
  });
  ensureModule('stdin', <String, Object?>{
    'supported': true,
    'interactive': true,
  });
  ensureModule('stdin_injector', <String, Object?>{
    'enabled': true,
    'macros': <String>['y', 'n', 'retry'],
  });
  ensureModule('timeline', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'label': 'Resolve deps', 'status': 'success'},
      <String, Object?>{'label': 'Compile', 'status': 'running'},
      <String, Object?>{'label': 'Bundle', 'status': 'queued'},
    ],
  });
  ensureModule('process_bridge', <String, Object?>{
    'backend': 'local',
    'pty': true,
    'status': 'connected',
  });
  ensureModule('execution_lane', <String, Object?>{
    'mode': 'queue',
    'max_concurrency': 2,
    'active_jobs': 0,
    'queue': <Map<String, Object?>>[],
    'running': <Map<String, Object?>>[],
  });
  ensureModule('log_viewer', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'level': 'info', 'message': 'Terminal ready'},
      <String, Object?>{'level': 'info', 'message': 'Lane max concurrency = 2'},
    ],
  });
  ensureModule('log_panel', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'level': 'info', 'message': 'Local bridge connected'},
      <String, Object?>{
        'level': 'warn',
        'message': 'No active PTY resize event',
      },
    ],
  });
  ensureModule('capabilities', <String, Object?>{
    'interactive_stdin': true,
    'streaming': true,
    'ansi': true,
    'links': true,
  });

  final manifest = _coerceObjectMap(out['manifest']);
  final enabledModules = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _terminalModules,
  ).toList(growable: true);
  if (enabledModules.isEmpty) {
    enabledModules.addAll(_terminalModuleOrder);
  } else {
    for (final module in _terminalModuleOrder) {
      if (!enabledModules.contains(module)) enabledModules.add(module);
    }
  }
  manifest['enabled_modules'] = enabledModules;

  for (final key in const <String>[
    'enabled_views',
    'enabled_panels',
    'enabled_tools',
    'enabled_providers',
    'enabled_commands',
  ]) {
    final values = umbrellaRuntimeStringList(
      manifest[key],
      allowed: _terminalModules,
    ).toList(growable: true);
    if (values.isEmpty) {
      values.addAll(_terminalManifestDefaults[key] ?? const <String>[]);
    }
    for (final module in modules.keys) {
      final normalized = _norm(module);
      if (!_terminalModules.contains(normalized)) continue;
      if (!values.contains(normalized)) values.add(normalized);
    }
    manifest[key] = values;
  }

  out['manifest'] = manifest;
  out['modules'] = modules;
}

List<String> _availableModules(Map<String, Object?> props) {
  final manifest = _coerceObjectMap(props['manifest']);
  final fromManifest = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _terminalModules,
  );
  if (fromManifest.isNotEmpty) return fromManifest;

  final modules = <String>[];
  final moduleMap = _coerceObjectMap(props['modules']);
  for (final key in _terminalModuleOrder) {
    if (props[key] is Map ||
        props[key] == true ||
        moduleMap[key] is Map ||
        moduleMap[key] == true) {
      modules.add(key);
    }
  }
  if (modules.isEmpty) {
    modules.addAll(const [
      'workbench',
      'tabs',
      'stream_view',
      'prompt',
      'progress_view',
      'timeline',
      'log_panel',
    ]);
  }
  return modules;
}

Map<String, Object?>? _sectionProps(Map<String, Object?> props, String key) {
  final normalized = _norm(key);
  final manifest = _coerceObjectMap(props['manifest']);
  final enabled = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _terminalModules,
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

String _lineLevelFromArgs(Map<String, Object?> args) {
  final level = _norm(args['level']?.toString() ?? '');
  if (level.isNotEmpty) return level;
  if (args['stderr'] == true || args['warn'] == true) return 'stderr';
  if (args['error'] == true) return 'error';
  return 'output';
}

String _labelFromItem(Object? item) {
  if (item is Map) {
    final map = coerceObjectMap(item);
    final label = map['label'] ?? map['title'] ?? map['name'] ?? map['id'];
    if (label != null) return label.toString();
  }
  return item?.toString() ?? '';
}

bool _readBool(Object? value, {required bool fallback}) {
  if (value == null) return fallback;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final raw = value.toString().trim().toLowerCase();
  if (raw == 'true' || raw == '1' || raw == 'yes' || raw == 'on') return true;
  if (raw == 'false' || raw == '0' || raw == 'no' || raw == 'off') {
    return false;
  }
  return fallback;
}

String _norm(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

String _two(int value) => value < 10 ? '0$value' : value.toString();

Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;

xterm.TerminalTheme _buildTerminalTheme(Color bg, Color fg) {
  final red = const Color(0xffef4444);
  final green = const Color(0xff22c55e);
  final yellow = const Color(0xfff59e0b);
  final blue = const Color(0xff3b82f6);
  final magenta = const Color(0xffa855f7);
  final cyan = const Color(0xff22d3ee);

  return xterm.TerminalTheme(
    background: bg,
    foreground: fg,
    cursor: fg,
    selection: fg.withValues(alpha: 0.32),
    black: bg,
    red: red,
    green: green,
    yellow: yellow,
    blue: blue,
    magenta: magenta,
    cyan: cyan,
    white: fg,
    brightBlack: _mix(bg, Colors.white, 0.35),
    brightRed: _mix(red, Colors.white, 0.25),
    brightGreen: _mix(green, Colors.white, 0.25),
    brightYellow: _mix(yellow, Colors.white, 0.25),
    brightBlue: _mix(blue, Colors.white, 0.25),
    brightMagenta: _mix(magenta, Colors.white, 0.25),
    brightCyan: _mix(cyan, Colors.white, 0.25),
    brightWhite: _mix(fg, Colors.white, 0.15),
    searchHitBackground: _mix(blue, bg, 0.6),
    searchHitBackgroundCurrent: _mix(magenta, bg, 0.5),
    searchHitForeground: fg,
  );
}

Widget buildTerminalControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUITerminal(
    controlId: controlId,
    initialProps: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
