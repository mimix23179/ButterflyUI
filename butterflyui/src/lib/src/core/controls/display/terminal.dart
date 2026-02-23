import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

const int _terminalSchemaVersion = 2;

const List<String> _terminalModuleOrder = [
  'session',
  'view',
  'stream',
  'stream_view',
  'raw_view',
  'prompt',
  'stdin',
  'stdin_injector',
  'command_builder',
  'capabilities',
  'presets',
  'replay',
  'flow_gate',
  'output_mapper',
  'timeline',
  'progress',
  'progress_view',
  'tabs',
  'workbench',
  'process_bridge',
  'execution_lane',
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

class ButterflyUITerminal extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> initialProps;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITerminal({
    super.key,
    required this.controlId,
    required this.initialProps,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUITerminal> createState() => _ButterflyUITerminalState();
}

class _ButterflyUITerminalState extends State<ButterflyUITerminal> {
  final WebviewController _windowsController = WebviewController();
  WebViewController? _flutterController;
  StreamSubscription<dynamic>? _windowsMessageSub;

  late Map<String, Object?> _runtimeProps;
  String _latestBuffer = '';
  String _latestInput = '';
  bool _xtermReady = false;
  bool _xtermInitialized = false;

  bool get _useFlutterWebView {
    final engine = (_runtimeProps['webview_engine'] ?? 'windows').toString().trim().toLowerCase();
    if (engine == 'flutter' || engine == 'webview_flutter') return true;
    if (engine == 'windows' || engine == 'webview_windows') return false;
    return !Platform.isWindows;
  }

  @override
  void initState() {
    super.initState();
    _runtimeProps = _normalizeProps(widget.initialProps);
    _latestBuffer = _collectBuffer(_runtimeProps);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    unawaited(_initializeXterm());
  }

  @override
  void didUpdateWidget(covariant ButterflyUITerminal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = _normalizeProps(widget.initialProps);

    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }

    final oldUseFlutter = _resolveUseFlutterWebView(oldWidget.initialProps);
    if (_useFlutterWebView != oldUseFlutter) {
      _xtermReady = false;
      _xtermInitialized = false;
      unawaited(_initializeXterm());
    } else {
      final nextBuffer = _collectBuffer(_runtimeProps);
      if (nextBuffer != _latestBuffer) {
        _latestBuffer = nextBuffer;
        unawaited(_runXtermJavaScript(
          'if(window.ButterflyUIXterm){window.ButterflyUIXterm.setText(${jsonEncode(_latestBuffer)});}',
        ));
      }
    }
  }

  bool _resolveUseFlutterWebView(Map<String, Object?> props) {
    final engine = (props['webview_engine'] ?? 'windows').toString().trim().toLowerCase();
    if (engine == 'flutter' || engine == 'webview_flutter') return true;
    if (engine == 'windows' || engine == 'webview_windows') return false;
    return !Platform.isWindows;
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _windowsMessageSub?.cancel();
    unawaited(_windowsController.dispose());
    super.dispose();
  }

  Future<void> _initializeXterm() async {
    if (_xtermInitialized) return;
    _xtermInitialized = true;

    if (_useFlutterWebView) {
      await _initializeFlutterXterm();
      return;
    }

    await _windowsController.initialize().timeout(const Duration(milliseconds: 15000));
    _windowsMessageSub?.cancel();
    _windowsMessageSub = _windowsController.webMessage.listen(_handleXtermMessage);

    final html = _buildXtermHtml();
    await _windowsController.loadStringContent(html);
  }

  Future<void> _initializeFlutterXterm() async {
    final controller = WebViewController();
    _flutterController = controller;

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) {
          if (!_xtermReady) {
            _xtermReady = true;
            _emitConfiguredEvent('ready', {'engine': 'xterm', 'webview_engine': 'flutter'});
          }
        },
      ),
    );

    await controller.addJavaScriptChannel(
      'ButterflyUI',
      onMessageReceived: (message) {
        _handleXtermMessage(message.message);
      },
    );

    await controller.loadHtmlString(_buildXtermHtml());
  }

  String _buildXtermHtml() {
    final bg = _hexColor(coerceColor(_runtimeProps['bgcolor'] ?? _runtimeProps['background']) ?? const Color(0xff050a06));
    final fg = _hexColor(coerceColor(_runtimeProps['text_color']) ?? const Color(0xffd1ffd6));
    final fontSize = coerceDouble(_runtimeProps['font_size']) ?? 12;
    final prompt = (_runtimeProps['prompt'] ?? '').toString();
    final readOnly = _runtimeProps['read_only'] == true;
    final initial = _latestBuffer;

    return '''
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/xterm@5.5.0/css/xterm.min.css" />
  <style>
    html, body, #terminal { height: 100%; width: 100%; margin: 0; padding: 0; background: $bg; }
    body { overflow: hidden; }
  </style>
</head>
<body>
  <div id="terminal"></div>
  <script src="https://cdn.jsdelivr.net/npm/xterm@5.5.0/lib/xterm.min.js"></script>
  <script>
    (function() {
      function post(event, payload) {
        const msg = JSON.stringify({ event, payload: payload || {} });
        if (window.ButterflyUI && typeof window.ButterflyUI.postMessage === 'function') {
          window.ButterflyUI.postMessage(msg);
        } else if (window.chrome && window.chrome.webview && typeof window.chrome.webview.postMessage === 'function') {
          window.chrome.webview.postMessage(msg);
        }
      }

      const term = new Terminal({
        convertEol: true,
        cursorBlink: true,
        fontSize: $fontSize,
        theme: {
          background: '$bg',
          foreground: '$fg',
          cursor: '$fg',
          selectionBackground: '${fg}44'
        }
      });
      term.open(document.getElementById('terminal'));

      let buffer = '';
      let inputLine = '';
      let readOnly = ${readOnly ? 'true' : 'false'};
      const prompt = ${jsonEncode(prompt)};

      function render() {
        term.reset();
        if (buffer) term.write(buffer);
        if (prompt) term.write(prompt);
        if (inputLine) term.write(inputLine);
      }

      function normalizeNewline(text) {
        return (text || '').replace(/\r\n/g, '\n').replace(/\r/g, '\n');
      }

      term.onData(function(data) {
        if (readOnly) return;
        post('input', { data: data });

        if (data === '\r') {
          const value = inputLine;
          if (prompt || inputLine) {
            term.write('\r\n');
          }
          if (prompt) term.write(prompt);
          inputLine = '';
          post('submit', { value: value, input: value });
          post('change', { value: '', input: '' });
          return;
        }

        if (data === '\u007f') {
          if (inputLine.length > 0) {
            inputLine = inputLine.slice(0, -1);
            term.write('\b \b');
            post('change', { value: inputLine, input: inputLine });
          }
          return;
        }

        if (data >= ' ') {
          inputLine += data;
          term.write(data);
          post('change', { value: inputLine, input: inputLine });
        }
      });

      window.ButterflyUIXterm = {
        setText: function(text) {
          buffer = normalizeNewline(text);
          render();
          post('output', { buffer: buffer });
        },
        appendText: function(text) {
          const chunk = normalizeNewline(text);
          if (!chunk) return;
          buffer += chunk;
          term.write(chunk);
          post('output', { buffer: buffer });
        },
        clear: function() {
          buffer = '';
          inputLine = '';
          render();
          post('output', { buffer: buffer });
        },
        focus: function() {
          term.focus();
        },
        blur: function() {
          if (document.activeElement && typeof document.activeElement.blur === 'function') {
            document.activeElement.blur();
          }
        },
        setReadOnly: function(value) {
          readOnly = !!value;
        },
        setInput: function(value) {
          inputLine = String(value || '');
          render();
          post('change', { value: inputLine, input: inputLine });
        },
        getInput: function() {
          return inputLine;
        },
        getText: function() {
          return buffer;
        }
      };

      window.ButterflyUIXterm.setText(${jsonEncode(initial)});
      post('ready', { engine: 'xterm' });
    })();
  </script>
</body>
</html>
''';
  }

  String _hexColor(Color color) {
    final a = color.alpha.toRadixString(16).padLeft(2, '0');
    final r = color.red.toRadixString(16).padLeft(2, '0');
    final g = color.green.toRadixString(16).padLeft(2, '0');
    final b = color.blue.toRadixString(16).padLeft(2, '0');
    return '#$a$r$g$b';
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (_norm(method)) {
      case 'get_state':
        return {
          'schema_version': _runtimeProps['schema_version'] ?? _terminalSchemaVersion,
          'module': _runtimeProps['module'],
          'state': _runtimeProps['state'],
          'value': _latestBuffer,
          'input': _latestInput,
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
            _runtimeProps = _normalizeProps(_runtimeProps);
            _latestBuffer = _collectBuffer(_runtimeProps);
          });
          await _runXtermJavaScript(
            'if(window.ButterflyUIXterm){window.ButterflyUIXterm.setText(${jsonEncode(_latestBuffer)});}',
          );
        }
        return _runtimeProps;
      case 'set_module':
        final module = _norm(args['module']?.toString() ?? '');
        if (!_terminalModules.contains(module)) {
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
        final event = _norm((args['event'] ?? args['name'] ?? method).toString());
        if (!_terminalEvents.contains(event)) {
          return {'ok': false, 'error': 'unknown event: $event'};
        }
        final payload = args['payload'];
        _emitConfiguredEvent(event, payload is Map ? coerceObjectMap(payload) : args);
        return true;
      case 'clear':
        _latestBuffer = '';
        await _runXtermJavaScript('if(window.ButterflyUIXterm){window.ButterflyUIXterm.clear();}');
        return null;
      case 'write':
      case 'append':
        final value = args['value']?.toString() ?? '';
        if (value.isNotEmpty) {
          _latestBuffer += value;
          await _runXtermJavaScript(
            'if(window.ButterflyUIXterm){window.ButterflyUIXterm.appendText(${jsonEncode(value)});}',
          );
          _emitConfiguredEvent('output', {'buffer': _latestBuffer});
        }
        return null;
      case 'append_lines':
        final raw = args['lines'];
        if (raw is List) {
          final lines = raw
              .map((item) => _lineFromEntry(item) ?? '')
              .where((line) => line.isNotEmpty)
              .join('\n');
          if (lines.isNotEmpty) {
            _latestBuffer += lines;
            await _runXtermJavaScript(
              'if(window.ButterflyUIXterm){window.ButterflyUIXterm.appendText(${jsonEncode(lines)});}',
            );
            _emitConfiguredEvent('output', {'buffer': _latestBuffer});
          }
        }
        return null;
      case 'focus':
        await _runXtermJavaScript('if(window.ButterflyUIXterm){window.ButterflyUIXterm.focus();}');
        return null;
      case 'blur':
        await _runXtermJavaScript('if(window.ButterflyUIXterm){window.ButterflyUIXterm.blur();}');
        return null;
      case 'set_input':
        _latestInput = args['value']?.toString() ?? '';
        await _runXtermJavaScript(
          'if(window.ButterflyUIXterm){window.ButterflyUIXterm.setInput(${jsonEncode(_latestInput)});}',
        );
        return null;
      case 'set_read_only':
        final value = args['value'] == true;
        _runtimeProps['read_only'] = value;
        await _runXtermJavaScript(
          'if(window.ButterflyUIXterm){window.ButterflyUIXterm.setReadOnly(${value ? 'true' : 'false'});}',
        );
        return null;
      case 'get_buffer':
      case 'get_value':
        {
          final result = await _runXtermJavaScript(
            'window.ButterflyUIXterm ? window.ButterflyUIXterm.getText() : "";',
            expectResult: true,
          );
          if (result is String) {
            _latestBuffer = result;
            return result;
          }
          return _latestBuffer;
        }
      case 'get_input':
        {
          final result = await _runXtermJavaScript(
            'window.ButterflyUIXterm ? window.ButterflyUIXterm.getInput() : "";',
            expectResult: true,
          );
          if (result is String) {
            _latestInput = result;
            return result;
          }
          return _latestInput;
        }
      default:
        final normalized = _norm(method);
        if (_terminalModules.contains(normalized)) {
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

  String? _lineFromEntry(Object? item) {
    if (item is Map) {
      final map = coerceObjectMap(item);
      return map['text']?.toString() ?? map['line']?.toString() ?? map['value']?.toString();
    }
    if (item == null) return null;
    final value = item.toString();
    return value.isEmpty ? null : value;
  }

  String _collectBuffer(Map<String, Object?> props) {
    final raw = (props['raw_text'] ?? props['raw'])?.toString();
    if (raw != null && raw.isNotEmpty) return raw;

    final output = props['output']?.toString();
    if (output != null && output.isNotEmpty) return output;

    final lines = props['lines'];
    if (lines is List) {
      final out = <String>[];
      for (final item in lines) {
        final line = _lineFromEntry(item);
        if (line != null && line.isNotEmpty) out.add(line);
      }
      if (out.isNotEmpty) return out.join('\n');
    }
    return _latestBuffer;
  }

  Future<Object?> _runXtermJavaScript(String script, {bool expectResult = false}) async {
    if (_useFlutterWebView) {
      final controller = _flutterController;
      if (controller == null) return null;
      if (expectResult) {
        final raw = await controller.runJavaScriptReturningResult(script);
        return _normalizeJavaScriptResult(raw);
      }
      await controller.runJavaScript(script);
      return null;
    }

    final raw = await _windowsController.executeScript(script);
    return expectResult ? _normalizeJavaScriptResult(raw) : null;
  }

  Object? _normalizeJavaScriptResult(Object? raw) {
    if (raw == null) return null;
    if (raw is num || raw is bool) return raw;
    final text = raw.toString();
    if (text.isEmpty || text == 'null' || text == 'undefined') return null;
    try {
      return jsonDecode(text);
    } catch (_) {
      return text;
    }
  }

  void _handleXtermMessage(dynamic message) {
    Object? decoded = message;
    if (message is String) {
      try {
        decoded = jsonDecode(message);
      } catch (_) {
        decoded = message;
      }
    }

    if (decoded is! Map) return;
    final map = coerceObjectMap(decoded);
    final event = map['event']?.toString() ?? 'message';
    final payload = map['payload'] is Map ? coerceObjectMap(map['payload'] as Map) : <String, Object?>{};

    if (event == 'ready') {
      _xtermReady = true;
      payload['engine'] = 'xterm';
      payload['webview_engine'] = _useFlutterWebView ? 'flutter' : 'windows';
      _emitConfiguredEvent('ready', payload);
      return;
    }

    if (event == 'output' && payload['buffer'] is String) {
      _latestBuffer = payload['buffer']!.toString();
    }
    if ((event == 'change' || event == 'submit') && payload['input'] is String) {
      _latestInput = payload['input']!.toString();
    }

    _emitConfiguredEvent(event, payload);
  }

  Set<String> _configuredEvents() {
    final raw = _runtimeProps['events'];
    final out = <String>{};
    if (raw is List) {
      for (final entry in raw) {
        final value = _norm(entry?.toString() ?? '');
        if (value.isNotEmpty && _terminalEvents.contains(value)) {
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
      'schema_version': _runtimeProps['schema_version'] ?? _terminalSchemaVersion,
      'module': _runtimeProps['module'],
      'state': _runtimeProps['state'],
      ...payload,
    });
  }

  Widget _buildXtermView() {
    if (_useFlutterWebView) {
      final controller = _flutterController;
      if (controller == null) return const SizedBox.shrink();
      return WebViewWidget(controller: controller);
    }
    return Webview(_windowsController);
  }

  Widget _buildTerminalContainer() {
    final borderColor = coerceColor(_runtimeProps['border_color']);
    final borderWidth = coerceDouble(_runtimeProps['border_width']) ?? 0;
    final backgroundColor =
        coerceColor(_runtimeProps['bgcolor'] ?? _runtimeProps['background']) ?? const Color(0xff050a06);
    final radius = coerceDouble(_runtimeProps['radius']) ?? 10;

    return SizedBox(
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: borderColor != null && borderWidth > 0
              ? Border.all(color: borderColor.withValues(alpha: 0.6), width: borderWidth)
              : null,
          borderRadius: BorderRadius.circular(radius),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildXtermView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableModules = _availableModules(_runtimeProps);
    final activeModule = _norm(_runtimeProps['module']?.toString() ?? 'session');

    if ((_runtimeProps['state']?.toString() ?? '') == 'loading') {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TerminalHeader(
          state: (_runtimeProps['state'] ?? 'ready').toString(),
          engine: (_runtimeProps['engine'] ?? 'xterm').toString(),
          webviewEngine: (_runtimeProps['webview_engine'] ?? (_useFlutterWebView ? 'flutter' : 'windows')).toString(),
        ),
        const SizedBox(height: 8),
        _TerminalModuleTabs(
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
        _buildTerminalContainer(),
        const SizedBox(height: 8),
        for (final module in availableModules) ...[
          ExpansionTile(
            key: ValueKey<String>('terminal_module_$module'),
            initiallyExpanded: module == activeModule,
            title: Text(module.replaceAll('_', ' ')),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            children: [
              _TerminalGenericModule(
                module: module,
                props: _sectionProps(_runtimeProps, module) ?? <String, Object?>{'events': _runtimeProps['events']},
                onEmit: _emitConfiguredEvent,
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
  out['schema_version'] = (coerceOptionalInt(out['schema_version']) ?? _terminalSchemaVersion).clamp(1, 9999);

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

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((e) => _norm(e?.toString() ?? ''))
        .where((e) => e.isNotEmpty && _terminalEvents.contains(e))
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
    }
  }
  for (final entry in modules.entries) {
    final normalized = _norm(entry.key);
    if (!_terminalModules.contains(normalized)) continue;
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
  for (final key in _terminalModuleOrder) {
    if (props[key] is Map || moduleMap[key] is Map) {
      modules.add(key);
    }
  }
  if (modules.isEmpty) {
    modules.addAll(const ['session', 'view', 'prompt']);
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

class _TerminalHeader extends StatelessWidget {
  const _TerminalHeader({required this.state, required this.engine, required this.webviewEngine});

  final String state;
  final String engine;
  final String webviewEngine;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Terminal', style: Theme.of(context).textTheme.titleMedium),
              Text('State: $state', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Text('Engine: $engine / $webviewEngine'),
      ],
    );
  }
}

class _TerminalModuleTabs extends StatelessWidget {
  const _TerminalModuleTabs({
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

class _TerminalGenericModule extends StatelessWidget {
  const _TerminalGenericModule({
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

Widget buildTerminalControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUITerminal(
    controlId: controlId,
    initialProps: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
