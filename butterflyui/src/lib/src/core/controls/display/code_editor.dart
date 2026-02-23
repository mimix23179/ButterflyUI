import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

const int _codeEditorSchemaVersion = 2;

const List<String> _codeEditorModuleOrder = [
  'ide',
  'editor_surface',
  'editor_view',
  'editor_tabs',
  'document_tab_strip',
  'file_tabs',
  'explorer_tree',
  'workspace_explorer',
  'file_tree',
  'tree',
  'code_document',
  'code_buffer',
  'code_category_layer',
  'editor_intent_router',
  'intent_router',
  'intent_panel',
  'intent_search',
  'smart_search_bar',
  'search_box',
  'search_field',
  'search_scope_selector',
  'search_source',
  'search_provider',
  'search_history',
  'search_intent',
  'search_item',
  'search_results_view',
  'search_everything_panel',
  'semantic_search',
  'query_token',
  'scoped_search_replace',
  'inline_search_overlay',
  'inline_widget',
  'inline_error_view',
  'diagnostics_panel',
  'diagnostic_stream',
  'gutter',
  'hint',
  'mini_map',
  'editor_minimap',
  'ghost_editor',
  'diff',
  'diff_narrator',
  'command_bar',
  'command_search',
  'dock_graph',
  'dock',
  'dock_pane',
  'workbench_editor',
  'inspector',
  'scope_picker',
  'empty_state_view',
  'empty_view',
  'export_panel',
];

const Set<String> _codeEditorModules = {
  'editor_intent_router',
  'editor_minimap',
  'editor_surface',
  'editor_view',
  'diff',
  'editor_tabs',
  'empty_state_view',
  'explorer_tree',
  'ide',
  'code_buffer',
  'code_category_layer',
  'code_document',
  'file_tabs',
  'file_tree',
  'smart_search_bar',
  'semantic_search',
  'search_box',
  'search_everything_panel',
  'search_field',
  'search_history',
  'search_intent',
  'search_item',
  'search_provider',
  'search_results_view',
  'search_scope_selector',
  'search_source',
  'query_token',
  'document_tab_strip',
  'command_search',
  'tree',
  'workbench_editor',
  'workspace_explorer',
  'command_bar',
  'diagnostic_stream',
  'diff_narrator',
  'dock_graph',
  'dock',
  'dock_pane',
  'empty_view',
  'export_panel',
  'gutter',
  'hint',
  'mini_map',
  'scope_picker',
  'scoped_search_replace',
  'diagnostics_panel',
  'ghost_editor',
  'inline_error_view',
  'inline_search_overlay',
  'inline_widget',
  'inspector',
  'intent_panel',
  'intent_router',
  'intent_search',
};

const Set<String> _codeEditorStates = {
  'idle',
  'loading',
  'ready',
  'searching',
  'diff',
  'disabled',
};

const Set<String> _codeEditorEvents = {
  'ready',
  'change',
  'submit',
  'save',
  'format_request',
  'search',
  'open_document',
  'close_document',
  'select',
  'state_change',
  'module_change',
};

class ButterflyUICodeEditor extends StatefulWidget {
  final String controlId;
  final String value;
  final String? language;
  final String? theme;
  final String engine;
  final String webviewEngine;
  final bool readOnly;
  final bool autofocus;
  final bool wordWrap;
  final bool showLineNumbers;
  final bool showGutter;
  final bool showMinimap;
  final bool glyphMargin;
  final bool emitOnChange;
  final int debounceMs;
  final int tabSize;
  final String? documentUri;
  final double fontSize;
  final String fontFamily;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final Map<String, Object?> initialProps;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUICodeEditor({
    super.key,
    required this.controlId,
    required this.value,
    required this.language,
    required this.theme,
    required this.engine,
    required this.webviewEngine,
    required this.readOnly,
    required this.autofocus,
    required this.wordWrap,
    required this.showLineNumbers,
    required this.showGutter,
    required this.showMinimap,
    required this.glyphMargin,
    required this.emitOnChange,
    required this.debounceMs,
    required this.tabSize,
    required this.documentUri,
    required this.fontSize,
    required this.fontFamily,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.initialProps,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUICodeEditor> createState() => _ButterflyUICodeEditorState();
}

class _ButterflyUICodeEditorState extends State<ButterflyUICodeEditor> {
  late final TextEditingController _fallbackController = TextEditingController(
    text: widget.value,
  );
  final FocusNode _fallbackFocusNode = FocusNode();
  final ScrollController _fallbackEditorScroll = ScrollController();
  final ScrollController _fallbackGutterScroll = ScrollController();

  final WebviewController _windowsController = WebviewController();
  WebViewController? _flutterController;
  StreamSubscription<dynamic>? _windowsMessageSub;

  Timer? _debounce;
  bool _fallbackSuppressChange = false;
  bool _monacoReady = false;
  bool _monacoInitialized = false;
  bool _isSyncingGutter = false;
  String _latestValue = '';
  late Map<String, Object?> _runtimeProps;

  bool get _useMonaco {
    final normalized = widget.engine.trim().toLowerCase();
    return !(normalized == 'flutter' ||
        normalized == 'basic' ||
        normalized == 'text' ||
        normalized == 'textarea');
  }

  bool get _useFlutterWebView {
    final normalized = widget.webviewEngine.trim().toLowerCase();
    if (normalized == 'flutter' || normalized == 'webview_flutter') {
      return true;
    }
    if (normalized == 'windows' || normalized == 'webview_windows') {
      return false;
    }
    return !Platform.isWindows;
  }

  @override
  void initState() {
    super.initState();
    _runtimeProps = _normalizeProps(widget.initialProps);
    _latestValue = widget.value;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);

    _fallbackEditorScroll.addListener(() {
      if (_isSyncingGutter) return;
      if (!_fallbackGutterScroll.hasClients) return;
      _isSyncingGutter = true;
      final target = _fallbackEditorScroll.offset.clamp(
        0.0,
        _fallbackGutterScroll.position.maxScrollExtent,
      );
      _fallbackGutterScroll.jumpTo(target);
      _isSyncingGutter = false;
    });

    if (_useMonaco) {
      unawaited(_initializeMonaco());
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUICodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = _normalizeProps(widget.initialProps);

    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }

    final oldUsesMonaco = _resolveUseMonaco(oldWidget.engine);
    final oldUsesFlutterWebview = _resolveUseFlutterWebView(
      oldWidget.webviewEngine,
    );
    if (_useMonaco != oldUsesMonaco ||
        _useFlutterWebView != oldUsesFlutterWebview) {
      _monacoReady = false;
      _monacoInitialized = false;
      if (_useMonaco) {
        unawaited(_initializeMonaco());
      }
    }

    if (widget.value != oldWidget.value && widget.value != _latestValue) {
      _latestValue = widget.value;
      if (_useMonaco) {
        unawaited(_setMonacoValue(widget.value, silent: true));
      } else if (widget.value != _fallbackController.text) {
        _fallbackSuppressChange = true;
        _fallbackController.value = _fallbackController.value.copyWith(
          text: widget.value,
          selection: TextSelection.collapsed(offset: widget.value.length),
        );
        _fallbackSuppressChange = false;
      }
    }
  }

  bool _resolveUseMonaco(String value) {
    final normalized = value.trim().toLowerCase();
    return !(normalized == 'flutter' ||
        normalized == 'basic' ||
        normalized == 'text' ||
        normalized == 'textarea');
  }

  bool _resolveUseFlutterWebView(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'flutter' || normalized == 'webview_flutter') {
      return true;
    }
    if (normalized == 'windows' || normalized == 'webview_windows') {
      return false;
    }
    return !Platform.isWindows;
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _windowsMessageSub?.cancel();
    _debounce?.cancel();
    _fallbackFocusNode.dispose();
    _fallbackController.dispose();
    _fallbackEditorScroll.dispose();
    _fallbackGutterScroll.dispose();
    unawaited(_windowsController.dispose());
    super.dispose();
  }

  Future<void> _initializeMonaco() async {
    if (_monacoInitialized) return;
    _monacoInitialized = true;
    if (_useFlutterWebView) {
      await _initializeFlutterMonaco();
      return;
    }

    await _windowsController.initialize().timeout(
      const Duration(milliseconds: 15000),
    );
    _windowsMessageSub?.cancel();
    _windowsMessageSub = _windowsController.webMessage.listen(_handleMonacoMessage);

    final html = await _buildMonacoHtml();
    await _windowsController.loadStringContent(html);
  }

  Future<void> _initializeFlutterMonaco() async {
    final controller = WebViewController();
    _flutterController = controller;

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) async {
          if (!_monacoReady) {
            _monacoReady = true;
            _emitConfiguredEvent('ready', {
              'engine': 'monaco',
              'webview_engine': 'flutter',
            });
          }
        },
      ),
    );

    await controller.addJavaScriptChannel(
      'ButterflyUI',
      onMessageReceived: (message) {
        _handleMonacoMessage(message.message);
      },
    );

    final html = await _buildMonacoHtml();
    await controller.loadHtmlString(html);
  }

  Future<String> _buildMonacoHtml() async {
    final template = await rootBundle.loadString(
      'assets/editor/monaco_editor.html',
    );
    final script = await rootBundle.loadString('assets/editor/monaco_editor.js');
    final style = await rootBundle.loadString('assets/editor/monaco_editor.css');

    final config = <String, Object?>{
      'language': widget.language ?? 'plaintext',
      'theme': widget.theme ?? 'vs-dark',
      'readOnly': widget.readOnly,
      'wordWrap': widget.wordWrap,
      'lineNumbers': widget.showLineNumbers,
      'glyphMargin': widget.glyphMargin,
      'minimap': widget.showMinimap,
      'emitOnChange': widget.emitOnChange,
      'debounceMs': widget.debounceMs,
      'fontSize': widget.fontSize,
      'fontFamily': widget.fontFamily,
      'tabSize': widget.tabSize,
      'documentUri': widget.documentUri,
      'submitOnCtrlEnter': true,
      'formatOnType': false,
      'formatOnPaste': false,
      'renderWhitespace': 'selection',
    };

    return template
        .replaceFirst('/*{{style}}*/', style)
        .replaceFirst('/*{{script}}*/', script)
        .replaceFirst('/*{{initial}}*/ ""', jsonEncode(widget.value))
        .replaceFirst('/*{{config}}*/ {}', jsonEncode(config));
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (_norm(method)) {
      case 'get_state':
        return {
          'schema_version': _runtimeProps['schema_version'] ?? _codeEditorSchemaVersion,
          'module': _runtimeProps['module'],
          'state': _runtimeProps['state'],
          'value': _latestValue,
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
        if (!_codeEditorModules.contains(module)) {
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
        if (!_codeEditorStates.contains(state)) {
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
        if (!_codeEditorEvents.contains(event)) {
          return {'ok': false, 'error': 'unknown event: $event'};
        }
        final payload = args['payload'];
        _emitConfiguredEvent(event, payload is Map ? coerceObjectMap(payload) : args);
        return true;
      default:
        final normalized = _norm(method);
        if (_codeEditorModules.contains(normalized)) {
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
    }

    if (_useMonaco) {
      return _handleMonacoInvoke(method, args);
    }
    return _handleFallbackInvoke(method, args);
  }

  Future<Object?> _handleFallbackInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'get_value':
        return _fallbackController.text;
      case 'set_value':
        final value = args['value']?.toString() ?? '';
        _fallbackSuppressChange = true;
        _fallbackController.value = _fallbackController.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
        _fallbackSuppressChange = false;
        _latestValue = value;
        if (mounted) setState(() {});
        return null;
      case 'focus':
        _fallbackFocusNode.requestFocus();
        return null;
      case 'blur':
        _fallbackFocusNode.unfocus();
        return null;
      case 'select_all':
        _fallbackController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _fallbackController.text.length,
        );
        return null;
      case 'insert_text':
        final value = args['value']?.toString() ?? '';
        if (value.isEmpty) return null;
        final selection = _fallbackController.selection;
        if (!selection.isValid) {
          _fallbackController.text += value;
        } else {
          final base = selection.start;
          final extent = selection.end;
          final text = _fallbackController.text;
          final next = text.replaceRange(base, extent, value);
          _fallbackController.value = TextEditingValue(
            text: next,
            selection: TextSelection.collapsed(offset: base + value.length),
          );
        }
        _latestValue = _fallbackController.text;
        _emitFallbackChange(immediate: true);
        if (mounted) setState(() {});
        return null;
      case 'format_document':
        _emitConfiguredEvent('format_request', {
          'value': _fallbackController.text,
          'language': widget.language ?? '',
        });
        return null;
      default:
        throw UnsupportedError('Unknown code_editor method: $method');
    }
  }

  Future<Object?> _handleMonacoInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'get_value':
        final result = await _runMonacoJavaScript(
          'window.ButterflyUIMonaco ? window.ButterflyUIMonaco.getValue() : "";',
          expectResult: true,
        );
        if (result is String) {
          _latestValue = result;
          return result;
        }
        return _latestValue;
      case 'set_value':
        final value = args['value']?.toString() ?? '';
        _latestValue = value;
        await _setMonacoValue(value, silent: true);
        return null;
      case 'focus':
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.focus();}',
        );
        return null;
      case 'blur':
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.blur();}',
        );
        return null;
      case 'select_all':
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.selectAll();}',
        );
        return null;
      case 'insert_text':
        final value = args['value']?.toString() ?? '';
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.insertText(${jsonEncode(value)});}',
        );
        return null;
      case 'format_document':
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.formatDocument();}',
        );
        _emitConfiguredEvent('format_request', {
          'value': _latestValue,
          'language': widget.language ?? '',
        });
        return null;
      case 'reveal_line':
        final line = coerceOptionalInt(args['line']) ?? 1;
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.revealLine($line);}',
        );
        return null;
      case 'set_markers':
        final markers = args['markers'] is List
            ? List<Object?>.from(args['markers'] as List)
            : const <Object?>[];
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.setMarkers(${jsonEncode(markers)});}',
        );
        return null;
      default:
        throw UnsupportedError('Unknown code_editor method: $method');
    }
  }

  Future<void> _setMonacoValue(String value, {required bool silent}) async {
    await _runMonacoJavaScript(
      'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.setValue(${jsonEncode(value)}, ${silent ? 'true' : 'false'});}',
    );
  }

  Future<Object?> _runMonacoJavaScript(
    String script, {
    bool expectResult = false,
  }) async {
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
      if (text.startsWith('"') && text.endsWith('"') && text.length >= 2) {
        try {
          return jsonDecode(text);
        } catch (_) {}
      }
      return text;
    }
  }

  void _handleMonacoMessage(dynamic message) {
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
    final payload = map['payload'] is Map
        ? coerceObjectMap(map['payload'] as Map)
        : <String, Object?>{};

    if (event == 'ready') {
      _monacoReady = true;
      payload['engine'] = 'monaco';
      payload['webview_engine'] = _useFlutterWebView ? 'flutter' : 'windows';
      _emitConfiguredEvent('ready', payload);
      return;
    }

    if (event == 'change') {
      final value = payload['value']?.toString() ?? '';
      _latestValue = value;
    }

    _emitConfiguredEvent(event, payload);
  }

  void _emitFallbackChange({bool immediate = false}) {
    if (_fallbackSuppressChange || !widget.emitOnChange) return;
    _debounce?.cancel();
    final text = _fallbackController.text;
    if (immediate || widget.debounceMs <= 0) {
      _emitConfiguredEvent('change', {'value': text});
      return;
    }
    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () {
      _emitConfiguredEvent('change', {'value': text});
    });
  }

  void _emitFallbackSubmit() {
    _debounce?.cancel();
    _emitConfiguredEvent('submit', {
      'value': _fallbackController.text,
      'language': widget.language ?? '',
    });
  }

  Set<String> _configuredEvents() {
    final raw = _runtimeProps['events'];
    final out = <String>{};
    if (raw is List) {
      for (final entry in raw) {
        final value = _norm(entry?.toString() ?? '');
        if (value.isNotEmpty && _codeEditorEvents.contains(value)) {
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
      'schema_version': _runtimeProps['schema_version'] ?? _codeEditorSchemaVersion,
      'module': _runtimeProps['module'],
      'state': _runtimeProps['state'],
      ...payload,
    });
  }

  Widget _buildFallbackEditor() {
    final lineCount = '\n'.allMatches(_fallbackController.text).length + 1;
    final lineNumbersText = List<String>.generate(
      lineCount,
      (index) => '${index + 1}',
    ).join('\n');

    final editor = TextField(
      controller: _fallbackController,
      focusNode: _fallbackFocusNode,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      maxLines: null,
      minLines: 12,
      scrollController: _fallbackEditorScroll,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
        fontFamily: widget.fontFamily,
        fontSize: widget.fontSize,
        color: widget.textColor,
        height: 1.45,
      ),
      onChanged: (_) {
        _latestValue = _fallbackController.text;
        _emitFallbackChange();
        if (mounted) setState(() {});
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );

    final wrappedEditor = Focus(
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        final key = event.logicalKey;
        final ctrl = HardwareKeyboard.instance.isControlPressed;
        if (ctrl && key == LogicalKeyboardKey.enter) {
          _emitFallbackSubmit();
          return KeyEventResult.handled;
        }
        if (ctrl && key == LogicalKeyboardKey.keyS) {
          _emitConfiguredEvent('save', {
            'value': _fallbackController.text,
          });
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: editor,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showGutter && widget.showLineNumbers)
          Container(
            width: 54,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: widget.backgroundColor.withValues(alpha: 0.75),
            alignment: Alignment.topRight,
            child: SingleChildScrollView(
              controller: _fallbackGutterScroll,
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                lineNumbersText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: widget.fontFamily,
                  fontSize: widget.fontSize - 1,
                  color: widget.textColor.withValues(alpha: 0.55),
                  height: 1.45,
                ),
              ),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: widget.wordWrap
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            child: SizedBox(
              width: widget.wordWrap ? null : 1200,
              child: wrappedEditor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonacoEditor() {
    if (_useFlutterWebView) {
      final controller = _flutterController;
      if (controller == null) {
        return const SizedBox.shrink();
      }
      return WebViewWidget(controller: controller);
    }
    return Webview(_windowsController);
  }

  Widget _buildEditorContainer() {
    final child = _useMonaco ? _buildMonacoEditor() : _buildFallbackEditor();
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: widget.borderWidth > 0
            ? Border.all(color: widget.borderColor, width: widget.borderWidth)
            : null,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableModules = _availableModules(_runtimeProps);
    final activeModule = _norm(_runtimeProps['module']?.toString() ?? 'editor_surface');

    if ((_runtimeProps['state']?.toString() ?? '') == 'loading') {
      return const Center(child: CircularProgressIndicator());
    }

    final sectionWidgets = <Widget>[];

    sectionWidgets.add(
      _CodeEditorHeader(
        state: (_runtimeProps['state'] ?? 'ready').toString(),
        language: (widget.language ?? 'plaintext'),
        engine: widget.engine,
      ),
    );

    sectionWidgets.add(
      _ModuleTabs(
        modules: availableModules,
        activeModule: activeModule,
        onSelect: (module) {
          setState(() {
            _runtimeProps['module'] = module;
          });
          _emitConfiguredEvent('module_change', {'module': module});
        },
      ),
    );

    var editorPlaced = false;
    for (final module in availableModules) {
      final section = _sectionProps(_runtimeProps, module) ?? <String, Object?>{'events': _runtimeProps['events']};
      Widget child;
      if (!editorPlaced && (module == 'ide' || module == 'editor_surface' || module == 'editor_view')) {
        child = _buildEditorContainer();
        editorPlaced = true;
      } else if (module.contains('search') || module == 'command_search') {
        child = _SearchModule(
          controlId: widget.controlId,
          module: module,
          props: section,
          onEmit: _emitConfiguredEvent,
        );
      } else if (module.contains('tab')) {
        child = _TabsModule(
          controlId: widget.controlId,
          module: module,
          props: section,
          onEmit: _emitConfiguredEvent,
        );
      } else if (module.contains('tree') || module.contains('explorer') || module == 'workspace_explorer') {
        child = _TreeModule(
          controlId: widget.controlId,
          module: module,
          props: section,
          onEmit: _emitConfiguredEvent,
        );
      } else if (module.contains('diagnostic') || module == 'gutter' || module == 'inline_error_view') {
        child = _DiagnosticsModule(module: module, props: section);
      } else if (module == 'diff') {
        child = _DiffModule(
          controlId: widget.controlId,
          props: section,
          onEmit: _emitConfiguredEvent,
        );
      } else {
        child = _GenericModule(
          controlId: widget.controlId,
          module: module,
          props: section,
          onEmit: _emitConfiguredEvent,
        );
      }

      sectionWidgets.add(
        ExpansionTile(
          key: ValueKey<String>('code_editor_module_$module'),
          initiallyExpanded: module == activeModule,
          title: Text(module.replaceAll('_', ' ')),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          children: [child],
        ),
      );
    }

    if (!editorPlaced) {
      sectionWidgets.add(_buildEditorContainer());
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
}

Map<String, Object?> _normalizeProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] = (coerceOptionalInt(out['schema_version']) ?? _codeEditorSchemaVersion).clamp(1, 9999);

  final module = _norm(out['module']?.toString() ?? '');
  if (module.isNotEmpty && _codeEditorModules.contains(module)) {
    out['module'] = module;
  } else if (module.isNotEmpty) {
    out.remove('module');
  }

  final state = _norm(out['state']?.toString() ?? '');
  if (state.isNotEmpty && _codeEditorStates.contains(state)) {
    out['state'] = state;
  } else if (state.isNotEmpty) {
    out.remove('state');
  }

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((e) => _norm(e?.toString() ?? ''))
        .where((e) => e.isNotEmpty && _codeEditorEvents.contains(e))
        .toSet()
        .toList(growable: false);
  }

  final modules = _coerceObjectMap(out['modules']);
  final normalizedModules = <String, Object?>{};
  for (final moduleKey in _codeEditorModules) {
    final topLevel = out[moduleKey];
    if (topLevel is Map) {
      final value = coerceObjectMap(topLevel);
      normalizedModules[moduleKey] = value;
      out[moduleKey] = value;
    }
  }
  for (final entry in modules.entries) {
    final normalized = _norm(entry.key);
    if (!_codeEditorModules.contains(normalized)) continue;
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
  for (final key in _codeEditorModuleOrder) {
    if (props[key] is Map || moduleMap[key] is Map) {
      modules.add(key);
    }
  }
  if (modules.isEmpty) {
    modules.addAll(const ['ide', 'editor_surface', 'editor_view']);
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

class _CodeEditorHeader extends StatelessWidget {
  const _CodeEditorHeader({required this.state, required this.language, required this.engine});

  final String state;
  final String language;
  final String engine;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Code Editor', style: Theme.of(context).textTheme.titleMedium),
              Text('State: $state', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Text('Lang: $language'),
        const SizedBox(width: 8),
        Text('Engine: $engine'),
      ],
    );
  }
}

class _ModuleTabs extends StatelessWidget {
  const _ModuleTabs({
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

class _SearchModule extends StatefulWidget {
  const _SearchModule({
    required this.controlId,
    required this.module,
    required this.props,
    required this.onEmit,
  });

  final String controlId;
  final String module;
  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  State<_SearchModule> createState() => _SearchModuleState();
}

class _SearchModuleState extends State<_SearchModule> {
  late final TextEditingController _controller = TextEditingController(
    text: (widget.props['query'] ?? '').toString(),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: (widget.props['placeholder'] ?? 'Search...').toString(),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.tonal(
          onPressed: () {
            widget.onEmit('search', {
              'module': widget.module,
              'query': _controller.text,
            });
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
}

class _TabsModule extends StatelessWidget {
  const _TabsModule({
    required this.controlId,
    required this.module,
    required this.props,
    required this.onEmit,
  });

  final String controlId;
  final String module;
  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  Widget build(BuildContext context) {
    final tabs = props['tabs'] is List ? (props['tabs'] as List) : const <dynamic>[];
    if (tabs.isEmpty) {
      return const Text('No tabs');
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tab in tabs)
          ActionChip(
            label: Text(tab is Map ? (tab['label'] ?? tab['title'] ?? tab['id'] ?? '').toString() : tab.toString()),
            onPressed: () {
              onEmit('select', {'module': module, 'tab': tab});
            },
          ),
      ],
    );
  }
}

class _TreeModule extends StatelessWidget {
  const _TreeModule({
    required this.controlId,
    required this.module,
    required this.props,
    required this.onEmit,
  });

  final String controlId;
  final String module;
  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  Widget build(BuildContext context) {
    final nodes = props['nodes'] is List
        ? (props['nodes'] as List)
        : (props['items'] is List ? (props['items'] as List) : const <dynamic>[]);
    if (nodes.isEmpty) {
      return const Text('No nodes');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final node in nodes.take(20))
          ListTile(
            dense: true,
            title: Text(node is Map ? (node['label'] ?? node['name'] ?? node['id'] ?? '').toString() : node.toString()),
            onTap: () => onEmit('select', {'module': module, 'node': node}),
          ),
      ],
    );
  }
}

class _DiagnosticsModule extends StatelessWidget {
  const _DiagnosticsModule({required this.module, required this.props});

  final String module;
  final Map<String, Object?> props;

  @override
  Widget build(BuildContext context) {
    final items = props['items'] is List
        ? (props['items'] as List)
        : (props['diagnostics'] is List ? (props['diagnostics'] as List) : const <dynamic>[]);
    if (items.isEmpty) {
      return Text('No diagnostics for ${module.replaceAll('_', ' ')}');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items.take(20))
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(item.toString()),
          ),
      ],
    );
  }
}

class _DiffModule extends StatelessWidget {
  const _DiffModule({
    required this.controlId,
    required this.props,
    required this.onEmit,
  });

  final String controlId;
  final Map<String, Object?> props;
  final void Function(String event, Map<String, Object?> payload) onEmit;

  @override
  Widget build(BuildContext context) {
    final left = (props['left'] ?? props['before'] ?? '').toString();
    final right = (props['right'] ?? props['after'] ?? '').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Before', style: Theme.of(context).textTheme.titleSmall)),
            Expanded(child: Text('After', style: Theme.of(context).textTheme.titleSmall)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SelectableText(left.isEmpty ? '-' : left)),
            const SizedBox(width: 8),
            Expanded(child: SelectableText(right.isEmpty ? '-' : right)),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () => onEmit('select', {'module': 'diff', 'left': left, 'right': right}),
          child: const Text('Use Diff'),
        ),
      ],
    );
  }
}

class _GenericModule extends StatelessWidget {
  const _GenericModule({
    required this.controlId,
    required this.module,
    required this.props,
    required this.onEmit,
  });

  final String controlId;
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

Widget buildCodeEditorControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final value = (props['value'] ?? props['text'] ?? props['code'] ?? '')
      .toString();
  final fontSize = coerceDouble(props['font_size']) ?? 13;
  final fontFamily = props['font_family']?.toString() ?? 'JetBrains Mono';
  final backgroundColor =
      coerceColor(
        props['editor_bg'] ?? props['editor_background'] ?? props['bgcolor'],
      ) ??
      const Color(0xff0b1220);
  final textColor =
      coerceColor(props['editor_text_color'] ?? props['text_color']) ??
      const Color(0xffdbeafe);
  final borderColor =
      coerceColor(props['border_color']) ?? const Color(0xff334155);
  final borderWidth = coerceDouble(props['border_width']) ?? 1.0;
  final radius = coerceDouble(props['radius']) ?? 10.0;

  return ButterflyUICodeEditor(
    controlId: controlId,
    value: value,
    language: props['language']?.toString(),
    theme: props['theme']?.toString(),
    engine: (props['engine'] ?? 'monaco').toString(),
    webviewEngine: (props['webview_engine'] ?? 'windows').toString(),
    readOnly: props['read_only'] == true,
    autofocus: props['auto_focus'] == true || props['autofocus'] == true,
    wordWrap: props['word_wrap'] == true || props['wrap'] == true,
    showLineNumbers: props['line_numbers'] == null
        ? true
        : (props['line_numbers'] == true),
    showGutter: props['show_gutter'] == null
        ? true
        : (props['show_gutter'] == true),
    showMinimap: props['show_minimap'] == true || props['minimap'] == true,
    glyphMargin: props['glyph_margin'] == true ||
        props['show_breakpoints'] == true,
    emitOnChange: props['emit_on_change'] == null
        ? true
        : (props['emit_on_change'] == true),
    debounceMs: (coerceOptionalInt(props['debounce_ms']) ?? 180).clamp(0, 2000),
    tabSize: (coerceOptionalInt(props['tab_size']) ?? 2).clamp(1, 12),
    documentUri: props['document_uri']?.toString(),
    fontSize: fontSize,
    fontFamily: fontFamily,
    backgroundColor: backgroundColor,
    textColor: textColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    radius: radius,
    initialProps: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
